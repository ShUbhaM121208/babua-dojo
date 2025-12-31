import { supabase } from "@/integrations/supabase/client";
import crypto from "crypto";

// Google Gemini API Configuration
const GEMINI_API_KEY = import.meta.env.VITE_GEMINI_API_KEY || "";
const GEMINI_API_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`;

export interface CodeReview {
  id?: string;
  timeComplexity: string;
  spaceComplexity: string;
  codeQualityScore: number; // 0-100
  strengths: string[];
  improvements: string[];
  alternativeApproaches: string[];
  bestPractices: string[];
  fullReviewMarkdown: string;
  modelUsed?: string;
  tokensUsed?: number;
  processingTimeMs?: number;
  createdAt?: string;
}

export interface ReviewRequest {
  code: string;
  language: string;
  problemId: string;
  problemTitle: string;
  problemDescription: string;
  submissionId?: string;
}

export interface RateLimitStatus {
  canRequest: boolean;
  remainingReviews: number;
  totalAllowed: number;
  isPro: boolean;
}

/**
 * Generate hash for code caching
 */
function generateCodeHash(code: string, language: string): string {
  return crypto
    .createHash("sha256")
    .update(`${code}-${language}`)
    .digest("hex");
}

/**
 * Create system prompt for code review
 */
function createSystemPrompt(): string {
  return `You are an expert code reviewer specializing in algorithmic problems and data structures. 
Your task is to analyze submitted code and provide comprehensive, constructive feedback.

Analyze the code for:
1. Time and space complexity (Big O notation)
2. Code quality and readability
3. Strengths and what's done well
4. Areas for improvement
5. Alternative approaches
6. Best practices and patterns

Be encouraging but honest. Focus on education and improvement.
Format your response as a structured JSON object with the following exact structure:
{
  "timeComplexity": "O(n) - explanation",
  "spaceComplexity": "O(1) - explanation",
  "codeQualityScore": 85,
  "strengths": ["point 1", "point 2"],
  "improvements": ["suggestion 1", "suggestion 2"],
  "alternativeApproaches": ["approach 1 with explanation", "approach 2"],
  "bestPractices": ["practice 1", "practice 2"],
  "fullReviewMarkdown": "# Complete markdown review"
}`;
}

/**
 * Create user prompt for code review
 */
function createUserPrompt(request: ReviewRequest): string {
  return `${createSystemPrompt()}

Please review this ${request.language} solution for the following problem:

**Problem: ${request.problemTitle}**
${request.problemDescription}

**Submitted Code:**
\`\`\`${request.language}
${request.code}
\`\`\`

Provide a detailed review in JSON format with these exact fields:
- timeComplexity: string with O notation and explanation
- spaceComplexity: string with O notation and explanation  
- codeQualityScore: number between 0-100
- strengths: array of strings describing what's done well
- improvements: array of strings with actionable suggestions
- alternativeApproaches: array of strings with alternative solutions
- bestPractices: array of strings with best practice recommendations
- fullReviewMarkdown: complete markdown formatted review

Return ONLY the JSON object, no other text.`;
}

/**
 * Call Google Gemini API for code review
 */
async function callGemini(request: ReviewRequest): Promise<CodeReview> {
  const startTime = Date.now();

  const response = await fetch(GEMINI_API_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      contents: [
        {
          parts: [
            {
              text: createUserPrompt(request),
            },
          ],
        },
      ],
      generationConfig: {
        temperature: 0.7,
        maxOutputTokens: 2048,
      },
    }),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(`Gemini API error: ${error.error?.message || "Unknown error"}`);
  }

  const data = await response.json();
  const processingTime = Date.now() - startTime;

  // Parse the AI response
  const content = data.candidates[0]?.content?.parts[0]?.text || "";
  
  // Extract JSON from markdown code blocks if present
  let jsonContent = content;
  const jsonMatch = content.match(/```json\s*([\s\S]*?)\s*```/);
  if (jsonMatch) {
    jsonContent = jsonMatch[1];
  } else {
    // Try to find JSON object in the text
    const objectMatch = content.match(/\{[\s\S]*\}/);
    if (objectMatch) {
      jsonContent = objectMatch[0];
    }
  }

  const reviewData = JSON.parse(jsonContent);

  return {
    timeComplexity: reviewData.timeComplexity,
    spaceComplexity: reviewData.spaceComplexity,
    codeQualityScore: reviewData.codeQualityScore,
    strengths: reviewData.strengths,
    improvements: reviewData.improvements,
    alternativeApproaches: reviewData.alternativeApproaches,
    bestPractices: reviewData.bestPractices,
    fullReviewMarkdown: reviewData.fullReviewMarkdown,
    modelUsed: "gemini-pro",
    tokensUsed: data.usageMetadata?.totalTokenCount || 0,
    processingTimeMs: processingTime,
  };
}

/**
 * Check if user can request a review (rate limiting)
 */
export async function checkRateLimit(): Promise<RateLimitStatus> {
  try {
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return {
        canRequest: false,
        remainingReviews: 0,
        totalAllowed: 3,
        isPro: false,
      };
    }

    // For now, assume all users are free (not Pro)
    const isPro = false;

    // Get today's review count
    const { data: rateLimitData, error } = await supabase
      .from("review_rate_limits")
      .select("review_count")
      .eq("user_id", user.id)
      .eq("review_date", new Date().toISOString().split("T")[0])
      .single();

    // If table doesn't exist, allow reviews anyway
    if (error && error.code === 'PGRST116') {
      // No rate limit record found - allow reviews
      return {
        canRequest: true,
        remainingReviews: 3,
        totalAllowed: 3,
        isPro: false,
      };
    }

    const usedReviews = rateLimitData?.review_count || 0;
    const totalAllowed = isPro ? 999 : 3;
    const canRequest = usedReviews < totalAllowed;

    return {
      canRequest,
      remainingReviews: Math.max(0, totalAllowed - usedReviews),
      totalAllowed,
      isPro,
    };
  } catch (err) {
    console.warn('Could not check rate limit, allowing reviews:', err);
    // If anything fails, allow reviews
    return {
      canRequest: true,
      remainingReviews: 3,
      totalAllowed: 3,
      isPro: false,
    };
  }
}

/**
 * Get cached review if exists
 */
async function getCachedReview(
  codeHash: string,
  language: string
): Promise<CodeReview | null> {
  const { data, error } = await supabase.rpc("get_cached_review", {
    p_code_hash: codeHash,
    p_language: language,
  });

  if (error || !data || data.length === 0) {
    return null;
  }

  const cached = data[0];
  return {
    id: cached.id,
    timeComplexity: cached.time_complexity,
    spaceComplexity: cached.space_complexity,
    codeQualityScore: cached.code_quality_score,
    strengths: cached.strengths,
    improvements: cached.improvements,
    alternativeApproaches: cached.alternative_approaches,
    bestPractices: cached.best_practices,
    fullReviewMarkdown: cached.full_review_markdown,
    createdAt: cached.created_at,
  };
}

/**
 * Save review to database
 */
async function saveReview(
  request: ReviewRequest,
  review: CodeReview,
  codeHash: string
): Promise<void> {
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    throw new Error("User not authenticated");
  }

  const { error } = await supabase.from("code_reviews").insert({
    user_id: user.id,
    submission_id: request.submissionId || null,
    problem_id: request.problemId,
    code: request.code,
    code_hash: codeHash,
    language: request.language,
    time_complexity: review.timeComplexity,
    space_complexity: review.spaceComplexity,
    code_quality_score: review.codeQualityScore,
    strengths: review.strengths,
    improvements: review.improvements,
    alternative_approaches: review.alternativeApproaches,
    best_practices: review.bestPractices,
    full_review_markdown: review.fullReviewMarkdown,
    model_used: review.modelUsed,
    tokens_used: review.tokensUsed,
    processing_time_ms: review.processingTimeMs,
  });

  if (error) {
    console.error("Failed to save review:", error);
    throw new Error("Failed to save review to database");
  }
}

/**
 * Increment rate limit counter
 */
async function incrementRateLimit(): Promise<void> {
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    throw new Error("User not authenticated");
  }

  const { error } = await supabase.rpc("increment_review_count", {
    p_user_id: user.id,
  });

  if (error) {
    console.error("Failed to increment rate limit:", error);
    throw new Error("Failed to update rate limit");
  }
}

/**
 * Request an AI code review (main function)
 */
export async function requestCodeReview(
  request: ReviewRequest
): Promise<CodeReview> {
  // Step 1: Check rate limit
  const rateLimitStatus = await checkRateLimit();
  if (!rateLimitStatus.canRequest) {
    throw new Error(
      rateLimitStatus.isPro
        ? "Rate limit exceeded. Please try again later."
        : `Daily limit reached (${rateLimitStatus.totalAllowed} reviews/day). Upgrade to Pro for unlimited reviews!`
    );
  }

  // Step 2: Check cache
  const codeHash = generateCodeHash(request.code, request.language);
  const cachedReview = await getCachedReview(codeHash, request.language);

  if (cachedReview) {
    console.log("Returning cached review");
    // Still increment rate limit for cached reviews
    await incrementRateLimit();
    return cachedReview;
  }

  // Step 3: Call Gemini API
  console.log("Requesting new review from Gemini");
  const review = await callGemini(request);

  // Step 4: Save to database
  await saveReview(request, review, codeHash);

  // Step 5: Increment rate limit
  await incrementRateLimit();

  return review;
}

/**
 * Get user's review history
 */
export async function getUserReviews(
  problemId?: string,
  limit: number = 10
): Promise<CodeReview[]> {
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return [];
  }

  let query = supabase
    .from("code_reviews")
    .select("*")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false })
    .limit(limit);

  if (problemId) {
    query = query.eq("problem_id", problemId);
  }

  const { data, error } = await query;

  if (error) {
    console.error("Failed to fetch reviews:", error);
    return [];
  }

  return (data || []).map((review) => ({
    id: review.id,
    timeComplexity: review.time_complexity,
    spaceComplexity: review.space_complexity,
    codeQualityScore: review.code_quality_score,
    strengths: review.strengths,
    improvements: review.improvements,
    alternativeApproaches: review.alternative_approaches,
    bestPractices: review.best_practices,
    fullReviewMarkdown: review.full_review_markdown,
    modelUsed: review.model_used,
    tokensUsed: review.tokens_used,
    processingTimeMs: review.processing_time_ms,
    createdAt: review.created_at,
  }));
}

/**
 * Get review statistics
 */
export async function getReviewStats(): Promise<{
  totalReviews: number;
  averageScore: number;
  todayReviews: number;
  remainingToday: number;
}> {
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return {
      totalReviews: 0,
      averageScore: 0,
      todayReviews: 0,
      remainingToday: 3,
    };
  }

  // Get total reviews
  const { count: totalReviews } = await supabase
    .from("code_reviews")
    .select("*", { count: "exact", head: true })
    .eq("user_id", user.id);

  // Get average score
  const { data: reviews } = await supabase
    .from("code_reviews")
    .select("code_quality_score")
    .eq("user_id", user.id);

  const averageScore =
    reviews && reviews.length > 0
      ? reviews.reduce((sum, r) => sum + r.code_quality_score, 0) / reviews.length
      : 0;

  // Get rate limit status
  const rateLimitStatus = await checkRateLimit();

  return {
    totalReviews: totalReviews || 0,
    averageScore: Math.round(averageScore),
    todayReviews: rateLimitStatus.totalAllowed - rateLimitStatus.remainingReviews,
    remainingToday: rateLimitStatus.remainingReviews,
  };
}

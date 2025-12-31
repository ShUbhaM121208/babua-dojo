import { supabase } from "@/integrations/supabase/client";

// Google Gemini API Configuration
const GEMINI_API_KEY = import.meta.env.VITE_GEMINI_API_KEY || "";
const GEMINI_API_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`;

export interface InterviewSession {
  id: string;
  user_id: string;
  problem_id: string;
  started_at: string;
  ended_at?: string;
  duration_seconds?: number;
  status: 'active' | 'completed' | 'abandoned';
  user_code?: string;
  language?: string;
  code_submitted: boolean;
  tests_passed: boolean;
  communication_score?: number;
  problem_solving_score?: number;
  code_quality_score?: number;
  overall_score?: number;
  strengths?: string[];
  areas_for_improvement?: string[];
  detailed_feedback?: string;
  interviewer_notes?: string;
  conversation_history?: ConversationMessage[];
}

export interface ConversationMessage {
  role: 'interviewer' | 'candidate' | 'system';
  message: string;
  messageType?: 'question' | 'answer' | 'hint' | 'feedback' | 'clarification';
  code_snapshot?: string;
  timestamp: string;
}

export interface InterviewEvaluation {
  communicationScore: number;
  problemSolvingScore: number;
  codeQualityScore: number;
  overallScore: number;
  strengths: string[];
  areasForImprovement: string[];
  detailedFeedback: string;
}

export interface InterviewStats {
  totalSessions: number;
  completedSessions: number;
  averageOverallScore: number;
  averageDurationMinutes: number;
  problemsPracticed: number;
}

/**
 * Create interviewer system prompt
 */
function createInterviewerPrompt(problemTitle: string, problemDescription: string): string {
  return `You are an experienced technical interviewer conducting a coding interview. Your role is to:

1. **Ask Clarifying Questions**: Start by asking 1-2 thoughtful questions about the problem to assess understanding
2. **Guide the Candidate**: Listen to their approach and provide hints if they're stuck (not direct answers)
3. **Encourage Communication**: Prompt them to think aloud and explain their reasoning
4. **Assess Problem-Solving**: Evaluate how they break down the problem
5. **Review Code**: Once they submit, ask follow-up questions about their implementation
6. **Be Professional but Encouraging**: Create a supportive interview environment

**Problem**: ${problemTitle}
${problemDescription}

**Interview Style**:
- Ask open-ended questions
- Provide hints progressively (start subtle, get more direct if needed)
- Assess communication skills, not just coding ability
- Be encouraging and constructive
- Keep responses concise (2-4 sentences)

**Important**: Keep your responses brief and conversational. Don't overwhelm the candidate with too much information at once.`;
}

/**
 * Call Gemini AI for interview response
 */
async function callGeminiForInterview(
  conversationHistory: ConversationMessage[],
  systemPrompt: string,
  userMessage: string
): Promise<string> {
  const messages = conversationHistory.map(msg => ({
    role: msg.role === 'interviewer' ? 'model' : 'user',
    parts: [{ text: msg.message }]
  }));

  // Add system context as first message
  const contents = [
    {
      role: 'user',
      parts: [{ text: systemPrompt }]
    },
    {
      role: 'model',
      parts: [{ text: "I understand. I'll conduct a professional technical interview, asking clarifying questions, providing guidance, and assessing the candidate's problem-solving and communication skills. Let's begin!" }]
    },
    ...messages,
    {
      role: 'user',
      parts: [{ text: userMessage }]
    }
  ];

  const response = await fetch(GEMINI_API_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      contents,
      generationConfig: {
        temperature: 0.8, // Slightly higher for more natural conversation
        maxOutputTokens: 500, // Keep responses concise
      },
    }),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(`Gemini API error: ${error.error?.message || "Unknown error"}`);
  }

  const data = await response.json();
  return data.candidates[0]?.content?.parts[0]?.text || "";
}

/**
 * Start a new interview session
 */
export async function startInterviewSession(
  problemId: string,
  language: string
): Promise<InterviewSession> {
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    throw new Error("User not authenticated");
  }

  const { data, error } = await supabase
    .from("ai_interview_sessions")
    .insert({
      user_id: user.id,
      problem_id: problemId,
      language,
      status: 'active'
    })
    .select()
    .single();

  if (error) {
    console.error("Failed to start interview session:", error);
    throw new Error("Failed to start interview session");
  }

  return data as InterviewSession;
}

/**
 * Send message in interview
 */
export async function sendInterviewMessage(
  sessionId: string,
  message: string,
  problemTitle: string,
  problemDescription: string,
  codeSnapshot?: string
): Promise<ConversationMessage> {
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    throw new Error("User not authenticated");
  }

  // Get conversation history
  const { data: session } = await supabase
    .from("ai_interview_sessions")
    .select("conversation_history")
    .eq("id", sessionId)
    .single();

  const history: ConversationMessage[] = (session?.conversation_history as any) || [];

  // Save candidate's message
  const candidateMessage: ConversationMessage = {
    role: 'candidate',
    message,
    timestamp: new Date().toISOString(),
    code_snapshot: codeSnapshot
  };

  await supabase.rpc("save_interview_message", {
    p_session_id: sessionId,
    p_role: 'candidate',
    p_message: message,
    p_message_type: 'answer',
    p_code_snapshot: codeSnapshot
  });

  // Get AI response
  const systemPrompt = createInterviewerPrompt(problemTitle, problemDescription);
  const aiResponse = await callGeminiForInterview(history, systemPrompt, message);

  // Save interviewer's response
  const interviewerMessage: ConversationMessage = {
    role: 'interviewer',
    message: aiResponse,
    timestamp: new Date().toISOString()
  };

  await supabase.rpc("save_interview_message", {
    p_session_id: sessionId,
    p_role: 'interviewer',
    p_message: aiResponse,
    p_message_type: 'question'
  });

  return interviewerMessage;
}

/**
 * Get initial interviewer greeting
 */
export async function getInterviewerGreeting(
  sessionId: string,
  problemTitle: string,
  problemDescription: string
): Promise<ConversationMessage> {
  const systemPrompt = createInterviewerPrompt(problemTitle, problemDescription);
  
  const greeting = await callGeminiForInterview(
    [],
    systemPrompt,
    "Let's start the interview. Please greet me and ask your first clarifying question about the problem."
  );

  // Save greeting
  await supabase.rpc("save_interview_message", {
    p_session_id: sessionId,
    p_role: 'interviewer',
    p_message: greeting,
    p_message_type: 'question'
  });

  return {
    role: 'interviewer',
    message: greeting,
    timestamp: new Date().toISOString()
  };
}

/**
 * Submit code for review
 */
export async function submitCodeForInterview(
  sessionId: string,
  code: string,
  problemTitle: string,
  problemDescription: string,
  testsPassed: boolean
): Promise<ConversationMessage> {
  // Update session with submitted code
  await supabase
    .from("ai_interview_sessions")
    .update({
      user_code: code,
      code_submitted: true,
      tests_passed: testsPassed,
      updated_at: new Date().toISOString()
    })
    .eq("id", sessionId);

  // Get conversation history
  const { data: session } = await supabase
    .from("ai_interview_sessions")
    .select("conversation_history")
    .eq("id", sessionId)
    .single();

  const history: ConversationMessage[] = (session?.conversation_history as any) || [];

  const systemPrompt = createInterviewerPrompt(problemTitle, problemDescription);
  
  const submissionMessage = `I've submitted my code. Tests ${testsPassed ? 'passed' : 'failed'}. Here's my solution:\n\n\`\`\`\n${code}\n\`\`\`\n\nCould you review it?`;

  const response = await callGeminiForInterview(history, systemPrompt, submissionMessage);

  // Save messages
  await supabase.rpc("save_interview_message", {
    p_session_id: sessionId,
    p_role: 'candidate',
    p_message: submissionMessage,
    p_message_type: 'answer',
    p_code_snapshot: code
  });

  await supabase.rpc("save_interview_message", {
    p_session_id: sessionId,
    p_role: 'interviewer',
    p_message: response,
    p_message_type: 'feedback'
  });

  return {
    role: 'interviewer',
    message: response,
    timestamp: new Date().toISOString()
  };
}

/**
 * End interview and get evaluation
 */
export async function endInterviewSession(
  sessionId: string,
  problemTitle: string,
  problemDescription: string
): Promise<InterviewEvaluation> {
  // Get session data
  const { data: session } = await supabase
    .from("ai_interview_sessions")
    .select("*")
    .eq("id", sessionId)
    .single();

  if (!session) {
    throw new Error("Session not found");
  }

  const history: ConversationMessage[] = (session.conversation_history as any) || [];

  // Get AI evaluation
  const evaluationPrompt = `Based on this interview conversation, provide a structured evaluation:

**Problem**: ${problemTitle}

**Conversation Summary**: 
${history.map(msg => `${msg.role}: ${msg.message}`).join('\n\n')}

**Code Submitted**: ${session.code_submitted ? 'Yes' : 'No'}
**Tests Passed**: ${session.tests_passed ? 'Yes' : 'No'}

Provide evaluation in this JSON format:
{
  "communicationScore": 1-5,
  "problemSolvingScore": 1-5,
  "codeQualityScore": 1-5,
  "strengths": ["strength 1", "strength 2", ...],
  "areasForImprovement": ["area 1", "area 2", ...],
  "detailedFeedback": "2-3 paragraphs of constructive feedback"
}

Be fair but constructive. Focus on specific observations from the conversation.`;

  const evaluationUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`;
  const response = await fetch(evaluationUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      contents: [{
        parts: [{ text: evaluationPrompt }]
      }],
      generationConfig: {
        temperature: 0.3, // Lower for consistent evaluations
        maxOutputTokens: 1000
      }
    })
  });

  const data = await response.json();
  const evaluationText = data.candidates[0]?.content?.parts[0]?.text || "";
  
  // Extract JSON from markdown if needed
  let jsonText = evaluationText;
  const jsonMatch = evaluationText.match(/```json\s*([\s\S]*?)\s*```/);
  if (jsonMatch) {
    jsonText = jsonMatch[1];
  } else {
    const objectMatch = evaluationText.match(/\{[\s\S]*\}/);
    if (objectMatch) {
      jsonText = objectMatch[0];
    }
  }

  const evaluation = JSON.parse(jsonText);

  // Save evaluation to database
  await supabase.rpc("end_interview_session", {
    p_session_id: sessionId,
    p_communication: evaluation.communicationScore,
    p_problem_solving: evaluation.problemSolvingScore,
    p_code_quality: evaluation.codeQualityScore,
    p_strengths: evaluation.strengths,
    p_improvements: evaluation.areasForImprovement,
    p_feedback: evaluation.detailedFeedback
  });

  return {
    communicationScore: evaluation.communicationScore,
    problemSolvingScore: evaluation.problemSolvingScore,
    codeQualityScore: evaluation.codeQualityScore,
    overallScore: (evaluation.communicationScore + evaluation.problemSolvingScore + evaluation.codeQualityScore) / 3,
    strengths: evaluation.strengths,
    areasForImprovement: evaluation.areasForImprovement,
    detailedFeedback: evaluation.detailedFeedback
  };
}

/**
 * Get interview session history
 */
export async function getInterviewSession(sessionId: string): Promise<InterviewSession | null> {
  const { data, error } = await supabase
    .from("ai_interview_sessions")
    .select("*")
    .eq("id", sessionId)
    .single();

  if (error || !data) {
    return null;
  }

  return data as InterviewSession;
}

/**
 * Get user's interview statistics
 */
export async function getInterviewStatistics(): Promise<InterviewStats> {
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return {
      totalSessions: 0,
      completedSessions: 0,
      averageOverallScore: 0,
      averageDurationMinutes: 0,
      problemsPracticed: 0
    };
  }

  const { data, error } = await supabase.rpc("get_interview_stats", {
    p_user_id: user.id
  });

  if (error || !data || data.length === 0) {
    return {
      totalSessions: 0,
      completedSessions: 0,
      averageOverallScore: 0,
      averageDurationMinutes: 0,
      problemsPracticed: 0
    };
  }

  const stats = data[0];
  return {
    totalSessions: stats.total_sessions || 0,
    completedSessions: stats.completed_sessions || 0,
    averageOverallScore: stats.average_overall_score || 0,
    averageDurationMinutes: stats.average_duration_minutes || 0,
    problemsPracticed: stats.problems_practiced || 0
  };
}

/**
 * Get all interview sessions for user
 */
export async function getUserInterviewSessions(limit: number = 10): Promise<InterviewSession[]> {
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return [];
  }

  const { data, error } = await supabase
    .from("ai_interview_sessions")
    .select("*")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false })
    .limit(limit);

  if (error) {
    console.error("Failed to fetch interview sessions:", error);
    return [];
  }

  return (data as InterviewSession[]) || [];
}

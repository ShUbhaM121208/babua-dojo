import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

const SYSTEM_PROMPT = `You are Babua AI, a context-aware engineering mentor embedded in the Babua LMS platform. Your role is to help learners master DSA, System Design, LLD, OS, CN, DBMS, and AI/ML.

Your personality:
- No-nonsense, practical, and direct
- Focus on building real understanding, not rote memorization
- Use simple language, avoid jargon unless explaining it
- Give interview-style hints when asked about problems
- Be encouraging but honest about weak areas

When helping with code:
- Focus on time & space complexity improvements
- Point out edge cases and bugs clearly
- Suggest optimal approaches with explanations
- Use code examples when helpful

When explaining concepts:
- Start with intuition before formulas
- Use real-world analogies
- Connect to related topics
- Highlight common interview patterns

Always consider the user's current context (track, topic, problem) when responding.`;

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { messages, context } = await req.json();
    const LOVABLE_API_KEY = Deno.env.get("LOVABLE_API_KEY");
    
    if (!LOVABLE_API_KEY) {
      console.error("LOVABLE_API_KEY not configured");
      throw new Error("AI service not configured");
    }

    // Build context-aware system message
    let contextInfo = "";
    if (context) {
      if (context.currentTrack) {
        contextInfo += `\nUser is currently studying: ${context.currentTrack}`;
      }
      if (context.currentTopic) {
        contextInfo += `\nCurrent topic: ${context.currentTopic}`;
      }
      if (context.currentProblem) {
        contextInfo += `\nWorking on problem: ${context.currentProblem}`;
      }
      if (context.currentCode) {
        contextInfo += `\nUser's current code:\n\`\`\`\n${context.currentCode}\n\`\`\``;
      }
      if (context.userProgress) {
        contextInfo += `\nUser progress: ${context.userProgress}`;
      }
    }

    const systemMessage = SYSTEM_PROMPT + (contextInfo ? `\n\n--- CURRENT CONTEXT ---${contextInfo}` : "");

    console.log("Calling Lovable AI with context:", context ? JSON.stringify(context) : "none");

    const response = await fetch("https://ai.gateway.lovable.dev/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${LOVABLE_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "google/gemini-2.5-flash",
        messages: [
          { role: "system", content: systemMessage },
          ...messages,
        ],
        stream: true,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      console.error("AI Gateway error:", response.status, errorText);
      
      if (response.status === 429) {
        return new Response(JSON.stringify({ error: "Rate limit exceeded. Please try again in a moment." }), {
          status: 429,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
      if (response.status === 402) {
        return new Response(JSON.stringify({ error: "AI credits exhausted. Please add credits to continue." }), {
          status: 402,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
      
      return new Response(JSON.stringify({ error: "AI service temporarily unavailable" }), {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    console.log("Streaming response from AI Gateway");
    
    return new Response(response.body, {
      headers: { ...corsHeaders, "Content-Type": "text/event-stream" },
    });
  } catch (e) {
    console.error("Babua AI error:", e);
    return new Response(JSON.stringify({ error: e instanceof Error ? e.message : "Unknown error" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});

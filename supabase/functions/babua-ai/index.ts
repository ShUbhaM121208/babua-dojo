import "https://deno.land/x/xhr@0.1.0/mod.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { messages, context } = await req.json();
    const apiKey = Deno.env.get("GEMINI_API_KEY");

    if (!apiKey) {
      throw new Error("GEMINI_API_KEY not configured");
    }

    console.log("Received context:", JSON.stringify(context, null, 2));

    // Build comprehensive system prompt with context
    let systemPrompt = `You are Babua AI, an expert programming mentor specializing in Data Structures, Algorithms, and Software Engineering. 

Your teaching style:
- Break down complex concepts into simple, practical explanations
- Provide concrete examples and step-by-step guidance
- Help debug code and suggest optimizations
- Explain time and space complexity
- Give hints without giving away the complete solution

`;
    
    // Add current problem context
    if (context?.currentProblem) {
      const prob = context.currentProblem;
      console.log("Problem context found:", prob.title);
      systemPrompt += `\nCurrent Problem Context:
- Problem: ${prob.title}
- Difficulty: ${prob.difficulty}
- Description: ${prob.description}
- Tags: ${prob.tags?.join(", ") || "N/A"}
`;
    } else {
      console.log("No problem context provided");
    }

    // Add user code context
    if (context?.userCode) {
      systemPrompt += `\nUser's Current Code (${context.language || "javascript"}):
\`\`\`${context.language || "javascript"}
${context.userCode}
\`\`\`
`;
    }

    // Add test results if available
    if (context?.testResults) {
      systemPrompt += `\nTest Results:
- Passed: ${context.testResults.passed}/${context.testResults.total}
- Time: ${context.testResults.runtime || "N/A"}
${context.testResults.failedCases?.length ? `- Failed Cases: ${context.testResults.failedCases.map((c: any) => c.id).join(", ")}` : ""}
`;
    }

    if (context?.currentTopic) {
      systemPrompt += `\nCurrent Topic: ${context.currentTopic}`;
    }

    systemPrompt += `\n\nBe concise, practical, and encouraging. If the user asks about the current problem, refer to the context above.`;

    // Prepare Gemini messages
    const geminiMessages = [
      { role: "user", parts: [{ text: systemPrompt }] },
      ...messages.map((msg: any) => ({
        role: msg.role === "assistant" ? "model" : "user",
        parts: [{ text: msg.content }]
      }))
    ];

    // Call Gemini
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: geminiMessages,
          generationConfig: { temperature: 0.7, maxOutputTokens: 2048 },
        }),
      }
    );

    if (!response.ok) {
      const error = await response.text();
      console.error("Gemini error:", error);
      throw new Error("Gemini API failed");
    }

    const data = await response.json();
    const text = data.candidates?.[0]?.content?.parts?.[0]?.text || "No response";

    // Return as SSE stream with the format expected by frontend
    const encoder = new TextEncoder();
    const stream = new ReadableStream({
      start(controller) {
        // Send text in SSE format with proper JSON structure
        const sseData = `data: ${JSON.stringify({
          choices: [{ delta: { content: text } }]
        })}\n\n`;
        controller.enqueue(encoder.encode(sseData));
        controller.enqueue(encoder.encode("data: [DONE]\n\n"));
        controller.close();
      },
    });

    return new Response(stream, {
      headers: { ...corsHeaders, "Content-Type": "text/event-stream" },
    });
  } catch (error) {
    console.error("Error:", error);
    return new Response(
      JSON.stringify({ error: error.message || "Internal error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});

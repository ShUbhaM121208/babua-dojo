import { useState, useCallback } from "react";
import { useLocation } from "react-router-dom";
import type { AIContext, Message, Problem, UserProgress, TestResult } from "@/types";
import type { TutorHintLevel, SessionType, TutorHint } from "@/types/tutor";

const CHAT_URL = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/babua-ai`;

interface SendMessageOptions {
  problem?: Problem;
  userCode?: string;
  language?: string;
  testResults?: TestResult;
  userProgress?: UserProgress;
  tutorMode?: boolean;
  sessionType?: SessionType;
  hintLevel?: TutorHintLevel;
  previousHints?: TutorHint[];
}

export function useBabuaAI() {
  const [messages, setMessages] = useState<Message[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [lastRequestTime, setLastRequestTime] = useState<number>(0);
  const [tutorModeEnabled, setTutorModeEnabled] = useState(false);
  const [currentSessionType, setCurrentSessionType] = useState<SessionType>('hint_based');
  const location = useLocation();

  const COOLDOWN_MS = 2000; // 2 seconds between requests

  const buildContext = useCallback((options?: SendMessageOptions): AIContext => {
    const path = location.pathname;
    const context: AIContext = {
      currentRoute: path,
    };

    // Extract track from URL
    if (path.startsWith("/tracks/")) {
      const slug = path.split("/tracks/")[1];
      context.currentTrack = slug?.toUpperCase().replace("-", " ");
    }

    // Extract problem context
    if (path.startsWith("/practice")) {
      context.currentTrack = "Practice Problems";
    }

    if (path.startsWith("/problem/")) {
      const problemId = path.split("/problem/")[1];
      context.currentTopic = `Problem ${problemId}`;
    }

    // Add problem details if provided
    if (options?.problem) {
      console.log("Building context with problem:", options.problem.title);
      context.currentProblem = {
        id: options.problem.id,
        title: options.problem.title,
        difficulty: options.problem.difficulty,
        description: options.problem.description,
        tags: options.problem.tags,
      };
    } else {
      console.log("No problem provided in options");
    }

    // Add code context
    if (options?.userCode) {
      context.userCode = options.userCode;
      context.language = options.language || "javascript";
    }

    // Add test results
    if (options?.testResults) {
      context.testResults = options.testResults;
    }

    // Add user progress
    if (options?.userProgress) {
      context.userProgress = options.userProgress;
    }

    // Add tutor mode context
    if (options?.tutorMode) {
      context.tutorMode = {
        enabled: true,
        sessionType: options.sessionType || currentSessionType,
        hintLevel: options.hintLevel,
        previousHints: options.previousHints || []
      };
    }

    console.log("Final context being sent:", JSON.stringify(context, null, 2));
    return context;
  }, [location.pathname, currentSessionType]);

  const sendMessage = useCallback(async (
    input: string,
    options?: SendMessageOptions
  ) => {
    // Check cooldown
    const now = Date.now();
    const timeSinceLastRequest = now - lastRequestTime;
    if (timeSinceLastRequest < COOLDOWN_MS) {
      const waitTime = Math.ceil((COOLDOWN_MS - timeSinceLastRequest) / 1000);
      setError(`Please wait ${waitTime} second${waitTime > 1 ? 's' : ''} before sending another message.`);
      return;
    }
    
    setLastRequestTime(now);
    
    const userMsg: Message = { role: "user", content: input };
    setMessages((prev) => [...prev, userMsg]);
    setIsLoading(true);
    setError(null);

    let assistantContent = "";

    const updateAssistant = (chunk: string) => {
      assistantContent += chunk;
      setMessages((prev) => {
        const last = prev[prev.length - 1];
        if (last?.role === "assistant") {
          return prev.map((m, i) =>
            i === prev.length - 1 ? { ...m, content: assistantContent } : m
          );
        }
        return [...prev, { role: "assistant", content: assistantContent }];
      });
    };

    try {
      const context = buildContext(options);
      
      const resp = await fetch(CHAT_URL, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY}`,
        },
        body: JSON.stringify({
          messages: [...messages, userMsg],
          context,
        }),
      });

      if (!resp.ok) {
        const errorData = await resp.json().catch(() => ({}));
        
        // Handle rate limiting with user-friendly message
        if (resp.status === 429) {
          throw new Error("AI is processing too many requests. Please wait 30 seconds and try again.");
        }
        
        throw new Error(errorData.error || `Request failed: ${resp.status}`);
      }

      if (!resp.body) throw new Error("No response body");

      const reader = resp.body.getReader();
      const decoder = new TextDecoder();
      let buffer = "";

      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        buffer += decoder.decode(value, { stream: true });

        let newlineIndex: number;
        while ((newlineIndex = buffer.indexOf("\n")) !== -1) {
          let line = buffer.slice(0, newlineIndex);
          buffer = buffer.slice(newlineIndex + 1);

          if (line.endsWith("\r")) line = line.slice(0, -1);
          if (line.startsWith(":") || line.trim() === "") continue;
          if (!line.startsWith("data: ")) continue;

          const jsonStr = line.slice(6).trim();
          if (jsonStr === "[DONE]") break;

          try {
            const parsed = JSON.parse(jsonStr);
            const content = parsed.choices?.[0]?.delta?.content;
            if (content) updateAssistant(content);
          } catch {
            buffer = line + "\n" + buffer;
            break;
          }
        }
      }

      // Flush remaining buffer
      if (buffer.trim()) {
        for (let raw of buffer.split("\n")) {
          if (!raw) continue;
          if (raw.endsWith("\r")) raw = raw.slice(0, -1);
          if (!raw.startsWith("data: ")) continue;
          const jsonStr = raw.slice(6).trim();
          if (jsonStr === "[DONE]") continue;
          try {
            const parsed = JSON.parse(jsonStr);
            const content = parsed.choices?.[0]?.delta?.content;
            if (content) updateAssistant(content);
          } catch { /* ignore */ }
        }
      }
    } catch (e) {
      console.error("Babua AI error:", e);
      setError(e instanceof Error ? e.message : "Failed to get response");
      // Remove the user message if we failed
      setMessages((prev) => prev.slice(0, -1));
    } finally {
      setIsLoading(false);
    }
  }, [messages, buildContext, lastRequestTime]);

  const clearMessages = useCallback(() => {
    setMessages([]);
    setError(null);
  }, []);

  const enableTutorMode = useCallback((sessionType: SessionType = 'hint_based') => {
    setTutorModeEnabled(true);
    setCurrentSessionType(sessionType);
  }, []);

  const disableTutorMode = useCallback(() => {
    setTutorModeEnabled(false);
  }, []);

  const requestTutorHint = useCallback(async (
    problemId: string,
    hintLevel: TutorHintLevel,
    userCode?: string,
    previousHints?: TutorHint[]
  ): Promise<TutorHint | null> => {
    setIsLoading(true);
    setError(null);
    
    try {
      const context = buildContext({
        tutorMode: true,
        sessionType: currentSessionType,
        hintLevel,
        userCode,
        previousHints
      });
      
      const resp = await fetch(CHAT_URL, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY}`,
        },
        body: JSON.stringify({
          type: 'tutor_hint',
          problemId,
          hintLevel,
          userCode,
          previousHints,
          context,
        }),
      });

      if (!resp.ok) {
        throw new Error(`Request failed: ${resp.status}`);
      }

      const hint: TutorHint = await resp.json();
      return hint;
    } catch (e) {
      console.error("Tutor hint error:", e);
      setError(e instanceof Error ? e.message : "Failed to get hint");
      return null;
    } finally {
      setIsLoading(false);
    }
  }, [buildContext, currentSessionType]);

  return {
    messages,
    isLoading,
    error,
    sendMessage,
    clearMessages,
    tutorModeEnabled,
    currentSessionType,
    enableTutorMode,
    disableTutorMode,
    requestTutorHint,
  };
}

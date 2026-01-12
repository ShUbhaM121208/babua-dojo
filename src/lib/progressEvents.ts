// Progress update event system for real-time UI updates across all pages

export const PROGRESS_EVENTS = {
  PROBLEM_SOLVED: 'problem:solved',
  PROGRESS_UPDATED: 'progress:updated',
} as const;

export interface ProblemSolvedEvent {
  problemId: string;
  problemSlug?: string;
  trackSlug: string;
  difficulty: string;
}

/**
 * Emit a problem solved event
 */
export function emitProblemSolved(data: ProblemSolvedEvent): void {
  const event = new CustomEvent(PROGRESS_EVENTS.PROBLEM_SOLVED, { detail: data });
  window.dispatchEvent(event);
  console.log('📢 Emitted problem solved event:', data);
}

/**
 * Listen for problem solved events
 */
export function onProblemSolved(callback: (data: ProblemSolvedEvent) => void): () => void {
  const handler = (event: Event) => {
    const customEvent = event as CustomEvent<ProblemSolvedEvent>;
    callback(customEvent.detail);
  };
  
  window.addEventListener(PROGRESS_EVENTS.PROBLEM_SOLVED, handler);
  
  // Return cleanup function
  return () => window.removeEventListener(PROGRESS_EVENTS.PROBLEM_SOLVED, handler);
}

/**
 * Emit a general progress update event
 */
export function emitProgressUpdated(): void {
  const event = new CustomEvent(PROGRESS_EVENTS.PROGRESS_UPDATED);
  window.dispatchEvent(event);
}

/**
 * Listen for progress update events
 */
export function onProgressUpdated(callback: () => void): () => void {
  window.addEventListener(PROGRESS_EVENTS.PROGRESS_UPDATED, callback);
  return () => window.removeEventListener(PROGRESS_EVENTS.PROGRESS_UPDATED, callback);
}

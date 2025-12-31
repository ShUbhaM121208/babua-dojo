import { useState, useEffect, useCallback, useRef } from 'react';

interface AsyncState<T> {
  data: T | null;
  loading: boolean;
  error: Error | null;
}

interface UseAsyncOptions<T> {
  onSuccess?: (data: T) => void;
  onError?: (error: Error) => void;
  initialData?: T | null;
}

/**
 * Custom hook for handling async operations with loading, error, and data states
 */
export function useAsync<T>(
  asyncFunction: (...args: any[]) => Promise<T>,
  options: UseAsyncOptions<T> = {}
) {
  const [state, setState] = useState<AsyncState<T>>({
    data: options.initialData ?? null,
    loading: false,
    error: null,
  });

  const mountedRef = useRef(true);

  useEffect(() => {
    return () => {
      mountedRef.current = false;
    };
  }, []);

  const execute = useCallback(
    async (...args: any[]) => {
      setState({ data: state.data, loading: true, error: null });

      try {
        const data = await asyncFunction(...args);
        
        if (mountedRef.current) {
          setState({ data, loading: false, error: null });
          options.onSuccess?.(data);
        }
        
        return data;
      } catch (error) {
        const err = error instanceof Error ? error : new Error(String(error));
        
        if (mountedRef.current) {
          setState({ data: null, loading: false, error: err });
          options.onError?.(err);
        }
        
        throw err;
      }
    },
    [asyncFunction, options.onSuccess, options.onError]
  );

  const reset = useCallback(() => {
    setState({
      data: options.initialData ?? null,
      loading: false,
      error: null,
    });
  }, [options.initialData]);

  return {
    ...state,
    execute,
    reset,
  };
}

/**
 * Hook for debouncing values
 */
export function useDebounce<T>(value: T, delay: number = 500): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => {
      clearTimeout(handler);
    };
  }, [value, delay]);

  return debouncedValue;
}

/**
 * Hook for handling intervals with proper cleanup
 */
export function useInterval(callback: () => void, delay: number | null) {
  const savedCallback = useRef(callback);

  useEffect(() => {
    savedCallback.current = callback;
  }, [callback]);

  useEffect(() => {
    if (delay === null) return;

    const id = setInterval(() => savedCallback.current(), delay);
    return () => clearInterval(id);
  }, [delay]);
}

/**
 * Hook for detecting clicks outside an element
 */
export function useClickOutside<T extends HTMLElement = HTMLElement>(
  callback: () => void
) {
  const ref = useRef<T>(null);

  useEffect(() => {
    const handleClick = (event: MouseEvent) => {
      if (ref.current && !ref.current.contains(event.target as Node)) {
        callback();
      }
    };

    document.addEventListener('mousedown', handleClick);
    return () => document.removeEventListener('mousedown', handleClick);
  }, [callback]);

  return ref;
}

/**
 * Hook for keyboard shortcuts
 */
export function useKeyPress(
  targetKey: string,
  callback: () => void,
  modifiers?: {
    ctrl?: boolean;
    shift?: boolean;
    alt?: boolean;
    meta?: boolean;
  }
) {
  useEffect(() => {
    const handleKeyPress = (event: KeyboardEvent) => {
      const matchesModifiers = 
        (!modifiers?.ctrl || event.ctrlKey) &&
        (!modifiers?.shift || event.shiftKey) &&
        (!modifiers?.alt || event.altKey) &&
        (!modifiers?.meta || event.metaKey);

      if (event.key === targetKey && matchesModifiers) {
        event.preventDefault();
        callback();
      }
    };

    window.addEventListener('keydown', handleKeyPress);
    return () => window.removeEventListener('keydown', handleKeyPress);
  }, [targetKey, callback, modifiers]);
}

/**
 * Hook for copying text to clipboard
 */
export function useClipboard(timeout: number = 2000) {
  const [isCopied, setIsCopied] = useState(false);

  const copy = async (text: string) => {
    try {
      await navigator.clipboard.writeText(text);
      setIsCopied(true);

      setTimeout(() => {
        setIsCopied(false);
      }, timeout);

      return true;
    } catch (error) {
      console.error('Failed to copy:', error);
      setIsCopied(false);
      return false;
    }
  };

  return { isCopied, copy };
}

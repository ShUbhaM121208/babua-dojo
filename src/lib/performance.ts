/**
 * Performance monitoring utilities for tracking page load times and user interactions
 */

interface PerformanceMetrics {
  pageLoadTime: number;
  domContentLoaded: number;
  firstContentfulPaint: number;
  largestContentfulPaint: number;
  firstInputDelay: number;
  cumulativeLayoutShift: number;
}

/**
 * Get web vitals and performance metrics
 */
export function getPerformanceMetrics(): Partial<PerformanceMetrics> {
  if (typeof window === 'undefined' || !window.performance) {
    return {};
  }

  const navigation = performance.getEntriesByType('navigation')[0] as PerformanceNavigationTiming;
  const paint = performance.getEntriesByType('paint');

  const metrics: Partial<PerformanceMetrics> = {};

  // Page load time
  if (navigation) {
    metrics.pageLoadTime = navigation.loadEventEnd - navigation.fetchStart;
    metrics.domContentLoaded = navigation.domContentLoadedEventEnd - navigation.fetchStart;
  }

  // First Contentful Paint
  const fcp = paint.find(entry => entry.name === 'first-contentful-paint');
  if (fcp) {
    metrics.firstContentfulPaint = fcp.startTime;
  }

  return metrics;
}

/**
 * Log performance metrics to console in development
 */
export function logPerformanceMetrics(): void {
  if (process.env.NODE_ENV !== 'development') return;

  window.addEventListener('load', () => {
    setTimeout(() => {
      const metrics = getPerformanceMetrics();
      console.group('⚡ Performance Metrics');
      console.log('Page Load Time:', `${metrics.pageLoadTime?.toFixed(2)}ms`);
      console.log('DOM Content Loaded:', `${metrics.domContentLoaded?.toFixed(2)}ms`);
      console.log('First Contentful Paint:', `${metrics.firstContentfulPaint?.toFixed(2)}ms`);
      console.groupEnd();
    }, 0);
  });
}

/**
 * Measure function execution time
 */
export function measurePerformance<T>(
  fn: () => T,
  label: string = 'Function'
): T {
  const start = performance.now();
  const result = fn();
  const end = performance.now();
  
  if (process.env.NODE_ENV === 'development') {
    console.log(`${label} took ${(end - start).toFixed(2)}ms`);
  }
  
  return result;
}

/**
 * Measure async function execution time
 */
export async function measureAsyncPerformance<T>(
  fn: () => Promise<T>,
  label: string = 'Async Function'
): Promise<T> {
  const start = performance.now();
  const result = await fn();
  const end = performance.now();
  
  if (process.env.NODE_ENV === 'development') {
    console.log(`${label} took ${(end - start).toFixed(2)}ms`);
  }
  
  return result;
}

/**
 * Mark a custom performance entry
 */
export function markPerformance(name: string): void {
  if (typeof window !== 'undefined' && window.performance) {
    performance.mark(name);
  }
}

/**
 * Measure time between two marks
 */
export function measureBetweenMarks(
  measureName: string,
  startMark: string,
  endMark: string
): number | null {
  if (typeof window === 'undefined' || !window.performance) {
    return null;
  }

  try {
    performance.measure(measureName, startMark, endMark);
    const measure = performance.getEntriesByName(measureName)[0];
    return measure ? measure.duration : null;
  } catch (error) {
    console.error('Error measuring performance:', error);
    return null;
  }
}

/**
 * Clear performance marks and measures
 */
export function clearPerformanceMarks(name?: string): void {
  if (typeof window !== 'undefined' && window.performance) {
    if (name) {
      performance.clearMarks(name);
      performance.clearMeasures(name);
    } else {
      performance.clearMarks();
      performance.clearMeasures();
    }
  }
}

/**
 * Report performance to analytics (placeholder)
 */
export function reportPerformance(
  metric: string,
  value: number,
  metadata?: Record<string, any>
): void {
  if (process.env.NODE_ENV === 'production') {
    // Integrate with analytics service (Google Analytics, Mixpanel, etc.)
    // Example: gtag('event', 'performance', { metric, value, ...metadata });
    console.log('Performance Report:', { metric, value, metadata });
  }
}

/**
 * Monitor Core Web Vitals
 */
export function monitorWebVitals(): void {
  if (typeof window === 'undefined') return;

  // LCP - Largest Contentful Paint
  const lcpObserver = new PerformanceObserver((list) => {
    const entries = list.getEntries();
    const lastEntry = entries[entries.length - 1] as PerformanceEntry;
    reportPerformance('LCP', lastEntry.startTime);
  });

  try {
    lcpObserver.observe({ entryTypes: ['largest-contentful-paint'] });
  } catch (e) {
    // Browser doesn't support this metric
  }

  // FID - First Input Delay
  const fidObserver = new PerformanceObserver((list) => {
    const entries = list.getEntries();
    entries.forEach((entry: any) => {
      reportPerformance('FID', entry.processingStart - entry.startTime);
    });
  });

  try {
    fidObserver.observe({ entryTypes: ['first-input'] });
  } catch (e) {
    // Browser doesn't support this metric
  }

  // CLS - Cumulative Layout Shift
  let clsValue = 0;
  const clsObserver = new PerformanceObserver((list) => {
    list.getEntries().forEach((entry: any) => {
      if (!entry.hadRecentInput) {
        clsValue += entry.value;
        reportPerformance('CLS', clsValue);
      }
    });
  });

  try {
    clsObserver.observe({ entryTypes: ['layout-shift'] });
  } catch (e) {
    // Browser doesn't support this metric
  }
}

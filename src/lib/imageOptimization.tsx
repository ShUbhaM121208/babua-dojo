import { useState, useEffect, useRef, ImgHTMLAttributes } from 'react';

interface LazyImageProps extends ImgHTMLAttributes<HTMLImageElement> {
  src: string;
  alt: string;
  placeholder?: string;
  threshold?: number;
}

/**
 * Lazy-loaded image component with intersection observer
 */
export function LazyImage({ 
  src, 
  alt, 
  placeholder = 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 300"%3E%3Crect fill="%23e2e8f0" width="400" height="300"/%3E%3C/svg%3E',
  threshold = 0.1,
  className = '',
  ...props 
}: LazyImageProps) {
  const [imageSrc, setImageSrc] = useState(placeholder);
  const [isLoaded, setIsLoaded] = useState(false);
  const imgRef = useRef<HTMLImageElement>(null);

  useEffect(() => {
    if (!imgRef.current) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setImageSrc(src);
          observer.disconnect();
        }
      },
      { threshold }
    );

    observer.observe(imgRef.current);

    return () => {
      observer.disconnect();
    };
  }, [src, threshold]);

  return (
    <img
      ref={imgRef}
      src={imageSrc}
      alt={alt}
      className={`transition-opacity duration-300 ${isLoaded ? 'opacity-100' : 'opacity-0'} ${className}`}
      onLoad={() => setIsLoaded(true)}
      loading="lazy"
      {...props}
    />
  );
}

/**
 * Get optimized image URL (placeholder for future CDN integration)
 */
export function getOptimizedImageUrl(
  url: string,
  options?: {
    width?: number;
    height?: number;
    quality?: number;
    format?: 'webp' | 'avif' | 'jpeg' | 'png';
  }
): string {
  // For now, return original URL
  // In production, integrate with image CDN like Cloudinary, imgix, or Vercel Image Optimization
  // Example: return `${CDN_URL}/${url}?w=${options?.width}&q=${options?.quality}&f=${options?.format}`;
  return url;
}

/**
 * Preload critical images
 */
export function preloadImage(src: string): Promise<void> {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.onload = () => resolve();
    img.onerror = reject;
    img.src = src;
  });
}

/**
 * Preload multiple images
 */
export async function preloadImages(srcs: string[]): Promise<void> {
  await Promise.all(srcs.map(preloadImage));
}

import { Header } from "./Header";
import { BabuaAIChat } from "@/components/ai/BabuaAIChat";

interface LayoutProps {
  children: React.ReactNode;
  title?: string;
}

export function Layout({ children, title }: LayoutProps) {
  return (
    <div className="min-h-screen bg-background">
      <a 
        href="#main-content" 
        className="sr-only focus:not-sr-only focus:absolute focus:top-4 focus:left-4 focus:z-50 focus:px-4 focus:py-2 focus:bg-primary focus:text-primary-foreground focus:rounded"
        aria-label="Skip to main content"
      >
        Skip to main content
      </a>
      <Header />
      <main 
        id="main-content" 
        className="pt-16"
        role="main"
        aria-label={title || "Main content"}
      >
        {children}
      </main>
      <BabuaAIChat />
    </div>
  );
}

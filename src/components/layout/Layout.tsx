import { Header } from "./Header";
import { BabuaAIChat } from "@/components/ai/BabuaAIChat";

interface LayoutProps {
  children: React.ReactNode;
}

export function Layout({ children }: LayoutProps) {
  return (
    <div className="min-h-screen bg-background">
      <Header />
      <main className="pt-16">{children}</main>
      <BabuaAIChat />
    </div>
  );
}

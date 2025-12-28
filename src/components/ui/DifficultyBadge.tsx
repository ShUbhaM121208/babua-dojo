import { cn } from "@/lib/utils";

interface DifficultyBadgeProps {
  difficulty: "easy" | "medium" | "hard" | "mixed";
  className?: string;
}

export function DifficultyBadge({ difficulty, className }: DifficultyBadgeProps) {
  const styles = {
    easy: "badge-easy",
    medium: "badge-medium",
    hard: "badge-hard",
    mixed: "bg-muted text-muted-foreground border-border",
  };

  const labels = {
    easy: "Easy",
    medium: "Medium",
    hard: "Hard",
    mixed: "Mixed",
  };

  return (
    <span
      className={cn(
        "inline-flex items-center px-2.5 py-0.5 rounded text-xs font-mono border",
        styles[difficulty],
        className
      )}
    >
      {labels[difficulty]}
    </span>
  );
}

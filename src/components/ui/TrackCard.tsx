import { Link } from "react-router-dom";
import { DifficultyBadge } from "./DifficultyBadge";
import { ArrowRight } from "lucide-react";

interface TrackCardProps {
  slug: string;
  title: string;
  shortTitle: string;
  description: string;
  topics: number;
  problems: number;
  difficulty: "easy" | "medium" | "hard" | "mixed";
  progress: number;
  icon: string;
}

export function TrackCard({
  slug,
  title,
  shortTitle,
  description,
  topics,
  problems,
  difficulty,
  progress,
  icon,
}: TrackCardProps) {
  return (
    <Link
      to={`/tracks/${slug}`}
      className="group block surface-card p-6 hover:border-primary/50 transition-all duration-300 hover-lift"
    >
      <div className="flex items-start justify-between mb-4">
        <span className="text-3xl">{icon}</span>
        <DifficultyBadge difficulty={difficulty} />
      </div>

      <h3 className="font-mono text-lg font-semibold mb-2 group-hover:text-primary transition-colors">
        {title}
      </h3>

      <p className="text-sm text-muted-foreground mb-4 line-clamp-2">
        {description}
      </p>

      <div className="flex items-center gap-4 text-xs text-muted-foreground mb-4">
        <span className="font-mono">{topics} topics</span>
        <span className="text-border">•</span>
        <span className="font-mono">{problems} problems</span>
      </div>

      {/* Progress Bar */}
      <div className="mb-4">
        <div className="flex justify-between text-xs mb-1">
          <span className="text-muted-foreground">Progress</span>
          <span className="font-mono text-primary">{progress}%</span>
        </div>
        <div className="h-1.5 bg-secondary rounded-full overflow-hidden">
          <div
            className="h-full bg-primary rounded-full transition-all duration-500"
            style={{ width: `${progress}%` }}
          />
        </div>
      </div>

      <div className="flex items-center text-sm font-medium text-primary opacity-0 group-hover:opacity-100 transition-opacity">
        <span>Continue Learning</span>
        <ArrowRight className="ml-1 h-4 w-4" />
      </div>
    </Link>
  );
}

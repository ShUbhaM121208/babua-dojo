import { Progress } from "./progress";
import { calculateLevel, levels } from "@/data/achievements";
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip";

interface LevelProgressBarProps {
  currentXP: number;
  showDetails?: boolean;
}

export function LevelProgressBar({ currentXP, showDetails = true }: LevelProgressBarProps) {
  const currentLevel = calculateLevel(currentXP);
  const nextLevel = levels.find(l => l.level === currentLevel.level + 1);
  
  const xpInCurrentLevel = currentXP - currentLevel.minXP;
  const xpNeededForNextLevel = nextLevel ? nextLevel.minXP - currentLevel.minXP : 0;
  const progressPercentage = nextLevel 
    ? (xpInCurrentLevel / xpNeededForNextLevel) * 100 
    : 100;

  return (
    <div className="space-y-2">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <span className="text-3xl">{currentLevel.badge}</span>
          <div>
            <p className="font-semibold text-lg">Level {currentLevel.level}</p>
            <p className="text-sm text-muted-foreground">{currentLevel.title}</p>
          </div>
        </div>
        {showDetails && (
          <div className="text-right">
            <p className="text-sm font-mono font-semibold">{currentXP.toLocaleString()} XP</p>
            {nextLevel && (
              <p className="text-xs text-muted-foreground">
                {xpNeededForNextLevel - xpInCurrentLevel} XP to Level {nextLevel.level}
              </p>
            )}
          </div>
        )}
      </div>
      
      <TooltipProvider>
        <Tooltip>
          <TooltipTrigger asChild>
            <div className="space-y-1">
              <Progress value={progressPercentage} className="h-3" />
              {showDetails && nextLevel && (
                <div className="flex justify-between text-xs text-muted-foreground">
                  <span>{currentLevel.minXP.toLocaleString()} XP</span>
                  <span>{nextLevel.minXP.toLocaleString()} XP</span>
                </div>
              )}
            </div>
          </TooltipTrigger>
          <TooltipContent>
            <div className="space-y-1">
              <p className="font-semibold">Progress to {nextLevel?.title || 'Max Level'}</p>
              <p className="text-sm">
                {xpInCurrentLevel.toLocaleString()} / {xpNeededForNextLevel.toLocaleString()} XP
              </p>
              <p className="text-xs text-muted-foreground">
                {progressPercentage.toFixed(1)}% complete
              </p>
            </div>
          </TooltipContent>
        </Tooltip>
      </TooltipProvider>

      {!nextLevel && (
        <p className="text-center text-sm text-amber-500 font-semibold">
          🏆 Max Level Reached!
        </p>
      )}
    </div>
  );
}

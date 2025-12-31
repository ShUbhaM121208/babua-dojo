import { Achievement } from "@/data/achievements";
import { Badge } from "./badge";
import { Card } from "./card";
import { Lock } from "lucide-react";
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip";

interface AchievementBadgeProps {
  achievement: Achievement;
  unlocked: boolean;
  unlockedAt?: string;
  size?: 'sm' | 'md' | 'lg';
  showProgress?: boolean;
  currentProgress?: number;
}

export function AchievementBadge({ 
  achievement, 
  unlocked, 
  unlockedAt,
  size = 'md',
  showProgress = false,
  currentProgress = 0
}: AchievementBadgeProps) {
  const sizeClasses = {
    sm: 'w-16 h-20',
    md: 'w-20 h-24',
    lg: 'w-32 h-36'
  };

  const iconSizes = {
    sm: 'text-2xl',
    md: 'text-3xl',
    lg: 'text-5xl'
  };

  const rarityColors = {
    common: 'border-gray-500',
    rare: 'border-blue-500',
    epic: 'border-purple-500',
    legendary: 'border-amber-500'
  };

  const rarityGradients = {
    common: 'from-gray-500/20 to-gray-500/5',
    rare: 'from-blue-500/20 to-blue-500/5',
    epic: 'from-purple-500/20 to-purple-500/5',
    legendary: 'from-amber-500/20 to-amber-500/5'
  };

  const progressPercentage = showProgress && achievement.requirement.value 
    ? Math.min((currentProgress / achievement.requirement.value) * 100, 100)
    : 0;

  return (
    <TooltipProvider>
      <Tooltip>
        <TooltipTrigger asChild>
          <Card 
            className={`
              ${sizeClasses[size]} 
              ${unlocked ? rarityColors[achievement.rarity] : 'border-gray-700'} 
              ${unlocked ? `bg-gradient-to-br ${rarityGradients[achievement.rarity]}` : 'bg-gray-900/50'}
              relative overflow-hidden cursor-pointer transition-all hover:scale-105 hover:shadow-lg
              ${!unlocked && 'opacity-60 grayscale'}
            `}
          >
            <div className="absolute inset-0 flex flex-col items-center justify-center p-2">
              {!unlocked && (
                <div className="absolute inset-0 bg-black/40 backdrop-blur-[2px] flex items-center justify-center">
                  <Lock className="h-6 w-6 text-gray-400" />
                </div>
              )}
              
              <div className={`${iconSizes[size]} mb-1 ${unlocked ? '' : 'filter blur-sm'}`}>
                {achievement.icon}
              </div>
              
              <div className="text-center">
                <p className={`font-semibold ${size === 'sm' ? 'text-[10px]' : size === 'md' ? 'text-xs' : 'text-sm'} line-clamp-2`}>
                  {achievement.title}
                </p>
                {unlocked && unlockedAt && size === 'lg' && (
                  <p className="text-[10px] text-muted-foreground mt-1">
                    {new Date(unlockedAt).toLocaleDateString()}
                  </p>
                )}
              </div>

              {showProgress && !unlocked && (
                <div className="absolute bottom-0 left-0 right-0 h-1 bg-gray-700">
                  <div 
                    className="h-full bg-primary transition-all"
                    style={{ width: `${progressPercentage}%` }}
                  />
                </div>
              )}
            </div>
          </Card>
        </TooltipTrigger>
        <TooltipContent side="top" className="max-w-xs">
          <div className="space-y-2">
            <div className="flex items-center justify-between gap-2">
              <p className="font-semibold">{achievement.title}</p>
              <Badge variant={unlocked ? "default" : "secondary"} className="text-xs">
                {achievement.rarity}
              </Badge>
            </div>
            <p className="text-sm text-muted-foreground">{achievement.description}</p>
            <div className="flex items-center justify-between text-xs pt-2 border-t">
              <span className="text-muted-foreground">Reward:</span>
              <span className="font-semibold text-amber-500">+{achievement.xpReward} XP</span>
            </div>
            {showProgress && !unlocked && (
              <div className="text-xs text-muted-foreground pt-1">
                Progress: {currentProgress} / {achievement.requirement.value}
              </div>
            )}
            {unlocked && unlockedAt && (
              <div className="text-xs text-green-500 pt-1">
                ✓ Unlocked on {new Date(unlockedAt).toLocaleDateString()}
              </div>
            )}
          </div>
        </TooltipContent>
      </Tooltip>
    </TooltipProvider>
  );
}

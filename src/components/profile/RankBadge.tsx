import { cn } from '@/lib/utils';
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from '@/components/ui/tooltip';
import { RankConfig, RANKS, getRankConfig } from '@/lib/rankService';
import { motion } from 'framer-motion';

interface RankBadgeProps {
  rank: string;
  xp?: number;
  xpToNext?: number;
  progressPercentage?: number;
  size?: 'small' | 'medium' | 'large';
  showTooltip?: boolean;
  animated?: boolean;
  className?: string;
}

export function RankBadge({
  rank,
  xp,
  xpToNext,
  progressPercentage,
  size = 'medium',
  showTooltip = true,
  animated = true,
  className,
}: RankBadgeProps) {
  const rankConfig = getRankConfig(rank);

  if (!rankConfig) {
    return null;
  }

  const sizeClasses = {
    small: 'h-6 px-2 text-xs',
    medium: 'h-8 px-3 text-sm',
    large: 'h-10 px-4 text-base',
  };

  const iconSizes = {
    small: 'text-xs',
    medium: 'text-sm',
    large: 'text-base',
  };

  // Determine if rank is high tier (master, grandmaster, legend)
  const isHighTier = ['master', 'grandmaster', 'legend'].includes(rank.toLowerCase());

  const badgeContent = (
    <motion.div
      initial={animated ? { scale: 0.9, opacity: 0 } : false}
      animate={animated ? { scale: 1, opacity: 1 } : false}
      transition={{ duration: 0.3 }}
      className={cn(
        'inline-flex items-center gap-1.5 rounded-full font-semibold',
        'border-2 backdrop-blur-sm',
        sizeClasses[size],
        isHighTier && animated && 'animate-glow',
        className
      )}
      style={{
        backgroundColor: `${rankConfig.color}20`,
        borderColor: rankConfig.color,
        color: rankConfig.color,
      }}
    >
      {rankConfig.icon && (
        <span className={iconSizes[size]}>{rankConfig.icon}</span>
      )}
      <span className="capitalize">{rankConfig.title}</span>
    </motion.div>
  );

  if (!showTooltip) {
    return badgeContent;
  }

  return (
    <TooltipProvider>
      <Tooltip>
        <TooltipTrigger asChild>
          {badgeContent}
        </TooltipTrigger>
        <TooltipContent className="max-w-xs">
          <div className="space-y-2">
            <div className="flex items-center gap-2">
              <span className="text-lg">{rankConfig.icon}</span>
              <div>
                <div className="font-semibold capitalize">{rankConfig.title}</div>
                {xp !== undefined && (
                  <div className="text-xs text-muted-foreground">
                    {xp.toLocaleString()} XP
                  </div>
                )}
              </div>
            </div>

            {progressPercentage !== undefined && xpToNext !== undefined && xpToNext > 0 && (
              <div className="space-y-1">
                <div className="flex justify-between text-xs">
                  <span className="text-muted-foreground">Progress to next rank</span>
                  <span className="font-medium">{progressPercentage}%</span>
                </div>
                <div className="h-2 w-full rounded-full bg-muted overflow-hidden">
                  <motion.div
                    initial={{ width: 0 }}
                    animate={{ width: `${progressPercentage}%` }}
                    transition={{ duration: 0.5, ease: 'easeOut' }}
                    className="h-full rounded-full"
                    style={{ backgroundColor: rankConfig.color }}
                  />
                </div>
                <div className="text-xs text-muted-foreground text-center">
                  {xpToNext.toLocaleString()} XP to next rank
                </div>
              </div>
            )}

            {xpToNext === 0 && (
              <div className="text-xs text-center font-semibold text-yellow-500">
                🏆 Maximum Rank Achieved!
              </div>
            )}
          </div>
        </TooltipContent>
      </Tooltip>
    </TooltipProvider>
  );
}

// ============================================
// RANK PROGRESS CARD
// ============================================

interface RankProgressCardProps {
  currentRank: string;
  xp: number;
  xpToNext: number;
  progressPercentage: number;
  nextRank?: string | null;
  className?: string;
}

export function RankProgressCard({
  currentRank,
  xp,
  xpToNext,
  progressPercentage,
  nextRank,
  className,
}: RankProgressCardProps) {
  const rankConfig = getRankConfig(currentRank);
  const nextRankConfig = nextRank ? getRankConfig(nextRank) : null;

  if (!rankConfig) return null;

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      className={cn(
        'rounded-lg border bg-card p-6 shadow-sm',
        className
      )}
    >
      <div className="space-y-4">
        {/* Current Rank */}
        <div className="flex items-center justify-between">
          <div>
            <div className="text-sm text-muted-foreground">Current Rank</div>
            <div className="flex items-center gap-2 mt-1">
              <span className="text-3xl">{rankConfig.icon}</span>
              <div>
                <div className="text-xl font-bold capitalize" style={{ color: rankConfig.color }}>
                  {rankConfig.title}
                </div>
                <div className="text-sm text-muted-foreground">
                  {xp.toLocaleString()} XP
                </div>
              </div>
            </div>
          </div>

          {nextRankConfig && (
            <div className="text-right">
              <div className="text-sm text-muted-foreground">Next Rank</div>
              <div className="flex items-center gap-2 mt-1 justify-end">
                <div>
                  <div className="text-lg font-semibold capitalize" style={{ color: nextRankConfig.color }}>
                    {nextRankConfig.title}
                  </div>
                  <div className="text-xs text-muted-foreground">
                    {nextRankConfig.minXP.toLocaleString()} XP
                  </div>
                </div>
                <span className="text-2xl opacity-50">{nextRankConfig.icon}</span>
              </div>
            </div>
          )}
        </div>

        {/* Progress Bar */}
        {nextRankConfig ? (
          <div className="space-y-2">
            <div className="flex justify-between text-sm">
              <span className="text-muted-foreground">Progress</span>
              <span className="font-medium">{progressPercentage}%</span>
            </div>
            <div className="relative h-3 w-full rounded-full bg-muted overflow-hidden">
              <motion.div
                initial={{ width: 0 }}
                animate={{ width: `${progressPercentage}%` }}
                transition={{ duration: 1, ease: 'easeOut' }}
                className="h-full rounded-full relative overflow-hidden"
                style={{
                  background: `linear-gradient(90deg, ${rankConfig.color} 0%, ${nextRankConfig.color} 100%)`,
                }}
              >
                <motion.div
                  animate={{
                    x: ['0%', '100%'],
                  }}
                  transition={{
                    duration: 2,
                    repeat: Infinity,
                    ease: 'linear',
                  }}
                  className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent"
                />
              </motion.div>
            </div>
            <div className="text-center text-sm text-muted-foreground">
              <span className="font-medium text-foreground">{xpToNext.toLocaleString()} XP</span> until {nextRankConfig.title}
            </div>
          </div>
        ) : (
          <div className="text-center py-4">
            <div className="text-2xl mb-2">🏆</div>
            <div className="font-semibold text-yellow-500">Maximum Rank Achieved!</div>
            <div className="text-sm text-muted-foreground mt-1">
              You've reached the pinnacle of achievement
            </div>
          </div>
        )}

        {/* Rank Tier Indicators */}
        <div className="flex justify-between pt-2">
          {RANKS.map((r, idx) => {
            const isActive = r.title === currentRank;
            const isPast = r.minXP < rankConfig.minXP;
            
            return (
              <TooltipProvider key={r.title}>
                <Tooltip>
                  <TooltipTrigger>
                    <div
                      className={cn(
                        'w-8 h-8 rounded-full flex items-center justify-center text-sm transition-all',
                        isActive && 'ring-2 ring-offset-2 scale-110',
                        isPast && 'opacity-100',
                        !isPast && !isActive && 'opacity-30'
                      )}
                      style={{
                        backgroundColor: isActive || isPast ? r.color : '#6b7280',
                        ringColor: isActive ? r.color : 'transparent',
                      }}
                    >
                      {r.icon}
                    </div>
                  </TooltipTrigger>
                  <TooltipContent>
                    <div className="text-xs">
                      <div className="font-semibold capitalize">{r.title}</div>
                      <div className="text-muted-foreground">{r.minXP.toLocaleString()} XP</div>
                    </div>
                  </TooltipContent>
                </Tooltip>
              </TooltipProvider>
            );
          })}
        </div>
      </div>
    </motion.div>
  );
}

// ============================================
// TITLE BADGE
// ============================================

interface TitleBadgeProps {
  title: string;
  icon?: string;
  color?: string;
  rarity?: 'common' | 'rare' | 'epic' | 'legendary';
  size?: 'small' | 'medium';
  className?: string;
}

export function TitleBadge({
  title,
  icon,
  color = '#8b5cf6',
  rarity = 'common',
  size = 'medium',
  className,
}: TitleBadgeProps) {
  const sizeClasses = {
    small: 'h-6 px-2 text-xs',
    medium: 'h-7 px-3 text-sm',
  };

  const rarityStyles = {
    common: 'border-gray-400',
    rare: 'border-blue-500',
    epic: 'border-purple-500',
    legendary: 'border-yellow-500 animate-glow',
  };

  return (
    <div
      className={cn(
        'inline-flex items-center gap-1.5 rounded-md font-medium border',
        'backdrop-blur-sm',
        sizeClasses[size],
        rarityStyles[rarity],
        className
      )}
      style={{
        backgroundColor: `${color}15`,
        color: color,
      }}
    >
      {icon && <span>{icon}</span>}
      <span>{title}</span>
    </div>
  );
}

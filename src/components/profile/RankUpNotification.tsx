import { useEffect, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Dialog, DialogContent } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import confetti from 'canvas-confetti';
import { getRankConfig } from '@/lib/rankService';
import { Sparkles, Trophy, Star, ArrowRight } from 'lucide-react';

interface RankUpNotificationProps {
  oldRank: string;
  newRank: string;
  newXP: number;
  onClose: () => void;
}

export function RankUpNotification({
  oldRank,
  newRank,
  newXP,
  onClose,
}: RankUpNotificationProps) {
  const [show, setShow] = useState(true);
  const oldRankConfig = getRankConfig(oldRank);
  const newRankConfig = getRankConfig(newRank);

  useEffect(() => {
    // Trigger confetti animation
    const duration = 3000;
    const animationEnd = Date.now() + duration;
    const defaults = { startVelocity: 30, spread: 360, ticks: 60, zIndex: 9999 };

    function randomInRange(min: number, max: number) {
      return Math.random() * (max - min) + min;
    }

    const interval = setInterval(function () {
      const timeLeft = animationEnd - Date.now();

      if (timeLeft <= 0) {
        return clearInterval(interval);
      }

      const particleCount = 50 * (timeLeft / duration);

      confetti({
        ...defaults,
        particleCount,
        origin: { x: randomInRange(0.1, 0.3), y: Math.random() - 0.2 },
        colors: [newRankConfig?.color || '#8b5cf6', oldRankConfig?.color || '#3b82f6'],
      });
      confetti({
        ...defaults,
        particleCount,
        origin: { x: randomInRange(0.7, 0.9), y: Math.random() - 0.2 },
        colors: [newRankConfig?.color || '#8b5cf6', oldRankConfig?.color || '#3b82f6'],
      });
    }, 250);

    // Play sound effect (optional)
    try {
      const audio = new Audio('/sounds/rank-up.mp3');
      audio.volume = 0.5;
      audio.play().catch(() => {
        // Ignore if sound fails to play
      });
    } catch (error) {
      // Sound not available
    }

    return () => clearInterval(interval);
  }, [newRankConfig?.color, oldRankConfig?.color]);

  const handleClose = () => {
    setShow(false);
    setTimeout(onClose, 300);
  };

  if (!oldRankConfig || !newRankConfig) return null;

  return (
    <Dialog open={show} onOpenChange={handleClose}>
      <DialogContent className="sm:max-w-md !fixed !left-[50%] !top-[50%] !translate-x-[-50%] !translate-y-[-50%]">
        <div className="relative overflow-hidden">
          {/* Animated background */}
          <motion.div
            animate={{
              background: [
                `radial-gradient(circle at 20% 50%, ${oldRankConfig.color}20 0%, transparent 50%)`,
                `radial-gradient(circle at 80% 50%, ${newRankConfig.color}20 0%, transparent 50%)`,
                `radial-gradient(circle at 20% 50%, ${oldRankConfig.color}20 0%, transparent 50%)`,
              ],
            }}
            transition={{ duration: 3, repeat: Infinity }}
            className="absolute inset-0 pointer-events-none"
          />

          <div className="relative space-y-6 p-6">
            {/* Header */}
            <div className="text-center space-y-2">
              <motion.div
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ type: 'spring', duration: 0.5 }}
                className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-gradient-to-br from-yellow-400 to-yellow-600 mx-auto"
              >
                <Trophy className="w-8 h-8 text-white" />
              </motion.div>

              <motion.h2
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.2 }}
                className="text-2xl font-bold"
              >
                Rank Up!
              </motion.h2>

              <motion.p
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 0.3 }}
                className="text-muted-foreground"
              >
                Congratulations on your progress!
              </motion.p>
            </div>

            {/* Rank Transition */}
            <div className="flex items-center justify-center gap-4 py-4">
              {/* Old Rank */}
              <motion.div
                initial={{ x: -50, opacity: 0 }}
                animate={{ x: 0, opacity: 1 }}
                transition={{ delay: 0.4 }}
                className="text-center space-y-2"
              >
                <div
                  className="w-20 h-20 rounded-full flex items-center justify-center text-3xl border-4"
                  style={{
                    backgroundColor: `${oldRankConfig.color}20`,
                    borderColor: oldRankConfig.color,
                  }}
                >
                  {oldRankConfig.icon}
                </div>
                <div className="text-sm font-medium capitalize" style={{ color: oldRankConfig.color }}>
                  {oldRankConfig.title}
                </div>
              </motion.div>

              {/* Arrow */}
              <motion.div
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ delay: 0.6, type: 'spring' }}
              >
                <ArrowRight className="w-8 h-8 text-muted-foreground" />
              </motion.div>

              {/* New Rank */}
              <motion.div
                initial={{ x: 50, opacity: 0 }}
                animate={{ x: 0, opacity: 1 }}
                transition={{ delay: 0.8 }}
                className="text-center space-y-2"
              >
                <motion.div
                  animate={{
                    scale: [1, 1.1, 1],
                    rotate: [0, 5, -5, 0],
                  }}
                  transition={{
                    duration: 2,
                    repeat: Infinity,
                    repeatDelay: 1,
                  }}
                  className="w-20 h-20 rounded-full flex items-center justify-center text-3xl border-4 relative"
                  style={{
                    backgroundColor: `${newRankConfig.color}20`,
                    borderColor: newRankConfig.color,
                    boxShadow: `0 0 20px ${newRankConfig.color}40`,
                  }}
                >
                  {newRankConfig.icon}
                  <motion.div
                    animate={{ rotate: 360 }}
                    transition={{ duration: 3, repeat: Infinity, ease: 'linear' }}
                    className="absolute -top-2 -right-2"
                  >
                    <Sparkles className="w-6 h-6" style={{ color: newRankConfig.color }} />
                  </motion.div>
                </motion.div>
                <div className="text-sm font-bold capitalize" style={{ color: newRankConfig.color }}>
                  {newRankConfig.title}
                </div>
              </motion.div>
            </div>

            {/* XP Display */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 1 }}
              className="text-center space-y-2"
            >
              <div className="flex items-center justify-center gap-2">
                <Star className="w-5 h-5 text-yellow-500" />
                <span className="text-2xl font-bold">{newXP.toLocaleString()}</span>
                <span className="text-muted-foreground">XP</span>
              </div>
              <p className="text-sm text-muted-foreground">
                Keep up the great work to reach the next rank!
              </p>
            </motion.div>

            {/* Close Button */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 1.2 }}
            >
              <Button onClick={handleClose} className="w-full" size="lg">
                Continue
              </Button>
            </motion.div>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}

// ============================================
// RANK UP TOAST (Simpler version)
// ============================================

interface RankUpToastProps {
  oldRank: string;
  newRank: string;
  onViewDetails?: () => void;
}

export function RankUpToast({ oldRank, newRank, onViewDetails }: RankUpToastProps) {
  const newRankConfig = getRankConfig(newRank);

  if (!newRankConfig) return null;

  return (
    <div className="flex items-center gap-3">
      <div
        className="w-12 h-12 rounded-full flex items-center justify-center text-xl border-2 flex-shrink-0"
        style={{
          backgroundColor: `${newRankConfig.color}20`,
          borderColor: newRankConfig.color,
        }}
      >
        {newRankConfig.icon}
      </div>
      <div className="flex-1 min-w-0">
        <div className="font-semibold">Rank Up!</div>
        <div className="text-sm text-muted-foreground">
          You're now <span className="font-medium capitalize" style={{ color: newRankConfig.color }}>
            {newRankConfig.title}
          </span>
        </div>
      </div>
      {onViewDetails && (
        <Button variant="ghost" size="sm" onClick={onViewDetails}>
          View
        </Button>
      )}
    </div>
  );
}

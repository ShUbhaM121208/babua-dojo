// SuperMemo-2 Spaced Repetition Algorithm Implementation
import type { SM2Params, SM2Result } from '@/types/weakness';

/**
 * SuperMemo-2 (SM-2) Algorithm for optimal spaced repetition
 * Based on the original algorithm by Piotr Wozniak
 * 
 * Performance ratings:
 * 0 - Complete blackout, total failure
 * 1 - Wrong response but remembered after seeing correct answer
 * 2 - Wrong response but seemed easy after seeing correct answer
 * 3 - Correct response but required significant effort
 * 4 - Correct response after some hesitation
 * 5 - Perfect response, immediate recall
 */

export function calculateNextReview(
  params: SM2Params,
  performanceRating: number
): SM2Result {
  // Validate inputs
  if (performanceRating < 0 || performanceRating > 5) {
    throw new Error('Performance rating must be between 0 and 5');
  }

  let { easeFactor, interval, repetition } = params;
  
  // Calculate new ease factor
  const newEaseFactor = Math.max(
    1.3,
    easeFactor + (0.1 - (5 - performanceRating) * (0.08 + (5 - performanceRating) * 0.02))
  );

  let newInterval: number;
  let newRepetition: number;

  // If performance was poor (< 3), reset the learning process
  if (performanceRating < 3) {
    newRepetition = 0;
    newInterval = 1;
  } else {
    newRepetition = repetition + 1;
    
    // Calculate new interval based on repetition number
    if (newRepetition === 1) {
      newInterval = 1;
    } else if (newRepetition === 2) {
      newInterval = 6;
    } else {
      newInterval = Math.round(interval * newEaseFactor);
    }
  }

  // Calculate next review date
  const nextReviewDate = new Date();
  nextReviewDate.setDate(nextReviewDate.getDate() + newInterval);

  return {
    newEaseFactor,
    newInterval,
    newRepetition,
    nextReviewDate
  };
}

/**
 * Calculate mastery level based on performance history
 */
export function calculateMasteryLevel(
  repetitionNumber: number,
  easeFactor: number,
  recentPerformance: number[]
): number {
  if (recentPerformance.length === 0) return 0;

  // Base mastery on repetition number (more repetitions = higher mastery)
  const repetitionScore = Math.min(repetitionNumber * 10, 40);

  // Ease factor contribution (higher ease = better mastery)
  const easeScore = ((easeFactor - 1.3) / (2.5 - 1.3)) * 30;

  // Recent performance average
  const avgPerformance = recentPerformance.reduce((a, b) => a + b, 0) / recentPerformance.length;
  const performanceScore = (avgPerformance / 5) * 30;

  return Math.min(Math.round(repetitionScore + easeScore + performanceScore), 100);
}

/**
 * Determine optimal daily problem count based on user's capacity and goals
 */
export function calculateOptimalDailyProblems(
  userLevel: 'beginner' | 'intermediate' | 'advanced' | 'expert',
  availableTimeMinutes: number,
  intensityPreference: 'light' | 'moderate' | 'intensive'
): number {
  const baseProblems: Record<string, number> = {
    beginner: 2,
    intermediate: 3,
    advanced: 4,
    expert: 5
  };

  const intensityMultiplier: Record<string, number> = {
    light: 0.7,
    moderate: 1.0,
    intensive: 1.5
  };

  const avgTimePerProblem = {
    beginner: 45,
    intermediate: 30,
    advanced: 25,
    expert: 20
  };

  const baseCount = baseProblems[userLevel];
  const maxByTime = Math.floor(availableTimeMinutes / avgTimePerProblem[userLevel]);
  const adjusted = Math.round(baseCount * intensityMultiplier[intensityPreference]);

  return Math.max(1, Math.min(adjusted, maxByTime, 10));
}

/**
 * Generate difficulty progression for a practice plan
 */
export function generateDifficultyProgression(
  startingLevel: number, // 0-100
  targetLevel: number, // 0-100
  durationDays: number,
  progressionType: 'gradual' | 'aggressive' | 'adaptive'
): number[] {
  const progression: number[] = [];
  const totalIncrease = targetLevel - startingLevel;

  switch (progressionType) {
    case 'gradual':
      // Linear progression
      for (let day = 0; day < durationDays; day++) {
        progression.push(
          Math.round(startingLevel + (totalIncrease * day) / durationDays)
        );
      }
      break;

    case 'aggressive':
      // Fast initial growth, then plateau
      for (let day = 0; day < durationDays; day++) {
        const progress = Math.log(day + 1) / Math.log(durationDays + 1);
        progression.push(Math.round(startingLevel + totalIncrease * progress));
      }
      break;

    case 'adaptive':
      // S-curve progression (slow start, fast middle, slow end)
      for (let day = 0; day < durationDays; day++) {
        const x = (day / durationDays - 0.5) * 12; // Scale to -6 to +6
        const sigmoid = 1 / (1 + Math.exp(-x));
        progression.push(Math.round(startingLevel + totalIncrease * sigmoid));
      }
      break;
  }

  return progression;
}

/**
 * Calculate priority score for a problem in the review queue
 */
export function calculatePriorityScore(
  nextReviewDate: Date,
  weaknessScore: number, // 0-100
  masteryLevel: number, // 0-100
  repetitionNumber: number
): number {
  const now = new Date();
  const daysOverdue = Math.max(
    0,
    Math.floor((now.getTime() - nextReviewDate.getTime()) / (1000 * 60 * 60 * 24))
  );

  // Components of priority score (all normalized to 0-100 range)
  const overdueScore = Math.min(daysOverdue * 10, 100); // 10 points per day overdue
  const weaknessComponent = weaknessScore; // Higher weakness = higher priority
  const masteryComponent = 100 - masteryLevel; // Lower mastery = higher priority
  const repetitionComponent = Math.max(0, 50 - repetitionNumber * 5); // Fewer reps = higher priority

  // Weighted combination
  return (
    overdueScore * 0.4 +
    weaknessComponent * 0.3 +
    masteryComponent * 0.2 +
    repetitionComponent * 0.1
  );
}

/**
 * Analyze performance trends to determine improvement trajectory
 */
export function analyzeImprovementTrend(
  historicalScores: Array<{ date: string; score: number }>
): 'improving' | 'stable' | 'declining' {
  if (historicalScores.length < 3) return 'stable';

  // Use simple linear regression
  const n = historicalScores.length;
  const xValues = historicalScores.map((_, i) => i);
  const yValues = historicalScores.map(h => h.score);

  const sumX = xValues.reduce((a, b) => a + b, 0);
  const sumY = yValues.reduce((a, b) => a + b, 0);
  const sumXY = xValues.reduce((acc, x, i) => acc + x * yValues[i], 0);
  const sumXX = xValues.reduce((acc, x) => acc + x * x, 0);

  const slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);

  // Threshold for determining trend
  const threshold = 0.5;

  if (slope > threshold) return 'improving';
  if (slope < -threshold) return 'declining';
  return 'stable';
}

/**
 * Generate personalized milestone targets
 */
export function generateMilestones(
  weaknesses: Array<{ id: string; name: string; currentScore: number }>,
  durationDays: number
): Array<{
  day: number;
  title: string;
  description: string;
  targetWeaknesses: string[];
  targetImprovement: number;
}> {
  const milestones: any[] = [];
  const milestoneCount = Math.min(Math.floor(durationDays / 7), 8); // Weekly milestones, max 8

  for (let i = 1; i <= milestoneCount; i++) {
    const day = Math.floor((i / milestoneCount) * durationDays);
    const progressPercentage = (i / milestoneCount) * 100;

    const targetWeaknesses = weaknesses
      .filter(w => w.currentScore > 50 - (progressPercentage / 2))
      .map(w => w.id);

    milestones.push({
      day,
      title: `Milestone ${i}: ${Math.round(progressPercentage)}% Progress`,
      description: `Achieve ${Math.round(20 + progressPercentage / 2)}% improvement in target areas`,
      targetWeaknesses,
      targetImprovement: Math.round(20 + progressPercentage / 2)
    });
  }

  return milestones;
}

/**
 * Recommend optimal practice time distribution
 */
export function recommendPracticeSchedule(
  dailyProblems: number,
  userTimezone: string = 'UTC'
): Array<{ timeSlot: string; problemCount: number; reasoning: string }> {
  const schedule: Array<{ timeSlot: string; problemCount: number; reasoning: string }> = [];

  if (dailyProblems <= 2) {
    schedule.push({
      timeSlot: 'morning',
      problemCount: dailyProblems,
      reasoning: 'Peak cognitive performance for focused problem solving'
    });
  } else if (dailyProblems <= 4) {
    schedule.push(
      {
        timeSlot: 'morning',
        problemCount: Math.ceil(dailyProblems / 2),
        reasoning: 'Tackle harder problems when fresh'
      },
      {
        timeSlot: 'evening',
        problemCount: Math.floor(dailyProblems / 2),
        reasoning: 'Reinforce learning with practice'
      }
    );
  } else {
    schedule.push(
      {
        timeSlot: 'morning',
        problemCount: Math.ceil(dailyProblems * 0.4),
        reasoning: 'Focus on conceptually challenging problems'
      },
      {
        timeSlot: 'afternoon',
        problemCount: Math.ceil(dailyProblems * 0.3),
        reasoning: 'Practice implementation and coding speed'
      },
      {
        timeSlot: 'evening',
        problemCount: Math.floor(dailyProblems * 0.3),
        reasoning: 'Review and reinforce concepts'
      }
    );
  }

  return schedule;
}

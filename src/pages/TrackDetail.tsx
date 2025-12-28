import { useParams, Link } from "react-router-dom";
import { Layout } from "@/components/layout/Layout";
import { Button } from "@/components/ui/button";
import { DifficultyBadge } from "@/components/ui/DifficultyBadge";
import { tracks, dsaTopics } from "@/data/mockData";
import {
  ChevronRight,
  Check,
  BookmarkPlus,
  MessageSquare,
  ArrowLeft,
  ChevronDown,
} from "lucide-react";
import { useState } from "react";

export default function TrackDetail() {
  const { slug } = useParams();
  const track = tracks.find((t) => t.slug === slug);
  const [expandedTopic, setExpandedTopic] = useState<string | null>("arrays");
  const [selectedProblem, setSelectedProblem] = useState(dsaTopics[0]?.subtopics[0] || null);

  if (!track) {
    return (
      <Layout>
        <div className="py-20 text-center">
          <h1 className="text-2xl font-bold mb-4">Track not found</h1>
          <Link to="/tracks">
            <Button variant="outline">Back to Tracks</Button>
          </Link>
        </div>
      </Layout>
    );
  }

  const totalCompleted = dsaTopics.reduce((acc, t) => acc + t.completed, 0);
  const totalProblems = dsaTopics.reduce((acc, t) => acc + t.problems, 0);
  const progressPercent = Math.round((totalCompleted / totalProblems) * 100);

  return (
    <Layout>
      <div className="min-h-screen">
        {/* Header */}
        <div className="border-b border-border bg-secondary/30">
          <div className="container mx-auto px-4 py-6">
            <Link
              to="/tracks"
              className="inline-flex items-center text-sm text-muted-foreground hover:text-foreground mb-4 transition-colors"
            >
              <ArrowLeft className="h-4 w-4 mr-1" />
              All Tracks
            </Link>

            <div className="flex items-start justify-between">
              <div>
                <div className="flex items-center gap-3 mb-2">
                  <span className="text-3xl">{track.icon}</span>
                  <h1 className="text-2xl md:text-3xl font-bold">{track.title}</h1>
                </div>
                <p className="text-muted-foreground max-w-xl">{track.description}</p>
              </div>

              <div className="hidden md:flex items-center gap-4">
                <div className="text-right">
                  <div className="text-2xl font-mono font-bold text-primary">
                    {progressPercent}%
                  </div>
                  <div className="text-xs text-muted-foreground">Complete</div>
                </div>
                <div className="w-24 h-2 bg-secondary rounded-full overflow-hidden">
                  <div
                    className="h-full bg-primary rounded-full"
                    style={{ width: `${progressPercent}%` }}
                  />
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Three Column Layout */}
        <div className="container mx-auto px-4 py-6">
          <div className="grid lg:grid-cols-12 gap-6">
            {/* Left - Topic Tree */}
            <div className="lg:col-span-3">
              <div className="surface-card p-4 sticky top-20">
                <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4">
                  TOPICS
                </h3>
                <div className="space-y-1">
                  {dsaTopics.map((topic) => (
                    <div key={topic.id}>
                      <button
                        onClick={() =>
                          setExpandedTopic(
                            expandedTopic === topic.id ? null : topic.id
                          )
                        }
                        className={`w-full flex items-center justify-between p-2 rounded text-left text-sm transition-colors ${
                          expandedTopic === topic.id
                            ? "bg-primary/10 text-primary"
                            : "hover:bg-secondary"
                        }`}
                      >
                        <div className="flex items-center gap-2">
                          <ChevronDown
                            className={`h-4 w-4 transition-transform ${
                              expandedTopic === topic.id ? "" : "-rotate-90"
                            }`}
                          />
                          <span className="font-medium">{topic.title}</span>
                        </div>
                        <span className="text-xs text-muted-foreground font-mono">
                          {topic.completed}/{topic.problems}
                        </span>
                      </button>

                      {expandedTopic === topic.id && topic.subtopics.length > 0 && (
                        <div className="ml-6 mt-1 space-y-0.5">
                          {topic.subtopics.map((sub) => (
                            <button
                              key={sub.id}
                              onClick={() => setSelectedProblem(sub)}
                              className={`w-full flex items-center gap-2 p-2 rounded text-left text-sm transition-colors ${
                                selectedProblem?.id === sub.id
                                  ? "bg-primary/10 text-primary"
                                  : "hover:bg-secondary text-muted-foreground"
                              }`}
                            >
                              {sub.completed ? (
                                <Check className="h-3 w-3 text-primary" />
                              ) : (
                                <div className="h-3 w-3 rounded-full border border-muted-foreground" />
                              )}
                              <span className="truncate">{sub.title}</span>
                            </button>
                          ))}
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            </div>

            {/* Center - Content Preview */}
            <div className="lg:col-span-6">
              {selectedProblem ? (
                <div className="surface-card p-6">
                  <div className="flex items-center justify-between mb-4">
                    <h2 className="text-xl font-bold">{selectedProblem.title}</h2>
                    <DifficultyBadge
                      difficulty={selectedProblem.difficulty as "easy" | "medium" | "hard"}
                    />
                  </div>

                  <div className="prose prose-invert max-w-none">
                    <h3 className="font-mono text-lg font-semibold mb-3">Problem Statement</h3>
                    <p className="text-muted-foreground mb-6">
                      Given an array of integers <code className="text-primary">nums</code> and an
                      integer <code className="text-primary">target</code>, return indices of the
                      two numbers such that they add up to target.
                    </p>

                    <h4 className="font-mono text-sm font-semibold text-muted-foreground mb-2">
                      Example:
                    </h4>
                    <div className="surface-elevated rounded-lg p-4 font-mono text-sm mb-6">
                      <div className="text-muted-foreground">
                        Input: nums = [2,7,11,15], target = 9
                      </div>
                      <div className="text-primary mt-1">Output: [0,1]</div>
                      <div className="text-muted-foreground mt-1 text-xs">
                        Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
                      </div>
                    </div>

                    <h4 className="font-mono text-sm font-semibold text-muted-foreground mb-2">
                      Constraints:
                    </h4>
                    <ul className="text-sm text-muted-foreground space-y-1 list-disc list-inside mb-6">
                      <li>2 ≤ nums.length ≤ 10⁴</li>
                      <li>-10⁹ ≤ nums[i] ≤ 10⁹</li>
                      <li>-10⁹ ≤ target ≤ 10⁹</li>
                      <li>Only one valid answer exists.</li>
                    </ul>

                    <h4 className="font-mono text-sm font-semibold text-muted-foreground mb-2">
                      Approach:
                    </h4>
                    <p className="text-muted-foreground text-sm">
                      Use a hash map to store each number's index as you iterate. For each number,
                      check if its complement (target - current) exists in the map.
                    </p>
                  </div>

                  <div className="flex items-center gap-3 mt-8 pt-6 border-t border-border">
                    <Button className="font-mono">
                      <Check className="mr-2 h-4 w-4" />
                      Mark as Done
                    </Button>
                    <Button variant="outline" className="font-mono">
                      <BookmarkPlus className="mr-2 h-4 w-4" />
                      Add to Revision
                    </Button>
                    <Button variant="ghost" className="font-mono ml-auto">
                      <MessageSquare className="mr-2 h-4 w-4" />
                      Discussion
                    </Button>
                  </div>
                </div>
              ) : (
                <div className="surface-card p-12 text-center">
                  <p className="text-muted-foreground">
                    Select a topic from the left to view content
                  </p>
                </div>
              )}
            </div>

            {/* Right - Progress & Revision */}
            <div className="lg:col-span-3">
              <div className="space-y-4 sticky top-20">
                {/* Progress Card */}
                <div className="surface-card p-4">
                  <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4">
                    YOUR PROGRESS
                  </h3>
                  <div className="space-y-3">
                    <div className="flex justify-between items-center">
                      <span className="text-sm text-muted-foreground">Completed</span>
                      <span className="font-mono font-bold">
                        {totalCompleted}/{totalProblems}
                      </span>
                    </div>
                    <div className="h-2 bg-secondary rounded-full overflow-hidden">
                      <div
                        className="h-full bg-primary rounded-full"
                        style={{ width: `${progressPercent}%` }}
                      />
                    </div>
                    <div className="flex justify-between text-xs text-muted-foreground">
                      <span>Current streak: 23 days</span>
                      <span className="text-primary">{progressPercent}%</span>
                    </div>
                  </div>
                </div>

                {/* Revision Queue */}
                <div className="surface-card p-4">
                  <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4">
                    REVISION QUEUE
                  </h3>
                  <div className="space-y-2">
                    {["3Sum", "Container With Most Water", "Group Anagrams"].map(
                      (item, index) => (
                        <div
                          key={index}
                          className="flex items-center justify-between p-2 rounded bg-secondary/50"
                        >
                          <span className="text-sm">{item}</span>
                          <ChevronRight className="h-4 w-4 text-muted-foreground" />
                        </div>
                      )
                    )}
                  </div>
                  <Button variant="ghost" className="w-full mt-3 font-mono text-sm">
                    View All (8)
                  </Button>
                </div>

                {/* Quick Actions */}
                <div className="surface-card p-4">
                  <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4">
                    QUICK ACTIONS
                  </h3>
                  <div className="space-y-2">
                    <Button variant="outline" className="w-full justify-start font-mono text-sm">
                      <MessageSquare className="mr-2 h-4 w-4" />
                      Ask Community
                    </Button>
                    <Button variant="outline" className="w-full justify-start font-mono text-sm">
                      Random Problem
                    </Button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}

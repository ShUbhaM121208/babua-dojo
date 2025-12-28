import { useState } from "react";
import { Layout } from "@/components/layout/Layout";
import { Button } from "@/components/ui/button";
import { DifficultyBadge } from "@/components/ui/DifficultyBadge";
import { problems } from "@/data/mockData";
import { Check, BookmarkPlus, Filter, Search } from "lucide-react";
import { Input } from "@/components/ui/input";

export default function Practice() {
  const [filter, setFilter] = useState<"all" | "easy" | "medium" | "hard">("all");
  const [showSolved, setShowSolved] = useState(true);
  const [searchQuery, setSearchQuery] = useState("");

  const filteredProblems = problems.filter((p) => {
    if (filter !== "all" && p.difficulty !== filter) return false;
    if (!showSolved && p.solved) return false;
    if (searchQuery && !p.title.toLowerCase().includes(searchQuery.toLowerCase())) return false;
    return true;
  });

  const solvedCount = problems.filter((p) => p.solved).length;
  const progressPercent = Math.round((solvedCount / problems.length) * 100);

  return (
    <Layout>
      <div className="py-12">
        <div className="container mx-auto px-4">
          {/* Header */}
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
            <div>
              <h1 className="text-3xl md:text-4xl font-bold mb-2">Practice</h1>
              <p className="text-muted-foreground">
                Solve problems. Build muscle memory. Get better.
              </p>
            </div>

            {/* Progress */}
            <div className="surface-card p-4 min-w-[200px]">
              <div className="flex items-center justify-between mb-2">
                <span className="text-sm text-muted-foreground">Progress</span>
                <span className="font-mono font-bold text-primary">{progressPercent}%</span>
              </div>
              <div className="h-2 bg-secondary rounded-full overflow-hidden">
                <div
                  className="h-full bg-primary rounded-full"
                  style={{ width: `${progressPercent}%` }}
                />
              </div>
              <div className="text-xs text-muted-foreground mt-2 font-mono">
                {solvedCount}/{problems.length} solved
              </div>
            </div>
          </div>

          {/* Filters */}
          <div className="flex flex-col sm:flex-row gap-4 mb-6">
            <div className="relative flex-1 max-w-md">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Search problems..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="pl-9 bg-secondary border-border"
              />
            </div>

            <div className="flex items-center gap-2">
              <div className="flex items-center bg-secondary rounded-lg p-1">
                {(["all", "easy", "medium", "hard"] as const).map((level) => (
                  <button
                    key={level}
                    onClick={() => setFilter(level)}
                    className={`px-3 py-1.5 rounded text-sm font-mono transition-colors ${
                      filter === level
                        ? "bg-primary text-primary-foreground"
                        : "text-muted-foreground hover:text-foreground"
                    }`}
                  >
                    {level.charAt(0).toUpperCase() + level.slice(1)}
                  </button>
                ))}
              </div>

              <Button
                variant={showSolved ? "default" : "outline"}
                size="sm"
                onClick={() => setShowSolved(!showSolved)}
                className="font-mono"
              >
                <Filter className="h-4 w-4 mr-1" />
                {showSolved ? "All" : "Unsolved"}
              </Button>
            </div>
          </div>

          {/* Problem List */}
          <div className="surface-card overflow-hidden">
            <div className="grid grid-cols-12 gap-4 px-4 py-3 border-b border-border text-sm font-mono text-muted-foreground bg-secondary/50">
              <div className="col-span-1">Status</div>
              <div className="col-span-5">Problem</div>
              <div className="col-span-2">Difficulty</div>
              <div className="col-span-2">Track</div>
              <div className="col-span-2 text-right">Actions</div>
            </div>

            <div className="divide-y divide-border">
              {filteredProblems.map((problem) => (
                <div
                  key={problem.id}
                  className="grid grid-cols-12 gap-4 px-4 py-4 items-center hover:bg-secondary/30 transition-colors"
                >
                  <div className="col-span-1">
                    {problem.solved ? (
                      <Check className="h-5 w-5 text-primary" />
                    ) : (
                      <div className="h-5 w-5 rounded-full border-2 border-muted-foreground" />
                    )}
                  </div>

                  <div className="col-span-5">
                    <button className="text-left hover:text-primary transition-colors">
                      <span className="font-medium">{problem.title}</span>
                    </button>
                    <div className="flex gap-2 mt-1">
                      {problem.tags.map((tag) => (
                        <span
                          key={tag}
                          className="text-xs text-muted-foreground font-mono"
                        >
                          {tag}
                        </span>
                      ))}
                    </div>
                  </div>

                  <div className="col-span-2">
                    <DifficultyBadge
                      difficulty={problem.difficulty as "easy" | "medium" | "hard"}
                    />
                  </div>

                  <div className="col-span-2">
                    <span className="text-sm text-muted-foreground font-mono">
                      {problem.track}
                    </span>
                  </div>

                  <div className="col-span-2 flex justify-end gap-2">
                    <Button variant="ghost" size="sm" className="h-8 w-8 p-0">
                      <BookmarkPlus className="h-4 w-4" />
                    </Button>
                    <Button size="sm" className="font-mono">
                      Solve
                    </Button>
                  </div>
                </div>
              ))}
            </div>

            {filteredProblems.length === 0 && (
              <div className="py-12 text-center text-muted-foreground">
                No problems match your filters
              </div>
            )}
          </div>

          {/* Quick Stats */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-8">
            {[
              { label: "Easy", count: problems.filter((p) => p.difficulty === "easy").length, color: "text-emerald-400" },
              { label: "Medium", count: problems.filter((p) => p.difficulty === "medium").length, color: "text-amber-400" },
              { label: "Hard", count: problems.filter((p) => p.difficulty === "hard").length, color: "text-red-400" },
              { label: "In Revision", count: 8, color: "text-primary" },
            ].map((stat) => (
              <div key={stat.label} className="surface-card p-4 text-center">
                <div className={`text-2xl font-mono font-bold ${stat.color}`}>
                  {stat.count}
                </div>
                <div className="text-sm text-muted-foreground">{stat.label}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </Layout>
  );
}

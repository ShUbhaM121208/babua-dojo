import { useState, useMemo, useEffect } from "react";
import { Layout } from "@/components/layout/Layout";
import { Button } from "@/components/ui/button";
import { DifficultyBadge } from "@/components/ui/DifficultyBadge";
import { detailedProblems } from "@/data/mockData";
import { Check, BookmarkPlus, Filter, Search, Bot, Code, ChevronLeft, ChevronRight } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Link } from "react-router-dom";
import { useBabuaAI } from "@/hooks/useBabuaAI";
import { useAuth } from "@/contexts/AuthContext";
import { supabase } from "@/integrations/supabase/client";
import { onProblemSolved } from "@/lib/progressEvents";

export default function Practice() {
  const [filter, setFilter] = useState<"all" | "easy" | "medium" | "hard">("all");
  const [topicFilter, setTopicFilter] = useState<string>("all");
  const [showSolved, setShowSolved] = useState(true);
  const [searchQuery, setSearchQuery] = useState("");
  const [companyFilter, setCompanyFilter] = useState<string>("all");
  const [currentPage, setCurrentPage] = useState(1);
  const [solvedProblems, setSolvedProblems] = useState<Set<string>>(new Set());
  const problemsPerPage = 20;
  const { sendMessage } = useBabuaAI();
  const { user } = useAuth();

  // Load solved problems from database
  useEffect(() => {
    loadSolvedProblems();
  }, [user]);

  // Listen for problem solved events
  useEffect(() => {
    const cleanup = onProblemSolved(() => {
      console.log('Practice page: Reloading solved problems after solve event');
      loadSolvedProblems();
    });
    return cleanup;
  }, [user]);

  async function loadSolvedProblems() {
    if (!user) return;
    
    // Try user_problem_progress first
    const { data, error } = await supabase
      .from('user_problem_progress')
      .select('problem_id, solved')
      .eq('user_id', user.id)
      .eq('solved', true);
    
    if (error) {
      console.error('Error loading solved problems:', error);
      
      // Fallback: Try problem_submissions table
      const { data: submissions, error: subError } = await supabase
        .from('problem_submissions')
        .select('problem_id')
        .eq('user_id', user.id)
        .eq('all_passed', true);
      
      if (!subError && submissions) {
        const uniqueProblems = [...new Set(submissions.map(s => s.problem_id))];
        setSolvedProblems(new Set(uniqueProblems));
        console.log('Loaded solved problems from submissions:', uniqueProblems);
      }
    } else if (data) {
      const problemIds = data.map(p => p.problem_id);
      setSolvedProblems(new Set(problemIds));
      console.log('Loaded solved problems from progress:', problemIds);
      console.log('Mock problem IDs sample:', Object.values(detailedProblems).slice(0, 5).map(p => p.id));
    }
  }

  // Convert detailedProblems object to array and filter only DSA track
  // Merge with solved status from database
  const problemsArray = useMemo(() => {
    return Object.values(detailedProblems)
      .filter((p) => p.track === "DSA")
      .map(p => ({
        ...p,
        // Check if problem is solved by matching either the numeric ID or the slug
        solved: solvedProblems.has(String(p.id)) || 
                (p.slug && solvedProblems.has(p.slug))
      }));
  }, [solvedProblems]);

  // Get unique topics from DSA problems
  const allTopics = useMemo(() => {
    const topics = new Set<string>();
    problemsArray.forEach((p) => {
      p.tags.forEach(tag => topics.add(tag));
    });
    return Array.from(topics).sort();
  }, [problemsArray]);

  // Get unique companies from DSA problems
  const allCompanies = useMemo(() => {
    const companies = new Set<string>();
    problemsArray.forEach((p) => {
      if (p.companies) {
        p.companies.forEach(c => companies.add(c));
      }
    });
    return Array.from(companies).sort();
  }, [problemsArray]);

  const filteredProblems = useMemo(() => {
    return problemsArray.filter((p) => {
      if (filter !== "all" && p.difficulty !== filter) return false;
      if (!showSolved && p.solved) return false;
      if (searchQuery && !p.title.toLowerCase().includes(searchQuery.toLowerCase())) return false;
      if (companyFilter !== "all" && !p.companies?.includes(companyFilter)) return false;
      if (topicFilter !== "all" && !p.tags.includes(topicFilter)) return false;
      return true;
    });
  }, [problemsArray, filter, showSolved, searchQuery, companyFilter, topicFilter]);

  // Pagination calculations
  const totalPages = Math.ceil(filteredProblems.length / problemsPerPage);
  const startIndex = (currentPage - 1) * problemsPerPage;
  const endIndex = startIndex + problemsPerPage;
  const paginatedProblems = filteredProblems.slice(startIndex, endIndex);

  // Reset to page 1 when filters change
  useEffect(() => {
    setCurrentPage(1);
  }, [filter, topicFilter, searchQuery, companyFilter, showSolved]);

  const solvedCount = problemsArray.filter((p) => p.solved).length;
  const progressPercent = Math.round((solvedCount / problemsArray.length) * 100);

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
                {solvedCount}/{problemsArray.length} solved
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

            <div className="flex items-center gap-2 flex-wrap">
              {/* Difficulty Filter */}
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

              {/* Topic Filter */}
              <select
                value={topicFilter}
                onChange={(e) => setTopicFilter(e.target.value)}
                className="px-3 py-1.5 bg-secondary border border-border rounded-lg text-sm font-mono focus:outline-none focus:ring-2 focus:ring-primary"
                aria-label="Filter by topic"
              >
                <option value="all">All Topics</option>
                {allTopics.map((topic) => (
                  <option key={topic} value={topic}>
                    {topic}
                  </option>
                ))}
              </select>

              {/* Company Filter */}
              <select
                value={companyFilter}
                onChange={(e) => setCompanyFilter(e.target.value)}
                className="px-3 py-1.5 bg-secondary border border-border rounded-lg text-sm font-mono focus:outline-none focus:ring-2 focus:ring-primary"
                aria-label="Filter by company"
              >
                <option value="all">All Companies</option>
                {allCompanies.map((company) => (
                  <option key={company} value={company}>
                    {company}
                  </option>
                ))}
              </select>

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
              <div className="col-span-1">#</div>
              <div className="col-span-1">Status</div>
              <div className="col-span-5">Problem</div>
              <div className="col-span-2">Difficulty</div>
              <div className="col-span-3 text-right">Actions</div>
            </div>

            <div className="divide-y divide-border">
              {paginatedProblems.map((problem, index) => (
                <div
                  key={problem.id}
                  className="grid grid-cols-12 gap-4 px-4 py-4 items-center hover:bg-secondary/30 transition-colors"
                >
                  <div className="col-span-1">
                    <span className="text-sm text-muted-foreground font-mono">
                      {startIndex + index + 1}
                    </span>
                  </div>

                  <div className="col-span-1">
                    {problem.solved ? (
                      <Check className="h-5 w-5 text-primary" />
                    ) : (
                      <div className="h-5 w-5 rounded-full border-2 border-muted-foreground" />
                    )}
                  </div>

                  <div className="col-span-5">
                    <Link 
                      to={`/problems/${problem.slug || problem.id}`}
                      className="text-left hover:text-primary transition-colors block"
                    >
                      <span className="font-medium">{problem.title}</span>
                    </Link>
                    <div className="flex gap-2 mt-1 flex-wrap items-center">
                      {problem.companies && problem.companies.length > 0 && (
                        <div className="flex gap-1 items-center">
                          {problem.companies.slice(0, 3).map((company) => (
                            <span
                              key={company}
                              className="text-xs px-2 py-0.5 rounded-full bg-primary/10 text-primary font-medium"
                            >
                              {company}
                            </span>
                          ))}
                          {problem.companies.length > 3 && (
                            <span className="text-xs text-muted-foreground">
                              +{problem.companies.length - 3}
                            </span>
                          )}
                        </div>
                      )}
                      {problem.tags.slice(0, 2).map((tag) => (
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

                  <div className="col-span-3 flex justify-end gap-2">
                    <Button 
                      variant="ghost" 
                      size="sm" 
                      className="h-8 px-2"
                      onClick={() => sendMessage(`Can you give me hints for solving ${problem.title}?`)}
                    >
                      <Bot className="h-4 w-4" />
                    </Button>
                    <Link to={`/problems/${problem.slug || problem.id}`}>
                      <Button size="sm" className="font-mono">
                        <Code className="h-4 w-4 mr-1" />
                        Solve
                      </Button>
                    </Link>
                  </div>
                </div>
              ))}
            </div>

            {filteredProblems.length === 0 && (
              <div className="py-12 text-center text-muted-foreground">
                No DSA problems match your filters
              </div>
            )}
          </div>

          {/* Pagination */}
          {filteredProblems.length > 0 && (
            <div className="flex flex-col sm:flex-row items-center justify-between gap-4 mt-6 p-4 surface-card">
              <div className="text-sm text-muted-foreground font-mono">
                Showing {startIndex + 1}-{Math.min(endIndex, filteredProblems.length)} of {filteredProblems.length} problems
              </div>
              
              <div className="flex items-center gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => setCurrentPage(p => Math.max(1, p - 1))}
                  disabled={currentPage === 1}
                  className="font-mono"
                >
                  <ChevronLeft className="h-4 w-4 mr-1" />
                  Previous
                </Button>
                
                <div className="flex items-center gap-1">
                  {Array.from({ length: Math.min(5, totalPages) }, (_, i) => {
                    let pageNum;
                    if (totalPages <= 5) {
                      pageNum = i + 1;
                    } else if (currentPage <= 3) {
                      pageNum = i + 1;
                    } else if (currentPage >= totalPages - 2) {
                      pageNum = totalPages - 4 + i;
                    } else {
                      pageNum = currentPage - 2 + i;
                    }
                    
                    return (
                      <Button
                        key={pageNum}
                        variant={currentPage === pageNum ? "default" : "outline"}
                        size="sm"
                        onClick={() => setCurrentPage(pageNum)}
                        className="w-10 font-mono"
                      >
                        {pageNum}
                      </Button>
                    );
                  })}
                </div>
                
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))}
                  disabled={currentPage === totalPages}
                  className="font-mono"
                >
                  Next
                  <ChevronRight className="h-4 w-4 ml-1" />
                </Button>
              </div>
            </div>
          )}

          {/* Quick Stats */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-8">
            {[
              { label: "Easy", count: problemsArray.filter((p) => p.difficulty === "easy").length, color: "text-emerald-400" },
              { label: "Medium", count: problemsArray.filter((p) => p.difficulty === "medium").length, color: "text-amber-400" },
              { label: "Hard", count: problemsArray.filter((p) => p.difficulty === "hard").length, color: "text-red-400" },
              { label: "Total", count: problemsArray.length, color: "text-primary" },
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

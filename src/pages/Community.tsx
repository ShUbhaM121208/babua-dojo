import { Layout } from "@/components/layout/Layout";
import { Button } from "@/components/ui/button";
import { communityStats } from "@/data/mockData";
import { Users, Trophy, MessageSquare, Flame, ArrowRight } from "lucide-react";

export default function Community() {
  const dailyGrindPosts = [
    { user: "anon_4829", message: "Day 45: Finally understood DP tabulation. The grind continues.", time: "2h ago", likes: 23 },
    { user: "code_monk", message: "Solved 5 mediums today. Feeling unstoppable.", time: "4h ago", likes: 18 },
    { user: "grind_master", message: "156 day streak. No days off.", time: "6h ago", likes: 45 },
    { user: "algo_ninja", message: "Graph problems are clicking now. BFS/DFS mastered.", time: "8h ago", likes: 12 },
    { user: "binary_beast", message: "Mock interview went well. System design is the next mountain.", time: "12h ago", likes: 31 },
  ];

  const accountabilityRooms = [
    { name: "DSA Daily Grind", members: 5, active: true, streak: 23 },
    { name: "System Design Study", members: 4, active: true, streak: 15 },
    { name: "Interview Prep Q1", members: 5, active: false, streak: 0 },
    { name: "FAANG Aspirants", members: 5, active: true, streak: 45 },
  ];

  return (
    <Layout>
      <div className="py-12">
        <div className="container mx-auto px-4">
          {/* Header */}
          <div className="max-w-3xl mb-12">
            <div className="flex items-center gap-3 mb-4">
              <Users className="h-8 w-8 text-primary" />
              <h1 className="text-3xl md:text-4xl font-bold">Community</h1>
            </div>
            <p className="text-lg text-muted-foreground">
              Grind together. Compete together. No one succeeds alone.
            </p>
          </div>

          <div className="grid lg:grid-cols-3 gap-8">
            {/* Main Content - Daily Grind Board */}
            <div className="lg:col-span-2 space-y-6">
              <div className="flex items-center justify-between">
                <h2 className="font-mono text-xl font-semibold flex items-center gap-2">
                  <Flame className="h-5 w-5 text-primary" />
                  Daily Grind Board
                </h2>
                <Button variant="outline" size="sm" className="font-mono">
                  <MessageSquare className="h-4 w-4 mr-2" />
                  Post Update
                </Button>
              </div>

              <div className="space-y-4">
                {dailyGrindPosts.map((post, index) => (
                  <div key={index} className="surface-card p-4">
                    <div className="flex items-start justify-between mb-2">
                      <div className="flex items-center gap-2">
                        <div className="w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center">
                          <span className="text-xs font-mono text-primary">
                            {post.user.slice(0, 2).toUpperCase()}
                          </span>
                        </div>
                        <span className="font-mono text-sm">{post.user}</span>
                      </div>
                      <span className="text-xs text-muted-foreground">{post.time}</span>
                    </div>
                    <p className="text-foreground mb-3">{post.message}</p>
                    <div className="flex items-center gap-4 text-sm text-muted-foreground">
                      <button className="flex items-center gap-1 hover:text-primary transition-colors">
                        <Flame className="h-4 w-4" />
                        <span className="font-mono">{post.likes}</span>
                      </button>
                      <button className="hover:text-foreground transition-colors">
                        Reply
                      </button>
                    </div>
                  </div>
                ))}
              </div>

              <Button variant="ghost" className="w-full font-mono">
                Load More Posts
                <ArrowRight className="ml-2 h-4 w-4" />
              </Button>
            </div>

            {/* Sidebar */}
            <div className="space-y-6">
              {/* Leaderboard */}
              <div className="surface-card p-4">
                <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4 flex items-center gap-2">
                  <Trophy className="h-4 w-4 text-primary" />
                  WEEKLY LEADERBOARD
                </h3>
                <div className="space-y-3">
                  {communityStats.topContributors.map((user, index) => (
                    <div
                      key={index}
                      className="flex items-center justify-between p-2 rounded bg-secondary/50"
                    >
                      <div className="flex items-center gap-3">
                        <span
                          className={`font-mono text-sm w-6 ${
                            index === 0
                              ? "text-amber-400"
                              : index === 1
                              ? "text-zinc-400"
                              : index === 2
                              ? "text-amber-600"
                              : "text-muted-foreground"
                          }`}
                        >
                          #{index + 1}
                        </span>
                        <span className="font-mono text-sm">{user.name}</span>
                      </div>
                      <div className="text-right">
                        <div className="font-mono text-sm text-primary">{user.solved}</div>
                        <div className="text-xs text-muted-foreground">solved</div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Accountability Rooms */}
              <div className="surface-card p-4">
                <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4">
                  ACCOUNTABILITY ROOMS
                </h3>
                <div className="space-y-3">
                  {accountabilityRooms.map((room, index) => (
                    <div
                      key={index}
                      className="flex items-center justify-between p-3 rounded bg-secondary/50"
                    >
                      <div>
                        <div className="font-medium text-sm flex items-center gap-2">
                          {room.name}
                          {room.active && (
                            <span className="w-2 h-2 rounded-full bg-primary animate-pulse" />
                          )}
                        </div>
                        <div className="text-xs text-muted-foreground font-mono">
                          {room.members}/5 members
                          {room.streak > 0 && ` • ${room.streak} day streak`}
                        </div>
                      </div>
                      <Button
                        variant={room.active ? "ghost" : "outline"}
                        size="sm"
                        className="font-mono text-xs"
                        disabled={room.active}
                      >
                        {room.active ? "Full" : "Join"}
                      </Button>
                    </div>
                  ))}
                </div>
                <Button variant="outline" className="w-full mt-4 font-mono text-sm">
                  Create Room
                </Button>
              </div>

              {/* Community Stats */}
              <div className="surface-card p-4">
                <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4">
                  COMMUNITY STATS
                </h3>
                <div className="grid grid-cols-2 gap-4">
                  <div className="text-center p-3 rounded bg-secondary/50">
                    <div className="text-xl font-mono font-bold text-primary">
                      {communityStats.activeUsers.toLocaleString()}
                    </div>
                    <div className="text-xs text-muted-foreground">Total Users</div>
                  </div>
                  <div className="text-center p-3 rounded bg-secondary/50">
                    <div className="text-xl font-mono font-bold text-primary">
                      {communityStats.dailyActive.toLocaleString()}
                    </div>
                    <div className="text-xs text-muted-foreground">Active Today</div>
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

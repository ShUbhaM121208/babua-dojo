import { Layout } from "@/components/layout/Layout";
import { Button } from "@/components/ui/button";
import { userDashboard, tracks } from "@/data/mockData";
import {
  Flame,
  Target,
  BookOpen,
  Calendar,
  ArrowRight,
  Clock,
  CheckCircle2,
  RotateCcw,
} from "lucide-react";
import { Link } from "react-router-dom";

export default function Dashboard() {
  return (
    <Layout>
      <div className="py-12">
        <div className="container mx-auto px-4">
          {/* Header */}
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8">
            <div>
              <h1 className="text-3xl md:text-4xl font-bold mb-2">Dashboard</h1>
              <p className="text-muted-foreground font-mono">
                Keep grinding. Consistency beats talent.
              </p>
            </div>

            {/* Streak Card */}
            <div className="surface-card p-4 flex items-center gap-4">
              <div className="w-16 h-16 rounded-full bg-primary/20 flex items-center justify-center">
                <Flame className="h-8 w-8 text-primary" />
              </div>
              <div>
                <div className="text-3xl font-mono font-bold text-primary">
                  {userDashboard.streak}
                </div>
                <div className="text-sm text-muted-foreground">Day Streak</div>
                <div className="text-xs text-muted-foreground font-mono">
                  Best: {userDashboard.longestStreak} days
                </div>
              </div>
            </div>
          </div>

          <div className="grid lg:grid-cols-3 gap-6">
            {/* Main Content */}
            <div className="lg:col-span-2 space-y-6">
              {/* Quick Stats */}
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                {[
                  { icon: Target, label: "Total Solved", value: userDashboard.totalSolved, color: "text-primary" },
                  { icon: Clock, label: "This Week", value: userDashboard.thisWeek, color: "text-emerald-400" },
                  { icon: RotateCcw, label: "In Revision", value: userDashboard.revisionQueue, color: "text-amber-400" },
                  { icon: Calendar, label: "Sessions", value: userDashboard.upcomingSessions.length, color: "text-blue-400" },
                ].map((stat, index) => (
                  <div key={index} className="surface-card p-4">
                    <stat.icon className={`h-5 w-5 ${stat.color} mb-2`} />
                    <div className="text-2xl font-mono font-bold">{stat.value}</div>
                    <div className="text-xs text-muted-foreground">{stat.label}</div>
                  </div>
                ))}
              </div>

              {/* Track Progress */}
              <div className="surface-card p-6">
                <div className="flex items-center justify-between mb-6">
                  <h2 className="font-mono text-lg font-semibold flex items-center gap-2">
                    <BookOpen className="h-5 w-5 text-primary" />
                    Track Progress
                  </h2>
                  <Link to="/tracks">
                    <Button variant="ghost" size="sm" className="font-mono">
                      View All
                      <ArrowRight className="ml-1 h-4 w-4" />
                    </Button>
                  </Link>
                </div>

                <div className="space-y-4">
                  {tracks.slice(0, 4).map((track) => (
                    <Link
                      key={track.id}
                      to={`/tracks/${track.slug}`}
                      className="block p-4 rounded-lg bg-secondary/50 hover:bg-secondary transition-colors"
                    >
                      <div className="flex items-center justify-between mb-2">
                        <div className="flex items-center gap-3">
                          <span className="text-xl">{track.icon}</span>
                          <span className="font-medium">{track.shortTitle}</span>
                        </div>
                        <span className="font-mono text-sm text-primary">
                          {track.progress}%
                        </span>
                      </div>
                      <div className="h-1.5 bg-background rounded-full overflow-hidden">
                        <div
                          className="h-full bg-primary rounded-full transition-all"
                          style={{ width: `${track.progress}%` }}
                        />
                      </div>
                    </Link>
                  ))}
                </div>
              </div>

              {/* Recent Activity */}
              <div className="surface-card p-6">
                <h2 className="font-mono text-lg font-semibold mb-4">Recent Activity</h2>
                <div className="space-y-3">
                  {userDashboard.recentActivity.map((activity, index) => (
                    <div
                      key={index}
                      className="flex items-center justify-between p-3 rounded bg-secondary/50"
                    >
                      <div className="flex items-center gap-3">
                        <CheckCircle2 className="h-4 w-4 text-primary" />
                        <div>
                          <span className="text-muted-foreground text-sm">
                            {activity.action}
                          </span>
                          <span className="text-foreground ml-1 font-medium">
                            {activity.item}
                          </span>
                        </div>
                      </div>
                      <span className="text-xs text-muted-foreground">{activity.time}</span>
                    </div>
                  ))}
                </div>
              </div>
            </div>

            {/* Sidebar */}
            <div className="space-y-6">
              {/* Revision Queue */}
              <div className="surface-card p-4">
                <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4 flex items-center gap-2">
                  <RotateCcw className="h-4 w-4 text-primary" />
                  REVISION QUEUE
                </h3>
                <div className="space-y-2">
                  {["3Sum", "Container With Most Water", "Group Anagrams", "LRU Cache", "Valid Parentheses"].slice(0, 5).map(
                    (item, index) => (
                      <div
                        key={index}
                        className="flex items-center justify-between p-3 rounded bg-secondary/50"
                      >
                        <span className="text-sm">{item}</span>
                        <Button variant="ghost" size="sm" className="h-7 font-mono text-xs">
                          Review
                        </Button>
                      </div>
                    )
                  )}
                </div>
                <Link to="/practice">
                  <Button variant="outline" className="w-full mt-4 font-mono text-sm">
                    View All ({userDashboard.revisionQueue})
                  </Button>
                </Link>
              </div>

              {/* Upcoming Sessions */}
              <div className="surface-card p-4">
                <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4 flex items-center gap-2">
                  <Calendar className="h-4 w-4 text-primary" />
                  UPCOMING SESSIONS
                </h3>
                {userDashboard.upcomingSessions.length > 0 ? (
                  <div className="space-y-3">
                    {userDashboard.upcomingSessions.map((session, index) => (
                      <div
                        key={index}
                        className="p-4 rounded bg-primary/10 border border-primary/20"
                      >
                        <div className="font-medium text-sm mb-1">{session.type}</div>
                        <div className="text-xs text-muted-foreground font-mono">
                          {session.date} at {session.time}
                        </div>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-6 text-muted-foreground text-sm">
                    No upcoming sessions
                  </div>
                )}
                <Link to="/support">
                  <Button variant="outline" className="w-full mt-4 font-mono text-sm">
                    Book a Session
                  </Button>
                </Link>
              </div>

              {/* Daily Goal */}
              <div className="surface-card p-4">
                <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4">
                  TODAY'S GOAL
                </h3>
                <div className="text-center py-4">
                  <div className="text-4xl font-mono font-bold text-primary mb-2">
                    3/5
                  </div>
                  <div className="text-sm text-muted-foreground">problems solved</div>
                  <div className="h-2 bg-secondary rounded-full overflow-hidden mt-4">
                    <div className="h-full bg-primary rounded-full" style={{ width: "60%" }} />
                  </div>
                </div>
                <Link to="/practice">
                  <Button className="w-full font-mono mt-4">
                    Continue Grinding
                    <ArrowRight className="ml-2 h-4 w-4" />
                  </Button>
                </Link>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}

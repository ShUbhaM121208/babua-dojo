import { useEffect, useRef } from "react";
import { Link } from "react-router-dom";
import { Layout } from "@/components/layout/Layout";
import { Button } from "@/components/ui/button";
import { TrackCard } from "@/components/ui/TrackCard";
import { tracks, communityStats, supportServices } from "@/data/mockData";
import { 
  Terminal, 
  Users, 
  BookOpen, 
  Zap, 
  ArrowRight, 
  CheckCircle2,
  Github,
  MessageSquare
} from "lucide-react";
import gsap from "gsap";

export default function Index() {
  const heroRef = useRef<HTMLDivElement>(null);
  const statsRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const ctx = gsap.context(() => {
      gsap.from(".hero-title", {
        y: 30,
        opacity: 0,
        duration: 0.8,
        ease: "power3.out",
      });
      gsap.from(".hero-subtitle", {
        y: 20,
        opacity: 0,
        duration: 0.8,
        delay: 0.2,
        ease: "power3.out",
      });
      gsap.from(".hero-cta", {
        y: 20,
        opacity: 0,
        duration: 0.8,
        delay: 0.4,
        ease: "power3.out",
      });
    }, heroRef);

    return () => ctx.revert();
  }, []);

  return (
    <Layout>
      {/* Hero Section */}
      <section ref={heroRef} className="relative py-24 md:py-32 overflow-hidden">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_center,_var(--tw-gradient-stops))] from-primary/5 via-transparent to-transparent" />
        
        <div className="container mx-auto px-4 relative z-10">
          <div className="max-w-4xl mx-auto text-center">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full border border-border bg-secondary/50 text-sm text-muted-foreground mb-6 font-mono">
              <Terminal className="h-4 w-4 text-primary" />
              <span>100% Free Engineering Learning</span>
            </div>

            <h1 className="hero-title text-4xl md:text-6xl lg:text-7xl font-bold mb-6 leading-tight">
              Learn Real Engineering.
              <br />
              <span className="text-primary terminal-glow">For Free.</span>
            </h1>

            <p className="hero-subtitle text-lg md:text-xl text-muted-foreground mb-8 max-w-2xl mx-auto">
              A hardcore engineering dojo for developers who want to build real skills.
              No certificates. No upsells. Just pure learning.
              <span className="text-foreground"> Pay only if you want extra help.</span>
            </p>

            <div className="hero-cta flex flex-col sm:flex-row items-center justify-center gap-4">
              <Link to="/tracks">
                <Button size="lg" className="font-mono text-base px-8">
                  Start Learning
                  <ArrowRight className="ml-2 h-5 w-5" />
                </Button>
              </Link>
              <Link to="/community">
                <Button variant="outline" size="lg" className="font-mono text-base px-8">
                  Join Community
                </Button>
              </Link>
            </div>

            {/* Terminal Preview */}
            <div className="mt-16 max-w-2xl mx-auto">
              <div className="surface-card overflow-hidden">
                <div className="flex items-center gap-2 px-4 py-3 border-b border-border bg-secondary/50">
                  <div className="w-3 h-3 rounded-full bg-red-500/50" />
                  <div className="w-3 h-3 rounded-full bg-yellow-500/50" />
                  <div className="w-3 h-3 rounded-full bg-green-500/50" />
                  <span className="ml-2 text-xs text-muted-foreground font-mono">~/babua/dsa</span>
                </div>
                <div className="p-4 font-mono text-sm">
                  <div className="flex items-center gap-2 text-muted-foreground">
                    <span className="text-primary">$</span>
                    <span>babua start --track dsa</span>
                  </div>
                  <div className="mt-2 text-muted-foreground">
                    <span className="text-primary">→</span> Loading Arrays & Hashing...
                  </div>
                  <div className="mt-1 text-muted-foreground">
                    <span className="text-primary">→</span> 156 topics | 450 problems
                  </div>
                  <div className="mt-1 text-foreground">
                    <span className="text-primary">✓</span> Ready to grind. No excuses.
                  </div>
                  <div className="mt-2 flex items-center">
                    <span className="text-primary">$</span>
                    <span className="ml-2 w-2 h-4 bg-primary animate-blink" />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* What is Babua LMS */}
      <section className="py-20 border-t border-border">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto">
            <h2 className="text-3xl md:text-4xl font-bold mb-6 text-center">
              What is <span className="text-primary">Babua LMS</span>?
            </h2>
            <p className="text-lg text-muted-foreground text-center mb-12">
              Not another course-selling platform. This is an engineering dojo.
            </p>

            <div className="grid md:grid-cols-3 gap-6">
              {[
                {
                  icon: BookOpen,
                  title: "Structured Learning",
                  description: "Follow battle-tested tracks from DSA to System Design. Every topic is ordered for maximum understanding.",
                },
                {
                  icon: Zap,
                  title: "Practice-First",
                  description: "Theory means nothing without practice. Solve problems, build projects, get your hands dirty.",
                },
                {
                  icon: Users,
                  title: "Community Driven",
                  description: "Learn with peers. Compete on leaderboards. Join accountability rooms. No one grinds alone.",
                },
              ].map((item, index) => (
                <div
                  key={index}
                  className="surface-card p-6 text-center"
                >
                  <div className="inline-flex items-center justify-center w-12 h-12 rounded-lg bg-primary/10 mb-4">
                    <item.icon className="h-6 w-6 text-primary" />
                  </div>
                  <h3 className="font-mono font-semibold mb-2">{item.title}</h3>
                  <p className="text-sm text-muted-foreground">{item.description}</p>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Learning Tracks */}
      <section className="py-20 border-t border-border">
        <div className="container mx-auto px-4">
          <div className="flex items-center justify-between mb-12">
            <div>
              <h2 className="text-3xl md:text-4xl font-bold mb-2">Learning Tracks</h2>
              <p className="text-muted-foreground">Pick a track. Start grinding.</p>
            </div>
            <Link to="/tracks">
              <Button variant="ghost" className="font-mono">
                View All
                <ArrowRight className="ml-2 h-4 w-4" />
              </Button>
            </Link>
          </div>

          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {tracks.slice(0, 6).map((track) => (
              <TrackCard
                key={track.id}
                slug={track.slug}
                title={track.title}
                shortTitle={track.shortTitle}
                description={track.description}
                topics={track.topics}
                problems={track.problems}
                difficulty={track.difficulty as "easy" | "medium" | "hard" | "mixed"}
                progress={track.progress}
                icon={track.icon}
              />
            ))}
          </div>
        </div>
      </section>

      {/* Why 100% Free */}
      <section className="py-20 border-t border-border bg-secondary/30">
        <div className="container mx-auto px-4">
          <div className="max-w-3xl mx-auto text-center">
            <h2 className="text-3xl md:text-4xl font-bold mb-6">
              Why is it <span className="text-primary">100% Free</span>?
            </h2>
            <p className="text-lg text-muted-foreground mb-8">
              Because real engineering knowledge should be accessible to everyone.
              We're engineers who've been through the grind. We know the struggle.
            </p>

            <div className="space-y-4 text-left max-w-xl mx-auto">
              {[
                "All core learning content is free forever",
                "No paywalls. No locked lessons. No certificate fees.",
                "Optional paid services for personalized help",
                "Community-funded. Mentor-supported.",
                "Open curriculum. You own your learning.",
              ].map((item, index) => (
                <div key={index} className="flex items-center gap-3">
                  <CheckCircle2 className="h-5 w-5 text-primary flex-shrink-0" />
                  <span className="text-foreground">{item}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Community Stats */}
      <section ref={statsRef} className="py-20 border-t border-border">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl md:text-4xl font-bold mb-12 text-center">
            The Grind is <span className="text-primary">Real</span>
          </h2>

          <div className="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-4xl mx-auto mb-12">
            {[
              { label: "Active Learners", value: communityStats.activeUsers.toLocaleString() },
              { label: "Problems Solved", value: communityStats.problemsSolved.toLocaleString() },
              { label: "Daily Active", value: communityStats.dailyActive.toLocaleString() },
              { label: "7-Day Streaks", value: communityStats.streak7Days.toLocaleString() },
            ].map((stat, index) => (
              <div key={index} className="text-center p-6 surface-card">
                <div className="text-3xl md:text-4xl font-mono font-bold text-primary mb-2">
                  {stat.value}
                </div>
                <div className="text-sm text-muted-foreground">{stat.label}</div>
              </div>
            ))}
          </div>

          {/* Top Contributors */}
          <div className="max-w-2xl mx-auto">
            <h3 className="font-mono text-lg font-semibold mb-4 text-center">Top Grinders</h3>
            <div className="surface-card divide-y divide-border">
              {communityStats.topContributors.slice(0, 5).map((user, index) => (
                <div key={index} className="flex items-center justify-between px-4 py-3">
                  <div className="flex items-center gap-3">
                    <span className="font-mono text-muted-foreground w-6">#{index + 1}</span>
                    <span className="font-mono text-foreground">{user.name}</span>
                  </div>
                  <div className="flex items-center gap-4 text-sm">
                    <span className="text-muted-foreground">
                      <span className="text-primary font-mono">{user.streak}</span> day streak
                    </span>
                    <span className="text-muted-foreground">
                      <span className="text-foreground font-mono">{user.solved}</span> solved
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Optional Paid Support */}
      <section className="py-20 border-t border-border">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto">
            <div className="text-center mb-12">
              <h2 className="text-3xl md:text-4xl font-bold mb-4">
                Need Extra <span className="text-primary">Help</span>?
              </h2>
              <p className="text-muted-foreground">
                100% optional. For those who want personalized guidance.
              </p>
            </div>

            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
              {supportServices.map((service) => (
                <div
                  key={service.id}
                  className={`surface-card p-5 relative ${
                    service.popular ? "border-primary/50" : ""
                  }`}
                >
                  {service.popular && (
                    <div className="absolute -top-2 right-4 px-2 py-0.5 bg-primary text-xs font-mono rounded">
                      Popular
                    </div>
                  )}
                  <h3 className="font-mono font-semibold mb-2">{service.title}</h3>
                  <p className="text-sm text-muted-foreground mb-4">{service.description}</p>
                  <div className="flex items-center justify-between">
                    <span className="text-2xl font-mono font-bold text-primary">
                      ₹{service.price}
                    </span>
                    <span className="text-xs text-muted-foreground">{service.duration}</span>
                  </div>
                </div>
              ))}
            </div>

            <div className="text-center mt-8">
              <Link to="/support">
                <Button variant="outline" className="font-mono">
                  View All Services
                  <ArrowRight className="ml-2 h-4 w-4" />
                </Button>
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Join Community CTA */}
      <section className="py-20 border-t border-border bg-secondary/30">
        <div className="container mx-auto px-4">
          <div className="max-w-3xl mx-auto text-center">
            <Terminal className="h-12 w-12 text-primary mx-auto mb-6" />
            <h2 className="text-3xl md:text-4xl font-bold mb-4">
              Ready to <span className="text-primary">Grind</span>?
            </h2>
            <p className="text-lg text-muted-foreground mb-8">
              Join thousands of engineers who chose skill over certificates.
              The dojo is open. The grind is real.
            </p>

            <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
              <Link to="/tracks">
                <Button size="lg" className="font-mono text-base px-8">
                  Start Free Learning
                  <ArrowRight className="ml-2 h-5 w-5" />
                </Button>
              </Link>
              <Button variant="outline" size="lg" className="font-mono text-base px-8">
                <MessageSquare className="mr-2 h-5 w-5" />
                Join Discord
              </Button>
            </div>

            <div className="mt-8 flex items-center justify-center gap-6 text-sm text-muted-foreground">
              <a href="#" className="flex items-center gap-2 hover:text-foreground transition-colors">
                <Github className="h-4 w-4" />
                <span>Open Source</span>
              </a>
              <span className="text-border">•</span>
              <span>Built with ❤️ by engineers, for engineers</span>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-8 border-t border-border">
        <div className="container mx-auto px-4">
          <div className="flex flex-col md:flex-row items-center justify-between gap-4">
            <div className="flex items-center gap-2">
              <Terminal className="h-5 w-5 text-primary" />
              <span className="font-mono text-sm">babua.lms</span>
            </div>
            <div className="flex items-center gap-6 text-sm text-muted-foreground">
              <Link to="/tracks" className="hover:text-foreground transition-colors">Tracks</Link>
              <Link to="/practice" className="hover:text-foreground transition-colors">Practice</Link>
              <Link to="/community" className="hover:text-foreground transition-colors">Community</Link>
              <Link to="/support" className="hover:text-foreground transition-colors">Support</Link>
            </div>
            <div className="text-sm text-muted-foreground font-mono">
              © 2024 Babua LMS
            </div>
          </div>
        </div>
      </footer>
    </Layout>
  );
}

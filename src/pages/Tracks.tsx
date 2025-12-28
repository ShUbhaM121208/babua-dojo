import { Layout } from "@/components/layout/Layout";
import { TrackCard } from "@/components/ui/TrackCard";
import { tracks } from "@/data/mockData";
import { BookOpen } from "lucide-react";

export default function Tracks() {
  return (
    <Layout>
      <div className="py-12">
        <div className="container mx-auto px-4">
          {/* Header */}
          <div className="max-w-3xl mb-12">
            <div className="flex items-center gap-3 mb-4">
              <BookOpen className="h-8 w-8 text-primary" />
              <h1 className="text-3xl md:text-4xl font-bold">Learning Tracks</h1>
            </div>
            <p className="text-lg text-muted-foreground">
              Each track is designed by engineers who've been through the grind.
              Pick one. Master it. Move to the next.
            </p>
          </div>

          {/* Tracks Grid */}
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {tracks.map((track) => (
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

          {/* Bottom Info */}
          <div className="mt-16 max-w-2xl mx-auto text-center">
            <div className="surface-card p-8">
              <h3 className="font-mono text-xl font-semibold mb-4">
                Not sure where to start?
              </h3>
              <p className="text-muted-foreground mb-6">
                Most engineers start with <span className="text-primary font-medium">DSA</span> to build foundations,
                then move to <span className="text-primary font-medium">System Design</span> for senior-level thinking.
              </p>
              <div className="font-mono text-sm text-muted-foreground">
                Recommended order: DSA → LLD → System Design → OS → CN → DBMS
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}

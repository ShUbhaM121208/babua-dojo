import { Layout } from "@/components/layout/Layout";
import { Button } from "@/components/ui/button";
import { supportServices } from "@/data/mockData";
import { HeartHandshake, Check, ArrowRight } from "lucide-react";

export default function Support() {
  return (
    <Layout>
      <div className="py-12">
        <div className="container mx-auto px-4">
          {/* Header */}
          <div className="max-w-3xl mx-auto text-center mb-16">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full border border-border bg-secondary/50 text-sm text-muted-foreground mb-6 font-mono">
              <HeartHandshake className="h-4 w-4 text-primary" />
              <span>100% Optional</span>
            </div>

            <h1 className="text-3xl md:text-4xl font-bold mb-4">
              Need Extra <span className="text-primary">Help</span>?
            </h1>
            <p className="text-lg text-muted-foreground">
              All learning content is free forever. These optional services are for those
              who want personalized guidance from experienced engineers.
            </p>
          </div>

          {/* Services Grid */}
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6 max-w-5xl mx-auto mb-16">
            {supportServices.map((service) => (
              <div
                key={service.id}
                className={`surface-card p-6 relative flex flex-col ${
                  service.popular ? "border-primary/50 ring-1 ring-primary/20" : ""
                }`}
              >
                {service.popular && (
                  <div className="absolute -top-3 left-1/2 -translate-x-1/2 px-3 py-1 bg-primary text-xs font-mono rounded-full">
                    Most Popular
                  </div>
                )}

                <h3 className="font-mono text-lg font-semibold mb-2">{service.title}</h3>
                <p className="text-sm text-muted-foreground mb-4 flex-grow">
                  {service.description}
                </p>

                <div className="flex items-end justify-between mb-4">
                  <div>
                    <span className="text-3xl font-mono font-bold text-primary">
                      ₹{service.price}
                    </span>
                    <span className="text-muted-foreground ml-2">/{service.duration}</span>
                  </div>
                </div>

                <Button className="w-full font-mono" variant={service.popular ? "default" : "outline"}>
                  Book Now
                  <ArrowRight className="ml-2 h-4 w-4" />
                </Button>
              </div>
            ))}
          </div>

          {/* How It Works */}
          <div className="max-w-4xl mx-auto">
            <h2 className="text-2xl font-bold mb-8 text-center">How It Works</h2>
            <div className="grid md:grid-cols-3 gap-8">
              {[
                {
                  step: "01",
                  title: "Choose a Service",
                  description: "Pick what you need help with - interviews, resume, roadmap, or accountability.",
                },
                {
                  step: "02",
                  title: "Book a Slot",
                  description: "Select a time that works for you. All sessions are scheduled within 48 hours.",
                },
                {
                  step: "03",
                  title: "Get Real Help",
                  description: "Connect with engineers from top companies who've been through the same grind.",
                },
              ].map((item, index) => (
                <div key={index} className="text-center">
                  <div className="inline-flex items-center justify-center w-12 h-12 rounded-full bg-primary/10 mb-4">
                    <span className="font-mono font-bold text-primary">{item.step}</span>
                  </div>
                  <h3 className="font-mono font-semibold mb-2">{item.title}</h3>
                  <p className="text-sm text-muted-foreground">{item.description}</p>
                </div>
              ))}
            </div>
          </div>

          {/* Why Pay */}
          <div className="max-w-3xl mx-auto mt-16">
            <div className="surface-card p-8">
              <h2 className="text-xl font-bold mb-6 text-center">Why Offer Paid Services?</h2>
              <div className="space-y-4">
                {[
                  "100% of proceeds go to mentors and platform maintenance",
                  "Keeps all learning content free forever",
                  "Provides real income for engineers who volunteer their time",
                  "Creates incentive for quality mentorship",
                  "Completely optional - you can master everything without paying",
                ].map((item, index) => (
                  <div key={index} className="flex items-start gap-3">
                    <Check className="h-5 w-5 text-primary flex-shrink-0 mt-0.5" />
                    <span className="text-muted-foreground">{item}</span>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* CTA */}
          <div className="max-w-xl mx-auto mt-16 text-center">
            <p className="text-muted-foreground mb-4">
              Not sure what you need? Start with a free community discussion.
            </p>
            <Button variant="outline" className="font-mono">
              Ask the Community
              <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          </div>
        </div>
      </div>
    </Layout>
  );
}

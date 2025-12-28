import { Link, useLocation } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Terminal, Menu, X } from "lucide-react";
import { useState } from "react";

const navLinks = [
  { path: "/tracks", label: "Tracks" },
  { path: "/practice", label: "Practice" },
  { path: "/community", label: "Community" },
  { path: "/support", label: "Support" },
];

export function Header() {
  const location = useLocation();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  return (
    <header className="fixed top-0 left-0 right-0 z-50 border-b border-border bg-background/80 backdrop-blur-md">
      <div className="container mx-auto px-4">
        <div className="flex h-16 items-center justify-between">
          {/* Logo */}
          <Link to="/" className="flex items-center gap-2 hover-lift">
            <Terminal className="h-6 w-6 text-primary" />
            <span className="font-mono text-lg font-bold">babua.lms</span>
          </Link>

          {/* Desktop Navigation */}
          <nav className="hidden md:flex items-center gap-1">
            {navLinks.map((link) => (
              <Link
                key={link.path}
                to={link.path}
                className={`px-4 py-2 text-sm font-medium transition-colors rounded-md ${
                  location.pathname === link.path
                    ? "text-primary bg-primary/10"
                    : "text-muted-foreground hover:text-foreground hover:bg-secondary"
                }`}
              >
                {link.label}
              </Link>
            ))}
          </nav>

          {/* Desktop Actions */}
          <div className="hidden md:flex items-center gap-3">
            <Link to="/dashboard">
              <Button variant="ghost" size="sm" className="font-mono text-sm">
                Dashboard
              </Button>
            </Link>
            <Button size="sm" className="font-mono text-sm">
              Start Learning
            </Button>
          </div>

          {/* Mobile Menu Toggle */}
          <button
            className="md:hidden p-2"
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
          >
            {mobileMenuOpen ? (
              <X className="h-5 w-5" />
            ) : (
              <Menu className="h-5 w-5" />
            )}
          </button>
        </div>

        {/* Mobile Menu */}
        {mobileMenuOpen && (
          <div className="md:hidden py-4 border-t border-border">
            <nav className="flex flex-col gap-2">
              {navLinks.map((link) => (
                <Link
                  key={link.path}
                  to={link.path}
                  onClick={() => setMobileMenuOpen(false)}
                  className={`px-4 py-3 text-sm font-medium transition-colors rounded-md ${
                    location.pathname === link.path
                      ? "text-primary bg-primary/10"
                      : "text-muted-foreground hover:text-foreground hover:bg-secondary"
                  }`}
                >
                  {link.label}
                </Link>
              ))}
              <div className="pt-2 mt-2 border-t border-border flex flex-col gap-2">
                <Link to="/dashboard" onClick={() => setMobileMenuOpen(false)}>
                  <Button variant="ghost" className="w-full font-mono text-sm">
                    Dashboard
                  </Button>
                </Link>
                <Button className="w-full font-mono text-sm">
                  Start Learning
                </Button>
              </div>
            </nav>
          </div>
        )}
      </div>
    </header>
  );
}

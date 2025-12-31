import { Link, useLocation, useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Terminal, Menu, X, LogOut, User } from "lucide-react";
import { useState } from "react";
import { useAuth } from "@/contexts/AuthContext";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

const navLinks = [
  { path: "/tracks", label: "Tracks" },
  { path: "/practice", label: "Practice" },
  { path: "/battle-matchmaking", label: "Battle Royale" },
  { path: "/doubt-arena", label: "Doubt Arena" },
  { path: "/interview-prep", label: "Interview Prep" },
  { path: "/mock-interview", label: "Mock Interview" },
  { path: "/analytics", label: "Analytics" },
  { path: "/community", label: "Community" },
  { path: "/support", label: "Support" },
];

export function Header() {
  const location = useLocation();
  const navigate = useNavigate();
  const { user, signOut } = useAuth();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const handleSignOut = async () => {
    await signOut();
    navigate('/');
  };

  const handleStartLearning = () => {
    if (user) {
      navigate('/tracks');
    } else {
      navigate('/auth');
    }
  };

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
            {user ? (
              <>
                <Link to="/dashboard">
                  <Button variant="ghost" size="sm" className="font-mono text-sm">
                    Dashboard
                  </Button>
                </Link>
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <Button variant="outline" size="sm" className="font-mono text-sm">
                      <User className="h-4 w-4 mr-2" />
                      Account
                    </Button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end" className="w-56">
                    <DropdownMenuLabel className="font-normal">
                      <div className="flex flex-col space-y-1">
                        <p className="text-sm font-medium leading-none">
                          {user.user_metadata?.full_name || 'User'}
                        </p>
                        <p className="text-xs leading-none text-muted-foreground">
                          {user.email}
                        </p>
                      </div>
                    </DropdownMenuLabel>
                    <DropdownMenuSeparator />
                    <Link to="/profile">
                      <DropdownMenuItem className="cursor-pointer">
                        <User className="h-4 w-4 mr-2" />
                        Profile
                      </DropdownMenuItem>
                    </Link>
                    <Link to="/dashboard">
                      <DropdownMenuItem className="cursor-pointer">
                        Dashboard
                      </DropdownMenuItem>
                    </Link>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem onClick={handleSignOut} className="cursor-pointer">
                      <LogOut className="h-4 w-4 mr-2" />
                      Log out
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              </>
            ) : (
              <Button 
                size="sm" 
                className="font-mono text-sm"
                onClick={handleStartLearning}
              >
                Start Learning
              </Button>
            )}
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
                {user ? (
                  <>
                    <Link to="/dashboard" onClick={() => setMobileMenuOpen(false)}>
                      <Button variant="ghost" className="w-full font-mono text-sm justify-start">
                        <User className="h-4 w-4 mr-2" />
                        Dashboard
                      </Button>
                    </Link>
                    <Button 
                      variant="ghost" 
                      className="w-full font-mono text-sm justify-start text-destructive hover:text-destructive"
                      onClick={() => {
                        handleSignOut();
                        setMobileMenuOpen(false);
                      }}
                    >
                      <LogOut className="h-4 w-4 mr-2" />
                      Log out
                    </Button>
                  </>
                ) : (
                  <Button 
                    className="w-full font-mono text-sm"
                    onClick={() => {
                      handleStartLearning();
                      setMobileMenuOpen(false);
                    }}
                  >
                    Start Learning
                  </Button>
                )}
              </div>
            </nav>
          </div>
        )}
      </div>
    </header>
  );
}

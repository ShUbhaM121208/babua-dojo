import { Link, useLocation, useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Terminal, Menu, X, LogOut, User, ChevronDown } from "lucide-react";
import { useState, useEffect } from "react";
import { useAuth } from "@/contexts/AuthContext";
import { RankBadge } from "@/components/profile/RankBadge";
import { getUserRank } from "@/lib/rankService";
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
  { path: "/study-plans", label: "Study Plans" },
  { path: "/tournaments", label: "Tournaments" },
  { path: "/battle-matchmaking", label: "Battle" },
  { path: "/analytics", label: "Analytics" },
];

const moreLinks = [
  { path: "/doubt-arena", label: "Doubt Arena" },
  { path: "/whiteboard", label: "Whiteboard" },
  { path: "/interview-prep", label: "Interview Prep" },
  { path: "/mock-interview", label: "Mock Interview" },
  { path: "/community", label: "Community" },
  { path: "/support", label: "Support" },
];

export function Header() {
  const location = useLocation();
  const navigate = useNavigate();
  const { user, signOut } = useAuth();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [userRank, setUserRank] = useState<any>(null);

  useEffect(() => {
    if (user) {
      getUserRank(user.id).then(async (rank) => {
        if (!rank) {
          // Initialize rank if it doesn't exist
          const { updateUserRankFromXP } = await import('@/lib/rankService');
          await updateUserRankFromXP(user.id, 0);
          const newRank = await getUserRank(user.id);
          setUserRank(newRank);
        } else {
          setUserRank(rank);
        }
      });
    }
  }, [user]);

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
    <header className="fixed top-0 left-0 right-0 z-50 border-b border-border/40 bg-background/95 backdrop-blur-xl supports-[backdrop-filter]:bg-background/60">
      <div className="container mx-auto px-4">
        <div className="flex h-14 items-center justify-between">
          {/* Logo */}
          <Link to="/" className="flex items-center gap-2 group">
            <div className="relative">
              <Terminal className="h-5 w-5 text-primary transition-transform group-hover:scale-110" />
              <div className="absolute inset-0 blur-lg bg-primary/20 group-hover:bg-primary/30 transition-colors -z-10"></div>
            </div>
            <span className="font-mono text-base font-bold bg-gradient-to-r from-foreground to-foreground/80 bg-clip-text">
              babua.lms
            </span>
          </Link>

          {/* Desktop Navigation */}
          <nav className="hidden lg:flex items-center gap-1">
            {navLinks.map((link) => (
              <Link
                key={link.path}
                to={link.path}
                className={`relative px-4 py-2 text-sm font-medium transition-all rounded-lg ${
                  location.pathname === link.path
                    ? "text-primary bg-primary/10"
                    : "text-muted-foreground hover:text-foreground hover:bg-primary/5"
                }`}
              >
                {link.label}
              </Link>
            ))}
            
            {/* More Dropdown */}
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button
                  variant="ghost"
                  size="sm"
                  className="text-sm font-medium text-muted-foreground hover:text-foreground hover:bg-primary/5"
                >
                  More
                  <ChevronDown className="h-4 w-4 ml-1" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end" className="w-48">
                {moreLinks.map((link) => (
                  <Link key={link.path} to={link.path}>
                    <DropdownMenuItem className="cursor-pointer">
                      {link.label}
                    </DropdownMenuItem>
                  </Link>
                ))}
              </DropdownMenuContent>
            </DropdownMenu>
          </nav>

          {/* Desktop Actions */}
          <div className="hidden lg:flex items-center gap-3">
            {user ? (
              <>
                <Link to="/dashboard">
                  <Button 
                    variant="ghost" 
                    size="sm" 
                    className="font-mono text-sm"
                  >
                    Dashboard
                  </Button>
                </Link>
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <Button 
                      variant="outline" 
                      size="icon"
                      className="h-9 w-9 rounded-full"
                    >
                      <User className="h-4 w-4" />
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
                className="font-mono text-sm shadow-lg shadow-primary/20"
                onClick={handleStartLearning}
              >
                Get Started
              </Button>
            )}
          </div>

          {/* Mobile Menu Toggle */}
          <button
            className="lg:hidden p-2 hover:bg-primary/5 rounded-lg transition-colors"
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
          <div className="lg:hidden py-4 border-t border-border/40 animate-in slide-in-from-top-2 duration-200">
            <nav className="flex flex-col gap-1">
              {navLinks.map((link) => (
                <Link
                  key={link.path}
                  to={link.path}
                  onClick={() => setMobileMenuOpen(false)}
                  className={`px-4 py-2.5 text-sm font-medium transition-all rounded-lg ${
                    location.pathname === link.path
                      ? "text-primary bg-primary/10"
                      : "text-muted-foreground hover:text-foreground hover:bg-primary/5"
                  }`}
                >
                  {link.label}
                </Link>
              ))}
              
              <div className="px-4 py-2 text-xs font-semibold text-muted-foreground">
                More
              </div>
              
              {moreLinks.map((link) => (
                <Link
                  key={link.path}
                  to={link.path}
                  onClick={() => setMobileMenuOpen(false)}
                  className={`px-4 py-2.5 text-sm font-medium transition-all rounded-lg ${
                    location.pathname === link.path
                      ? "text-primary bg-primary/10"
                      : "text-muted-foreground hover:text-foreground hover:bg-primary/5"
                  }`}
                >
                  {link.label}
                </Link>
              ))}
              
              <div className="pt-2 mt-2 border-t border-border/40 flex flex-col gap-1">
                {user ? (
                  <>
                    <Link to="/dashboard" onClick={() => setMobileMenuOpen(false)}>
                      <Button variant="ghost" className="w-full font-mono text-sm justify-start h-9 hover:bg-primary/5">
                        <User className="h-4 w-4 mr-2" />
                        Dashboard
                      </Button>
                    </Link>
                    <Button 
                      variant="ghost" 
                      className="w-full font-mono text-sm justify-start text-destructive hover:text-destructive hover:bg-destructive/10 h-9"
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
                    className="w-full font-mono text-sm h-9 bg-primary hover:bg-primary/90 shadow-lg shadow-primary/20"
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

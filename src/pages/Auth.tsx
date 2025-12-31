import { useState, useEffect } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { useAuth } from '@/contexts/AuthContext';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { useToast } from '@/hooks/use-toast';
import { Loader2, Terminal, Gift } from 'lucide-react';
import { processReferralSignup } from '@/lib/referralService';
import { supabase } from '@/integrations/supabase/client';

export default function Auth() {
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [fullName, setFullName] = useState('');
  const [loading, setLoading] = useState(false);
  const [searchParams] = useSearchParams();
  const [referralCode, setReferralCode] = useState<string | null>(null);
  const { signIn, signUp } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();

  // Extract referral code from URL on mount
  useEffect(() => {
    const refCode = searchParams.get('ref');
    if (refCode) {
      setReferralCode(refCode);
      setIsLogin(false); // Auto-switch to signup mode
      toast({
        title: 'Referral Code Detected! 🎉',
        description: 'Sign up now and earn 200 XP bonus!',
      });
    }
  }, [searchParams, toast]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      if (isLogin) {
        const { error } = await signIn(email, password);
        if (error) {
          toast({
            title: 'Error',
            description: error.message,
            variant: 'destructive',
          });
        } else {
          toast({
            title: 'Success',
            description: 'Logged in successfully!',
          });
          navigate('/tracks');
        }
      } else {
        if (!fullName.trim()) {
          toast({
            title: 'Error',
            description: 'Please enter your full name',
            variant: 'destructive',
          });
          setLoading(false);
          return;
        }
        
        const { error } = await signUp(email, password, fullName);
        if (error) {
          toast({
            title: 'Error',
            description: error.message,
            variant: 'destructive',
          });
        } else {
          toast({
            title: 'Success',
            description: 'Account created successfully! You can now log in.',
          });
          
          // Process referral if code exists
          if (referralCode) {
            try {
              // Get the newly created user
              const { data: { user: newUser } } = await supabase.auth.getUser();
              if (newUser) {
                const success = await processReferralSignup(referralCode, newUser.id);
                if (success) {
                  toast({
                    title: 'Referral Bonus! 🎁',
                    description: 'You earned 200 XP from your referral!',
                  });
                }
              }
            } catch (refError) {
              console.error('Error processing referral:', refError);
              // Don't block signup if referral fails
            }
          }
          
          setIsLogin(true);
          setPassword('');
        }
      }
    } catch (error: any) {
      toast({
        title: 'Error',
        description: error.message || 'An error occurred',
        variant: 'destructive',
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-950 flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        {/* Logo */}
        <div className="text-center mb-8">
          <div className="flex items-center justify-center gap-2 mb-4">
            <Terminal className="w-8 h-8 text-primary" />
            <span className="text-2xl font-bold text-white">babua.lms</span>
          </div>
          <p className="text-gray-400">100% Free Engineering Learning</p>
        </div>

        {/* Auth Form */}
        <div className="bg-gray-900 rounded-lg border border-gray-800 p-8">
          {/* Referral Indicator */}
          {referralCode && !isLogin && (
            <div className="mb-6 p-4 bg-primary/10 border border-primary/30 rounded-lg">
              <div className="flex items-center gap-2 text-primary">
                <Gift className="w-5 h-5" />
                <span className="font-semibold">Referral Code Applied!</span>
              </div>
              <p className="text-sm text-gray-400 mt-1">
                Earn 200 XP bonus when you sign up
              </p>
            </div>
          )}
          
          <h2 className="text-2xl font-bold text-white mb-6 text-center">
            {isLogin ? 'Welcome Back' : 'Create Account'}
          </h2>

          <form onSubmit={handleSubmit} className="space-y-4">
            {!isLogin && (
              <div className="space-y-2">
                <Label htmlFor="fullName" className="text-gray-300">
                  Full Name
                </Label>
                <Input
                  id="fullName"
                  type="text"
                  placeholder="John Doe"
                  value={fullName}
                  onChange={(e) => setFullName(e.target.value)}
                  required={!isLogin}
                  className="bg-gray-800 border-gray-700 text-white placeholder:text-gray-500"
                />
              </div>
            )}

            <div className="space-y-2">
              <Label htmlFor="email" className="text-gray-300">
                Email
              </Label>
              <Input
                id="email"
                type="email"
                placeholder="you@example.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="bg-gray-800 border-gray-700 text-white placeholder:text-gray-500"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="password" className="text-gray-300">
                Password
              </Label>
              <Input
                id="password"
                type="password"
                placeholder="••••••••"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                minLength={6}
                className="bg-gray-800 border-gray-700 text-white placeholder:text-gray-500"
              />
              {!isLogin && (
                <p className="text-xs text-gray-500">
                  Password must be at least 6 characters
                </p>
              )}
            </div>

            <Button
              type="submit"
              disabled={loading}
              className="w-full bg-primary hover:bg-primary/90 text-white"
            >
              {loading ? (
                <>
                  <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                  {isLogin ? 'Logging in...' : 'Creating account...'}
                </>
              ) : isLogin ? (
                'Log In'
              ) : (
                'Sign Up'
              )}
            </Button>
          </form>

          <div className="mt-6 text-center">
            <button
              onClick={() => {
                setIsLogin(!isLogin);
                setPassword('');
                setFullName('');
              }}
              className="text-sm text-primary hover:underline"
            >
              {isLogin
                ? "Don't have an account? Sign up"
                : 'Already have an account? Log in'}
            </button>
          </div>
        </div>

        {/* Additional Info */}
        <div className="mt-6 text-center text-sm text-gray-500">
          <p>No certificates. No upsells. Just pure learning.</p>
          <p className="mt-1">Pay only if you want extra help.</p>
        </div>
      </div>
    </div>
  );
}

import { Suspense, lazy } from "react";
import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "@/contexts/AuthContext";
import { ProtectedRoute } from "@/components/auth/ProtectedRoute";
import { ErrorBoundary } from "@/components/ErrorBoundary";
import {
  DashboardSkeleton,
  ProblemSolverSkeleton,
  AnalyticsSkeleton,
  TracksSkeleton,
  MockInterviewSkeleton,
  ProfileSkeleton,
  BattleArenaSkeleton,
  InterviewRoomSkeleton
} from "@/components/LoadingSkeletons";

// Lazy load pages for code splitting
const Index = lazy(() => import("./pages/Index"));
const Auth = lazy(() => import("./pages/Auth"));
const Tracks = lazy(() => import("./pages/Tracks"));
const TrackDetail = lazy(() => import("./pages/TrackDetail"));
const Practice = lazy(() => import("./pages/Practice"));
const Community = lazy(() => import("./pages/Community"));
const Support = lazy(() => import("./pages/Support"));
const Dashboard = lazy(() => import("./pages/Dashboard"));
const ProblemSolver = lazy(() => import("./pages/ProblemSolver"));
const DoubtArena = lazy(() => import("./pages/DoubtArena"));
const Whiteboard = lazy(() => import("./pages/Whiteboard"));
const NotFound = lazy(() => import("./pages/NotFound"));
const Profile = lazy(() => import("./pages/Profile"));
const Analytics = lazy(() => import("./pages/Analytics"));
const MockInterview = lazy(() => import("./pages/MockInterview"));
const BattleMatchmaking = lazy(() => import("./pages/BattleMatchmaking"));
const BattleArena = lazy(() => import("./pages/BattleArena"));
const InterviewMatching = lazy(() => import("./pages/InterviewMatching"));
const InterviewRoom = lazy(() => import("./pages/InterviewRoom"));
const StudyPlans = lazy(() => import("./pages/StudyPlans"));
const StudyPlanDetail = lazy(() => import("./pages/StudyPlanDetail"));
const Leaderboards = lazy(() => import("./pages/Leaderboards"));
const Tournaments = lazy(() => import("./pages/Tournaments"));
const TournamentDetails = lazy(() => import("./components/tournaments/TournamentDetails"));
const TournamentLive = lazy(() => import("./pages/TournamentLive"));

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 1,
      refetchOnWindowFocus: false,
      staleTime: 5 * 60 * 1000, // 5 minutes
    },
  },
});

const App = () => (
  <ErrorBoundary>
    <QueryClientProvider client={queryClient}>
      <AuthProvider>
        <TooltipProvider>
          <Toaster />
          <Sonner />
          <BrowserRouter>
            <Suspense fallback={<DashboardSkeleton />}>
              <Routes>
                <Route path="/" element={<Index />} />
                <Route path="/auth" element={<Auth />} />
                <Route
                  path="/tracks"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<TracksSkeleton />}>
                        <Tracks />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/tracks/:slug"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<TracksSkeleton />}>
                        <TrackDetail />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/practice"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<DashboardSkeleton />}>
                        <Practice />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/problem/:id"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<ProblemSolverSkeleton />}>
                        <ProblemSolver />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/problems/:id"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<ProblemSolverSkeleton />}>
                        <ProblemSolver />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/doubt-arena"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<DashboardSkeleton />}>
                        <DoubtArena />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/whiteboard"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<DashboardSkeleton />}>
                        <Whiteboard />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/community"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<DashboardSkeleton />}>
                        <Community />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/support"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<DashboardSkeleton />}>
                        <Support />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/dashboard"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<DashboardSkeleton />}>
                        <Dashboard />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/profile"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<ProfileSkeleton />}>
                        <Profile />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/analytics"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<AnalyticsSkeleton />}>
                        <Analytics />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/study-plans"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<DashboardSkeleton />}>
                        <StudyPlans />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/study-plans/:id"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<DashboardSkeleton />}>
                        <StudyPlanDetail />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/leaderboards"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<DashboardSkeleton />}>
                        <Leaderboards />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/tournaments"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<DashboardSkeleton />}>
                        <Tournaments />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/tournaments/:tournamentId"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<DashboardSkeleton />}>
                        <TournamentDetails />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/tournaments/:tournamentId/live"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<DashboardSkeleton />}>
                        <TournamentLive />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/mock-interview"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<MockInterviewSkeleton />}>
                        <MockInterview />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/battle-matchmaking"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<DashboardSkeleton />}>
                        <BattleMatchmaking />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/battle/:roomId"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<BattleArenaSkeleton />}>
                        <BattleArena />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/interview-prep"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<DashboardSkeleton />}>
                        <InterviewMatching />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route
                  path="/interview/:sessionId"
                  element={
                    <ProtectedRoute>
                      <Suspense fallback={<InterviewRoomSkeleton />}>
                        <InterviewRoom />
                      </Suspense>
                    </ProtectedRoute>
                  }
                />
                <Route path="*" element={<NotFound />} />
              </Routes>
            </Suspense>
          </BrowserRouter>
        </TooltipProvider>
      </AuthProvider>
    </QueryClientProvider>
  </ErrorBoundary>
);

export default App;

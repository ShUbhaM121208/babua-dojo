import { Skeleton } from './ui/skeleton';
import { Card } from './ui/card';

export function ProblemSolverSkeleton() {
  return (
    <div className="h-screen flex flex-col">
      <div className="border-b p-4 flex items-center justify-between">
        <div className="space-y-2">
          <Skeleton className="h-8 w-64" />
          <Skeleton className="h-4 w-32" />
        </div>
        <div className="flex gap-2">
          <Skeleton className="h-10 w-24" />
          <Skeleton className="h-10 w-24" />
        </div>
      </div>
      
      <div className="flex-1 flex">
        <div className="w-1/2 p-6 space-y-4">
          <Skeleton className="h-6 w-3/4" />
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-2/3" />
        </div>
        <div className="w-1/2 border-l">
          <Skeleton className="h-full" />
        </div>
      </div>
    </div>
  );
}

export function DashboardSkeleton() {
  return (
    <div className="container mx-auto p-6 space-y-6">
      <Skeleton className="h-10 w-64" />
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {[1, 2, 3, 4].map((i) => (
          <Card key={i} className="p-4 space-y-2">
            <Skeleton className="h-4 w-24" />
            <Skeleton className="h-8 w-16" />
            <Skeleton className="h-3 w-32" />
          </Card>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card className="p-6 space-y-4">
          <Skeleton className="h-6 w-48" />
          <Skeleton className="h-64 w-full" />
        </Card>
        <Card className="p-6 space-y-4">
          <Skeleton className="h-6 w-48" />
          <Skeleton className="h-64 w-full" />
        </Card>
      </div>
    </div>
  );
}

export function AnalyticsSkeleton() {
  return (
    <div className="container mx-auto p-6 space-y-6">
      <div className="flex items-center justify-between">
        <div className="space-y-2">
          <Skeleton className="h-8 w-64" />
          <Skeleton className="h-4 w-48" />
        </div>
        <div className="flex gap-2">
          <Skeleton className="h-10 w-24" />
          <Skeleton className="h-10 w-32" />
        </div>
      </div>

      <Card className="p-6">
        <Skeleton className="h-20 w-full" />
      </Card>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {[1, 2, 3, 4].map((i) => (
          <Card key={i} className="p-4 space-y-3">
            <Skeleton className="h-4 w-24" />
            <Skeleton className="h-10 w-20" />
            <Skeleton className="h-3 w-full" />
          </Card>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {[1, 2].map((i) => (
          <Card key={i} className="p-6 space-y-4">
            <Skeleton className="h-6 w-48" />
            <Skeleton className="h-64 w-full" />
          </Card>
        ))}
      </div>
    </div>
  );
}

export function TracksSkeleton() {
  return (
    <div className="container mx-auto p-6 space-y-6">
      <Skeleton className="h-10 w-48" />
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {[1, 2, 3, 4, 5, 6].map((i) => (
          <Card key={i} className="p-6 space-y-4">
            <div className="flex items-start justify-between">
              <Skeleton className="h-12 w-12 rounded-full" />
              <Skeleton className="h-6 w-16" />
            </div>
            <Skeleton className="h-6 w-3/4" />
            <Skeleton className="h-4 w-full" />
            <Skeleton className="h-4 w-5/6" />
            <Skeleton className="h-2 w-full" />
            <Skeleton className="h-10 w-full" />
          </Card>
        ))}
      </div>
    </div>
  );
}

export function MockInterviewSkeleton() {
  return (
    <div className="container mx-auto p-6 space-y-6">
      <div className="text-center space-y-2 mb-8">
        <Skeleton className="h-10 w-64 mx-auto" />
        <Skeleton className="h-4 w-96 mx-auto" />
      </div>

      <Card className="p-6 space-y-6">
        <div className="space-y-4">
          <Skeleton className="h-6 w-32" />
          <Skeleton className="h-10 w-full" />
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div className="space-y-2">
            <Skeleton className="h-4 w-24" />
            <Skeleton className="h-10 w-full" />
          </div>
          <div className="space-y-2">
            <Skeleton className="h-4 w-24" />
            <Skeleton className="h-10 w-full" />
          </div>
        </div>
        <Skeleton className="h-12 w-full" />
      </Card>
    </div>
  );
}

export function ProfileSkeleton() {
  return (
    <div className="container mx-auto p-6 space-y-6">
      <Card className="p-6">
        <div className="flex items-start gap-6">
          <Skeleton className="h-32 w-32 rounded-full" />
          <div className="flex-1 space-y-3">
            <Skeleton className="h-8 w-48" />
            <Skeleton className="h-4 w-64" />
            <div className="flex gap-2">
              <Skeleton className="h-8 w-24" />
              <Skeleton className="h-8 w-24" />
            </div>
          </div>
        </div>
      </Card>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <Card className="p-6 space-y-4">
          <Skeleton className="h-6 w-32" />
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-3/4" />
        </Card>
        <Card className="p-6 space-y-4">
          <Skeleton className="h-6 w-32" />
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-3/4" />
        </Card>
        <Card className="p-6 space-y-4">
          <Skeleton className="h-6 w-32" />
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-3/4" />
        </Card>
      </div>
    </div>
  );
}

export function BattleArenaSkeleton() {
  return (
    <div className="h-screen flex">
      <div className="flex-1 p-6 space-y-4">
        <div className="flex items-center justify-between">
          <Skeleton className="h-8 w-48" />
          <Skeleton className="h-10 w-32" />
        </div>
        <Skeleton className="h-96 w-full" />
        <div className="grid grid-cols-3 gap-4">
          <Skeleton className="h-20" />
          <Skeleton className="h-20" />
          <Skeleton className="h-20" />
        </div>
      </div>
      <div className="w-80 border-l p-4 space-y-4">
        <Skeleton className="h-6 w-32" />
        {[1, 2, 3, 4].map((i) => (
          <Skeleton key={i} className="h-16 w-full" />
        ))}
      </div>
    </div>
  );
}

export function InterviewRoomSkeleton() {
  return (
    <div className="h-screen flex flex-col space-y-4 p-4">
      <Skeleton className="h-64 w-full" />
      <div className="flex-1 grid grid-cols-2 gap-4">
        <Skeleton className="h-full" />
        <Skeleton className="h-full" />
      </div>
      <Skeleton className="h-16 w-full" />
    </div>
  );
}

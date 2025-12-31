import { useState, useEffect, useCallback } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { ScrollArea } from '@/components/ui/scroll-area';
import { 
  Clock, 
  CheckCircle, 
  XCircle, 
  TrendingUp, 
  Code, 
  Calendar,
  BarChart3,
  Play,
  GitCompare
} from 'lucide-react';
import { submissionService, Submission, SubmissionStats } from '@/services/submissionService';
import { format } from 'date-fns';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';

interface SubmissionHistoryProps {
  problemId: string;
  onLoadCode: (code: string, language: string) => void;
  onCompare: (version1: number, version2: number) => void;
}

export function SubmissionHistory({ problemId, onLoadCode, onCompare }: SubmissionHistoryProps) {
  const [submissions, setSubmissions] = useState<Submission[]>([]);
  const [stats, setStats] = useState<SubmissionStats | null>(null);
  const [loading, setLoading] = useState(true);
  const [selectedVersions, setSelectedVersions] = useState<number[]>([]);

  const loadHistory = useCallback(async () => {
    setLoading(true);
    const [historyData, statsData] = await Promise.all([
      submissionService.getSubmissionHistory(problemId),
      submissionService.getSubmissionStats(problemId),
    ]);
    setSubmissions(historyData);
    setStats(statsData);
    setLoading(false);
  }, [problemId]);

  useEffect(() => {
    loadHistory();
  }, [loadHistory]);

  const handleVersionSelect = (version: number) => {
    if (selectedVersions.includes(version)) {
      setSelectedVersions(selectedVersions.filter(v => v !== version));
    } else if (selectedVersions.length < 2) {
      setSelectedVersions([...selectedVersions, version]);
    } else {
      setSelectedVersions([selectedVersions[1], version]);
    }
  };

  const handleCompare = () => {
    if (selectedVersions.length === 2) {
      onCompare(Math.min(...selectedVersions), Math.max(...selectedVersions));
    }
  };

  const getStatusColor = (status: Submission['status']) => {
    switch (status) {
      case 'accepted':
        return 'bg-green-500/10 text-green-500 border-green-500/20';
      case 'wrong_answer':
        return 'bg-red-500/10 text-red-500 border-red-500/20';
      case 'runtime_error':
      case 'compile_error':
        return 'bg-orange-500/10 text-orange-500 border-orange-500/20';
      case 'time_limit_exceeded':
      case 'memory_limit_exceeded':
        return 'bg-yellow-500/10 text-yellow-500 border-yellow-500/20';
      default:
        return 'bg-gray-500/10 text-gray-500 border-gray-500/20';
    }
  };

  const getStatusIcon = (status: Submission['status']) => {
    return status === 'accepted' ? (
      <CheckCircle className="h-4 w-4" />
    ) : (
      <XCircle className="h-4 w-4" />
    );
  };

  const improvementData = submissions
    .slice()
    .reverse()
    .map(sub => ({
      version: sub.version,
      passedTests: sub.passed_count,
      time: sub.total_time,
    }));

  if (loading) {
    return (
      <div className="flex items-center justify-center p-8">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  if (submissions.length === 0) {
    return (
      <Card>
        <CardContent className="flex flex-col items-center justify-center p-12">
          <Code className="h-12 w-12 text-muted-foreground mb-4" />
          <p className="text-muted-foreground">No submissions yet</p>
          <p className="text-sm text-muted-foreground mt-2">
            Submit your code to see your submission history
          </p>
        </CardContent>
      </Card>
    );
  }

  return (
    <div className="space-y-4">
      {/* Stats Overview */}
      {stats && (
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <Card>
            <CardHeader className="pb-3">
              <CardDescription>Total Attempts</CardDescription>
              <CardTitle className="text-3xl">{stats.total_attempts}</CardTitle>
            </CardHeader>
          </Card>
          <Card>
            <CardHeader className="pb-3">
              <CardDescription>Success Rate</CardDescription>
              <CardTitle className="text-3xl">
                {stats.success_rate.toFixed(1)}%
              </CardTitle>
            </CardHeader>
          </Card>
          <Card>
            <CardHeader className="pb-3">
              <CardDescription>Best Time</CardDescription>
              <CardTitle className="text-3xl">
                {stats.best_time ? `${stats.best_time.toFixed(0)}ms` : 'N/A'}
              </CardTitle>
            </CardHeader>
          </Card>
          <Card>
            <CardHeader className="pb-3">
              <CardDescription>First Success</CardDescription>
              <CardTitle className="text-3xl">
                v{stats.first_success_version || '-'}
              </CardTitle>
            </CardHeader>
          </Card>
        </div>
      )}

      <Tabs defaultValue="timeline" className="w-full">
        <TabsList className="grid w-full grid-cols-2">
          <TabsTrigger value="timeline">Timeline</TabsTrigger>
          <TabsTrigger value="analytics">Analytics</TabsTrigger>
        </TabsList>

        <TabsContent value="timeline" className="space-y-4">
          {/* Compare Button */}
          {selectedVersions.length === 2 && (
            <div className="flex justify-end">
              <Button onClick={handleCompare} variant="outline">
                <GitCompare className="mr-2 h-4 w-4" />
                Compare v{Math.min(...selectedVersions)} vs v{Math.max(...selectedVersions)}
              </Button>
            </div>
          )}

          {/* Submission Timeline */}
          <ScrollArea className="h-[600px]">
            <div className="space-y-4 pr-4">
              {submissions.map((submission, index) => (
                <Card
                  key={submission.id}
                  className={`transition-all ${
                    selectedVersions.includes(submission.version)
                      ? 'ring-2 ring-primary'
                      : ''
                  }`}
                >
                  <CardHeader className="pb-3">
                    <div className="flex items-start justify-between">
                      <div className="space-y-1">
                        <div className="flex items-center gap-2">
                          <CardTitle className="text-lg">
                            Version {submission.version}
                          </CardTitle>
                          <Badge className={getStatusColor(submission.status)}>
                            {getStatusIcon(submission.status)}
                            <span className="ml-1">{submission.status.replace('_', ' ')}</span>
                          </Badge>
                          {index === 0 && (
                            <Badge variant="outline">Latest</Badge>
                          )}
                        </div>
                        <CardDescription className="flex items-center gap-4 text-sm">
                          <span className="flex items-center gap-1">
                            <Calendar className="h-3 w-3" />
                            {format(new Date(submission.submitted_at), 'MMM dd, yyyy HH:mm')}
                          </span>
                          <span className="flex items-center gap-1">
                            <Code className="h-3 w-3" />
                            {submission.language}
                          </span>
                          <span className="flex items-center gap-1">
                            <Clock className="h-3 w-3" />
                            {submission.total_time.toFixed(0)}ms
                          </span>
                        </CardDescription>
                      </div>
                      <div className="flex items-center gap-2">
                        <input
                          type="checkbox"
                          checked={selectedVersions.includes(submission.version)}
                          onChange={() => handleVersionSelect(submission.version)}
                          className="h-4 w-4 rounded border-gray-300"
                          aria-label={`Select version ${submission.version} for comparison`}
                          disabled={
                            selectedVersions.length >= 2 &&
                            !selectedVersions.includes(submission.version)
                          }
                        />
                      </div>
                    </div>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-3">
                      {/* Test Results Summary */}
                      <div className="flex items-center justify-between text-sm">
                        <span className="text-muted-foreground">Test Results:</span>
                        <span className="font-medium">
                          {submission.passed_count} / {submission.passed_count + submission.failed_count} passed
                        </span>
                      </div>

                      {/* Progress Bar */}
                      <div className="h-2 bg-secondary rounded-full overflow-hidden">
                        <div
                          className={`h-full ${
                            submission.all_passed ? 'bg-green-500' : 'bg-red-500'
                          }`}
                          style={{
                            width: `${
                              (submission.passed_count /
                                (submission.passed_count + submission.failed_count)) *
                              100
                            }%`,
                          }}
                        />
                      </div>

                      {/* Error Message */}
                      {submission.error_message && (
                        <div className="p-3 bg-destructive/10 rounded-md text-sm text-destructive">
                          {submission.error_message}
                        </div>
                      )}

                      {/* Actions */}
                      <div className="flex gap-2 pt-2">
                        <Button
                          size="sm"
                          variant="outline"
                          onClick={() => onLoadCode(submission.code, submission.language)}
                        >
                          <Play className="mr-2 h-3 w-3" />
                          Load Code
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </ScrollArea>
        </TabsContent>

        <TabsContent value="analytics" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <TrendingUp className="h-5 w-5" />
                Improvement Trend
              </CardTitle>
              <CardDescription>
                Track your progress over time
              </CardDescription>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={300}>
                <LineChart data={improvementData}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis 
                    dataKey="version" 
                    label={{ value: 'Version', position: 'insideBottom', offset: -5 }}
                  />
                  <YAxis 
                    label={{ value: 'Tests Passed', angle: -90, position: 'insideLeft' }}
                  />
                  <Tooltip />
                  <Line 
                    type="monotone" 
                    dataKey="passedTests" 
                    stroke="hsl(var(--primary))" 
                    strokeWidth={2}
                    dot={{ r: 4 }}
                  />
                </LineChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <BarChart3 className="h-5 w-5" />
                Performance Metrics
              </CardTitle>
            </CardHeader>
            <CardContent>
              <ResponsiveContainer width="100%" height={300}>
                <LineChart data={improvementData}>
                  <CartesianGrid strokeDasharray="3 3" />
                  <XAxis 
                    dataKey="version" 
                    label={{ value: 'Version', position: 'insideBottom', offset: -5 }}
                  />
                  <YAxis 
                    label={{ value: 'Time (ms)', angle: -90, position: 'insideLeft' }}
                  />
                  <Tooltip />
                  <Line 
                    type="monotone" 
                    dataKey="time" 
                    stroke="hsl(var(--chart-2))" 
                    strokeWidth={2}
                    dot={{ r: 4 }}
                  />
                </LineChart>
              </ResponsiveContainer>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}

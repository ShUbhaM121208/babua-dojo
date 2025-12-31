import { useState, useEffect, useCallback } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { ScrollArea } from '@/components/ui/scroll-area';
import { 
  ArrowLeft, 
  GitCompare, 
  TrendingUp, 
  TrendingDown, 
  Minus,
  Copy,
  Check
} from 'lucide-react';
import { submissionService, Submission } from '@/services/submissionService';
import { codeDiffService, SideBySideDiff } from '@/lib/codeDiffService';
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter';
import { vscDarkPlus } from 'react-syntax-highlighter/dist/esm/styles/prism';

interface CodeDiffViewerProps {
  problemId: string;
  version1: number;
  version2: number;
  onBack: () => void;
  onReplay: (code: string, language: string) => void;
}

export function CodeDiffViewer({ 
  problemId, 
  version1, 
  version2, 
  onBack, 
  onReplay 
}: CodeDiffViewerProps) {
  const [submission1, setSubmission1] = useState<Submission | null>(null);
  const [submission2, setSubmission2] = useState<Submission | null>(null);
  const [diff, setDiff] = useState<SideBySideDiff | null>(null);
  const [loading, setLoading] = useState(true);
  const [copiedVersion, setCopiedVersion] = useState<number | null>(null);

  const loadComparison = useCallback(async () => {
    setLoading(true);
    const { submission1: sub1, submission2: sub2 } = 
      await submissionService.compareVersions(problemId, version1, version2);
    
    if (sub1 && sub2) {
      setSubmission1(sub1);
      setSubmission2(sub2);
      const diffResult = codeDiffService.generateSideBySideDiff(sub1.code, sub2.code);
      setDiff(diffResult);
    }
    setLoading(false);
  }, [problemId, version1, version2]);

  useEffect(() => {
    loadComparison();
  }, [loadComparison]);

  const handleCopy = async (code: string, version: number) => {
    await navigator.clipboard.writeText(code);
    setCopiedVersion(version);
    setTimeout(() => setCopiedVersion(null), 2000);
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center p-8">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  if (!submission1 || !submission2 || !diff) {
    return (
      <Card>
        <CardContent className="p-8 text-center">
          <p className="text-muted-foreground">Unable to load comparison</p>
          <Button onClick={onBack} className="mt-4">
            <ArrowLeft className="mr-2 h-4 w-4" />
            Back to History
          </Button>
        </CardContent>
      </Card>
    );
  }

  const similarity = codeDiffService.calculateSimilarity(submission1.code, submission2.code);
  const changeSummary = codeDiffService.getChangeSummary(submission1.code, submission2.code);
  const lineStats = codeDiffService.getLineStats(submission1.code, submission2.code);

  const performanceImproved = submission2.total_time < submission1.total_time;
  const testsImproved = submission2.passed_count > submission1.passed_count;

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <Button onClick={onBack} variant="outline">
          <ArrowLeft className="mr-2 h-4 w-4" />
          Back to History
        </Button>
        <div className="flex items-center gap-2">
          <Badge variant="outline" className="text-base px-4 py-2">
            <GitCompare className="mr-2 h-4 w-4" />
            Version {version1} → Version {version2}
          </Badge>
        </div>
      </div>

      {/* Stats Overview */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card>
          <CardHeader className="pb-3">
            <CardDescription>Code Similarity</CardDescription>
            <CardTitle className="text-3xl">{similarity.toFixed(1)}%</CardTitle>
          </CardHeader>
        </Card>
        <Card>
          <CardHeader className="pb-3">
            <CardDescription>Lines Changed</CardDescription>
            <CardTitle className="text-3xl flex items-center gap-2">
              {changeSummary.totalChanges}
              <span className="text-sm font-normal text-muted-foreground">
                (+{changeSummary.additions} -{changeSummary.deletions})
              </span>
            </CardTitle>
          </CardHeader>
        </Card>
        <Card>
          <CardHeader className="pb-3">
            <CardDescription>Tests Passed</CardDescription>
            <CardTitle className="text-3xl flex items-center gap-2">
              {submission2.passed_count}
              {testsImproved ? (
                <TrendingUp className="h-5 w-5 text-green-500" />
              ) : submission2.passed_count < submission1.passed_count ? (
                <TrendingDown className="h-5 w-5 text-red-500" />
              ) : (
                <Minus className="h-5 w-5 text-muted-foreground" />
              )}
            </CardTitle>
          </CardHeader>
        </Card>
        <Card>
          <CardHeader className="pb-3">
            <CardDescription>Execution Time</CardDescription>
            <CardTitle className="text-3xl flex items-center gap-2">
              {submission2.total_time.toFixed(0)}ms
              {performanceImproved ? (
                <TrendingUp className="h-5 w-5 text-green-500" />
              ) : submission2.total_time > submission1.total_time ? (
                <TrendingDown className="h-5 w-5 text-red-500" />
              ) : (
                <Minus className="h-5 w-5 text-muted-foreground" />
              )}
            </CardTitle>
          </CardHeader>
        </Card>
      </div>

      {/* Diff Viewer */}
      <Tabs defaultValue="sidebyside" className="w-full">
        <TabsList>
          <TabsTrigger value="sidebyside">Side by Side</TabsTrigger>
          <TabsTrigger value="unified">Unified</TabsTrigger>
          <TabsTrigger value="full">Full Code</TabsTrigger>
        </TabsList>

        <TabsContent value="sidebyside">
          <div className="grid grid-cols-2 gap-4">
            {/* Left Side - Old Version */}
            <Card>
              <CardHeader className="pb-3">
                <div className="flex items-center justify-between">
                  <div>
                    <CardTitle className="text-lg">Version {version1}</CardTitle>
                    <CardDescription>
                      {submission1.passed_count} tests passed
                    </CardDescription>
                  </div>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => onReplay(submission1.code, submission1.language)}
                  >
                    Replay
                  </Button>
                </div>
              </CardHeader>
              <CardContent className="p-0">
                <ScrollArea className="h-[600px]">
                  <div className="font-mono text-sm">
                    {diff.left.map((line, index) => (
                      <div
                        key={index}
                        className={`flex ${
                          line.type === 'delete'
                            ? 'bg-red-500/10'
                            : line.type === 'insert'
                            ? 'bg-transparent'
                            : ''
                        }`}
                      >
                        <span className="w-12 flex-shrink-0 text-right pr-4 text-muted-foreground select-none">
                          {line.lineNumber1}
                        </span>
                        <span className="flex-1 px-4 py-1 whitespace-pre-wrap break-all">
                          {line.text || '\u00A0'}
                        </span>
                      </div>
                    ))}
                  </div>
                </ScrollArea>
              </CardContent>
            </Card>

            {/* Right Side - New Version */}
            <Card>
              <CardHeader className="pb-3">
                <div className="flex items-center justify-between">
                  <div>
                    <CardTitle className="text-lg">Version {version2}</CardTitle>
                    <CardDescription>
                      {submission2.passed_count} tests passed
                    </CardDescription>
                  </div>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => onReplay(submission2.code, submission2.language)}
                  >
                    Replay
                  </Button>
                </div>
              </CardHeader>
              <CardContent className="p-0">
                <ScrollArea className="h-[600px]">
                  <div className="font-mono text-sm">
                    {diff.right.map((line, index) => (
                      <div
                        key={index}
                        className={`flex ${
                          line.type === 'insert'
                            ? 'bg-green-500/10'
                            : line.type === 'delete'
                            ? 'bg-transparent'
                            : ''
                        }`}
                      >
                        <span className="w-12 flex-shrink-0 text-right pr-4 text-muted-foreground select-none">
                          {line.lineNumber2}
                        </span>
                        <span className="flex-1 px-4 py-1 whitespace-pre-wrap break-all">
                          {line.text || '\u00A0'}
                        </span>
                      </div>
                    ))}
                  </div>
                </ScrollArea>
              </CardContent>
            </Card>
          </div>
        </TabsContent>

        <TabsContent value="unified">
          <Card>
            <CardHeader>
              <CardTitle>Unified Diff</CardTitle>
              <CardDescription>
                Lines with + are additions, lines with - are deletions
              </CardDescription>
            </CardHeader>
            <CardContent>
              <ScrollArea className="h-[600px]">
                <pre className="font-mono text-sm whitespace-pre-wrap">
                  {codeDiffService.generateUnifiedDiff(submission1.code, submission2.code)}
                </pre>
              </ScrollArea>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="full">
          <div className="grid grid-cols-2 gap-4">
            <Card>
              <CardHeader className="pb-3">
                <div className="flex items-center justify-between">
                  <CardTitle>Version {version1}</CardTitle>
                  <Button
                    size="sm"
                    variant="ghost"
                    onClick={() => handleCopy(submission1.code, version1)}
                  >
                    {copiedVersion === version1 ? (
                      <Check className="h-4 w-4" />
                    ) : (
                      <Copy className="h-4 w-4" />
                    )}
                  </Button>
                </div>
              </CardHeader>
              <CardContent className="p-0">
                <ScrollArea className="h-[600px]">
                  <SyntaxHighlighter
                    language={submission1.language}
                    style={vscDarkPlus}
                    showLineNumbers
                    customStyle={{
                      margin: 0,
                      borderRadius: 0,
                      fontSize: '0.875rem',
                    }}
                  >
                    {submission1.code}
                  </SyntaxHighlighter>
                </ScrollArea>
              </CardContent>
            </Card>

            <Card>
              <CardHeader className="pb-3">
                <div className="flex items-center justify-between">
                  <CardTitle>Version {version2}</CardTitle>
                  <Button
                    size="sm"
                    variant="ghost"
                    onClick={() => handleCopy(submission2.code, version2)}
                  >
                    {copiedVersion === version2 ? (
                      <Check className="h-4 w-4" />
                    ) : (
                      <Copy className="h-4 w-4" />
                    )}
                  </Button>
                </div>
              </CardHeader>
              <CardContent className="p-0">
                <ScrollArea className="h-[600px]">
                  <SyntaxHighlighter
                    language={submission2.language}
                    style={vscDarkPlus}
                    showLineNumbers
                    customStyle={{
                      margin: 0,
                      borderRadius: 0,
                      fontSize: '0.875rem',
                    }}
                  >
                    {submission2.code}
                  </SyntaxHighlighter>
                </ScrollArea>
              </CardContent>
            </Card>
          </div>
        </TabsContent>
      </Tabs>
    </div>
  );
}

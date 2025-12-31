import { useState, useMemo } from "react";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { AlertCircle, CheckCircle2, X } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { supabase } from "@/integrations/supabase/client";
import { dsaTopics } from "@/data/mockData";

interface CreateTournamentDialogProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: () => void;
}

export function CreateTournamentDialog({
  isOpen,
  onClose,
  onSuccess,
}: CreateTournamentDialogProps) {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  const [formData, setFormData] = useState({
    title: "",
    description: "",
    startDate: "",
    startTime: "",
    duration: "2",
    prizePool: "",
    maxParticipants: "",
    topics: [] as string[],
    rules: "",
  });

  // Get available DSA topics
  const availableTopics = useMemo(() => {
    return dsaTopics.map(topic => ({
      id: topic.id,
      title: topic.title,
      problemCount: topic.problems
    }));
  }, []);

  const handleChange = (field: string, value: any) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
    setError(null);
  };

  const validateForm = () => {
    if (!formData.title.trim()) return "Title is required";
    if (!formData.startDate) return "Start date is required";
    if (!formData.startTime) return "Start time is required";
    if (formData.topics.length === 0) return "At least one topic is required";
    return null;
  };

  const handleSelectTopic = (topicId: string) => {
    if (!formData.topics.includes(topicId)) {
      setFormData(prev => ({
        ...prev,
        topics: [...prev.topics, topicId]
      }));
    }
  };

  const handleRemoveTopic = (topicId: string) => {
    setFormData(prev => ({
      ...prev,
      topics: prev.topics.filter(t => t !== topicId)
    }));
  };

  const handleSubmit = async () => {
    const validationError = validateForm();
    if (validationError) {
      setError(validationError);
      return;
    }

    setLoading(true);
    setError(null);

    try {
      // Combine date and time
      const startDateTime = new Date(`${formData.startDate}T${formData.startTime}`);
      const endDateTime = new Date(startDateTime.getTime() + parseInt(formData.duration) * 60 * 60 * 1000);

      // Get problem IDs from selected topics
      const problemIds: string[] = [];
      formData.topics.forEach(topicId => {
        const topic = dsaTopics.find(t => t.id === topicId);
        if (topic) {
          topic.subtopics.forEach(subtopic => {
            problemIds.push(subtopic.id);
          });
        }
      });

      const { data: { user } } = await supabase.auth.getUser();

      if (!user) {
        throw new Error("You must be logged in to create a tournament");
      }

      // Try Supabase first, fall back to localStorage
      const { error: insertError } = await supabase
        .from("tournaments")
        .insert({
          name: formData.title,
          description: formData.description || null,
          start_time: startDateTime.toISOString(),
          end_time: endDateTime.toISOString(),
          problem_ids: problemIds,
          prize_pool: formData.prizePool || null,
          max_participants: formData.maxParticipants ? parseInt(formData.maxParticipants) : null,
          rules: formData.rules || null,
          status: "upcoming",
          created_by: user?.id,
        });

      // If Supabase fails, use localStorage
      if (insertError) {
        console.log("Supabase error, saving to localStorage:", insertError);
        const tournament = {
          id: crypto.randomUUID(),
          name: formData.title,
          description: formData.description || null,
          start_time: startDateTime.toISOString(),
          end_time: endDateTime.toISOString(),
          problem_ids: problemIds,
          prize_pool: formData.prizePool || null,
          max_participants: formData.maxParticipants ? parseInt(formData.maxParticipants) : null,
          rules: formData.rules || null,
          status: "upcoming" as const,
          created_by: user?.id,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
          entry_fee: 0,
          min_rank_required: null,
          banner_url: null,
          difficulty: "medium" as const,
          is_rated: true,
        };

        const existingTournaments = JSON.parse(localStorage.getItem("tournaments") || "[]");
        localStorage.setItem("tournaments", JSON.stringify([...existingTournaments, tournament]));
        console.log("Tournament saved to localStorage:", tournament);
      }

      setSuccess(true);
      setTimeout(() => {
        onSuccess();
        handleClose();
      }, 1500);
    } catch (err) {
      console.error("Failed to create tournament:", err);
      setError(err instanceof Error ? err.message : "Failed to create tournament");
    } finally {
      setLoading(false);
    }
  };

  const handleClose = () => {
    setFormData({
      title: "",
      description: "",
      startDate: "",
      startTime: "",
      duration: "2",
      prizePool: "",
      maxParticipants: "",
      topics: [],
      rules: "",
    });
    setError(null);
    setSuccess(false);
    onClose();
  };

  return (
    <Dialog open={isOpen} onOpenChange={handleClose}>
      <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto sm:max-w-[600px]">
        <DialogHeader>
          <DialogTitle className="text-2xl">Create New Tournament</DialogTitle>
          <DialogDescription>
            Fill in the details to create a competitive coding tournament
          </DialogDescription>
        </DialogHeader>

        {success ? (
          <div className="py-8">
            <Alert className="border-green-500 bg-green-500/10">
              <CheckCircle2 className="h-5 w-5 text-green-500" />
              <AlertDescription className="text-base">
                Tournament created successfully! Redirecting...
              </AlertDescription>
            </Alert>
          </div>
        ) : (
          <>
            <div className="space-y-4 py-4">
              {/* Basic Info */}
              <div className="space-y-2">
                <Label htmlFor="title">Tournament Title *</Label>
                <Input
                  id="title"
                  placeholder="e.g., New Year Coding Challenge 2025"
                  value={formData.title}
                  onChange={(e) => handleChange("title", e.target.value)}
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="description">Description</Label>
                <Textarea
                  id="description"
                  placeholder="Describe what makes this tournament special..."
                  rows={3}
                  value={formData.description}
                  onChange={(e) => handleChange("description", e.target.value)}
                />
              </div>

              {/* Schedule */}
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="startDate">Start Date *</Label>
                  <Input
                    id="startDate"
                    type="date"
                    value={formData.startDate}
                    onChange={(e) => handleChange("startDate", e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="startTime">Start Time *</Label>
                  <Input
                    id="startTime"
                    type="time"
                    value={formData.startTime}
                    onChange={(e) => handleChange("startTime", e.target.value)}
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="duration">Duration (hours)</Label>
                  <Select
                    value={formData.duration}
                    onValueChange={(value) => handleChange("duration", value)}
                  >
                    <SelectTrigger id="duration">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="1">1 hour</SelectItem>
                      <SelectItem value="2">2 hours</SelectItem>
                      <SelectItem value="3">3 hours</SelectItem>
                      <SelectItem value="4">4 hours</SelectItem>
                      <SelectItem value="6">6 hours</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              {/* Settings */}
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="prizePool">Prize Pool (₹)</Label>
                  <Input
                    id="prizePool"
                    type="number"
                    placeholder="e.g., 25000"
                    value={formData.prizePool}
                    onChange={(e) => handleChange("prizePool", e.target.value)}
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="maxParticipants">Max Participants</Label>
                  <Input
                    id="maxParticipants"
                    type="number"
                    placeholder="Leave empty for unlimited"
                    value={formData.maxParticipants}
                    onChange={(e) => handleChange("maxParticipants", e.target.value)}
                  />
                </div>
              </div>

              {/* Topics Selection */}
              <div className="space-y-2">
                <Label htmlFor="topics">Select DSA Topics *</Label>
                <div className="max-h-48 overflow-y-auto border border-border rounded-md p-3 bg-secondary/20">
                  <div className="space-y-1">
                    {availableTopics.map((topic) => {
                      const isSelected = formData.topics.includes(topic.id);
                      return (
                        <button
                          key={topic.id}
                          type="button"
                          onClick={() => handleSelectTopic(topic.id)}
                          disabled={loading || isSelected}
                          className={`w-full text-xs px-3 py-2 rounded text-left transition-colors flex items-center justify-between ${
                            isSelected
                              ? 'bg-primary text-primary-foreground cursor-not-allowed'
                              : 'bg-background hover:bg-primary/10 border border-border'
                          }`}
                        >
                          <span className="font-medium">{topic.title}</span>
                          <span className={`text-xs ${isSelected ? 'opacity-80' : 'text-muted-foreground'}`}>
                            {topic.problemCount} problems
                          </span>
                        </button>
                      );
                    })}
                  </div>
                </div>
                {formData.topics.length > 0 && (
                  <div className="flex flex-wrap gap-2 mt-3">
                    {formData.topics.map((topicId) => {
                      const topic = availableTopics.find(t => t.id === topicId);
                      return (
                        <Badge key={topicId} variant="secondary" className="gap-1">
                          {topic?.title}
                          <button
                            type="button"
                            onClick={() => handleRemoveTopic(topicId)}
                            className="ml-1 hover:text-destructive"
                            disabled={loading}
                            aria-label={`Remove ${topic?.title}`}
                          >
                            <X className="w-3 h-3" />
                          </button>
                        </Badge>
                      );
                    })}
                  </div>
                )}
                <p className="text-xs text-muted-foreground">
                  Problems from selected topics will be included in the tournament
                </p>
              </div>

              {/* Rules */}
              <div className="space-y-2">
                <Label htmlFor="rules">Rules & Guidelines</Label>
                <Textarea
                  id="rules"
                  placeholder="Any special rules or guidelines for participants..."
                  rows={3}
                  value={formData.rules}
                  onChange={(e) => handleChange("rules", e.target.value)}
                />
              </div>

              {error && (
                <Alert variant="destructive">
                  <AlertCircle className="h-4 w-4" />
                  <AlertDescription>{error}</AlertDescription>
                </Alert>
              )}
            </div>

            <DialogFooter>
              <Button variant="outline" onClick={handleClose} disabled={loading}>
                Cancel
              </Button>
              <Button onClick={handleSubmit} disabled={loading}>
                {loading ? "Creating..." : "Create Tournament"}
              </Button>
            </DialogFooter>
          </>
        )}
      </DialogContent>
    </Dialog>
  );
}

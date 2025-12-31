import { useState, useEffect } from "react";
import { Button } from "./button";
import { Input } from "./input";
import { X, Plus, Trash2, Calendar } from "lucide-react";
import { useAuth } from "@/contexts/AuthContext";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";

interface Task {
  id: string;
  user_id: string;
  title: string;
  date: string;
  status: 'ongoing' | 'completed' | 'missed';
  created_at: string;
}

export function DailyPlanner() {
  const { user } = useAuth();
  const { toast } = useToast();
  const [isOpen, setIsOpen] = useState(false);
  const [tasks, setTasks] = useState<Task[]>([]);
  const [newTaskTitle, setNewTaskTitle] = useState("");
  const [selectedDate, setSelectedDate] = useState(new Date().toISOString().split('T')[0]);
  const [activeTab, setActiveTab] = useState<'ongoing' | 'completed' | 'missed'>('ongoing');
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (user) {
      loadTasks();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user, selectedDate]);

  const loadTasks = async () => {
    if (!user) return;

    try {
      // @ts-ignore - daily_tasks table not in generated types yet
      const { data, error } = await supabase
        .from('daily_tasks')
        .select('*')
        .eq('user_id', user.id)
        .eq('date', selectedDate)
        .order('created_at', { ascending: false });

      if (error) throw error;
      setTasks(data || []);
    } catch (error) {
      console.error('Error loading tasks:', error);
    }
  };

  const addTask = async () => {
    if (!user || !newTaskTitle.trim()) return;

    setLoading(true);
    try {
      // @ts-ignore - daily_tasks table not in generated types yet
      const { data, error } = await supabase
        .from('daily_tasks')
        .insert({
          user_id: user.id,
          title: newTaskTitle,
          date: selectedDate,
          status: 'ongoing'
        })
        .select()
        .single();

      if (error) throw error;

      setTasks([data, ...tasks]);
      setNewTaskTitle("");
      toast({
        title: "Task added!",
        description: "Your task has been added to the planner.",
      });
    } catch (error) {
      console.error('Error adding task:', error);
      toast({
        title: "Error",
        description: "Failed to add task. Please try again.",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };
  const updateTaskStatus = async (taskId: string, status: 'ongoing' | 'completed' | 'missed') => {
    if (!user) return;

    try {
      // @ts-ignore - daily_tasks table not in generated types yet
      const { error } = await supabase
        .from('daily_tasks')
        .update({ status })
        .eq('id', taskId);

      if (error) throw error;

      setTasks(tasks.map(t => t.id === taskId ? { ...t, status } : t));
      toast({
        title: "Task updated!",
        description: `Task marked as ${status}.`,
      });
    } catch (error) {
      console.error('Error updating task:', error);
    }
  };

  const deleteTask = async (taskId: string) => {
    if (!user) return;

    try {
      // @ts-ignore - daily_tasks table not in generated types yet
      const { error } = await supabase
        .from('daily_tasks')
        .delete()
        .eq('id', taskId);

      if (error) throw error;

      setTasks(tasks.filter(t => t.id !== taskId));
      toast({
        title: "Task deleted",
        description: "Task has been removed from your planner.",
      });
    } catch (error) {
      console.error('Error deleting task:', error);
    }
  };

  const filteredTasks = tasks.filter(t => t.status === activeTab);
  const ongoingCount = tasks.filter(t => t.status === 'ongoing').length;
  const completedCount = tasks.filter(t => t.status === 'completed').length;
  const missedCount = tasks.filter(t => t.status === 'missed').length;

  if (!isOpen) {
    return (
      <Button
        onClick={() => setIsOpen(true)}
        variant="outline"
        className="fixed bottom-6 right-6 h-14 px-6 font-mono shadow-lg z-[60]"
      >
        <Calendar className="mr-2 h-5 w-5" />
        Daily Planner
      </Button>
    );
  }

  return (
    <div className="fixed inset-y-0 right-0 w-full sm:w-[400px] bg-background border-l border-border shadow-2xl z-[60] flex flex-col">
      {/* Header */}
      <div className="flex items-center justify-between p-4 border-b border-border">
        <h2 className="text-lg font-bold font-mono">Daily Planner</h2>
        <div className="flex items-center gap-2">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => setIsOpen(false)}
          >
            <X className="h-5 w-5" />
          </Button>
        </div>
      </div>

      {/* Add Task Section */}
      <div className="p-4 border-b border-border space-y-3">
        <Input
          placeholder="Title"
          value={newTaskTitle}
          onChange={(e) => setNewTaskTitle(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && addTask()}
          className="font-mono"
        />
        <div className="flex items-center gap-2">
          <div className="flex items-center gap-2 flex-1 px-3 py-2 rounded-md bg-secondary/50 border border-border">
            <Calendar className="h-4 w-4 text-muted-foreground" />
            <input
              type="date"
              value={selectedDate}
              onChange={(e) => setSelectedDate(e.target.value)}
              className="bg-transparent border-none outline-none text-sm font-mono flex-1"
              aria-label="Select date"
            />
          </div>
          <Button
            onClick={addTask}
            disabled={loading || !newTaskTitle.trim()}
            className="font-mono"
          >
            Add
          </Button>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex items-center gap-2 p-4 border-b border-border">
        <button
          onClick={() => setActiveTab('ongoing')}
          className={`px-4 py-2 rounded-md text-sm font-mono transition-colors ${
            activeTab === 'ongoing'
              ? 'bg-primary text-primary-foreground'
              : 'text-muted-foreground hover:text-foreground'
          }`}
        >
          Ongoing ({ongoingCount})
        </button>
        <button
          onClick={() => setActiveTab('completed')}
          className={`px-4 py-2 rounded-md text-sm font-mono transition-colors ${
            activeTab === 'completed'
              ? 'bg-primary text-primary-foreground'
              : 'text-muted-foreground hover:text-foreground'
          }`}
        >
          Completed ({completedCount})
        </button>
        <button
          onClick={() => setActiveTab('missed')}
          className={`px-4 py-2 rounded-md text-sm font-mono transition-colors ${
            activeTab === 'missed'
              ? 'bg-primary text-primary-foreground'
              : 'text-muted-foreground hover:text-foreground'
          }`}
        >
          Missed ({missedCount})
        </button>
      </div>

      {/* Tasks List */}
      <div className="flex-1 overflow-y-auto p-4">
        {filteredTasks.length === 0 ? (
          <div className="text-center py-12">
            <div className="w-16 h-16 mx-auto mb-4 rounded-2xl bg-primary/10 flex items-center justify-center">
              <Calendar className="h-8 w-8 text-primary" />
            </div>
            <h3 className="font-mono font-semibold mb-2">Plan your daily tasks here</h3>
            <p className="text-sm text-muted-foreground">
              Track, manage, and complete accordingly
            </p>
          </div>
        ) : (
          <div className="space-y-3">
            {filteredTasks.map((task) => (
              <div
                key={task.id}
                className="p-4 rounded-lg bg-secondary/50 border border-border hover:border-primary/50 transition-colors"
              >
                <div className="flex items-start justify-between gap-2 mb-2">
                  <h4 className="font-medium flex-1">{task.title}</h4>
                  <Button
                    variant="ghost"
                    size="icon"
                    className="h-6 w-6 text-destructive hover:text-destructive"
                    onClick={() => deleteTask(task.id)}
                  >
                    <Trash2 className="h-4 w-4" />
                  </Button>
                </div>
                <div className="flex items-center gap-2 text-xs text-muted-foreground mb-3">
                  <Calendar className="h-3 w-3" />
                  {new Date(task.date).toLocaleDateString('en-US', {
                    month: 'short',
                    day: 'numeric',
                    year: 'numeric'
                  })}
                </div>
                {task.status === 'ongoing' && (
                  <div className="flex gap-2">
                    <Button
                      size="sm"
                      variant="outline"
                      className="flex-1 text-xs"
                      onClick={() => updateTaskStatus(task.id, 'completed')}
                    >
                      Completed
                    </Button>
                    <Button
                      size="sm"
                      variant="outline"
                      className="flex-1 text-xs"
                      onClick={() => updateTaskStatus(task.id, 'missed')}
                    >
                      Missed
                    </Button>
                  </div>
                )}
                {task.status === 'completed' && (
                  <div className="px-3 py-1 rounded bg-green-500/20 border border-green-500/30 text-green-400 text-xs font-mono text-center">
                    Completed
                  </div>
                )}
                {task.status === 'missed' && (
                  <div className="px-3 py-1 rounded bg-red-500/20 border border-red-500/30 text-red-400 text-xs font-mono text-center">
                    Missed
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

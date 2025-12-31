import { useState, useEffect } from "react";
import { Layout } from "@/components/layout/Layout";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Textarea } from "@/components/ui/textarea";
import { Input } from "@/components/ui/input";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/hooks/use-toast";
import { Users, Trophy, MessageSquare, Flame, ArrowRight, Plus, Loader2, Trash2 } from "lucide-react";
import {
  getPosts,
  createPost,
  likePost,
  unlikePost,
  getAccountabilityRooms,
  createAccountabilityRoom,
  joinAccountabilityRoom,
  getWeeklyLeaderboard,
  deletePost,
  deleteAccountabilityRoom,
  type CommunityPost,
  type AccountabilityRoom,
  type LeaderboardEntry
} from "@/lib/communityService";
import { supabase } from "@/integrations/supabase/client";

export default function Community() {
  const { user } = useAuth();
  const { toast } = useToast();
  
  const [posts, setPosts] = useState<CommunityPost[]>([]);
  const [rooms, setRooms] = useState<AccountabilityRoom[]>([]);
  const [leaderboard, setLeaderboard] = useState<LeaderboardEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [postContent, setPostContent] = useState("");
  const [roomName, setRoomName] = useState("");
  const [roomDescription, setRoomDescription] = useState("");
  const [isPostDialogOpen, setIsPostDialogOpen] = useState(false);
  const [isRoomDialogOpen, setIsRoomDialogOpen] = useState(false);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    loadData();
    
    // Subscribe to realtime updates
    const postsChannel = supabase
      .channel('community-posts')
      .on('postgres_changes', {
        event: '*',
        schema: 'public',
        table: 'community_posts'
      }, () => {
        loadPosts();
      })
      .subscribe();
      
    return () => {
      postsChannel.unsubscribe();
    };
  }, []);

  const loadData = async () => {
    setLoading(true);
    try {
      await Promise.all([
        loadPosts(),
        loadRooms(),
        loadLeaderboard()
      ]);
    } catch (error) {
      console.error('Failed to load community data:', error);
    } finally {
      setLoading(false);
    }
  };

  const loadPosts = async () => {
    try {
      const data = await getPosts(20);
      setPosts(data);
    } catch (error) {
      console.error('Failed to load posts:', error);
    }
  };

  const loadRooms = async () => {
    try {
      const data = await getAccountabilityRooms();
      setRooms(data);
    } catch (error) {
      console.error('Failed to load rooms:', error);
    }
  };

  const loadLeaderboard = async () => {
    try {
      const data = await getWeeklyLeaderboard(5);
      setLeaderboard(data);
    } catch (error) {
      console.error('Failed to load leaderboard:', error);
    }
  };

  const handleCreatePost = async () => {
    if (!postContent.trim()) return;
    
    setSubmitting(true);
    try {
      await createPost(postContent);
      setPostContent("");
      setIsPostDialogOpen(false);
      toast({ title: "Post created!" });
      loadPosts();
    } catch (error: any) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } finally {
      setSubmitting(false);
    }
  };

  const handleLikePost = async (postId: string, isLiked: boolean) => {
    try {
      if (isLiked) {
        await unlikePost(postId);
      } else {
        await likePost(postId);
      }
      loadPosts();
    } catch (error: any) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    }
  };

  const handleCreateRoom = async () => {
    if (!roomName.trim()) return;
    
    setSubmitting(true);
    try {
      await createAccountabilityRoom(roomName, roomDescription);
      setRoomName("");
      setRoomDescription("");
      setIsRoomDialogOpen(false);
      toast({ title: "Room created!" });
      loadRooms();
    } catch (error: any) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } finally {
      setSubmitting(false);
    }
  };

  const handleJoinRoom = async (roomId: string) => {
    try {
      await joinAccountabilityRoom(roomId);
      toast({ title: "Joined room!" });
      loadRooms();
    } catch (error: any) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    }
  };

  const handleDeletePost = async (postId: string) => {
    if (!confirm('Are you sure you want to delete this post?')) return;
    
    try {
      await deletePost(postId);
      toast({ title: "Post deleted" });
      loadPosts();
    } catch (error: any) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    }
  };

  const handleDeleteRoom = async (roomId: string) => {
    if (!confirm('Are you sure you want to delete this room?')) return;
    
    try {
      await deleteAccountabilityRoom(roomId);
      toast({ title: "Room deleted" });
      loadRooms();
    } catch (error: any) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    }
  };

  const formatTimeAgo = (dateString: string) => {
    const date = new Date(dateString);
    const now = new Date();
    const seconds = Math.floor((now.getTime() - date.getTime()) / 1000);
    
    if (seconds < 60) return 'just now';
    if (seconds < 3600) return `${Math.floor(seconds / 60)}m ago`;
    if (seconds < 86400) return `${Math.floor(seconds / 3600)}h ago`;
    return `${Math.floor(seconds / 86400)}d ago`;
  };

  if (loading) {
    return (
      <Layout>
        <div className="flex items-center justify-center h-screen">
          <Loader2 className="h-8 w-8 animate-spin" />
        </div>
      </Layout>
    );
  }

  return (
    <Layout>
      <div className="py-12">
        <div className="container mx-auto px-4">
          {/* Header */}
          <div className="max-w-3xl mb-12">
            <div className="flex items-center gap-3 mb-4">
              <Users className="h-8 w-8 text-primary" />
              <h1 className="text-3xl md:text-4xl font-bold">Community</h1>
            </div>
            <p className="text-lg text-muted-foreground">
              Grind together. Compete together. No one succeeds alone.
            </p>
          </div>

          <div className="grid lg:grid-cols-3 gap-8">
            {/* Main Content - Daily Grind Board */}
            <div className="lg:col-span-2 space-y-6">
              <div className="flex items-center justify-between">
                <h2 className="font-mono text-xl font-semibold flex items-center gap-2">
                  <Flame className="h-5 w-5 text-primary" />
                  Daily Grind Board
                </h2>
                <Dialog open={isPostDialogOpen} onOpenChange={setIsPostDialogOpen}>
                  <DialogTrigger asChild>
                    <Button variant="outline" size="sm" className="font-mono">
                      <MessageSquare className="h-4 w-4 mr-2" />
                      Post Update
                    </Button>
                  </DialogTrigger>
                  <DialogContent>
                    <DialogHeader>
                      <DialogTitle>Share Your Progress</DialogTitle>
                    </DialogHeader>
                    <div className="space-y-4">
                      <Textarea
                        placeholder="What did you accomplish today?"
                        value={postContent}
                        onChange={(e) => setPostContent(e.target.value)}
                        rows={4}
                      />
                      <Button 
                        onClick={handleCreatePost} 
                        disabled={!postContent.trim() || submitting}
                        className="w-full"
                      >
                        {submitting ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : null}
                        Post
                      </Button>
                    </div>
                  </DialogContent>
                </Dialog>
              </div>

              <div className="space-y-4">
                {posts.length === 0 ? (
                  <div className="surface-card p-8 text-center text-muted-foreground">
                    No posts yet. Be the first to share your progress!
                  </div>
                ) : (
                  posts.map((post) => (
                    <div key={post.id} className="surface-card p-4">
                      <div className="flex items-start justify-between mb-2">
                        <div className="flex items-center gap-2">
                          <div className="w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center">
                            <span className="text-xs font-mono text-primary">
                              {post.username.slice(0, 2).toUpperCase()}
                            </span>
                          </div>
                          <span className="font-mono text-sm">{post.username}</span>
                        </div>
                        <div className="flex items-center gap-2">
                          <span className="text-xs text-muted-foreground">
                            {formatTimeAgo(post.created_at)}
                          </span>
                          {user?.id === post.user_id && (
                            <button
                              onClick={() => handleDeletePost(post.id)}
                              className="text-muted-foreground hover:text-destructive transition-colors"
                              title="Delete post"
                            >
                              <Trash2 className="h-4 w-4" />
                            </button>
                          )}
                        </div>
                      </div>
                      <p className="text-foreground mb-3 whitespace-pre-wrap">{post.content}</p>
                      <div className="flex items-center gap-4 text-sm text-muted-foreground">
                        <button
                          onClick={() => handleLikePost(post.id, post.is_liked || false)}
                          className={`flex items-center gap-1 transition-colors ${
                            post.is_liked ? 'text-primary' : 'hover:text-primary'
                          }`}
                        >
                          <Flame className="h-4 w-4" />
                          <span className="font-mono">{post.likes_count}</span>
                        </button>
                        <button className="hover:text-foreground transition-colors">
                          Reply
                        </button>
                      </div>
                    </div>
                  ))
                )}
              </div>

              <Button variant="ghost" className="w-full font-mono">
                Load More Posts
                <ArrowRight className="ml-2 h-4 w-4" />
              </Button>
            </div>

            {/* Sidebar */}
            <div className="space-y-6">
              {/* Leaderboard */}
              <div className="surface-card p-4">
                <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4 flex items-center gap-2">
                  <Trophy className="h-4 w-4 text-primary" />
                  WEEKLY LEADERBOARD
                </h3>
                <div className="space-y-3">
                  {leaderboard.length === 0 ? (
                    <div className="text-center text-muted-foreground text-sm py-4">
                      No data yet
                    </div>
                  ) : (
                    leaderboard.map((entry, index) => (
                      <div
                        key={entry.user_id}
                        className="flex items-center justify-between p-2 rounded bg-secondary/50"
                      >
                        <div className="flex items-center gap-3">
                          <span
                            className={`font-mono text-sm w-6 ${
                              index === 0
                                ? "text-amber-400"
                                : index === 1
                                ? "text-zinc-400"
                                : index === 2
                                ? "text-amber-600"
                                : "text-muted-foreground"
                            }`}
                          >
                            #{index + 1}
                          </span>
                          <span className="font-mono text-sm">{entry.username}</span>
                        </div>
                        <div className="text-right">
                          <div className="font-mono text-sm text-primary">{entry.problems_solved}</div>
                          <div className="text-xs text-muted-foreground">solved</div>
                        </div>
                      </div>
                    ))
                  )}
                </div>
              </div>

              {/* Accountability Rooms */}
              <div className="surface-card p-4">
                <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4">
                  ACCOUNTABILITY ROOMS
                </h3>
                <div className="space-y-3">
                  {rooms.length === 0 ? (
                    <div className="text-center text-muted-foreground text-sm py-4">
                      No rooms available
                    </div>
                  ) : (
                    rooms.map((room) => (
                      <div
                        key={room.id}
                        className="flex items-center justify-between p-3 rounded bg-secondary/50"
                      >
                        <div className="flex-1">
                          <div className="font-medium text-sm flex items-center gap-2">
                            {room.name}
                            {room.is_active && (
                              <span className="w-2 h-2 rounded-full bg-primary animate-pulse" />
                            )}
                          </div>
                          <div className="text-xs text-muted-foreground font-mono">
                            {room.current_members}/{room.max_members} members
                            {room.room_streak > 0 && ` • ${room.room_streak} day streak`}
                          </div>
                        </div>
                        <div className="flex items-center gap-2">
                          {user?.id === room.created_by ? (
                            <Button
                              variant="outline"
                              size="sm"
                              onClick={() => handleDeleteRoom(room.id)}
                              className="text-destructive hover:text-destructive"
                            >
                              <Trash2 className="h-4 w-4" />
                            </Button>
                          ) : (
                            <Button
                              variant={room.current_members >= room.max_members ? "ghost" : "outline"}
                              size="sm"
                              className="font-mono text-xs"
                              disabled={room.current_members >= room.max_members}
                              onClick={() => handleJoinRoom(room.id)}
                            >
                              {room.current_members >= room.max_members ? "Full" : "Join"}
                            </Button>
                          )}
                        </div>
                      </div>
                    ))
                  )}
                </div>
                <Dialog open={isRoomDialogOpen} onOpenChange={setIsRoomDialogOpen}>
                  <DialogTrigger asChild>
                    <Button variant="outline" className="w-full mt-4 font-mono text-sm">
                      <Plus className="h-4 w-4 mr-2" />
                      Create Room
                    </Button>
                  </DialogTrigger>
                  <DialogContent>
                    <DialogHeader>
                      <DialogTitle>Create Accountability Room</DialogTitle>
                    </DialogHeader>
                    <div className="space-y-4">
                      <div>
                        <label className="text-sm font-medium mb-2 block">Room Name</label>
                        <Input
                          placeholder="e.g., DSA Daily Grind"
                          value={roomName}
                          onChange={(e) => setRoomName(e.target.value)}
                        />
                      </div>
                      <div>
                        <label className="text-sm font-medium mb-2 block">Description (Optional)</label>
                        <Textarea
                          placeholder="What's this room about?"
                          value={roomDescription}
                          onChange={(e) => setRoomDescription(e.target.value)}
                          rows={3}
                        />
                      </div>
                      <Button 
                        onClick={handleCreateRoom} 
                        disabled={!roomName.trim() || submitting}
                        className="w-full"
                      >
                        {submitting ? <Loader2 className="h-4 w-4 animate-spin mr-2" /> : null}
                        Create Room
                      </Button>
                    </div>
                  </DialogContent>
                </Dialog>
              </div>

              {/* Community Stats */}
              <div className="surface-card p-4">
                <h3 className="font-mono text-sm font-semibold text-muted-foreground mb-4">
                  COMMUNITY STATS
                </h3>
                <div className="grid grid-cols-2 gap-4">
                  <div className="text-center p-3 rounded bg-secondary/50">
                    <div className="text-xl font-mono font-bold text-primary">
                      {posts.length}
                    </div>
                    <div className="text-xs text-muted-foreground">Total Posts</div>
                  </div>
                  <div className="text-center p-3 rounded bg-secondary/50">
                    <div className="text-xl font-mono font-bold text-primary">
                      {rooms.length}
                    </div>
                    <div className="text-xs text-muted-foreground">Active Rooms</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  );
}

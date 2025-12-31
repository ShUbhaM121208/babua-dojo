import { supabase } from '@/integrations/supabase/client';

// ============================================
// TYPES
// ============================================

export interface ForumCategory {
  id: string;
  name: string;
  slug: string;
  description: string;
  icon: string;
  color: string;
  display_order: number;
}

export interface DiscussionThread {
  id: string;
  author_id: string;
  author_username?: string;
  author_avatar?: string;
  category_id: string;
  category_name?: string;
  category_slug?: string;
  category_color?: string;
  title: string;
  content: string;
  tags: string[];
  view_count: number;
  reply_count: number;
  upvote_count: number;
  downvote_count: number;
  is_pinned: boolean;
  is_locked: boolean;
  is_solved: boolean;
  created_at: string;
  last_activity_at: string;
  user_vote?: 'upvote' | 'downvote' | null;
  is_bookmarked?: boolean;
  is_following?: boolean;
}

export interface DiscussionReply {
  id: string;
  thread_id: string;
  author_id: string;
  author_username?: string;
  author_avatar?: string;
  parent_reply_id: string | null;
  content: string;
  upvote_count: number;
  downvote_count: number;
  is_accepted_answer: boolean;
  is_edited: boolean;
  created_at: string;
  updated_at: string;
  edited_at: string | null;
  user_vote?: 'upvote' | 'downvote' | null;
}

// ============================================
// FORUM CATEGORIES
// ============================================

export async function getForumCategories(): Promise<ForumCategory[]> {
  try {
    const { data, error } = await supabase
      .from('forum_categories')
      .select('*')
      .eq('is_active', true)
      .order('display_order');

    if (error) throw error;
    return data as ForumCategory[];
  } catch (error) {
    console.error('Error fetching forum categories:', error);
    return [];
  }
}

// ============================================
// DISCUSSION THREADS
// ============================================

export async function getThreads(
  categorySlug?: string,
  userId?: string,
  limit: number = 20,
  offset: number = 0
): Promise<DiscussionThread[]> {
  try {
    let query = supabase
      .from('thread_list_view')
      .select('*')
      .range(offset, offset + limit - 1);

    if (categorySlug) {
      query = query.eq('category_slug', categorySlug);
    }

    const { data, error } = await query;
    if (error) throw error;

    // Fetch user's votes and bookmarks if logged in
    if (userId && data) {
      const threadIds = data.map(t => t.id);
      
      const [votesData, bookmarksData, followsData] = await Promise.all([
        supabase.from('thread_votes').select('thread_id, vote_type').eq('user_id', userId).in('thread_id', threadIds),
        supabase.from('thread_bookmarks').select('thread_id').eq('user_id', userId).in('thread_id', threadIds),
        supabase.from('thread_followers').select('thread_id').eq('user_id', userId).in('thread_id', threadIds),
      ]);

      const votes = new Map(votesData.data?.map(v => [v.thread_id, v.vote_type]));
      const bookmarks = new Set(bookmarksData.data?.map(b => b.thread_id));
      const follows = new Set(followsData.data?.map(f => f.thread_id));

      return data.map(thread => ({
        ...thread,
        user_vote: votes.get(thread.id) || null,
        is_bookmarked: bookmarks.has(thread.id),
        is_following: follows.has(thread.id),
      }));
    }

    return data as DiscussionThread[];
  } catch (error) {
    console.error('Error fetching threads:', error);
    return [];
  }
}

export async function getThread(threadId: string, userId?: string): Promise<DiscussionThread | null> {
  try {
    const { data, error } = await supabase
      .from('thread_list_view')
      .select('*')
      .eq('id', threadId)
      .single();

    if (error) throw error;

    // Increment view count
    await supabase.rpc('increment_thread_views', { thread_id: threadId });

    // Fetch user-specific data
    if (userId) {
      const [voteData, bookmarkData, followData] = await Promise.all([
        supabase.from('thread_votes').select('vote_type').eq('thread_id', threadId).eq('user_id', userId).single(),
        supabase.from('thread_bookmarks').select('id').eq('thread_id', threadId).eq('user_id', userId).single(),
        supabase.from('thread_followers').select('id').eq('thread_id', threadId).eq('user_id', userId).single(),
      ]);

      return {
        ...data,
        user_vote: voteData.data?.vote_type || null,
        is_bookmarked: !!bookmarkData.data,
        is_following: !!followData.data,
      };
    }

    return data as DiscussionThread;
  } catch (error) {
    console.error('Error fetching thread:', error);
    return null;
  }
}

export async function createThread(
  authorId: string,
  title: string,
  content: string,
  categoryId: string,
  tags: string[]
): Promise<{ id: string | null; error: string | null }> {
  try {
    const { data, error } = await supabase
      .from('discussion_threads')
      .insert({
        author_id: authorId,
        title,
        content,
        category_id: categoryId,
        tags,
      })
      .select('id')
      .single();

    if (error) throw error;

    // Auto-follow the thread
    await supabase.from('thread_followers').insert({
      thread_id: data.id,
      user_id: authorId,
    });

    return { id: data.id, error: null };
  } catch (error: any) {
    console.error('Error creating thread:', error);
    return { id: null, error: error.message };
  }
}

export async function updateThread(
  threadId: string,
  updates: { title?: string; content?: string; tags?: string[] }
): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('discussion_threads')
      .update({ ...updates, updated_at: new Date().toISOString() })
      .eq('id', threadId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error updating thread:', error);
    return false;
  }
}

export async function deleteThread(threadId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('discussion_threads')
      .update({ is_deleted: true })
      .eq('id', threadId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error deleting thread:', error);
    return false;
  }
}

export async function searchThreads(
  query: string,
  limit: number = 20
): Promise<DiscussionThread[]> {
  try {
    const { data, error } = await supabase
      .from('thread_list_view')
      .select('*')
      .textSearch('search_vector', query)
      .limit(limit);

    if (error) throw error;
    return data as DiscussionThread[];
  } catch (error) {
    console.error('Error searching threads:', error);
    return [];
  }
}

// ============================================
// DISCUSSION REPLIES
// ============================================

export async function getReplies(threadId: string, userId?: string): Promise<DiscussionReply[]> {
  try {
    const { data, error } = await supabase
      .from('discussion_replies')
      .select(`
        *,
        author:user_profiles!discussion_replies_author_id_fkey(username, avatar_url)
      `)
      .eq('thread_id', threadId)
      .eq('is_deleted', false)
      .order('created_at', { ascending: true });

    if (error) throw error;

    const replies = data.map((reply: any) => ({
      ...reply,
      author_username: reply.author?.username,
      author_avatar: reply.author?.avatar_url,
    }));

    // Fetch user votes if logged in
    if (userId) {
      const replyIds = replies.map(r => r.id);
      const { data: votesData } = await supabase
        .from('reply_votes')
        .select('reply_id, vote_type')
        .eq('user_id', userId)
        .in('reply_id', replyIds);

      const votes = new Map(votesData?.map(v => [v.reply_id, v.vote_type]));
      return replies.map(reply => ({
        ...reply,
        user_vote: votes.get(reply.id) || null,
      }));
    }

    return replies;
  } catch (error) {
    console.error('Error fetching replies:', error);
    return [];
  }
}

export async function createReply(
  threadId: string,
  authorId: string,
  content: string,
  parentReplyId?: string
): Promise<{ id: string | null; error: string | null }> {
  try {
    const { data, error } = await supabase
      .from('discussion_replies')
      .insert({
        thread_id: threadId,
        author_id: authorId,
        content,
        parent_reply_id: parentReplyId || null,
      })
      .select('id')
      .single();

    if (error) throw error;
    return { id: data.id, error: null };
  } catch (error: any) {
    console.error('Error creating reply:', error);
    return { id: null, error: error.message };
  }
}

export async function updateReply(replyId: string, content: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('discussion_replies')
      .update({
        content,
        is_edited: true,
        edited_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      })
      .eq('id', replyId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error updating reply:', error);
    return false;
  }
}

export async function deleteReply(replyId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('discussion_replies')
      .update({ is_deleted: true })
      .eq('id', replyId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error deleting reply:', error);
    return false;
  }
}

export async function markAsAcceptedAnswer(replyId: string, threadId: string): Promise<boolean> {
  try {
    // Unmark all other answers first
    await supabase
      .from('discussion_replies')
      .update({ is_accepted_answer: false })
      .eq('thread_id', threadId);

    // Mark this reply as accepted
    const { error } = await supabase
      .from('discussion_replies')
      .update({ is_accepted_answer: true })
      .eq('id', replyId);

    if (error) throw error;

    // Mark thread as solved
    await supabase
      .from('discussion_threads')
      .update({ is_solved: true })
      .eq('id', threadId);

    return true;
  } catch (error) {
    console.error('Error marking as accepted answer:', error);
    return false;
  }
}

// ============================================
// VOTING
// ============================================

export async function voteThread(
  threadId: string,
  userId: string,
  voteType: 'upvote' | 'downvote'
): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('thread_votes')
      .upsert({
        thread_id: threadId,
        user_id: userId,
        vote_type: voteType,
      });

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error voting on thread:', error);
    return false;
  }
}

export async function removeThreadVote(threadId: string, userId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('thread_votes')
      .delete()
      .eq('thread_id', threadId)
      .eq('user_id', userId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error removing thread vote:', error);
    return false;
  }
}

export async function voteReply(
  replyId: string,
  userId: string,
  voteType: 'upvote' | 'downvote'
): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('reply_votes')
      .upsert({
        reply_id: replyId,
        user_id: userId,
        vote_type: voteType,
      });

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error voting on reply:', error);
    return false;
  }
}

export async function removeReplyVote(replyId: string, userId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('reply_votes')
      .delete()
      .eq('reply_id', replyId)
      .eq('user_id', userId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error removing reply vote:', error);
    return false;
  }
}

// ============================================
// BOOKMARKS & FOLLOWS
// ============================================

export async function bookmarkThread(threadId: string, userId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('thread_bookmarks')
      .insert({ thread_id: threadId, user_id: userId });

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error bookmarking thread:', error);
    return false;
  }
}

export async function unbookmarkThread(threadId: string, userId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('thread_bookmarks')
      .delete()
      .eq('thread_id', threadId)
      .eq('user_id', userId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error unbookmarking thread:', error);
    return false;
  }
}

export async function followThread(threadId: string, userId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('thread_followers')
      .insert({ thread_id: threadId, user_id: userId });

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error following thread:', error);
    return false;
  }
}

export async function unfollowThread(threadId: string, userId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('thread_followers')
      .delete()
      .eq('thread_id', threadId)
      .eq('user_id', userId);

    if (error) throw error;
    return true;
  } catch (error) {
    console.error('Error unfollowing thread:', error);
    return false;
  }
}

// Add helper function for view increment (needs to be created as RPC)
export async function incrementThreadViews(threadId: string): Promise<void> {
  try {
    await supabase
      .from('discussion_threads')
      .update({ view_count: supabase.raw('view_count + 1') } as any)
      .eq('id', threadId);
  } catch (error) {
    console.error('Error incrementing thread views:', error);
  }
}

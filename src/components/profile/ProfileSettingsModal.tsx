import { useState, useEffect } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { useToast } from '@/hooks/use-toast';
import { Loader2, User, Palette, Shield, Bell } from 'lucide-react';
import { getUserPreferences, updateUserPreferences, type UserPreferences, applyTheme, applyColorScheme, applyFontSize } from '@/lib/profileCustomizationService';
import { AvatarUpload } from './AvatarUpload';

interface ProfileSettingsModalProps {
  userId: string;
  isOpen: boolean;
  onClose: () => void;
  onUpdate: () => void;
}

export function ProfileSettingsModal({ userId, isOpen, onClose, onUpdate }: ProfileSettingsModalProps) {
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [preferences, setPreferences] = useState<Partial<UserPreferences>>({});
  const { toast } = useToast();

  useEffect(() => {
    if (isOpen) {
      loadPreferences();
    }
  }, [isOpen, userId]);

  const loadPreferences = async () => {
    setLoading(true);
    const prefs = await getUserPreferences(userId);
    if (prefs) {
      setPreferences(prefs);
    } else {
      // Default preferences
      setPreferences({
        theme: 'system',
        color_scheme: 'blue',
        font_size: 'medium',
        compact_mode: false,
        profile_visibility: 'public',
        show_activity_status: true,
        show_problem_history: true,
        show_learning_path: true,
        allow_friend_requests: true,
        show_achievements: true,
        email_notifications: true,
        push_notifications: false,
        daily_challenge_reminder: true,
        streak_reminder: true,
        achievement_notifications: true,
        community_notifications: true,
        difficulty_preference: 'mixed',
        preferred_topics: [],
        practice_goal_daily: 3,
        study_time_goal_minutes: 60,
      });
    }
    setLoading(false);
  };

  const handleSave = async () => {
    setSaving(true);
    const success = await updateUserPreferences(userId, preferences);
    setSaving(false);

    if (success) {
      // Apply theme changes immediately
      if (preferences.theme) applyTheme(preferences.theme);
      if (preferences.color_scheme) applyColorScheme(preferences.color_scheme);
      if (preferences.font_size) applyFontSize(preferences.font_size);

      toast({
        title: 'Settings saved!',
        description: 'Your preferences have been updated',
      });
      onUpdate();
      onClose();
    } else {
      toast({
        title: 'Save failed',
        description: 'Failed to update preferences',
        variant: 'destructive',
      });
    }
  };

  const updatePref = <K extends keyof UserPreferences>(key: K, value: UserPreferences[K]) => {
    setPreferences(prev => ({ ...prev, [key]: value }));
  };

  if (loading) {
    return (
      <Dialog open={isOpen} onOpenChange={onClose}>
        <DialogContent className="max-w-md !fixed !left-[50%] !top-[50%] !translate-x-[-50%] !translate-y-[-50%]">
          <div className="flex items-center justify-center p-12">
            <Loader2 className="w-8 h-8 animate-spin" />
          </div>
        </DialogContent>
      </Dialog>
    );
  }

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-4xl w-[90vw] max-h-[90vh] overflow-hidden flex flex-col !fixed !left-[50%] !top-[50%] !translate-x-[-50%] !translate-y-[-50%]">
        <DialogHeader>
          <DialogTitle>Profile Settings</DialogTitle>
        </DialogHeader>

        <div className="flex-1 overflow-y-auto">
          <Tabs defaultValue="basic" className="mt-4">
          <TabsList className="grid w-full grid-cols-4">
            <TabsTrigger value="basic" className="gap-2">
              <User className="w-4 h-4" />
              Basic
            </TabsTrigger>
            <TabsTrigger value="appearance" className="gap-2">
              <Palette className="w-4 h-4" />
              Appearance
            </TabsTrigger>
            <TabsTrigger value="privacy" className="gap-2">
              <Shield className="w-4 h-4" />
              Privacy
            </TabsTrigger>
            <TabsTrigger value="notifications" className="gap-2">
              <Bell className="w-4 h-4" />
              Notifications
            </TabsTrigger>
          </TabsList>

          {/* Basic Tab */}
          <TabsContent value="basic" className="space-y-4 mt-4">
            <AvatarUpload 
              userId={userId} 
              currentAvatarUrl={null}
              onAvatarUpdate={() => onUpdate()}
            />

            <div className="space-y-4">
              <div>
                <Label>Daily Practice Goal</Label>
                <Select
                  value={preferences.practice_goal_daily?.toString()}
                  onValueChange={(v) => updatePref('practice_goal_daily', parseInt(v))}
                >
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="1">1 problem per day</SelectItem>
                    <SelectItem value="3">3 problems per day</SelectItem>
                    <SelectItem value="5">5 problems per day</SelectItem>
                    <SelectItem value="10">10 problems per day</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div>
                <Label>Study Time Goal (minutes/day)</Label>
                <Input
                  type="number"
                  value={preferences.study_time_goal_minutes}
                  onChange={(e) => updatePref('study_time_goal_minutes', parseInt(e.target.value))}
                  min={15}
                  max={480}
                />
              </div>

              <div>
                <Label>Difficulty Preference</Label>
                <Select
                  value={preferences.difficulty_preference}
                  onValueChange={(v: any) => updatePref('difficulty_preference', v)}
                >
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="easy">Easy</SelectItem>
                    <SelectItem value="medium">Medium</SelectItem>
                    <SelectItem value="hard">Hard</SelectItem>
                    <SelectItem value="mixed">Mixed</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
          </TabsContent>

          {/* Appearance Tab */}
          <TabsContent value="appearance" className="space-y-6 mt-4">
            <div>
              <Label className="text-base font-semibold">Theme</Label>
              <p className="text-sm text-muted-foreground mb-3">Choose your preferred color theme</p>
              <div className="grid grid-cols-3 gap-3">
                {(['light', 'dark', 'system'] as const).map((theme) => (
                  <Button
                    key={theme}
                    variant={preferences.theme === theme ? 'default' : 'outline'}
                    onClick={() => updatePref('theme', theme)}
                    className="capitalize"
                  >
                    {theme}
                  </Button>
                ))}
              </div>
            </div>

            <div>
              <Label className="text-base font-semibold">Color Scheme</Label>
              <p className="text-sm text-muted-foreground mb-3">Select your accent color</p>
              <div className="grid grid-cols-5 gap-3">
                {(['blue', 'green', 'purple', 'orange', 'red'] as const).map((color) => (
                  <Button
                    key={color}
                    variant={preferences.color_scheme === color ? 'default' : 'outline'}
                    onClick={() => updatePref('color_scheme', color)}
                    className="capitalize"
                    style={{
                      backgroundColor: preferences.color_scheme === color 
                        ? { blue: '#3b82f6', green: '#10b981', purple: '#8b5cf6', orange: '#f59e0b', red: '#ef4444' }[color]
                        : undefined
                    }}
                  >
                    {color}
                  </Button>
                ))}
              </div>
            </div>

            <div>
              <Label className="text-base font-semibold">Font Size</Label>
              <div className="grid grid-cols-3 gap-3 mt-3">
                {(['small', 'medium', 'large'] as const).map((size) => (
                  <Button
                    key={size}
                    variant={preferences.font_size === size ? 'default' : 'outline'}
                    onClick={() => updatePref('font_size', size)}
                    className="capitalize"
                  >
                    {size}
                  </Button>
                ))}
              </div>
            </div>

            <div className="flex items-center justify-between">
              <div>
                <Label>Compact Mode</Label>
                <p className="text-sm text-muted-foreground">Reduce spacing for denser layout</p>
              </div>
              <Switch
                checked={preferences.compact_mode}
                onCheckedChange={(checked) => updatePref('compact_mode', checked)}
              />
            </div>
          </TabsContent>

          {/* Privacy Tab */}
          <TabsContent value="privacy" className="space-y-4 mt-4">
            <div>
              <Label>Profile Visibility</Label>
              <Select
                value={preferences.profile_visibility}
                onValueChange={(v: any) => updatePref('profile_visibility', v)}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="public">Public - Anyone can view</SelectItem>
                  <SelectItem value="friends">Friends Only</SelectItem>
                  <SelectItem value="private">Private - Only me</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-3">
              {[
                { key: 'show_activity_status', label: 'Show Activity Status', desc: 'Let others see when you\'re online' },
                { key: 'show_problem_history', label: 'Show Problem History', desc: 'Display problems you\'ve solved' },
                { key: 'show_learning_path', label: 'Show Learning Path', desc: 'Make your study plans visible' },
                { key: 'allow_friend_requests', label: 'Allow Friend Requests', desc: 'Let others send you requests' },
                { key: 'show_achievements', label: 'Show Achievements', desc: 'Display badges on your profile' },
              ].map(({ key, label, desc }) => (
                <div key={key} className="flex items-center justify-between">
                  <div>
                    <Label>{label}</Label>
                    <p className="text-sm text-muted-foreground">{desc}</p>
                  </div>
                  <Switch
                    checked={preferences[key as keyof UserPreferences] as boolean}
                    onCheckedChange={(checked) => updatePref(key as any, checked)}
                  />
                </div>
              ))}
            </div>
          </TabsContent>

          {/* Notifications Tab */}
          <TabsContent value="notifications" className="space-y-4 mt-4">
            <div className="space-y-3">
              {[
                { key: 'email_notifications', label: 'Email Notifications', desc: 'Receive updates via email' },
                { key: 'push_notifications', label: 'Push Notifications', desc: 'Browser push notifications' },
                { key: 'daily_challenge_reminder', label: 'Daily Challenge Reminder', desc: 'Get notified about daily challenges' },
                { key: 'streak_reminder', label: 'Streak Reminder', desc: 'Don\'t break your streak!' },
                { key: 'achievement_notifications', label: 'Achievement Notifications', desc: 'New badges and milestones' },
                { key: 'community_notifications', label: 'Community Notifications', desc: 'Replies and mentions in forums' },
              ].map(({ key, label, desc }) => (
                <div key={key} className="flex items-center justify-between">
                  <div>
                    <Label>{label}</Label>
                    <p className="text-sm text-muted-foreground">{desc}</p>
                  </div>
                  <Switch
                    checked={preferences[key as keyof UserPreferences] as boolean}
                    onCheckedChange={(checked) => updatePref(key as any, checked)}
                  />
                </div>
              ))}
            </div>
          </TabsContent>
        </Tabs>
        </div>

        {/* Footer */}
        <div className="flex justify-end gap-3 pt-4 border-t flex-shrink-0">
          <Button variant="outline" onClick={onClose}>
            Cancel
          </Button>
          <Button onClick={handleSave} disabled={saving}>
            {saving && <Loader2 className="w-4 h-4 mr-2 animate-spin" />}
            Save Changes
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}

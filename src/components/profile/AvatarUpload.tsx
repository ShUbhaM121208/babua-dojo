import { useState, useRef } from 'react';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { Label } from '@/components/ui/label';
import { useToast } from '@/hooks/use-toast';
import { Upload, X, Loader2 } from 'lucide-react';
import { uploadAvatar, deleteAvatar } from '@/lib/profileCustomizationService';

interface AvatarUploadProps {
  userId: string;
  currentAvatarUrl?: string | null;
  onAvatarUpdate: (url: string | null) => void;
}

export function AvatarUpload({ userId, currentAvatarUrl, onAvatarUpdate }: AvatarUploadProps) {
  const [uploading, setUploading] = useState(false);
  const [previewUrl, setPreviewUrl] = useState<string | null>(currentAvatarUrl || null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const { toast } = useToast();

  const handleFileSelect = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    // Validate file size (5MB)
    if (file.size > 5 * 1024 * 1024) {
      toast({
        title: 'File too large',
        description: 'Please select an image under 5MB',
        variant: 'destructive',
      });
      return;
    }

    // Validate file type
    const validTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
    if (!validTypes.includes(file.type)) {
      toast({
        title: 'Invalid file type',
        description: 'Please select a JPEG, PNG, WebP, or GIF image',
        variant: 'destructive',
      });
      return;
    }

    // Show preview
    const reader = new FileReader();
    reader.onloadend = () => {
      setPreviewUrl(reader.result as string);
    };
    reader.readAsDataURL(file);

    // Upload
    setUploading(true);
    const { url, error } = await uploadAvatar(userId, file);
    setUploading(false);

    if (error) {
      toast({
        title: 'Upload failed',
        description: error,
        variant: 'destructive',
      });
      setPreviewUrl(currentAvatarUrl || null);
    } else if (url) {
      toast({
        title: 'Avatar uploaded!',
        description: 'Your profile picture has been updated',
      });
      onAvatarUpdate(url);
    }
  };

  const handleDelete = async () => {
    setUploading(true);
    const success = await deleteAvatar(userId);
    setUploading(false);

    if (success) {
      setPreviewUrl(null);
      onAvatarUpdate(null);
      toast({
        title: 'Avatar removed',
        description: 'Your profile picture has been removed',
      });
    } else {
      toast({
        title: 'Delete failed',
        description: 'Failed to remove avatar',
        variant: 'destructive',
      });
    }
  };

  return (
    <Card className="p-6">
      <Label className="text-base font-semibold mb-4 block">Profile Picture</Label>
      
      <div className="flex items-center gap-6">
        {/* Avatar Preview */}
        <div className="relative">
          <div className="w-32 h-32 rounded-full bg-gray-800 overflow-hidden border-4 border-gray-700">
            {previewUrl ? (
              <img
                src={previewUrl}
                alt="Avatar"
                className="w-full h-full object-cover"
              />
            ) : (
              <div className="w-full h-full flex items-center justify-center text-4xl text-gray-500">
                ?
              </div>
            )}
          </div>
          
          {uploading && (
            <div className="absolute inset-0 flex items-center justify-center bg-black/50 rounded-full">
              <Loader2 className="w-8 h-8 animate-spin text-white" />
            </div>
          )}
        </div>

        {/* Upload Controls */}
        <div className="flex flex-col gap-3">
          <input
            ref={fileInputRef}
            type="file"
            accept="image/jpeg,image/png,image/webp,image/gif"
            onChange={handleFileSelect}
            className="hidden"
          />
          
          <Button
            onClick={() => fileInputRef.current?.click()}
            disabled={uploading}
            className="gap-2"
          >
            <Upload className="w-4 h-4" />
            {previewUrl ? 'Change Avatar' : 'Upload Avatar'}
          </Button>

          {previewUrl && (
            <Button
              variant="outline"
              onClick={handleDelete}
              disabled={uploading}
              className="gap-2 border-red-500 text-red-500 hover:bg-red-500/10"
            >
              <X className="w-4 h-4" />
              Remove Avatar
            </Button>
          )}

          <p className="text-xs text-muted-foreground">
            JPEG, PNG, WebP, or GIF (max 5MB)
          </p>
        </div>
      </div>
    </Card>
  );
}

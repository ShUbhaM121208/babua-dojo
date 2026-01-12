import { useState } from 'react';
import { WhiteboardParticipant, WhiteboardRoom } from '@/lib/whiteboardService';
import { Button } from '@/components/ui/button';
import { Copy, Users, LogOut, XCircle, Crown, Check } from 'lucide-react';
import { useToast } from '@/hooks/use-toast';

interface RoomControlsProps {
  room: WhiteboardRoom;
  participants: WhiteboardParticipant[];
  currentUserId: string;
  onLeaveRoom: () => void;
  onCloseRoom?: () => void;
}

export default function RoomControls({
  room,
  participants,
  currentUserId,
  onLeaveRoom,
  onCloseRoom,
}: RoomControlsProps) {
  const { toast } = useToast();
  const [copiedCode, setCopiedCode] = useState(false);

  const isSolver = room.solver_id === currentUserId;
  const currentParticipant = participants.find(p => p.user_id === currentUserId);

  const copyRoomCode = async () => {
    try {
      await navigator.clipboard.writeText(room.room_code);
      setCopiedCode(true);
      toast({
        title: 'Copied!',
        description: 'Room code copied to clipboard',
      });
      setTimeout(() => setCopiedCode(false), 2000);
    } catch (err) {
      console.error('Failed to copy:', err);
      toast({
        title: 'Failed to copy',
        description: 'Please copy the code manually',
        variant: 'destructive',
      });
    }
  };

  const copyRoomLink = async () => {
    try {
      const url = `${window.location.origin}/doubt-arena?join=${room.room_code}`;
      await navigator.clipboard.writeText(url);
      toast({
        title: 'Link copied!',
        description: 'Share this link with others to join',
      });
    } catch (err) {
      console.error('Failed to copy link:', err);
      toast({
        title: 'Failed to copy link',
        description: 'Please copy the link manually',
        variant: 'destructive',
      });
    }
  };

  return (
    <div className="bg-background border-l border-border w-80 flex flex-col">
      {/* Room Info */}
      <div className="p-4 border-b border-border">
        <h2 className="text-lg font-bold mb-2">{room.title}</h2>
        
        {/* Room Code */}
        <div className="space-y-2">
          <div className="flex items-center gap-2">
            <div className="flex-1 bg-secondary px-3 py-2 rounded-lg font-mono text-lg font-bold text-center tracking-widest">
              {room.room_code}
            </div>
            <Button
              variant="ghost"
              size="sm"
              onClick={copyRoomCode}
              className="h-10 w-10 p-0"
            >
              {copiedCode ? (
                <Check className="h-4 w-4 text-primary" />
              ) : (
                <Copy className="h-4 w-4" />
              )}
            </Button>
          </div>
          
          <Button
            variant="outline"
            size="sm"
            onClick={copyRoomLink}
            className="w-full font-mono"
          >
            Copy Invite Link
          </Button>
        </div>
      </div>

      {/* Participants List */}
      <div className="flex-1 overflow-y-auto p-4">
        <div className="flex items-center gap-2 mb-3">
          <Users className="h-4 w-4 text-muted-foreground" />
          <h3 className="font-semibold text-sm">
            Participants ({participants.length}/{room.max_participants})
          </h3>
        </div>

        <div className="space-y-2">
          {participants.map((participant) => (
            <div
              key={participant.id}
              className={`flex items-center gap-2 p-2 rounded-lg ${
                participant.user_id === currentUserId
                  ? 'bg-primary/10 border border-primary'
                  : 'bg-secondary'
              }`}
            >
              <div className="h-8 w-8 rounded-full bg-primary/20 flex items-center justify-center text-sm font-bold">
                {participant.username.charAt(0).toUpperCase()}
              </div>
              
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2">
                  <span className="font-medium text-sm truncate">
                    {participant.username}
                  </span>
                  {participant.is_solver && (
                    <Crown className="h-3 w-3 text-amber-500 flex-shrink-0" title="Solver" />
                  )}
                </div>
                {participant.user_id === currentUserId && (
                  <span className="text-xs text-muted-foreground">You</span>
                )}
              </div>
            </div>
          ))}
        </div>

        {participants.length === 0 && (
          <div className="text-center text-muted-foreground text-sm py-8">
            Waiting for participants...
          </div>
        )}
      </div>

      {/* Action Buttons */}
      <div className="p-4 border-t border-border space-y-2">
        {isSolver && onCloseRoom && (
          <Button
            variant="destructive"
            onClick={onCloseRoom}
            className="w-full font-mono"
          >
            <XCircle className="h-4 w-4 mr-2" />
            Close Room
          </Button>
        )}
        
        <Button
          variant="outline"
          onClick={onLeaveRoom}
          className="w-full font-mono"
        >
          <LogOut className="h-4 w-4 mr-2" />
          Leave Room
        </Button>
      </div>

      {/* Info Banner */}
      {isSolver && (
        <div className="px-4 pb-4">
          <div className="bg-amber-500/10 border border-amber-500/20 rounded-lg p-3 text-xs text-amber-700 dark:text-amber-300">
            <Crown className="h-4 w-4 inline mr-1" />
            You are the <strong>Solver</strong>. Only you can close this room.
          </div>
        </div>
      )}
    </div>
  );
}

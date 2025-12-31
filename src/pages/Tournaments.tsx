import { useEffect, useState, useCallback } from "react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Trophy, Calendar, Search, Filter, Plus } from "lucide-react";
import { Tournament, tournamentService } from "@/services/tournamentService";
import { TournamentCard } from "@/components/tournaments/TournamentCard";
import { CreateTournamentDialog } from "@/components/tournaments/CreateTournamentDialog";
import { useAuth } from "@/contexts/AuthContext";
import { Skeleton } from "@/components/ui/skeleton";
import { format, startOfMonth, endOfMonth, eachDayOfInterval, isSameMonth, isSameDay } from "date-fns";

type TournamentStatus = 'upcoming' | 'live' | 'completed';

export default function Tournaments() {
  const { user } = useAuth();
  const [activeTab, setActiveTab] = useState<TournamentStatus>('upcoming');
  const [tournaments, setTournaments] = useState<Tournament[]>([]);
  const [filteredTournaments, setFilteredTournaments] = useState<Tournament[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState("");
  const [difficultyFilter, setDifficultyFilter] = useState<string>("all");
  const [participantCounts, setParticipantCounts] = useState<Record<string, number>>({});
  const [registrationStatus, setRegistrationStatus] = useState<Record<string, boolean>>({});
  const [userRanks, setUserRanks] = useState<Record<string, number>>({});
  const [calendarDate, setCalendarDate] = useState(new Date());
  const [calendarTournaments, setCalendarTournaments] = useState<Record<string, Tournament[]>>({});
  const [showCreateDialog, setShowCreateDialog] = useState(false);

  const loadTournaments = useCallback(async () => {
    try {
      setLoading(true);
      const data = await tournamentService.getTournaments(activeTab);
      setTournaments(data);

      // Load participant counts and registration status for each tournament
      const counts: Record<string, number> = {};
      const registrations: Record<string, boolean> = {};
      const ranks: Record<string, number> = {};

      await Promise.all(
        data.map(async (tournament) => {
          const count = await tournamentService.getParticipantCount(tournament.id);
          counts[tournament.id] = count;

          if (user) {
            const isRegistered = await tournamentService.isRegistered(tournament.id);
            registrations[tournament.id] = isRegistered;

            if (tournament.status === 'completed' && isRegistered) {
              const rankEntry = await tournamentService.getUserRank(tournament.id);
              if (rankEntry) ranks[tournament.id] = rankEntry.rank;
            }
          }
        })
      );

      setParticipantCounts(counts);
      setRegistrationStatus(registrations);
      setUserRanks(ranks);
    } catch (error) {
      console.error('Failed to load tournaments:', error);
    } finally {
      setLoading(false);
    }
  }, [activeTab, user]);

  useEffect(() => {
    loadTournaments();
  }, [loadTournaments]);

  const loadCalendarData = async () => {
    try {
      const start = startOfMonth(calendarDate);
      const end = endOfMonth(calendarDate);
      
      // Load all tournaments for the month
      const allTournaments = await tournamentService.getTournaments();
      
      // Group by date
      const grouped: Record<string, Tournament[]> = {};
      allTournaments.forEach(tournament => {
        const date = format(new Date(tournament.start_time), 'yyyy-MM-dd');
        if (!grouped[date]) grouped[date] = [];
        grouped[date].push(tournament);
      });
      
      setCalendarTournaments(grouped);
    } catch (error) {
      console.error('Failed to load calendar data:', error);
    }
  };

  const filterTournaments = () => {
    let filtered = [...tournaments];

    // Search filter
    if (searchQuery) {
      filtered = filtered.filter(
        (t) =>
          t.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
          t.description?.toLowerCase().includes(searchQuery.toLowerCase())
      );
    }

    // Difficulty filter
    if (difficultyFilter !== "all") {
      filtered = filtered.filter((t) => t.difficulty === difficultyFilter);
    }

    setFilteredTournaments(filtered);
  };

  const renderCalendar = () => {
    const monthStart = startOfMonth(calendarDate);
    const monthEnd = endOfMonth(calendarDate);
    const days = eachDayOfInterval({ start: monthStart, end: monthEnd });

    return (
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle className="flex items-center gap-2">
              <Calendar className="h-5 w-5" />
              Tournament Calendar
            </CardTitle>
            <div className="flex gap-2">
              <Button
                variant="outline"
                size="sm"
                onClick={() => setCalendarDate(new Date(calendarDate.getFullYear(), calendarDate.getMonth() - 1))}
              >
                Previous
              </Button>
              <Button
                variant="outline"
                size="sm"
                onClick={() => setCalendarDate(new Date())}
              >
                Today
              </Button>
              <Button
                variant="outline"
                size="sm"
                onClick={() => setCalendarDate(new Date(calendarDate.getFullYear(), calendarDate.getMonth() + 1))}
              >
                Next
              </Button>
            </div>
          </div>
          <CardDescription>
            {format(calendarDate, 'MMMM yyyy')}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-7 gap-2">
            {/* Day headers */}
            {['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map(day => (
              <div key={day} className="text-center text-sm font-semibold text-muted-foreground p-2">
                {day}
              </div>
            ))}
            
            {/* Empty cells for days before month start */}
            {Array.from({ length: monthStart.getDay() }).map((_, i) => (
              <div key={`empty-${i}`} className="p-2" />
            ))}
            
            {/* Calendar days */}
            {days.map(day => {
              const dateKey = format(day, 'yyyy-MM-dd');
              const dayTournaments = calendarTournaments[dateKey] || [];
              const isToday = isSameDay(day, new Date());
              
              return (
                <div
                  key={dateKey}
                  className={`p-2 border rounded-lg min-h-[80px] ${
                    isToday ? 'bg-primary/5 border-primary' : 'hover:bg-accent'
                  }`}
                >
                  <div className="text-sm font-medium mb-1">
                    {format(day, 'd')}
                  </div>
                  {dayTournaments.slice(0, 2).map(tournament => (
                    <div
                      key={tournament.id}
                      className="text-xs p-1 mb-1 rounded bg-primary/10 text-primary truncate cursor-pointer hover:bg-primary/20"
                      title={tournament.title}
                    >
                      {tournament.title}
                    </div>
                  ))}
                  {dayTournaments.length > 2 && (
                    <div className="text-xs text-muted-foreground">
                      +{dayTournaments.length - 2} more
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </CardContent>
      </Card>
    );
  };

  return (
    <div className="container mx-auto px-4 py-8 space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div>
          <h1 className="text-4xl font-bold flex items-center gap-3">
            <Trophy className="h-10 w-10 text-yellow-500" />
            Tournaments
          </h1>
          <p className="text-muted-foreground mt-2">
            Compete with others, climb the leaderboard, and win prizes
          </p>
        </div>
        
        {user && (
          <Button variant="outline" className="gap-2" onClick={() => setShowCreateDialog(true)}>
            <Plus className="h-4 w-4" />
            Create Tournament
          </Button>
        )}
      </div>

      {/* Filters */}
      <Card>
        <CardContent className="pt-6">
          <div className="flex flex-col md:flex-row gap-4">
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="Search tournaments..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="pl-10"
              />
            </div>
            
            <Select value={difficultyFilter} onValueChange={setDifficultyFilter}>
              <SelectTrigger className="w-full md:w-[180px]">
                <Filter className="h-4 w-4 mr-2" />
                <SelectValue placeholder="Difficulty" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All Levels</SelectItem>
                <SelectItem value="easy">Easy</SelectItem>
                <SelectItem value="medium">Medium</SelectItem>
                <SelectItem value="hard">Hard</SelectItem>
                <SelectItem value="expert">Expert</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </CardContent>
      </Card>

      {/* Tabs */}
      <Tabs value={activeTab} onValueChange={(v) => setActiveTab(v as TournamentStatus)}>
        <TabsList className="grid w-full grid-cols-4">
          <TabsTrigger value="upcoming">
            Upcoming
            {tournaments.filter(t => t.status === 'upcoming').length > 0 && (
              <span className="ml-2 px-2 py-0.5 bg-blue-500 text-white text-xs rounded-full">
                {tournaments.filter(t => t.status === 'upcoming').length}
              </span>
            )}
          </TabsTrigger>
          <TabsTrigger value="live">
            Live
            {tournaments.filter(t => t.status === 'live').length > 0 && (
              <span className="ml-2 px-2 py-0.5 bg-green-500 text-white text-xs rounded-full animate-pulse">
                {tournaments.filter(t => t.status === 'live').length}
              </span>
            )}
          </TabsTrigger>
          <TabsTrigger value="completed">Completed</TabsTrigger>
          <TabsTrigger value="calendar">Calendar</TabsTrigger>
        </TabsList>

        {/* Upcoming Tab */}
        <TabsContent value="upcoming" className="mt-6">
          {loading ? (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {[...Array(6)].map((_, i) => (
                <Skeleton key={i} className="h-[400px]" />
              ))}
            </div>
          ) : filteredTournaments.length === 0 ? (
            <Card>
              <CardContent className="py-12 text-center">
                <Trophy className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
                <p className="text-lg font-medium">No upcoming tournaments</p>
                <p className="text-muted-foreground mt-2">
                  Check back later for new tournaments
                </p>
              </CardContent>
            </Card>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {filteredTournaments.map((tournament) => (
                <TournamentCard
                  key={tournament.id}
                  tournament={tournament}
                  participantCount={participantCounts[tournament.id]}
                  isRegistered={registrationStatus[tournament.id]}
                />
              ))}
            </div>
          )}
        </TabsContent>

        {/* Live Tab */}
        <TabsContent value="live" className="mt-6">
          {loading ? (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {[...Array(3)].map((_, i) => (
                <Skeleton key={i} className="h-[400px]" />
              ))}
            </div>
          ) : filteredTournaments.length === 0 ? (
            <Card>
              <CardContent className="py-12 text-center">
                <Trophy className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
                <p className="text-lg font-medium">No live tournaments</p>
                <p className="text-muted-foreground mt-2">
                  Tournaments will appear here when they start
                </p>
              </CardContent>
            </Card>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {filteredTournaments.map((tournament) => (
                <TournamentCard
                  key={tournament.id}
                  tournament={tournament}
                  participantCount={participantCounts[tournament.id]}
                  isRegistered={registrationStatus[tournament.id]}
                />
              ))}
            </div>
          )}
        </TabsContent>

        {/* Completed Tab */}
        <TabsContent value="completed" className="mt-6">
          {loading ? (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {[...Array(6)].map((_, i) => (
                <Skeleton key={i} className="h-[400px]" />
              ))}
            </div>
          ) : filteredTournaments.length === 0 ? (
            <Card>
              <CardContent className="py-12 text-center">
                <Trophy className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
                <p className="text-lg font-medium">No completed tournaments</p>
                <p className="text-muted-foreground mt-2">
                  Past tournaments will be listed here
                </p>
              </CardContent>
            </Card>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              {filteredTournaments.map((tournament) => (
                <TournamentCard
                  key={tournament.id}
                  tournament={tournament}
                  participantCount={participantCounts[tournament.id]}
                  isRegistered={registrationStatus[tournament.id]}
                  userRank={userRanks[tournament.id]}
                />
              ))}
            </div>
          )}
        </TabsContent>

        {/* Calendar Tab */}
        <TabsContent value="calendar" className="mt-6">
          {renderCalendar()}
        </TabsContent>
      </Tabs>

      {/* Create Tournament Dialog */}
      <CreateTournamentDialog
        isOpen={showCreateDialog}
        onClose={() => setShowCreateDialog(false)}
        onSuccess={() => {
          loadTournaments();
          setShowCreateDialog(false);
        }}
      />
    </div>
  );
}

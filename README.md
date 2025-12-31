# 🥋 Babua Dojo - Next-Gen Competitive Coding Platform

<div align="center">

**Master coding through gamification, AI mentorship, and competitive battles**

[![React](https://img.shields.io/badge/React-18.3-blue.svg)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.5-blue.svg)](https://www.typescriptlang.org/)
[![Supabase](https://img.shields.io/badge/Supabase-Database-green.svg)](https://supabase.com/)
[![Vite](https://img.shields.io/badge/Vite-5.4-purple.svg)](https://vitejs.dev/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[Live Demo](#) • [Documentation](#features) • [Roadmap](COMPLETE_35_FEATURES_ROADMAP.md)

</div>

---

## 🎯 What is Babua Dojo?

Babua Dojo is a **comprehensive competitive programming platform** that combines the rigor of LeetCode with the engagement of Duolingo and the competition of esports. It transforms coding practice from a solitary grind into an exciting multiplayer learning experience.

### 🌟 Core Philosophy
- **Learn by Doing**: Real code execution with instant feedback
- **AI-Powered Mentorship**: Get hints without spoiling solutions
- **Competitive Spirit**: Tournaments, battles, and live matchmaking
- **Community First**: Forums, study buddies, and peer learning
- **Personalized Growth**: AI tracks weaknesses and creates custom study plans

---

## ✨ Standout Features

### 🤖 1. Babua AI Tutor Mode
Your personal coding mentor powered by AI that teaches instead of just giving answers.

**Features:**
- **Progressive Hints System**: 4-tier guidance (Conceptual → Algorithmic → Implementation → Solution)
- **Concept Mastery Tracking**: AI monitors what you understand and adapts
- **Personalized Learning Paths**: Custom roadmaps based on your weak areas
- **Code Review with AI**: Get detailed feedback on your solutions

**Use Case**: Stuck on a Two-Sum problem? Babua AI will first explain hash maps conceptually, then hint at the algorithm, guide implementation, and only reveal the full solution if needed.

---

### 🎯 2. Weakness Elimination Plan
Scientific learning backed by **SuperMemo-2 spaced repetition algorithm**.

**Features:**
- **AI-Powered Weakness Analysis**: Identifies patterns in your mistakes
- **Smart Practice Plans**: Auto-generates targeted problem sets
- **Spaced Repetition Queue**: Optimal review scheduling for long-term retention
- **Adaptive Difficulty**: Problems get harder as you improve
- **Priority Scoring**: Always practice what matters most

**Use Case**: Struggling with Dynamic Programming? The system schedules DP problems at scientifically optimal intervals, gradually increasing difficulty until you master it.

---

### ⚔️ 3. Code Battle Royale
Real-time multiplayer coding battles with live leaderboards.

**Features:**
- **ELO-Based Matchmaking**: Compete against players of similar skill
- **Live Coding Battles**: See opponents' progress in real-time
- **Tournament System**: Weekly/monthly competitions with prizes
- **Replay System**: Watch top performers solve problems
- **Rating & Rankings**: Global leaderboards across all tracks

**Use Case**: Join a Friday night battle with 50+ coders solving the same problem—fastest correct solution wins!

---

### 🎓 4. Mock Interview Simulator
Practice for FAANG interviews with **live video + real-time code collaboration**.

**Features:**
- **1-on-1 Video Interviews**: Daily.co integration for video calls
- **Shared Code Editor**: Collaborative Monaco editor with live cursor sync
- **Interview Recording & Playback**: Review your performance
- **Difficulty Matching**: Easy/Medium/Hard problem selection
- **Post-Interview Analytics**: Detailed feedback on performance

**Use Case**: Get paired with a peer, share video/audio, and solve a problem together like a real Google interview.

---

### 📚 5. Comprehensive Study Plans
Structured learning paths for all skill levels.

**Features:**
- **Pre-built Templates**: DSA Bootcamp, FAANG Prep, Contest Training
- **Custom Plan Builder**: Create your own curriculum
- **Daily Progress Tracking**: Streak system, mood logs, notes
- **Study Buddies**: Find accountability partners
- **AI Recommendations**: Personalized problem suggestions
- **Milestone Rewards**: XP, badges, and achievements

**Use Case**: Follow the "30-Day FAANG Interview Prep" plan with daily problems, video explanations, and community support.

---

### 🏆 6. Gamification & Progression

**Rank System:**
- Bronze → Silver → Gold → Platinum → Diamond → Legendary
- Special titles: "First Blood", "Night Owl", "Debugging Demon"
- Custom badges and profile customization

**XP & Rewards:**
- Earn XP for solving problems, helping in forums, winning battles
- Daily challenges with bonus XP
- Streak multipliers (7-day, 30-day, 100-day)
- Achievement unlocks

---

### 💬 7. Discussion Forums & Community

**Features:**
- **6 Categories**: General, DSA Help, Solutions, Career, Code Review, Resources
- **Voting System**: Upvote helpful solutions
- **Accepted Answers**: Mark best solutions
- **Full-Text Search**: Find discussions quickly
- **Thread Following**: Get notified of replies
- **Rich Text Editor**: Code snippets, images, formatting

---

## 🛠️ Tech Stack

### Frontend
- **React 18.3** - UI framework
- **TypeScript** - Type safety
- **Vite** - Build tool & dev server
- **Tailwind CSS** - Styling
- **shadcn/ui** - Component library
- **Monaco Editor** - Code editing (VS Code engine)
- **Recharts** - Analytics & visualizations
- **React Query** - Data fetching & caching

### Backend & Infrastructure
- **Supabase** - Database (PostgreSQL), Auth, Realtime, Storage
- **Daily.co** - Video/audio for interviews
- **Judge0 API** - Code execution engine
- **OpenAI/Gemini** - AI tutoring & code review
- **WebSockets** - Real-time battles & matchmaking

### DevOps
- **Vercel** - Deployment & hosting
- **GitHub Actions** - CI/CD
- **ESLint** - Code quality

---

## 🚀 Getting Started

### Prerequisites
- Node.js 18+ ([install with nvm](https://github.com/nvm-sh/nvm))
- npm or bun package manager
- Supabase account (for database)

### Installation

```bash
# Clone the repository
git clone https://github.com/ShUbhaM121208/babua-dojo.git
cd babua-dojo

# Install dependencies
npm install
# or
bun install

# Set up environment variables
cp .env.example .env
# Add your Supabase & API keys to .env

# Run database migrations
# Go to Supabase Dashboard → SQL Editor
# Run migrations from supabase/migrations/ folder

# Start development server
npm run dev

# Start WebSocket server (for battles)
npm run dev:ws

# Or run both concurrently
npm run dev:all
```

### Environment Variables

Create a `.env` file with:

```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
VITE_JUDGE0_API_KEY=your_judge0_api_key
VITE_OPENAI_API_KEY=your_openai_key
VITE_DAILY_API_KEY=your_daily_co_key
```

---

## 📂 Project Structure

```
babua-dojo/
├── src/
│   ├── components/       # React components
│   │   ├── ai/          # AI tutor components
│   │   ├── battle/      # Battle royale UI
│   │   ├── interview/   # Mock interview
│   │   ├── study-plans/ # Study plan components
│   │   └── ui/          # shadcn/ui components
│   ├── pages/           # Route pages
│   ├── hooks/           # Custom React hooks
│   ├── lib/             # Service layers
│   ├── types/           # TypeScript definitions
│   ├── contexts/        # React contexts
│   └── integrations/    # Supabase client
├── supabase/
│   └── migrations/      # Database schemas
├── server/
│   └── websocket.ts     # WebSocket server
└── public/              # Static assets
```

---

## 🎮 Usage Guide

### For Learners
1. **Sign Up** → Choose your learning track (DSA, Web Dev, Algorithms)
2. **Take Placement Test** → Get skill-level assessment
3. **Follow Study Plan** → Daily problems + video explanations
4. **Join Battles** → Compete in real-time coding competitions
5. **Track Progress** → Monitor XP, rank, weaknesses

### For Competitors
1. **Join Tournaments** → Weekly/monthly competitions
2. **Battle Royale** → Fast-paced multiplayer coding
3. **Climb Leaderboards** → Global & track-specific rankings
4. **Unlock Achievements** → Special titles & badges

### For Interview Prep
1. **Mock Interviews** → 1-on-1 video practice
2. **FAANG Study Plan** → Structured prep curriculum
3. **Company-Specific Tracks** → Google, Meta, Amazon patterns
4. **Review Recordings** → Analyze your performance

---

## 💰 Revenue Model

### Freemium Tiers
**Free Tier:**
- 5 AI hints/day
- Access to public tournaments
- Basic study plans
- Community forums

**Babua Pro ($9.99/month or $99/year):**
- ✨ Unlimited AI hints & code reviews
- 🎥 All video explanations
- 🚫 Ad-free experience
- 🏆 Premium tournament entries
- 📊 Advanced analytics
- 💾 Download problems as PDF
- 🎨 Custom profile themes
- 🎫 Priority support

### Additional Revenue Streams
- **Tournament Entry Fees**: $5-50 with prize pools
- **B2B/Enterprise**: Company team plans ($99-299/month)
- **Marketplace**: Premium problems & courses
- **Affiliate**: Bootcamp & course recommendations

---

## 🗺️ Roadmap

### ✅ Phase 1: Foundation (Weeks 1-3) - COMPLETE
- ✅ Code execution engine (Judge0)
- ✅ User authentication & profiles
- ✅ Problem database with test cases
- ✅ Battle Royale WebSocket server

### ✅ Phase 2: Engagement (Weeks 4-7) - COMPLETE
- ✅ Daily challenges
- ✅ Rank & progression system
- ✅ Tournaments system
- ✅ Discussion forums

### ✅ Phase 3: Advanced (Weeks 8-12) - COMPLETE
- ✅ AI Tutor Mode
- ✅ Mock Interviews with video
- ✅ Study Plans & recommendations
- ✅ Weakness analysis with spaced repetition

### 🚧 Phase 4: Scaling (Weeks 13-16) - IN PROGRESS
- [ ] Mobile apps (iOS/Android)
- [ ] VS Code extension
- [ ] Premium tier with Stripe
- [ ] Advanced analytics dashboard

### 📅 Phase 5: Expansion (Weeks 17-20)
- [ ] Company-sponsored tournaments
- [ ] Certificate programs
- [ ] Mentorship marketplace
- [ ] API for third-party integrations

See [COMPLETE_35_FEATURES_ROADMAP.md](COMPLETE_35_FEATURES_ROADMAP.md) for detailed breakdown.

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📞 Contact & Support

- **Developer**: Shubham
- **GitHub**: [@ShUbhaM121208](https://github.com/ShUbhaM121208)
- **Email**: support@babuadojo.com
- **Discord**: [Join our community](#)

---

## 🙏 Acknowledgments

- [shadcn/ui](https://ui.shadcn.com/) - Beautiful component library
- [Supabase](https://supabase.com/) - Backend infrastructure
- [Judge0](https://judge0.com/) - Code execution engine
- [Daily.co](https://daily.co/) - Video infrastructure
- Open source community ❤️

---

<div align="center">

**Made with ❤️ by Shubham**

⭐ Star this repo if you find it helpful!

[🏠 Homepage](#) • [📚 Docs](#features) • [🐛 Issues](https://github.com/ShUbhaM121208/babua-dojo/issues) • [💬 Discussions](https://github.com/ShUbhaM121208/babua-dojo/discussions)

</div>

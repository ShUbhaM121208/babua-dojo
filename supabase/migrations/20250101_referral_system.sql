-- Referral Program Migration
-- Implements viral growth system with code generation, tracking, and rewards

-- ============================================
-- TABLES
-- ============================================

-- Referrals Table
CREATE TABLE IF NOT EXISTS referrals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  referrer_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  referral_code TEXT UNIQUE NOT NULL,
  referred_user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'completed')),
  reward_earned BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  UNIQUE(referrer_id, referred_user_id)
);

-- Referral Rewards Table
CREATE TABLE IF NOT EXISTS referral_rewards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  referral_id UUID REFERENCES referrals(id) ON DELETE SET NULL,
  reward_type TEXT NOT NULL CHECK (reward_type IN ('xp_boost', 'badge', 'feature_unlock', 'premium_trial')),
  reward_value INTEGER DEFAULT 0, -- XP amount or days for premium
  reward_description TEXT,
  claimed BOOLEAN DEFAULT true,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Referral Milestones (for tracking achievements)
CREATE TABLE IF NOT EXISTS referral_milestones (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  total_referrals INTEGER DEFAULT 0,
  successful_referrals INTEGER DEFAULT 0, -- Users who solved 10+ problems
  total_xp_earned INTEGER DEFAULT 0,
  badges_unlocked TEXT[] DEFAULT '{}',
  last_referral_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX IF NOT EXISTS idx_referrals_referrer ON referrals(referrer_id);
CREATE INDEX IF NOT EXISTS idx_referrals_code ON referrals(referral_code);
CREATE INDEX IF NOT EXISTS idx_referrals_referred_user ON referrals(referred_user_id);
CREATE INDEX IF NOT EXISTS idx_referrals_status ON referrals(status);
CREATE INDEX IF NOT EXISTS idx_referral_rewards_user ON referral_rewards(user_id);
CREATE INDEX IF NOT EXISTS idx_referral_rewards_type ON referral_rewards(reward_type);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

ALTER TABLE referrals ENABLE ROW LEVEL SECURITY;
ALTER TABLE referral_rewards ENABLE ROW LEVEL SECURITY;
ALTER TABLE referral_milestones ENABLE ROW LEVEL SECURITY;

-- Referrals Policies
CREATE POLICY "Users can view their own referrals"
  ON referrals FOR SELECT
  USING (auth.uid() = referrer_id);

CREATE POLICY "Users can view referrals where they were referred"
  ON referrals FOR SELECT
  USING (auth.uid() = referred_user_id);

CREATE POLICY "Users can insert their own referrals"
  ON referrals FOR INSERT
  WITH CHECK (auth.uid() = referrer_id);

-- Referral Rewards Policies
CREATE POLICY "Users can view their own rewards"
  ON referral_rewards FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own rewards"
  ON referral_rewards FOR UPDATE
  USING (auth.uid() = user_id);

-- Referral Milestones Policies
CREATE POLICY "Users can view their own milestones"
  ON referral_milestones FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own milestones"
  ON referral_milestones FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own milestones"
  ON referral_milestones FOR UPDATE
  USING (auth.uid() = user_id);

-- ============================================
-- FUNCTIONS
-- ============================================

-- Function to generate unique referral code
CREATE OR REPLACE FUNCTION generate_referral_code()
RETURNS TEXT AS $$
DECLARE
  chars TEXT := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; -- Removed ambiguous chars
  result TEXT := '';
  i INTEGER;
BEGIN
  FOR i IN 1..8 LOOP
    result := result || substr(chars, floor(random() * length(chars) + 1)::integer, 1);
  END LOOP;
  RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Function to create referral code for new users
CREATE OR REPLACE FUNCTION create_user_referral_code()
RETURNS TRIGGER AS $$
DECLARE
  new_code TEXT;
  code_exists BOOLEAN;
BEGIN
  -- Generate unique code
  LOOP
    new_code := generate_referral_code();
    SELECT EXISTS(SELECT 1 FROM referrals WHERE referral_code = new_code) INTO code_exists;
    EXIT WHEN NOT code_exists;
  END LOOP;

  -- Insert referral record for the new user
  INSERT INTO referrals (referrer_id, referral_code, status)
  VALUES (NEW.id, new_code, 'active');

  -- Initialize milestone tracking
  INSERT INTO referral_milestones (user_id, total_referrals, successful_referrals)
  VALUES (NEW.id, 0, 0);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create referral code on user signup
DROP TRIGGER IF EXISTS trigger_create_referral_code ON auth.users;
CREATE TRIGGER trigger_create_referral_code
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION create_user_referral_code();

-- Function to process referral signup
CREATE OR REPLACE FUNCTION process_referral_signup(
  p_referral_code TEXT,
  p_new_user_id UUID
)
RETURNS BOOLEAN AS $$
DECLARE
  v_referrer_id UUID;
  v_referral_id UUID;
BEGIN
  -- Find the referrer by code
  SELECT referrer_id, id INTO v_referrer_id, v_referral_id
  FROM referrals
  WHERE referral_code = p_referral_code
    AND status = 'active'
    AND referrer_id != p_new_user_id; -- Prevent self-referral

  IF v_referrer_id IS NULL THEN
    RETURN false; -- Invalid code or self-referral
  END IF;

  -- Update the referral record
  UPDATE referrals
  SET referred_user_id = p_new_user_id,
      status = 'pending'
  WHERE id = v_referral_id;

  -- Update referrer's milestone count
  UPDATE referral_milestones
  SET total_referrals = total_referrals + 1,
      last_referral_at = NOW(),
      updated_at = NOW()
  WHERE user_id = v_referrer_id;

  -- Give signup bonus to new user (200 XP)
  INSERT INTO referral_rewards (user_id, reward_type, reward_value, reward_description)
  VALUES (
    p_new_user_id,
    'xp_boost',
    200,
    'Welcome bonus for joining via referral!'
  );

  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to complete referral when referee solves 10 problems
CREATE OR REPLACE FUNCTION check_referral_completion()
RETURNS TRIGGER AS $$
DECLARE
  v_referral RECORD;
  v_problems_solved INTEGER;
  v_referrer_successful_count INTEGER;
BEGIN
  -- Check if user was referred
  SELECT * INTO v_referral
  FROM referrals
  WHERE referred_user_id = NEW.user_id
    AND status = 'pending';

  IF v_referral IS NULL THEN
    RETURN NEW;
  END IF;

  -- Count problems solved by referred user
  SELECT COUNT(*) INTO v_problems_solved
  FROM user_problem_progress
  WHERE user_id = NEW.user_id
    AND solved = true;

  -- If they've solved 10+ problems, complete the referral
  IF v_problems_solved >= 10 THEN
    -- Update referral status
    UPDATE referrals
    SET status = 'completed',
        reward_earned = true,
        completed_at = NOW()
    WHERE id = v_referral.id;

    -- Update referrer's successful referrals count
    UPDATE referral_milestones
    SET successful_referrals = successful_referrals + 1,
        total_xp_earned = total_xp_earned + 500,
        updated_at = NOW()
    WHERE user_id = v_referral.referrer_id
    RETURNING successful_referrals INTO v_referrer_successful_count;

    -- Award 500 XP to referrer
    INSERT INTO referral_rewards (user_id, referral_id, reward_type, reward_value, reward_description)
    VALUES (
      v_referral.referrer_id,
      v_referral.id,
      'xp_boost',
      500,
      'Referral completed: Your friend solved 10 problems!'
    );

    -- Award badges at milestones
    IF v_referrer_successful_count = 5 THEN
      -- Recruiter badge
      INSERT INTO referral_rewards (user_id, reward_type, reward_value, reward_description)
      VALUES (
        v_referral.referrer_id,
        'badge',
        0,
        'Unlocked: Recruiter Badge (5 successful referrals)'
      );

      UPDATE referral_milestones
      SET badges_unlocked = array_append(badges_unlocked, 'recruiter')
      WHERE user_id = v_referral.referrer_id;

    ELSIF v_referrer_successful_count = 10 THEN
      -- Influencer badge
      INSERT INTO referral_rewards (user_id, reward_type, reward_value, reward_description)
      VALUES (
        v_referral.referrer_id,
        'badge',
        0,
        'Unlocked: Influencer Badge (10 successful referrals)'
      );

      UPDATE referral_milestones
      SET badges_unlocked = array_append(badges_unlocked, 'influencer')
      WHERE user_id = v_referral.referrer_id;

    ELSIF v_referrer_successful_count = 25 THEN
      -- Ambassador badge + 7-day premium trial
      INSERT INTO referral_rewards (user_id, reward_type, reward_value, reward_description)
      VALUES (
        v_referral.referrer_id,
        'badge',
        0,
        'Unlocked: Ambassador Badge (25 successful referrals)'
      );

      INSERT INTO referral_rewards (user_id, reward_type, reward_value, reward_description, expires_at)
      VALUES (
        v_referral.referrer_id,
        'premium_trial',
        7,
        '7-day Premium Trial unlocked!',
        NOW() + INTERVAL '7 days'
      );

      UPDATE referral_milestones
      SET badges_unlocked = array_append(badges_unlocked, 'ambassador')
      WHERE user_id = v_referral.referrer_id;
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to check referral completion on problem solve
DROP TRIGGER IF EXISTS trigger_check_referral_completion ON user_problem_progress;
CREATE TRIGGER trigger_check_referral_completion
  AFTER UPDATE OF solved ON user_problem_progress
  FOR EACH ROW
  WHEN (NEW.solved = true AND OLD.solved = false)
  EXECUTE FUNCTION check_referral_completion();

-- ============================================
-- HELPER VIEWS
-- ============================================

-- View for referral leaderboard
CREATE OR REPLACE VIEW referral_leaderboard AS
SELECT 
  rm.user_id,
  up.username,
  up.avatar_url,
  rm.successful_referrals,
  rm.total_referrals,
  rm.total_xp_earned,
  rm.badges_unlocked,
  rm.last_referral_at,
  ROW_NUMBER() OVER (ORDER BY rm.successful_referrals DESC, rm.total_referrals DESC) as rank
FROM referral_milestones rm
LEFT JOIN user_profiles up ON rm.user_id = up.id
WHERE rm.successful_referrals > 0
ORDER BY rm.successful_referrals DESC, rm.total_referrals DESC
LIMIT 100;

-- View for user referral stats
CREATE OR REPLACE VIEW user_referral_stats AS
SELECT 
  r.referrer_id as user_id,
  r.referral_code,
  rm.total_referrals,
  rm.successful_referrals,
  rm.total_xp_earned,
  rm.badges_unlocked,
  COUNT(CASE WHEN r.status = 'pending' THEN 1 END) as pending_referrals,
  COUNT(CASE WHEN r.status = 'completed' THEN 1 END) as completed_referrals,
  rm.last_referral_at
FROM referrals r
LEFT JOIN referral_milestones rm ON r.referrer_id = rm.user_id
WHERE r.referred_user_id IS NULL OR r.referred_user_id IS NOT NULL
GROUP BY r.referrer_id, r.referral_code, rm.total_referrals, rm.successful_referrals, 
         rm.total_xp_earned, rm.badges_unlocked, rm.last_referral_at;

COMMENT ON TABLE referrals IS 'Tracks referral relationships between users';
COMMENT ON TABLE referral_rewards IS 'Stores rewards earned through referrals';
COMMENT ON TABLE referral_milestones IS 'Tracks referral achievement milestones';

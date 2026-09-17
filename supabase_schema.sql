-- =========================================================================
-- Vodafone Foundation Instant Network Schools (INS) - Nyarugusu Camp
-- Supabase PostgreSQL Database Schema
-- =========================================================================

-- 1. Centers / Schools Table
CREATE TABLE IF NOT EXISTS centers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  code TEXT NOT NULL,
  location TEXT,
  contact TEXT,
  school_type TEXT DEFAULT 'Secondary',
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Coaches Table
CREATE TABLE IF NOT EXISTS coaches (
  id TEXT PRIMARY KEY,
  center_id TEXT REFERENCES centers(id) ON DELETE SET NULL,
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  role TEXT DEFAULT 'Lead Digital Coach',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Users Table (Role-based access)
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'coach', -- 'admin' | 'coach'
  center_id TEXT DEFAULT 'all',
  pin TEXT NOT NULL DEFAULT '1234',
  must_change_password BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Hardware Inventory Table (Serial-Number-First & Modular Ned Box Assets)
CREATE TABLE IF NOT EXISTS inventory (
  id TEXT PRIMARY KEY,
  serial_number TEXT NOT NULL,
  category TEXT NOT NULL,
  model TEXT NOT NULL,
  center_id TEXT REFERENCES centers(id) ON DELETE CASCADE,
  coach_id TEXT,
  status TEXT DEFAULT 'operational', -- 'operational', 'needs-repair', 'broken', 'lost', 'stolen', 'misplaced', 'in-storage'
  condition TEXT DEFAULT 'New / Good Condition',
  battery_health TEXT,
  last_audited DATE,
  audited_by TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_inventory_sn ON inventory(serial_number);
CREATE INDEX IF NOT EXISTS idx_inventory_center ON inventory(center_id);

-- 5. Classroom Teaching Sessions Table
CREATE TABLE IF NOT EXISTS teaching (
  id TEXT PRIMARY KEY,
  center_id TEXT REFERENCES centers(id) ON DELETE CASCADE,
  coach_id TEXT,
  teacher_name TEXT NOT NULL,
  date DATE NOT NULL,
  day_of_week TEXT,
  start_time TIME,
  end_time TIME,
  duration_minutes INTEGER DEFAULT 90,
  topic TEXT NOT NULL,
  milliweb_lesson_code TEXT,
  male_students INTEGER DEFAULT 0,
  female_students INTEGER DEFAULT 0,
  total_students INTEGER DEFAULT 0,
  tech_used JSONB DEFAULT '{}'::jsonb,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Teacher Preparation & Milliweb Repository Table
CREATE TABLE IF NOT EXISTS teacher_prep (
  id TEXT PRIMARY KEY,
  teacher_name TEXT NOT NULL,
  center_id TEXT REFERENCES centers(id) ON DELETE CASCADE,
  coach_id TEXT,
  date DATE NOT NULL,
  session_window TEXT DEFAULT 'Morning',
  lessons_count INTEGER DEFAULT 1,
  stored_in_milliweb BOOLEAN DEFAULT TRUE,
  lesson_codes JSONB DEFAULT '[]'::jsonb,
  code_status TEXT DEFAULT 'Loaded on Server',
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Student Research & Self-Study Table
CREATE TABLE IF NOT EXISTS research (
  id TEXT PRIMARY KEY,
  center_id TEXT REFERENCES centers(id) ON DELETE CASCADE,
  coach_id TEXT,
  date DATE NOT NULL,
  start_time TIME,
  end_time TIME,
  duration_minutes INTEGER DEFAULT 90,
  topic TEXT NOT NULL,
  milliweb_lesson_code TEXT,
  male_students INTEGER DEFAULT 0,
  female_students INTEGER DEFAULT 0,
  total_students INTEGER DEFAULT 0,
  access_mode TEXT DEFAULT 'Offline Milliweb Server',
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. Community Digital Access & Production Table
CREATE TABLE IF NOT EXISTS community (
  id TEXT PRIMARY KEY,
  activity_type TEXT NOT NULL,
  center_id TEXT REFERENCES centers(id) ON DELETE CASCADE,
  coach_id TEXT,
  beneficiary_name TEXT NOT NULL,
  date DATE NOT NULL,
  start_time TIME,
  end_time TIME,
  male_count INTEGER DEFAULT 0,
  female_count INTEGER DEFAULT 0,
  total_count INTEGER DEFAULT 0,
  purpose TEXT,
  devices_used TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 9. Withdrawals & Charging Station Table
CREATE TABLE IF NOT EXISTS withdrawals (
  id TEXT PRIMARY KEY,
  log_type TEXT DEFAULT 'checkout', -- 'checkout' | 'charging'
  center_id TEXT REFERENCES centers(id) ON DELETE CASCADE,
  coach_id TEXT,
  device_category TEXT,
  serial_number TEXT,
  beneficiary_name TEXT NOT NULL,
  organization TEXT,
  phone TEXT,
  date DATE NOT NULL,
  withdrawal_time TIME,
  expected_return_time TIME,
  actual_return_time TIME,
  is_taken BOOLEAN DEFAULT TRUE,
  acknowledged BOOLEAN DEFAULT TRUE,
  status TEXT DEFAULT 'checked-out', -- 'checked-out' | 'returned' | 'overdue'
  condition_on_return TEXT,
  charging_slot TEXT,
  device_model TEXT,
  battery_in TEXT,
  battery_out TEXT,
  pickup_authorized_by TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 10. Incidents & Maintenance Tickets Table
CREATE TABLE IF NOT EXISTS incidents (
  id TEXT PRIMARY KEY,
  incident_type TEXT NOT NULL,
  severity TEXT DEFAULT 'Medium',
  serial_number TEXT NOT NULL,
  center_id TEXT REFERENCES centers(id) ON DELETE CASCADE,
  reported_by TEXT NOT NULL,
  incident_date DATE NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'open', -- 'open' | 'in-repair' | 'resolved' | 'closed'
  action_taken TEXT,
  resolution_notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =========================================================================
-- Enable Row Level Security (RLS)
-- =========================================================================
ALTER TABLE centers ENABLE ROW LEVEL SECURITY;
ALTER TABLE coaches ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE teaching ENABLE ROW LEVEL SECURITY;
ALTER TABLE teacher_prep ENABLE ROW LEVEL SECURITY;
ALTER TABLE research ENABLE ROW LEVEL SECURITY;
ALTER TABLE community ENABLE ROW LEVEL SECURITY;
ALTER TABLE withdrawals ENABLE ROW LEVEL SECURITY;
ALTER TABLE incidents ENABLE ROW LEVEL SECURITY;

-- Allow full access for server-side service role key
CREATE POLICY "Allow server service role full access" ON centers FOR ALL USING (true);
CREATE POLICY "Allow server service role full access" ON coaches FOR ALL USING (true);
CREATE POLICY "Allow server service role full access" ON users FOR ALL USING (true);
CREATE POLICY "Allow server service role full access" ON inventory FOR ALL USING (true);
CREATE POLICY "Allow server service role full access" ON teaching FOR ALL USING (true);
CREATE POLICY "Allow server service role full access" ON teacher_prep FOR ALL USING (true);
CREATE POLICY "Allow server service role full access" ON research FOR ALL USING (true);
CREATE POLICY "Allow server service role full access" ON community FOR ALL USING (true);
CREATE POLICY "Allow server service role full access" ON withdrawals FOR ALL USING (true);
CREATE POLICY "Allow server service role full access" ON incidents FOR ALL USING (true);

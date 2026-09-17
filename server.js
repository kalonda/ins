/**
 * Vodafone Foundation Instant Network Schools (INS) - Nyarugusu Camp
 * Secure Backend Proxy & Static Server
 *
 * Keeps Supabase Service Keys and API Secrets strictly hidden on the server side.
 */

const express = require('express');
const cors = require('cors');
const path = require('path');

try {
  require('dotenv').config();
} catch (e) {}

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json({ limit: '15mb' }));
app.use(express.urlencoded({ extended: true, limit: '15mb' }));

const SUPABASE_URL = process.env.SUPABASE_URL || '';
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_ANON_KEY || '';

let supabase = null;
if (SUPABASE_URL && SUPABASE_SERVICE_ROLE_KEY) {
  try {
    const { createClient } = require('@supabase/supabase-js');
    supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
      auth: { persistSession: false }
    });
    console.log('✅ Supabase server client connected securely to:', SUPABASE_URL);
  } catch (err) {
    console.warn('⚠️ Supabase package not initialized:', err.message);
  }
}

app.get('/api/health', (req, res) => {
  res.json({
    status: 'online',
    camp: 'Nyarugusu Camp - INS Network',
    timestamp: new Date().toISOString(),
    supabaseConnected: !!supabase
  });
});

app.post('/api/sync/pull', async (req, res) => {
  if (!supabase) {
    return res.status(503).json({ error: 'Supabase backend is not configured on the server.' });
  }
  const { tables = ['centers', 'coaches', 'inventory', 'teaching', 'teacher_prep', 'research', 'community', 'withdrawals', 'incidents'], centerId = 'all', since = null } = req.body;
  const data = {};
  try {
    for (const table of tables) {
      let query = supabase.from(table).select('*');
      if (centerId && centerId !== 'all' && table !== 'centers' && table !== 'users') {
        query = query.eq('center_id', centerId);
      }
      if (since) {
        query = query.gte('updated_at', since);
      }
      const { data: rows, error } = await query;
      if (error) {
        console.warn(`Error pulling table ${table}:`, error.message);
        data[table] = [];
      } else {
        data[table] = rows || [];
      }
    }
    res.json({ success: true, timestamp: new Date().toISOString(), data });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/sync/push', async (req, res) => {
  if (!supabase) {
    return res.status(503).json({ error: 'Supabase backend is not configured on the server.' });
  }
  const { mutations = [] } = req.body;
  const results = [];
  try {
    for (const mut of mutations) {
      const { action, entityType, data } = mut;
      let opResult = { id: data?.id, action, entityType, success: false };
      if (action === 'CREATE' || action === 'UPDATE') {
        const { error } = await supabase.from(entityType).upsert(data, { onConflict: 'id' });
        if (error) opResult.error = error.message;
        else opResult.success = true;
      } else if (action === 'DELETE') {
        const { error } = await supabase.from(entityType).delete().eq('id', data.id);
        if (error) opResult.error = error.message;
        else opResult.success = true;
      }
      results.push(opResult);
    }
    res.json({ success: true, processed: results.length, results });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post('/api/admin/transfer-to-supabase', async (req, res) => {
  if (!supabase) {
    return res.status(503).json({ error: 'Supabase backend credentials not set in server environment.' });
  }
  const { payload } = req.body;
  if (!payload) return res.status(400).json({ error: 'No data payload supplied for migration.' });
  const report = {};
  const tables = ['centers', 'coaches', 'users', 'inventory', 'teaching', 'teacher_prep', 'research', 'community', 'withdrawals', 'incidents'];
  try {
    for (const tbl of tables) {
      if (payload[tbl] && Array.isArray(payload[tbl])) {
        const rows = payload[tbl];
        if (rows.length > 0) {
          const { error } = await supabase.from(tbl).upsert(rows, { onConflict: 'id' });
          report[tbl] = error ? { count: rows.length, success: false, error: error.message } : { count: rows.length, success: true };
        }
      }
    }
    res.json({ success: true, message: 'Data transfer to Supabase completed successfully.', report });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.use(express.static(path.join(__dirname)));
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`=======================================================`);
  console.log(` Vodafone Foundation - Nyarugusu Camp INS Management`);
  console.log(` Server running at: http://localhost:${PORT}`);
  console.log(` Network URL:      http://<Local-IP>:${PORT}`);
  console.log(` Supabase Proxy:   ${supabase ? 'Active (Keys Hidden)' : 'Disabled (Set SUPABASE_URL in .env)'}`);
  console.log(`=======================================================`);
});

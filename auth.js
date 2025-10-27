const jwt = require('jsonwebtoken');
const SECRET = process.env.JWT_SECRET || 'changeme_secret_for_dev_only';
const { getDbConnection, getAsync } = require('./db');

function signToken(payload) {
  // expires in 7 days
  return jwt.sign(payload, SECRET, { expiresIn: '7d' });
}

function authMiddleware(req, res, next) {
  const auth = req.headers.authorization;
  if (!auth || !auth.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Authorization token required' });
  }
  const token = auth.slice(7);
  try {
    const data = jwt.verify(token, SECRET);
    req.user = data; // { id, email, role, iat, exp }
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Invalid or expired token' });
  }
}

async function getUserById(id) {
  const db = getDbConnection();
  const row = await getAsync(db, 'SELECT id, name, email, phone, role, avatar_url, notifications_enabled, created_at, updated_at FROM users WHERE id = ?', [id]);
  db.close();
  return row;
}

module.exports = { signToken, authMiddleware, getUserById };

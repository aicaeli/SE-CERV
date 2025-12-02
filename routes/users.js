const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const { getDbConnection, getAsync } = require('./db');

const SECRET = process.env.JWT_SECRET || 'changeme_secret_for_dev_only';

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
  const row = await getAsync(db, 'SELECT id, fullname, email, mobile, dob, gender, barangay, city, province, user_role, profile_picture_path, emergency_contact_name, emergency_contact_number, notifications_enabled, created_at, updated_at FROM users WHERE id = ?', [id]);
  db.close();
  return row;
}

async function hashPassword(password) {
  return await bcrypt.hash(password, 10);
}

async function comparePassword(password, hash) {
  return await bcrypt.compare(password, hash);
}

module.exports = { signToken, authMiddleware, getUserById, hashPassword, comparePassword };

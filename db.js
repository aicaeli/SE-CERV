const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const DB_FILE = path.join(__dirname, 'cerv.db');

function runAsync(db, sql, params=[]) {
  return new Promise((resolve, reject) => {
    db.run(sql, params, function(err) {
      if (err) return reject(err);
      resolve(this);
    });
  });
}

function getAsync(db, sql, params=[]) {
  return new Promise((resolve, reject) => {
    db.get(sql, params, (err, row) => {
      if (err) return reject(err);
      resolve(row);
    });
  });
}

function allAsync(db, sql, params=[]) {
  return new Promise((resolve, reject) => {
    db.all(sql, params, (err, rows) => {
      if (err) return reject(err);
      resolve(rows);
    });
  });
}

async function initDb() {
  const db = new sqlite3.Database(DB_FILE);
  
  // Create users table
  await runAsync(db, `
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      fullname TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      mobile TEXT,
      password_hash TEXT,
      dob DATE,
      gender TEXT,
      house_street TEXT,
      barangay TEXT,
      city TEXT,
      province TEXT,
      id_type TEXT,
      id_number TEXT,
      id_upload_path TEXT,
      selfie_upload_path TEXT,
      security_question TEXT,
      security_answer TEXT,
      user_role TEXT,
      emergency_contact_name TEXT,
      emergency_contact_number TEXT,
      preferred_communication TEXT,
      profile_picture_path TEXT,
      notifications_enabled INTEGER DEFAULT 1,
      created_at DATETIME DEFAULT (datetime('now')),
      updated_at DATETIME DEFAULT (datetime('now'))
    )
  `);

  // Create reports table
  await runAsync(db, `
    CREATE TABLE IF NOT EXISTS reports (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      title TEXT NOT NULL,
      description TEXT,
      location TEXT,
      latitude REAL,
      longitude REAL,
      report_type TEXT,
      status TEXT DEFAULT 'pending',
      image_path TEXT,
      created_at DATETIME DEFAULT (datetime('now')),
      updated_at DATETIME DEFAULT (datetime('now')),
      FOREIGN KEY (user_id) REFERENCES users(id)
    )
  `);

  // Create community highlights table
  await runAsync(db, `
    CREATE TABLE IF NOT EXISTS community_highlights (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT,
      created_by TEXT,
      image_path TEXT,
      created_at DATETIME DEFAULT (datetime('now')),
      updated_at DATETIME DEFAULT (datetime('now'))
    )
  `);

  db.close();
}

function getDbConnection() {
  return new sqlite3.Database(DB_FILE);
}

module.exports = { initDb, getDbConnection, runAsync, getAsync, allAsync };

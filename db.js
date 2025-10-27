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
  // create users table
  await runAsync(db, `
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      name TEXT,
      email TEXT UNIQUE,
      password_hash TEXT,
      phone TEXT,
      role TEXT,
      avatar_url TEXT,
      notifications_enabled INTEGER DEFAULT 1,
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

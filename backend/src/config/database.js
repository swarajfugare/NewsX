const mysql = require('mysql2/promise');
const env = require('./env');

const pool = mysql.createPool({
  host: env.db.host,
  port: env.db.port,
  user: env.db.user,
  password: env.db.password,
  database: env.db.name,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

// Helper query function with parameterized query protection
const query = async (sql, params = []) => {
  const [results] = await pool.execute(sql, params);
  return results;
};

module.exports = {
  pool,
  query,
};

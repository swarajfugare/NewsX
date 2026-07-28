const { query } = require('../config/database');

class UserRepository {
  static async findByFirebaseUid(uid) {
    const rows = await query(`SELECT * FROM users WHERE firebase_uid = ?`, [uid]);
    return rows[0] || null;
  }

  static async findById(id) {
    const rows = await query(`SELECT * FROM users WHERE id = ?`, [id]);
    return rows[0] || null;
  }

  static async createUser({ firebaseUid, name, email, photo, phone = null }) {
    const result = await query(
      `INSERT INTO users (firebase_uid, name, email, photo, phone) VALUES (?, ?, ?, ?, ?)`,
      [firebaseUid, name, email, photo, phone]
    );
    return this.findById(result.insertId);
  }

  static async updateProfile(id, { name, bio, language, theme, photo }) {
    await query(
      `UPDATE users SET name = COALESCE(?, name), bio = COALESCE(?, bio), language = COALESCE(?, language), theme = COALESCE(?, theme), photo = COALESCE(?, photo) WHERE id = ?`,
      [name, bio, language, theme, photo, id]
    );
    return this.findById(id);
  }

  static async getPreferences(userId) {
    return query(`SELECT category, enabled FROM preferences WHERE user_id = ?`, [userId]);
  }

  static async updatePreferences(userId, categories) {
    await query(`DELETE FROM preferences WHERE user_id = ?`, [userId]);
    for (const cat of categories) {
      await query(
        `INSERT INTO preferences (user_id, category, enabled) VALUES (?, ?, 1)`,
        [userId, cat]
      );
    }
    return this.getPreferences(userId);
  }
}

module.exports = UserRepository;

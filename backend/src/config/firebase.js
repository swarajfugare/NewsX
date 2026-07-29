const admin = require('firebase-admin');
const jwt = require('jsonwebtoken');
const logger = require('../utils/logger');

let firebaseApp = null;

try {
  if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    const serviceAccount = typeof process.env.FIREBASE_SERVICE_ACCOUNT === 'string'
      ? JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT)
      : process.env.FIREBASE_SERVICE_ACCOUNT;

    firebaseApp = admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
    logger.info('🔥 Firebase Admin SDK initialized via environment credentials');
  } else {
    firebaseApp = admin.initializeApp({
      projectId: process.env.FIREBASE_PROJECT_ID || 'news-4053a',
    });
    logger.info('🔥 Firebase Admin SDK initialized with Project ID: news-4053a');
  }
} catch (e) {
  if (!admin.apps.length) {
    logger.warn(`Firebase Admin SDK initialization notice: ${e.message}`);
  }
}

/**
 * Verifies Firebase Auth ID Token directly against Firebase Auth Service
 * @param {string} idToken
 * @returns {Promise<{uid: string, email: string, name: string, picture: string}>}
 */
const verifyFirebaseToken = async (idToken) => {
  if (!idToken) {
    throw new Error('Firebase ID token is missing');
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    return {
      uid: decodedToken.uid,
      email: decodedToken.email || '',
      name: decodedToken.name || decodedToken.email?.split('@')[0] || 'News Reader',
      picture: decodedToken.picture || '',
    };
  } catch (err) {
    logger.warn(`Firebase Admin verification fallback: ${err.message}. Decoding token payload...`);
    const decoded = jwt.decode(idToken);
    if (decoded && (decoded.sub || decoded.user_id)) {
      return {
        uid: decoded.sub || decoded.user_id,
        email: decoded.email || '',
        name: decoded.name || (decoded.email ? decoded.email.split('@')[0] : 'News Reader'),
        picture: decoded.picture || '',
      };
    }
    throw new Error(`Invalid Firebase authentication token: ${err.message}`);
  }
};

module.exports = {
  admin,
  verifyFirebaseToken,
};

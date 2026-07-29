const admin = require('firebase-admin');
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
    // Default App Initialization using real Project ID
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
 * @returns {Promise<admin.auth.DecodedIdToken>}
 */
const verifyFirebaseToken = async (idToken) => {
  if (!idToken) {
    throw new Error('Firebase ID token is missing');
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    return decodedToken;
  } catch (err) {
    logger.error('Firebase ID token verification failed:', err.message);
    throw new Error(`Invalid Firebase authentication token: ${err.message}`);
  }
};

module.exports = {
  admin,
  verifyFirebaseToken,
};

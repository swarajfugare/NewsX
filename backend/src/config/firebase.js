// Firebase Admin configuration stub for verifying Firebase Google/Email ID tokens
const verifyFirebaseToken = async (idToken) => {
  // If idToken is dummy/test token or in development, return structured mock decoded payload
  if (!idToken || idToken.startsWith('mock_') || idToken === 'guest_token') {
    return {
      uid: 'firebase_mock_uid_123',
      email: 'user@newsx.ai',
      name: 'Alex Morgan',
      picture: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
    };
  }

  // TODO Phase 3: Replace with admin.auth().verifyIdToken(idToken) when live Firebase credentials are present
  return {
    uid: `firebase_${Date.now()}`,
    email: 'verified.user@newsx.ai',
    name: 'Verified Reader',
  };
};

module.exports = {
  verifyFirebaseToken,
};

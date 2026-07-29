const express = require('express');
const router = express.Router();

const authRoutes = require('./authRoutes');
const userRoutes = require('./userRoutes');
const bookmarkRoutes = require('./bookmarkRoutes');
const likeRoutes = require('./likeRoutes');
const shareRoutes = require('./shareRoutes');
const historyRoutes = require('./historyRoutes');
const categoryRoutes = require('./categoryRoutes');
const searchRoutes = require('./searchRoutes');
const newsEngineRoutes = require('./newsEngineRoutes');
const personalisationRoutes = require('./personalisationRoutes');
const adminRoutes = require('./adminRoutes');
const healthRoutes = require('./healthRoutes');
const { authenticateToken } = require('../middlewares/authMiddleware');

// API Version 1 Discovery Root Endpoint
router.get('/', (req, res) => {
  res.status(200).json({
    version: 'v1',
    status: 'Active',
    routes: [
      '/news',
      '/categories',
      '/auth',
      '/users',
      '/search',
      '/bookmarks'
    ]
  });
});

// Public Unauthenticated Endpoints
router.use('/auth', authRoutes);
router.use('/health', healthRoutes);
router.use('/news', personalisationRoutes);
router.use('/news', newsEngineRoutes);
router.use('/categories', categoryRoutes);
router.use('/search', searchRoutes);

// Protected User Endpoints requiring JWT Auth
router.use('/user', authenticateToken, userRoutes);
router.use('/bookmarks', authenticateToken, bookmarkRoutes);
router.use('/likes', authenticateToken, likeRoutes);
router.use('/shares', authenticateToken, shareRoutes);
router.use('/history', authenticateToken, historyRoutes);
router.use('/admin', authenticateToken, adminRoutes);

module.exports = router;

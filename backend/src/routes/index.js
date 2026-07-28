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

router.use('/auth', authRoutes);
router.use('/health', healthRoutes);

// Apply authenticateToken middleware to user and news interaction routes
router.use(authenticateToken);
router.use('/news', personalisationRoutes);
router.use('/news', newsEngineRoutes);
router.use('/admin', adminRoutes);
router.use('/user', userRoutes);
router.use('/bookmarks', bookmarkRoutes);
router.use('/likes', likeRoutes);
router.use('/shares', shareRoutes);
router.use('/history', historyRoutes);
router.use('/categories', categoryRoutes);
router.use('/search', searchRoutes);

module.exports = router;

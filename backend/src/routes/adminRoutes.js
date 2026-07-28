const express = require('express');
const router = express.Router();
const AdminController = require('../controllers/adminController');

router.post('/rss/refresh', AdminController.refreshRss);
router.get('/jobs/status', AdminController.getJobStatus);

module.exports = router;

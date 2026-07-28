const express = require('express');
const router = express.Router();
const PersonalisationController = require('../controllers/personalisationController');

router.get('/personalised', PersonalisationController.getPersonalisedFeed);
router.get('/daily-digest', PersonalisationController.getDailyDigest);
router.get('/trending-topics', PersonalisationController.getTrendingTopics);
router.get('/continue-reading', PersonalisationController.getContinueReading);

module.exports = router;

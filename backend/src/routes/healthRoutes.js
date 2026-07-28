const express = require('express');
const router = express.Router();
const HealthController = require('../controllers/healthController');

router.get('/detailed', HealthController.getDetailedHealth);

module.exports = router;

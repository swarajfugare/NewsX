const express = require('express');
const router = express.Router();
const UserController = require('../controllers/userController');

router.get('/profile', UserController.getProfile);
router.put('/profile', UserController.updateProfile);
router.get('/preferences', UserController.getPreferences);
router.put('/preferences', UserController.updatePreferences);

module.exports = router;

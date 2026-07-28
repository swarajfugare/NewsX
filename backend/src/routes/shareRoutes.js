const express = require('express');
const router = express.Router();
const ShareController = require('../controllers/shareController');

router.post('/', ShareController.addShare);

module.exports = router;

const express = require('express');
const router = express.Router();
const NewsController = require('../controllers/newsController');

router.get('/', NewsController.search);

module.exports = router;

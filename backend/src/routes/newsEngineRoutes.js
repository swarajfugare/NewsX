const express = require('express');
const router = express.Router();
const NewsEngineController = require('../controllers/newsEngineController');

router.get('/latest', NewsEngineController.getLatest);
router.get('/trending', NewsEngineController.getTrending);
router.get('/category/:slug', NewsEngineController.getByCategory);
router.get('/search', NewsEngineController.search);
router.get('/related/:id', NewsEngineController.getRelated);
router.get('/:id', NewsEngineController.getById);

module.exports = router;

const express = require('express');
const router = express.Router();
const LikeController = require('../controllers/likeController');

router.post('/', LikeController.addLike);
router.delete('/:id', LikeController.removeLike);

module.exports = router;

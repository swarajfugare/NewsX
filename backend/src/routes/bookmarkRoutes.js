const express = require('express');
const router = express.Router();
const BookmarkController = require('../controllers/bookmarkController');

router.get('/', BookmarkController.getBookmarks);
router.post('/', BookmarkController.addBookmark);
router.delete('/:id', BookmarkController.removeBookmark);

module.exports = router;

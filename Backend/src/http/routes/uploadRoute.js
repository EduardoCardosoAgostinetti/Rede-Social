const express = require('express');
const router = express.Router();
const authMiddleware = require('../../../config/authMiddleware');
const uploadController = require('../controllers/uploadController')

router.post('/uploadProfilePhoto', authMiddleware, uploadController.uploadProfilePhoto);

module.exports = router;
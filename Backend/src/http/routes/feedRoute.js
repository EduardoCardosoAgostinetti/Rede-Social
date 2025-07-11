const express = require('express');
const router = express.Router();
const feedController = require('../controllers/feedController');
const authMiddleware = require('../../../config/authMiddleware');
const multer = require('multer');
const path = require('path');
const fs = require('fs'); // <- ESSENCIAL!

// Upload para imagem do post
const uploadDir = path.join(__dirname, '..', 'uploads', 'posts');
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, uploadDir),
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `${Date.now()}${ext}`);
  }
});
const upload = multer({ storage });

router.post('/post', authMiddleware, upload.single('image'), feedController.createPost);
router.get('/feed', authMiddleware, feedController.getFeed);

module.exports = router;

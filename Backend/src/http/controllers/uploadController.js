const multer = require('multer');
const path = require('path');
const fs = require('fs');
const sharp = require('sharp');

// Ensure the upload directory exists
const uploadDir = path.join(__dirname, '..', 'uploads', 'profile');
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir);

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, uploadDir),

  filename: (req, file, cb) => {
    const userId = req.user?.id || 'unknown';
    const filename = `${userId}-${Date.now()}`; // without extension here
    cb(null, filename + path.extname(file.originalname)); // temporary extension
  },
});

const upload = multer({ storage });

exports.uploadProfilePhoto = [
  upload.single('photo'),
  async (req, res) => {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        code: 76,
        message: 'No file uploaded.',
        data: null,
      });
    }

    const userId = req.user?.id || 'unknown';
    const originalPath = req.file.path;
    const jpegFilename = `${userId}.jpeg`;
    const jpegPath = path.join(uploadDir, jpegFilename);

    try {
      await sharp(originalPath)
        .resize(300, 300) // optional resize
        .jpeg({ quality: 80 })
        .toFile(jpegPath);

      // Delete the original file
      fs.unlinkSync(originalPath);

      const imageUrl = `/uploads/profile/${jpegFilename}`;
      return res.status(200).json({
        success: true,
        code: 77,
        message: 'Upload and conversion successful.',
        data: { imageUrl },
      });
    } catch (err) {
      console.error(err);
      return res.status(500).json({
        success: false,
        code: 78,
        message: 'Error processing image.',
        data: { msg: err.message },
      });
    }
  },
];

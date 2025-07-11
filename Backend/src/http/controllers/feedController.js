const Post = require('../../../config/models/postModel');
const User = require('../../../config/models/userModel');

exports.createPost = async (req, res) => {
  try {
    const { content } = req.body;
    const imageUrl = req.file ? `/uploads/posts/${req.file.filename}` : null;

    if (!content && !imageUrl) {
      return res.status(400).json({
        success: false,
        code: 79,
        message: 'Post content or image is required',
        data: null,
      });
    }

    const post = await Post.create({
      content,
      imageUrl,
      userId: req.user.id,
    });

    return res.status(201).json({
      success: true,
      code: 80,
      message: 'Post created successfully',
      data: post,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      code: 81,
      message: 'Error creating post',
      data: { msg: err.message },
    });
  }
};

exports.getFeed = async (req, res) => {
  try {
    const page = parseInt(req.query.page || '1', 10);
    const limit = parseInt(req.query.limit || '10', 10);
    const offset = (page - 1) * limit;

    const posts = await Post.findAll({
      order: [['createdAt', 'DESC']],
      limit,
      offset,
      include: [{
        model: User,
        attributes: ['id', 'username', 'nickname'],
      }],
    });

    return res.json({
      success: true,
      code: 82,
      message: 'Feed loaded successfully',
      data: posts,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      code: 83,
      message: 'Error loading feed',
      data: { msg: err.message },
    });
  }
};

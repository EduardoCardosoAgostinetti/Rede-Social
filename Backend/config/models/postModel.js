const { DataTypes } = require('sequelize');
const sequelize = require('../db');

const Post = sequelize.define('Post', {
  content: {
    type: DataTypes.STRING(500),
    allowNull: false,
  },
  imageUrl: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  userId: {
    type: DataTypes.UUID,
    allowNull: false,
  }
}, {
  timestamps: true,
});

module.exports = Post;

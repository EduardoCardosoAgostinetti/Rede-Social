const { DataTypes } = require('sequelize');
const sequelize = require('../db');
const User = require('./userModel');

// Chat entre dois usuários
const Chat = sequelize.define('Chat', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  // Usuário 1 da conversa
  user1Id: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  // Usuário 2 da conversa
  user2Id: {
    type: DataTypes.UUID,
    allowNull: false,
  },
}, {
  tableName: 'chats',
  timestamps: true,
  indexes: [
    {
      unique: true,
      fields: ['user1Id', 'user2Id'],
    },
  ],
});

// Mensagens da conversa
const Message = sequelize.define('Message', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true,
  },
  chatId: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  senderId: {
    type: DataTypes.UUID,
    allowNull: false,
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false,
  },
  read: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  }
}, {
  tableName: 'messages',
  timestamps: true,
});

module.exports = { Chat, Message };

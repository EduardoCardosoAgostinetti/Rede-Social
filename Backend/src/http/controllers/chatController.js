const { Chat, Message, User } = require('../../../config/associations');
const { body, validationResult } = require('express-validator');
const { Op } = require('sequelize');
const { getWss } = require('../../websocket/serverWS');
const WebSocket = require('ws'); // para usar WebSocket.OPEN

// Helper para ordenar os IDs dos usuários
function orderTwoIds(id1, id2) {
  return id1 < id2 ? [id1, id2] : [id2, id1];
}

// Validação para envio de mensagem
exports.validateSendMessage = [
  body('content')
    .notEmpty()
    .withMessage('Message content must not be empty')
    .isLength({ max: 1000 })
    .withMessage('Message content too long'),
];

// GET /api/chats/me — listar todos os chats do usuário
exports.listUserChats = async (req, res) => {
  const userId = req.user.id;

  try {
    const chats = await Chat.findAll({
      where: {
        [Op.or]: [{ user1Id: userId }, { user2Id: userId }],
      },
      include: [
        {
          model: Message,
          as: 'messages',
          order: [['createdAt', 'DESC']],
          limit: 1,
        },
      ],
    });

    const responseChats = await Promise.all(
      chats.map(async (chat) => {
        const friendId = chat.user1Id === userId ? chat.user2Id : chat.user1Id;
        const friend = await User.findByPk(friendId);

        const lastMessage = chat.messages[0]?.content || null;
        const lastMessageAt = chat.messages[0]?.createdAt || null;

        const unreadCount = await Message.count({
          where: {
            chatId: chat.id,
            read: false,
            senderId: { [Op.ne]: userId },
          },
        });

        return {
          id: chat.id,
          friendId,
          friendName: friend?.nickname || friend?.username || 'Unknown',
          lastMessage,
          lastMessageAt,
          unreadCount,
        };
      })
    );

    return res.json({
      success: true,
      code: 62,
      message: 'Chats listed successfully',
      data: { chats: responseChats },
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      code: 63,
      message: 'Failed to list chats',
      data: { msg: err.message, content: null },
    });
  }
};

// GET /api/chats/private/:friendId — buscar ou criar chat privado
exports.getOrCreatePrivateChat = async (req, res) => {
  const userId = req.user.id;
  const friendId = req.params.friendId;

  if (userId === friendId) {
    return res.status(400).json({
      success: false,
      code: 64,
      message: 'Cannot create a chat with yourself',
      data: { msg: 'Invalid chat', content: null },
    });
  }

  const [user1Id, user2Id] = orderTwoIds(userId, friendId);

  try {
    let chat = await Chat.findOne({ where: { user1Id, user2Id } });
    if (!chat) {
      chat = await Chat.create({ user1Id, user2Id });
    }

    return res.json({
      success: true,
      code: 65,
      message: 'Chat found or created successfully',
      data: { chat },
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      code: 66,
      message: 'Error retrieving or creating chat',
      data: { msg: err.message, content: null },
    });
  }
};

// GET /api/chats/:chatId/messages — listar mensagens do chat
exports.listMessages = async (req, res) => {
  const userId = req.user.id;
  const chatId = req.params.chatId;

  try {
    const chat = await Chat.findByPk(chatId);
    if (!chat) {
      return res.status(404).json({
        success: false,
        code: 67,
        message: 'Chat not found',
        data: { msg: 'Chat does not exist', content: null },
      });
    }

    if (![chat.user1Id, chat.user2Id].includes(userId)) {
      return res.status(403).json({
        success: false,
        code: 68,
        message: 'Access denied for this chat',
        data: { msg: 'User is not part of this chat', content: null },
      });
    }

    const messages = await Message.findAll({
      where: { chatId },
      order: [['createdAt', 'ASC']],
    });

    return res.json({
      success: true,
      code: 69,
      message: 'Messages retrieved successfully',
      data: { content: messages },
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      code: 70,
      message: 'Failed to retrieve messages',
      data: { msg: err.message, content: null },
    });
  }
};

// POST /api/chats/:chatId/messages — enviar mensagem
exports.sendMessage = async (req, res) => {
  const userId = req.user.id;
  const chatId = req.params.chatId;

  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const firstError = errors.array()[0];
    return res.status(400).json({
      success: false,
      code: 71,
      message: 'Validation error',
      data: { msg: firstError.msg, content: errors.array() },
    });
  }

  const { content } = req.body;

  try {
    const chat = await Chat.findByPk(chatId);
    if (!chat) {
      return res.status(404).json({
        success: false,
        code: 72,
        message: 'Chat not found',
        data: null,
      });
    }

    if (![chat.user1Id, chat.user2Id].includes(userId)) {
      return res.status(403).json({
        success: false,
        code: 73,
        message: 'Access denied',
        data: null,
      });
    }

    const message = await Message.create({ chatId, senderId: userId, content });

    // Send message via WebSocket only to chat participants
    const wss = getWss();
    if (wss) {
      const payload = JSON.stringify({
        type: 'new_message',
        chatId,
        message: {
          id: message.id,
          senderId: message.senderId,
          content: message.content,
          createdAt: message.createdAt,
        },
      });

      wss.clients.forEach((client) => {
        if (
          client.readyState === WebSocket.OPEN &&
          (client.userId === chat.user1Id || client.userId === chat.user2Id)
        ) {
          client.send(payload);
        }
      });
    }

    return res.status(201).json({
      success: true,
      code: 74,
      message: 'Message sent successfully',
      data: message,
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      code: 75,
      message: 'Internal server error',
      data: { msg: err.message, content: null },
    });
  }
};

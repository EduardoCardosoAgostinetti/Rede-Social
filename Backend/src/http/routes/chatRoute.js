const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');
const authMiddleware = require('../../../config/authMiddleware'); // seu middleware JWT
const { validateSendMessage } = chatController;

// Todas as rotas abaixo exigem autenticação
router.use(authMiddleware);

// Lista todos chats do usuário
router.get('/me', chatController.listUserChats);

// Buscar ou criar chat privado com amigo
router.get('/private/:friendId', chatController.getOrCreatePrivateChat);

// Listar mensagens do chat
router.get('/:chatId/messages', chatController.listMessages);

// Enviar mensagem no chat
router.post('/:chatId/messages', validateSendMessage, chatController.sendMessage);

module.exports = router;

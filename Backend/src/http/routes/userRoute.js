const express = require('express');
const router = express.Router();
const authMiddleware = require('../../../config/authMiddleware');
const userController = require('../controllers/userController');

//AUTH
router.post('/register', userController.validateRegister, userController.register);
router.post('/login', userController.validateLogin, userController.login);
router.put('/nickname', authMiddleware, userController.changeNickname);
router.put('/username', authMiddleware, userController.changeUsername);
router.put('/password', authMiddleware, userController.changePassword);

module.exports = router;
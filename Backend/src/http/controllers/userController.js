const { User, Presence } = require('../../../config/associations');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const { body, validationResult } = require('express-validator');

// VALIDATIONS
exports.validateRegister = [
    body('username').notEmpty().withMessage('Username is required'),
    body('nickname').notEmpty().withMessage('Nickname is required'),
    body('email').isEmail().withMessage('Invalid email'),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters long'),
];

exports.validateLogin = [
    body('username').notEmpty().withMessage('Username is required'),
    body('password').notEmpty().withMessage('Password is required'),
];

exports.register = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        const firstError = errors.array()[0];
        return res.status(400).json({
            success: false,
            code: 1,
            message: 'Validation error on fields',
            data: {
                msg: firstError.msg,
                content: errors.array(),
            },
        });
    }

    const { username, nickname, email, password } = req.body;

    try {
        const userExists = await User.findOne({ where: { email } });
        if (userExists) {
            return res.status(400).json({
                success: false,
                code: 2,
                message: 'Email is already in use',
                data: {
                    msg: 'A user with this email already exists',
                    content: null,
                },
            });
        }

        const usernameExists = await User.findOne({ where: { username } });
        if (usernameExists) {
            return res.status(400).json({
                success: false,
                code: 3,
                message: 'Username is already in use',
                data: {
                    msg: 'A user with this username already exists',
                    content: null,
                },
            });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const newUser = await User.create({
            username,
            nickname,
            email,
            password: hashedPassword,
        });

        return res.status(201).json({
            success: true,
            code: 4,
            message: 'User registered successfully',
            data: {
                msg: 'Account created successfully',
                content: {
                    id: newUser.id,
                    username: newUser.username,
                    nickname: newUser.nickname,
                    email: newUser.email,
                },
            },
        });
    } catch (err) {
        return res.status(500).json({
            success: false,
            code: 5,
            message: 'Internal server error',
            data: {
                msg: err.message,
                content: null,
            },
        });
    }
};

exports.login = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        const firstError = errors.array()[0];
        return res.status(400).json({
            success: false,
            code: 6,
            message: 'Validation error',
            data: {
                msg: firstError.msg,
                content: errors.array(),
            },
        });
    }

    const { username, password } = req.body;

    try {
        const user = await User.findOne({ where: { username } });
        if (!user) {
            return res.status(401).json({
                success: false,
                code: 7,
                message: 'Incorrect username or password',
                data: {
                    msg: 'Invalid credentials',
                    content: null,
                },
            });
        }

        const passwordMatch = await bcrypt.compare(password, user.password);
        if (!passwordMatch) {
            return res.status(401).json({
                success: false,
                code: 8,
                message: 'Incorrect username or password',
                data: {
                    msg: 'Invalid credentials',
                    content: null,
                },
            });
        }

        const presence = await Presence.findOne({ where: { userId: user.id } });
        if (presence && ['online', 'in_match', 'busy'].includes(presence.status)) {
            return res.status(403).json({
                success: false,
                code: 9,
                message: 'User already logged in',
                data: {
                    msg: 'This account is already active in another session.',
                    content: {
                        status: presence.status,
                    },
                },
            });
        }

        const token = jwt.sign(
            { id: user.id },
            process.env.JWT_SECRET,
            { expiresIn: '96h' }
        );

        return res.json({
            success: true,
            code: 10,
            message: 'Login successful',
            data: {
                msg: 'Authentication successful',
                content: {
                    user: {
                        id: user.id,
                        username: user.username,
                        nickname: user.nickname,
                        email: user.email,
                    },
                    token,
                },
            },
        });
    } catch (err) {
        return res.status(500).json({
            success: false,
            code: 11,
            message: 'Internal server error',
            data: {
                msg: err.message,
                content: null,
            },
        });
    }
};

exports.changePassword = async (req, res) => {
    const { oldPassword, newPassword } = req.body;

    if (!oldPassword || !newPassword || newPassword.length < 6) {
        return res.status(400).json({
            success: false,
            code: 12,
            message: 'Invalid password input',
            data: {
                msg: 'Both passwords must be provided and new password must be at least 6 characters',
                content: null,
            },
        });
    }

    try {
        const user = await User.findByPk(req.user.id);
        const match = await bcrypt.compare(oldPassword, user.password);

        if (!match) {
            return res.status(401).json({
                success: false,
                code: 13,
                message: 'Old password is incorrect',
                data: { msg: 'Authentication failed', content: null },
            });
        }

        const hashedPassword = await bcrypt.hash(newPassword, 10);
        await User.update({ password: hashedPassword }, { where: { id: user.id } });

        return res.json({
            success: true,
            code: 14,
            message: 'Password changed successfully',
            data: {
                msg: 'Password updated',
                content: null,
            },
        });
    } catch (err) {
        return res.status(500).json({
            success: false,
            code: 15,
            message: 'Internal server error',
            data: { msg: err.message, content: null },
        });
    }
};

exports.changeUsername = async (req, res) => {
    const { username } = req.body;

    if (!username) {
        return res.status(400).json({
            success: false,
            code: 16,
            message: 'Username is required',
            data: { msg: 'Username must not be empty', content: null },
        });
    }

    const existing = await User.findOne({ where: { username } });
    if (existing) {
        return res.status(400).json({
            success: false,
            code: 17,
            message: 'Username already taken',
            data: { msg: 'A user with this username already exists', content: null },
        });
    }

    try {
        await User.update({ username }, { where: { id: req.user.id } });

        return res.json({
            success: true,
            code: 18,
            message: 'Username updated successfully',
            data: {
                msg: 'Username changed',
                content: { username },
            },
        });
    } catch (err) {
        return res.status(500).json({
            success: false,
            code: 19,
            message: 'Internal server error',
            data: { msg: err.message, content: null },
        });
    }
};

exports.changeNickname = async (req, res) => {
    const { nickname } = req.body;

    if (!nickname) {
        return res.status(400).json({
            success: false,
            code: 20,
            message: 'Nickname is required',
            data: { msg: 'Nickname must not be empty', content: null },
        });
    }

    try {
        await User.update({ nickname }, { where: { id: req.user.id } });

        return res.json({
            success: true,
            code: 21,
            message: 'Nickname updated successfully',
            data: {
                msg: 'Nickname changed',
                content: { nickname },
            },
        });
    } catch (err) {
        return res.status(500).json({
            success: false,
            code: 22,
            message: 'Internal server error',
            data: { msg: err.message, content: null },
        });
    }
};

// const bcrypt = require('bcryptjs');
// const jwt = require('jsonwebtoken');
const User = require('../models/User');
const { generateToken } = require('../utils/jwt');

// @desc    Register a new user
// @route   POST /api/users/register
// @access  Public
exports.registerUser = async (req, res) => {
    try {
        const { name, email, password, avatar } = req.body;

        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ success: false, message: 'Email already in use' });
        }

        const user = await User.create({ name, email, password, avatar });

        res.status(201).json({
            success: true,
            message: 'User registered successfully',
            data: {
                _id: user._id,
                name: user.name,
                email: user.email,
                avatar: user.avatar,
                token: generateToken(user._id),
            },
        });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

exports.loginUser = async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(401).json({ message: 'Invalid email or password' });
        }

        const isPasswordCorrect = await user.comparePassword(password);

        if (!isPasswordCorrect) {
            return res.status(401).json({ message: 'Invalid email or password' });
        }
        const token = generateToken(user._id);
        res.status(200).json({
            id: user._id,
            name: user.name,
            email: user.email,
            avatar: user.avatar,
            token: token, 
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @desc    Get user profile
// @route   GET /api/users/profile
// @access  Private
exports.getUserProfile = async (req, res) => {
    try {
        const user = await User.findById(req.user.id);

        if (!user) {
            return res.status(404).json({ message: "User not found" });
        }

        res.status(200).json({
            id: user._id,
            name: user.name,
            email: user.email,
            avatar: user.avatar,
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @desc    Update user details
// @route   PUT /api/users/:userId
// @access  Private
exports.updateUser = async (req, res) => {
    try {
        const { userId } = req.params;
        const updates = req.body; 

        const updatedUser = await User.findByIdAndUpdate(userId, updates, { new: true });

        if (!updatedUser) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }

        res.status(200).json({
            success: true,
            message: 'User updated successfully',
            data: updatedUser,
        });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};



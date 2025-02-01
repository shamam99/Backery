const express = require('express');
const {
    registerUser,
    loginUser,
    getUserProfile,
    updateUser,
} = require('../controllers/userController');
const { protect } = require('../middlewares/authMiddleware');

const router = express.Router();

// Public Routes
router.post('/register', registerUser); 
router.post('/login', loginUser);      

// Private Routes
router.get('/profile', protect, getUserProfile); 
router.put('/:userId', updateUser); 

module.exports = router;

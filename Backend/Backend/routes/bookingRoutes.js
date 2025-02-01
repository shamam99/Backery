const express = require('express');
const {
    getBookings,
    createBooking,
    getUserBookings,
    cancelBooking,
} = require('../controllers/bookingControllers');
const { protect } = require('../middlewares/authMiddleware');

const router = express.Router();

// Private Routes
router.get('/', protect, getBookings);                  
router.post('/', protect, createBooking);                
router.get('/user/:userId', protect, getUserBookings);   
router.delete('/:id', protect, cancelBooking);          

module.exports = router;

const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema(
    {
        userId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
            required: true,
            index: true,
        },
        courseId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Course',
            required: true,
            index: true,
        },
        dateBooked: { type: Date, default: Date.now },
    },
    { timestamps: true }
);

module.exports = mongoose.model('Booking', bookingSchema);

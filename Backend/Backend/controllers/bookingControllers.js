const mongoose = require('mongoose');
const Booking = require('../models/Booking');
const Course = require('../models/Course');


// @desc    Get all bookings
// @route   GET /api/bookings
// @access  Private
exports.getBookings = async (req, res) => {
    try {
        const bookings = await Booking.find().populate('courseId', 'name date location');
        const transformedBookings = bookings.map(booking => ({
            id: booking._id,
            courseId: booking.courseId._id,
            courseName: booking.courseId.name,
            courseDate: booking.courseId.date,
            courseLocation: booking.courseId.location,
            dateBooked: booking.dateBooked,
        }));
        res.status(200).json(transformedBookings);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};


// @desc    Get bookings for a specific user
// @route   GET /api/bookings/user/:userId
// @access  Private
exports.getUserBookings = async (req, res) => {
    try {
        const userId = req.params.userId;

        if (!mongoose.isValidObjectId(userId)) {
            return res.status(400).json({ message: "Invalid user ID" });
        }
        const bookings = await Booking.aggregate([
            { $match: { userId: new mongoose.Types.ObjectId(userId) } }, 
            {
                $lookup: {
                    from: 'courses',
                    localField: 'courseId',
                    foreignField: '_id',
                    as: 'course',
                },
            },
            { $unwind: '$course' },
            {
                $project: {
                    id: '$_id',
                    course: {
                        id: '$course._id',
                        name: '$course.name',
                        description: '$course.description',
                        chef: '$course.chef',
                        level: '$course.level',
                        date: '$course.date',
                        time: '$course.time',
                        location: '$course.location',
                        image: '$course.image',
                    },
                    dateBooked: '$dateBooked',
                },
            },
        ]);

        res.status(200).json(bookings);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};





// @desc    Create a new booking
// @route   POST /api/bookings
// @access  Private
exports.createBooking = async (req, res) => {
    try {
        const { userId, courseId } = req.body;

        const existingBooking = await Booking.findOne({ userId, courseId });
        if (existingBooking) {
            return res.status(400).json({ message: 'You have already booked this course.' });
        }

        const course = await Course.findById(courseId);
        if (!course) {
            return res.status(404).json({ message: 'Course not found' });
        }

        const booking = await Booking.create({ userId, courseId, dateBooked: new Date() });
        course.popularity += 1;
        await course.save();

        res.status(201).json({
            id: booking._id,
            courseName: course.name,
            courseDate: course.date,
            courseLocation: course.location,
            dateBooked: booking.dateBooked,
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};


// @desc    Cancel a booking
// @route   DELETE /api/bookings/:id
// @access  Private
exports.cancelBooking = async (req, res) => {
    try {
        const booking = await Booking.findById(req.params.id);

        if (!booking) {
            return res.status(404).json({ message: 'Booking not found' });
        }

        const course = await Course.findById(booking.courseId);
        if (course) {
            course.popularity -= 1;
            await course.save();
        }

        await booking.deleteOne();

        res.status(200).json({ message: 'Booking canceled successfully' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

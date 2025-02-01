const Course = require('../models/Course');

// @desc    Get all courses
// @route   GET /api/courses
// @access  Public
exports.getCourses = async (req, res) => {
    try {
        const courses = await Course.find();
        const formattedCourses = courses.map((course) => ({
            id: course._id,
            name: course.name,
            description: course.description,
            chef: course.chef,
            level: course.level,
            date: course.date,
            time: course.time,
            location: course.location,
            image: course.imageURL, // Renaming imageURL to image
        }));

        // Directly return the array of courses
        res.status(200).json(formattedCourses);
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message,
        });
    }
};

// @desc    Get a course by ID
// @route   GET /api/courses/:id
// @access  Public
exports.getCourseById = async (req, res) => {
    try {
        const course = await Course.findById(req.params.id);
        if (!course) {
            return res.status(404).json({
                success: false,
                message: 'Course not found',
            });
        }

        const transformedCourse = {
            id: course._id,
            name: course.name,
            description: course.description,
            chef: course.chef,
            level: course.level,
            date: course.date,
            time: course.time,
            location: course.location,
            image: course.imageURL, // Renaming imageURL to image
        };

        // Directly return the course object
        res.status(200).json(transformedCourse);
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message,
        });
    }
};



// @desc    Create a new course
// @route   POST /api/courses
// @access  Private (Admin Only)
exports.createCourse = async (req, res) => {
    try {
        const newCourse = await Course.create(req.body);

        res.status(201).json({
            success: true,
            message: 'Course created successfully',
            data: newCourse,
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message,
        });
    }
};

// @desc    Update a course
// @route   PUT /api/courses/:id
// @access  Private (Admin Only)
exports.updateCourse = async (req, res) => {
    try {
        const updatedCourse = await Course.findByIdAndUpdate(req.params.id, req.body, {
            new: true, 
            runValidators: true, 
        });

        if (!updatedCourse) {
            return res.status(404).json({
                success: false,
                message: 'Course not found',
            });
        }

        res.status(200).json({
            success: true,
            message: 'Course updated successfully',
            data: updatedCourse,
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message,
        });
    }
};

// @desc    Delete a course
// @route   DELETE /api/courses/:id
// @access  Private (Admin Only)
exports.deleteCourse = async (req, res) => {
    try {
        const course = await Course.findByIdAndDelete(req.params.id);

        if (!course) {
            return res.status(404).json({
                success: false,
                message: 'Course not found',
            });
        }

        res.status(200).json({
            success: true,
            message: 'Course deleted successfully',
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message,
        });
    }
};

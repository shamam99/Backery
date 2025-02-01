const express = require('express');
const {
    getCourses,
    getCourseById,
    createCourse,
    updateCourse,
    deleteCourse,
} = require('../controllers/courseControllers');

const router = express.Router();

// Public Routes
router.get('/', getCourses);        
router.get('/:id', getCourseById);  

// Private Routes (Admin Only)
router.post('/', createCourse);    
router.put('/:id', updateCourse);  
router.delete('/:id', deleteCourse); 

module.exports = router;

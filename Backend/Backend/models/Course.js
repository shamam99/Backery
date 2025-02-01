const mongoose = require('mongoose');

const courseSchema = new mongoose.Schema(
    {
        name: { type: String, required: true },
        description: { type: String, required: true },
        chef: { type: String, required: true }, 
        level: {
            type: String,
            enum: ['Beginner', 'Intermediate', 'Advanced'],
            required: true,
        }, 
        duration: { type: Number, required: true }, 
        date: { type: Date, required: true }, 
        time: { type: String, required: true }, 
        location: { type: String, required: true },
        imageURL: { type: String, required: true }, 
        popularity: { type: Number, default: 0 }, 
    },
    { timestamps: true }
);

module.exports = mongoose.model('Course', courseSchema);

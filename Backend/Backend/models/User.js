const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');


const userSchema = new mongoose.Schema(
    {
        name: { type: String, required: true },
        email: { type: String, required: true, unique: true },
        password: { type: String, required: true },
        avatar: { type: String, default: '' }, 
        bookedCourses: [
            {
                type: mongoose.Schema.Types.ObjectId,
                ref: 'Booking', 
            },
        ],
    },
    { timestamps: true } 
);


userSchema.pre('save', async function (next) {
    if (!this.isModified('password')) {
        return next(); 
    }

    try {
        const salt = await bcrypt.genSalt(10); 
        this.password = await bcrypt.hash(this.password, salt); 
        next();
    } catch (error) {
        next(error); 
    }
});

// Method to compare entered password with hashed password
userSchema.methods.comparePassword = async function (enteredPassword) {
    return await bcrypt.compare(enteredPassword, this.password);
};
module.exports = mongoose.model('User', userSchema);

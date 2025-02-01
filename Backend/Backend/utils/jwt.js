const jwt = require('jsonwebtoken');

// Function to generate a JWT token
const generateToken = (id) => {
    return jwt.sign({ id }, process.env.JWT_SECRET, {
        expiresIn: process.env.JWT_EXPIRES_IN, 
    });
};

module.exports = { generateToken };

# **Backery App**

A complete solution for managing and booking baking classes. The project comprises both frontend and backend components, designed to provide an exceptional user experience and powerful functionality.

---

## **Table of Contents**
- [Project Overview](#project-overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [System Requirements](#system-requirements)
- [Project Structure](#project-structure)
- [Environment Variables](#environment-variables)
- [How to Run the Project](#how-to-run-the-project)
  - [Running the Backend](#running-the-backend)
  - [Running the Frontend](#running-the-frontend)
- [Database](#database)
- [API Documentation](#api-documentation)
- [Figma Design](#figma-design)
- [Contributing](#contributing)
- [License](#license)

---

## **Project Overview**

**Backery App** is a modern platform that allows users to explore, book, and manage baking classes. It includes:
- A user-friendly frontend built with **SwiftUI**.
- A backend developed with **Node.js** and **Express.js**.
- Integration with MongoDB for data storage.

The app is designed for both customers and baking class administrators, offering seamless functionality across devices.

---

## **Features**

### **Frontend**
- **User Authentication**: Login and registration with email.
- **Browse Courses**: Explore popular and upcoming baking classes.
- **Book Classes**: Reserve spots in baking classes and manage bookings.
- **User Profile**: View and edit user details, including profile pictures.
- **Responsive Design**: Built for iOS with an elegant and accessible interface.

### **Backend**
- **Secure APIs**: RESTful APIs for user authentication, course management, and bookings.
- **Database Management**: MongoDB integration for storing user and course details.
- **Environment Variables**: Securely handle sensitive data with `.env` files.

---

## **Tech Stack**

### **Frontend**
- **Language**: Swift
- **Framework**: SwiftUI
- **Tools**: Xcode, Figma (for design)

### **Backend**
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB
- **Tools**: Postman (for API testing)

---

## **System Requirements**

### **Frontend Requirements**
- macOS with **Xcode** installed (version 14 or later).
- iOS Simulator or a physical iOS device for testing.

### **Backend Requirements**
- Node.js (version 16 or later)
- MongoDB (local or hosted)
- npm (Node Package Manager)

---

## **Project Structure**

### **Frontend Structure**
```
Backery/
├── Backery.xcodeproj
├── Backery/
│   ├── Views/
│   ├── ViewModels/
│   ├── Models/
│   ├── Assets/
│   ├── Services/
├── BackeryTests/
└── BackeryUITests/
```

### **Backend Structure**
```
backend/
├── controllers/
├── models/
├── routes/
├── middleware/
├── utils/
├── config/
├── .env (not included in the repo)
├── server.js
└── package.json
```

---

## **Environment Variables**

The `.env` file for the backend should include the following:
```
PORT=5000
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret
```

Make sure to replace `your_mongodb_connection_string` and `your_jwt_secret` with your actual database connection string and a secure secret key.

---

## **How to Run the Project**

### **Running the Backend**

1. **Clone the repository:**
   ```bash
   git clone https://github.com/shamam99/Backery.git
   ```

2. **Navigate to the backend folder:**
   ```bash
   cd Backery/backend
   ```

3. **Install dependencies:**
   ```bash
   npm install
   ```

4. **Create the `.env` file:**
   Add the environment variables as specified in the [Environment Variables](#environment-variables) section.

5. **Start the server:**
   ```bash
   npm start
   ```

6. **Test the APIs using Postman**:
   Use the provided Postman collection (`postman_collection.json`) to test the backend endpoints.

### **Running the Frontend**

1. **Navigate to the frontend folder:**
   ```bash
   cd Backery/
   ```

2. **Open the project in Xcode:**
   Open `Backery.xcodeproj` using Xcode.

3. **Run the app:**
   Select an iOS simulator or a connected device, and press **Run** in Xcode.

---

## **Database**

The project uses **MongoDB** to store the following data:
- **Users**: Stores user details such as name, email, password, and profile picture.
- **Courses**: Stores course details including name, description, level, duration, location, and image.
- **Bookings**: Tracks user bookings for classes.

### Sample MongoDB Documents

#### Users Collection
```json
{
  "_id": "user_id",
  "name": "John Doe",
  "email": "john.doe@example.com",
  "password": "hashed_password",
  "avatar": "https://example.com/avatar.jpg"
}
```

#### Courses Collection
```json
{
  "_id": "course_id",
  "name": "Cinnamon Rolls",
  "description": "Learn to bake perfect cinnamon rolls!",
  "level": "Beginner",
  "date": "2025-02-18",
  "time": "17:00",
  "location": "Riyadh",
  "image": "https://example.com/cinnamon-rolls.jpg"
}
```

---

## **API Documentation**

The backend APIs are documented and available in the provided Postman collection (`postman_collection.json`). Import the collection into Postman to explore and test all endpoints.

Key endpoints include:
- **User Authentication**: `/api/users/register`, `/api/users/login`
- **Course Management**: `/api/courses`
- **Bookings**: `/api/bookings`

---

## **Figma Design**

The UI/UX design for the app is available in Figma

---

## **Contributing**

We welcome contributions to improve the app! Follow these steps to contribute:
1. Fork the repository.
2. Create a new branch for your feature or bug fix:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Description of changes"
   ```
4. Push the changes to your fork:
   ```bash
   git push origin feature-name
   ```
5. Submit a pull request.

---

## **License**

This project is licensed under the [MIT License](LICENSE).

---

By shamm

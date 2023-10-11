const express = require('express');
const mongoose = require('mongoose');
require('dotenv').config(); // Load environment variables from .env file

// Initialize Express app
const app = express();
const port = process.env.PORT || 3000;

// Connect to MongoDB using the MONGODB_URI variable from .env
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => {
    console.log('Connected to MongoDB');
    // Start the server once connected to MongoDB
    app.listen(port, () => {
        console.log(`Server listening on port ${port}`);
    });
})
.catch((err) => console.log(err));

const express = require('express');
const mongoose = require('mongoose');
const Player = require('./models/Player');
require('dotenv').config(); // Load environment variables from .env file

// Initialize Express app
const app = express();

app.use(express.json());

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

// GET all players 
app.get('/players', (req, res) => {
  Player.find({})
    .then((result) => {
      res.json(result);
    })
    .catch((err) => {
      console.log(err);
    });
});

// UPDATE a player by id
app.put('/players/:id', (req, res) => {
  const id = req.params.id;
  const updatedPlayer = req.body;
  Player.findByIdAndUpdate({ id: id }, updatedPlayer, { new: true })
    .then((result) => {
      if (!result) {
        return res.status(404).json({ error: 'Player not found' });
      }
      res.json(result);
    })
    .catch((err) => {
      console.log(err);
      res.status(500).json({ error: 'Internal server error' });
    });
});

// POST a json object to the /players endpoint
app.post('/players', (req, res) => {
  const playerData = req.body;
  Player.insertMany(playerData)
    .then((result) => {
      res.json(result);
    })
    .catch((err) => {
      console.log(err);
    });
});
const mongoose = require('mongoose');

const playerSchema = new mongoose.Schema({
    id: {
        type: String,
        required: true,
        unique: true,
    },
    name: String,
    number: Number,
    position: String,
    rank: Number,
});

const Player = mongoose.model('Player', playerSchema);

module.exports = Player;
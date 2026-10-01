const mongoose = require('mongoose');
const db = require('../config/db');

const todoSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  title: { type: String, required: true, unique: true },
  desc: { type: String, required: true },
});


module.exports = mongoose.model("Todo", todoSchema);
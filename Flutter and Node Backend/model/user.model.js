const mongoose = require('mongoose');
const db = require('../config/db');
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");


const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
});

userSchema.pre('save', async function () {
  
  try{
    const user = this;
  const salt = await (bcrypt.genSalt(10));
  const hashedPassword = await (bcrypt.hash(user.password, salt));
  user.password = hashedPassword;
  } catch (error) {
    throw error;
  }
});

const comparePassword = async function (userPassword) {
  const isMatch = await bcrypt.compare(userPassword, this.password);
  return isMatch;
};
userSchema.methods.comparePassword = comparePassword;


const userModel = mongoose.model('User', userSchema);
module.exports = userModel;
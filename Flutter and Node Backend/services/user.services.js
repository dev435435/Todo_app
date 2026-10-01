const { compare } = require("bcrypt");
const userModel = require("../model/user.model");
const jwt = require("jsonwebtoken");

const userService = class {
  static register(email, password) {
    const userData = new userModel({ email, password });
    return userData.save().catch((error) => {
      throw error;
    });
  }
  static async checkUser(email) {
    const user = await userModel.findOne({ email });
    if (!user) {
      throw Error("User does not exist");
    }
   return await user;
  }
    static async generateToken(tokenData, secretKey, jwt_expire) {
   return await jwt.sign(tokenData, secretKey, { expiresIn: jwt_expire });
  }
};

module.exports = userService;

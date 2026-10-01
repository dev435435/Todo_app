const todoModel = require("../model/todo.model");

const todoService = class {
  static async storeTodoData(userId, title, desc) {
    try {
    const todoData = new todoModel({ userId, title, desc });
    return await todoData.save();
    } catch (error) {
      throw error;
    };
  }

  static async getTodosByUserId(userId) {
    try {
    return await todoModel.find({ userId });
    } catch (error) {
      throw error;
    };
  }

  static async deleteTodoById(todoId) {
    try {
      return await todoModel.findByIdAndDelete(todoId);
    } catch (error) {
      throw error;
    }
  // static async checkUser(email) {
  //   const user = await userModel.findOne({ email });
  //   if (!user) {
  //     throw Error("User does not exist");
  //   }
  //  return await user;
  // }
  //   static async generateToken(tokenData, secretKey, jwt_expire) {
  //  return await jwt.sign(tokenData, secretKey, { expiresIn: jwt_expire });
  // }
}
};

module.exports = todoService;
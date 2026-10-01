const todoService = require('../services/todo.services');

exports.storeTodo = async (req, res, next) => {
  try {  
  const {userId, title, desc} = req.body;
    let todos = await todoService.storeTodoData(userId, title, desc)
       res.json({ status : true, success: todos });
  } catch (error) {
    console.log('Error storing todo:', error);
    res.json({ status: false, message: 'Failed to store todo' });
  }
      
  };

  exports.getTodos = async (req, res, next) => {
    const {userId} = req.body;
    
     if (!userId) {
       return res.status(400).json({ status: false, message: 'Please create a todo first' });
     }
     try {  
     let todo = await todoService.getTodosByUserId(userId);
    
        res.json({ status: true, success: todo});
     } catch (error) {
       console.log('Error fetching todos:', error);
       res.json({ status: false, message: 'Failed to fetch todos' });
     }
      
  }

  exports.deleteTodo = async (req, res, next) => {
    try {
    const todoId = req.body._id;
    console.log('Deleting todo with ID:', todoId);
    let deletedTodo = await todoService.deleteTodoById(todoId);
    res.json({ status: true, message: 'Todo deleted successfully', deletedTodo });
    } catch (error) { 
      console.log('Error deleting todo:', error);
      res.json({ status: false, message: 'Failed to delete todo' });
    }
  };
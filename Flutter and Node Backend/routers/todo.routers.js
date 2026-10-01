const router = require('express').Router();
const todoRouter = require('../controller/todo.controller');


router.post('/storeTodo', todoRouter.storeTodo);
router.post('/getUserTodoList', todoRouter.getTodos);
router.post('/deleteTodo', todoRouter.deleteTodo);

module.exports = router;
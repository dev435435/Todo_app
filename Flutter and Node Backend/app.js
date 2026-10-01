const express = require('express');
const bodyParser = require('body-parser');
const userRouters = require('./routers/user.routers');
const todoRouters = require('./routers/todo.routers');
const cors = require('cors');



const app = express();
app.use(cors());
app.use(express.json());


app.use(userRouters);
app.use(todoRouters);
module.exports = app;
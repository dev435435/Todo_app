const app = require('./app');
const db = require('./config/db');
const userModel = require('./model/user.model');


app.get('/', (req, res) => {
  res.send('Hello World!!!!');
});

const port = 3000;
app.listen(port,'0.0.0.0', () => {
  console.log(`Server is running on http://localhost:${port}`);
});
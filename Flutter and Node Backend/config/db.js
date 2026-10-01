const mongoose = require('mongoose');

const connection = mongoose.connect("mongodb+srv://devanarkimas_db_user:vfyafXXB7RlxRJAP@cluster0.craillb.mongodb.net/?appName=Cluster0").then( () => {
  console.log('Connected to the database');
}).catch((error) => {
  console.log('Error connecting to the database:', error);
});



module.exports = connection;

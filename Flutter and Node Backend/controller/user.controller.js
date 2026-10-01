const userService = require('../services/user.services');

exports.register = (req, res, next) => {
    const {email, password} = req.body;
    userService.register(email, password)
      .then(() => {
       res.json({ status : true, success: 'User registered successfully' });
      })
      .catch((error) => {
        console.log('Error registering user:', error);
      });
  };

exports.login = async (req, res, next) => {
    const {email, password} = req.body;
    const user = await userService.checkUser(email);
    if(!user){
      throw new Error('User does not exist');
    }
    const isPassMatch = await user.comparePassword(password);
    if(isPassMatch === false){
      throw new Error('Incorrect password');
    }

    const tokenData = {
      _id: user._id,
      email: user.email
    };
  const token = await userService.generateToken(tokenData, "secretKey", '1h');
  res.status(200).json({ status : true, token: token});

  };

  

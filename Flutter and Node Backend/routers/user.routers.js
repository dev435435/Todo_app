const router = require('express').Router();
const userRouter = require('../controller/user.controller');


router.post('/register', userRouter.register);
router.post('/login', userRouter.login);

module.exports = router;
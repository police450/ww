const express = require('express');
const router = express.Router();
const controller = require("../controllers/auth")

router.use(process.env.subFolder+':lng?/logout', (req, res, next) => {
    if(!req.user){
        res.redirect(process.env.PUBLIC_URL+process.env.subFolder)
        return
    }
   // req.logOut()
     
    if (req.query.data) {
        req.session.user = null;
        res.send({ success: true })
        return;
    }else{
        req.session.user = null;
        req.session.logout = true
        res.redirect( process.env.PUBLIC_URL+process.env.subFolder)
    }
})
router.get(process.env.subFolder+':lng?/login',controller.login);
router.get(process.env.subFolder+':lng?/signup',controller.signup);
router.get(process.env.subFolder+':lng?/signup/invite/:code',controller.invitesignup);
router.get(process.env.subFolder+':lng?/forgot',controller.forgotPassword);
router.get(process.env.subFolder+':lng?/reset/:code',controller.verifyCode);
router.get(process.env.subFolder+':lng?/verify-account/:code?',controller.verifyAccount)
module.exports = router;
const express = require('express');
const router = express.Router();
const controller = require("../controllers/home");
const enablePublicLogin = require("../middleware/enable_public")

router.use(process.env.subFolder+'/:install?', async (req, res, next) => {

    if(process.env.ALLOWALLUSERINADMIN && (req.query.theme == "default" || req.query.theme == "trendott")){
        req.session.selectedThemeUser = req.query.theme == "default" ? 1 : 2;
    }

    if(req.installScript){
        if(req.params.install == "install"){
            next()
            return
        }else{
            res.redirect(process.env.PUBLIC_URL+"/install")
            return
        }
    }
    var isValid = false;
    if (req.user && req.user.level_id == 1) {
        isValid = true
    } else {
        if(req.body.maintenance_code && !req.query.cronData){
            if(req.body.maintenance_code == req.appSettings.maintanance_code){
                req.session.maintanance = true
                res.redirect(process.env.PUBLIC_URL)
                res.end()
                return
                //next()
            }
        }
        if (req.session && !req.session.maintanance && !req.query.cronData) {
            if (req.appSettings["maintanance"] == 1) {
                const commonFunction = require("../functions/commonFunctions")
                await commonFunction.getGeneralInfo(req, res, 'maintenance')
                let appSettings = {}
                appSettings['favicon'] = req.appSettings['favicon']
                appSettings['darktheme_logo'] = req.appSettings['darktheme_logo']
                appSettings['lightheme_logo'] = req.appSettings['lightheme_logo']
                delete req.query.appSettings
                //delete req.query.languages
                delete req.query.levelPermissions
                const menus = { ...req.query.menus }
                req.query.appSettings = appSettings
                delete req.query.menus
                req.query.socialShareMenus = menus.socialShareMenus
                req.query.maintanance = true
                if (req.query.data) {
                    res.send({ data: req.query, maintanance: true })
                    return
                }
                req.app.render(req, res, '/maintenance', req.query);
            } else {
                isValid = true
            }
        }else{
            isValid = true
        }
    }

    if(isValid){
        next()
    }
})


//member.site_public_access

router.use(require("./auth"))
router.use(require("./ipn"))
router.use(process.env.subFolder+':lng?/contact',controller.contact )
router.use(process.env.subFolder+':lng?/privacy',controller.privacy )
router.use(process.env.subFolder+':lng?/terms',controller.terms )
router.use(process.env.subFolder+'cron/execute',controller.cronFunction);
router.use(require("./dashboard"))

router.use(process.env.subFolder+':lng?/pages/:id',enablePublicLogin,controller.pages )
router.use(enablePublicLogin,require("./search"))
router.use(enablePublicLogin,require("./movies"))
router.use(enablePublicLogin,require("./comment"))
router.use(enablePublicLogin,require("./messages"))

router.use(enablePublicLogin,require("./video"))
router.use(enablePublicLogin,require("./livestreaming"))
router.use(enablePublicLogin,require('./channel'))
router.use(enablePublicLogin,require("./blog"))
router.use(enablePublicLogin,require('./playlists'))
router.use(enablePublicLogin,require('./audio'))
router.use(enablePublicLogin,require('./artist'))

router.use(enablePublicLogin,require("./ads"))
router.use(require("./member"))

router.use(process.env.subFolder+'home-data',enablePublicLogin, controller.homeData)
router.use(process.env.subFolder+':lng?/:data?',enablePublicLogin, controller.index)
router.use(process.env.subFolder+':lng?/*',enablePublicLogin, controller.notFound)
module.exports = router
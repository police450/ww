const express = require('express');
const router = express.Router();
const controller = require("../controllers/artists")
const multer = require("multer")

router.get(process.env.subFolder+':lng?/artists/:type',controller.browse);
router.get(process.env.subFolder+':lng?/artist/:id',multer().none(),controller.view);

module.exports = router;
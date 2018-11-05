var express = require("express");
var multer = require("multer");
var memoryStorage = multer.memoryStorage()
var videoUpload = multer({ dest: "uploads/" });
var audioUpload = multer({ dest: "uploads/" });
var imageUpload = multer({ storage: memoryStorage });
var video = require("./video");
var image = require("./image");

var app = express();

app.post("/image", imageUpload.single("image"), async function(req, res, next) {
  try {
    await image.convert(req, res);
  } catch (error) {
    next(error)
  }
});

app.post("/video", videoUpload.single("video"), async function(req, res, next) {
  try {
    await video.convert(req, res);
  } catch (error) {
    next(error)
  }
});

app.use(function(err, req, res, next) {
  console.log(err);
  res.status(500).send(err.message);
});

app.listen(3000);

var express = require('express')
var multer = require('multer')
var memoryStorage = multer.memoryStorage()

var imageUpload = multer({ storage: memoryStorage })
var fileUpload = multer({ dest: 'uploads/' })

var image = require('./image')
var audio = require('./audio')
var video = require('./video')

var app = express()

app.post('/image', imageUpload.single('image'), async function (req, res, next) {
  try {
    await image.convert(req, res)
  } catch (error) {
    next(error)
  }
})

app.post('/audio', fileUpload.single('audio'), async function (req, res, next) {
  try {
    await audio.convert(req, res)
  } catch (error) {
    next(error)
  }
})

app.post('/video', fileUpload.single('video'), async function (req, res, next) {
  try {
    await video.convert(req, res)
  } catch (error) {
    next(error)
  }
})

app.use(function (err, req, res, next) {
  console.log(err)
  res.status(500).send(err.message)
})

app.listen(3000)

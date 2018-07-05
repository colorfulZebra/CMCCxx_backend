'use strict'

const express = require('express')
const path = require('path')
const bodyParser = require('body-parser')
const multer = require('multer')
const moment = require('moment')
const config = require('./config')

const app = express()

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, config.upload)
  },
  filename: function(req, file, cb) {
    cb(null, `${file.fieldname}_${moment().format('YYYY_MM_DD_HH_mm_ss')}`)
  }
})
const upload = multer({ storage })

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({
  extended: true
}))

// Root router used for homepage
app.use('/', express.static(path.join(__dirname, config.dist)))

app.post('/upload', upload.single('fullList'), (req, res, next) => {
  console.log(req.file)
  res.send({
    result: 0,
    filename: req.file.filename
  })
})

app.listen(config.port, () => {
  console.log(`Listening on port ${config.port}...`)
})
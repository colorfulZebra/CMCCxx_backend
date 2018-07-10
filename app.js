'use strict'

const express = require('express')
const path = require('path')
const bodyParser = require('body-parser')
const multer = require('multer')
const moment = require('moment')
const config = require('./config')
const getlist = require('./getlist')

const app = express()

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, config.upload)
  },
  filename: function(req, file, cb) {
    cb(null, `${file.fieldname}_${moment().format('YYYY_MM_DD')}`)
  }
})
const upload = multer({ storage })

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({
  extended: true
}))

// Root router used for homepage
app.use('/', express.static(path.join(__dirname, config.dist)))

app.post('/upload/fulllist', upload.single('fullList'), (req, res, next) => {
  res.send({
    filename: req.file.filename
  })
})

app.post('/upload/marketlist', upload.single('marketList'), (req, res, next) => {
  res.send({
    filename: req.file.filename
  })
})

app.post('/upload/targetlist/xian', upload.single('targetListxa'), (req, res, next) => {
  res.send({
    filename: req.file.filename
  })
})

app.post('/upload/targetlist/xianyang', upload.single('targetListxy'), (req, res, next) => {
  res.send({
    filename: req.file.filename
  })
})

app.post('/result/list', (req, res) => {
  req.setTimeout(120*1000)
  let target = req.body.targetfile
  let base = req.body.basefile
  let market = req.body.marketfile
  if (target === undefined || base === undefined || market === undefined) {
    res.send({
      return: {
        code: 10,
        message: 'targetfile & basefile & marketfile path should not be undefined'
      }
    })
  }
  let result = {}
  try {
    result = getlist(target, base, market)
  } catch (err) {
    res.send({
      return: {
        code: 20,
        message: err
      }
    })
  }
  res.send({
    return: {
      code: 0,
      message: 'OK'
    },
    data: {
      total: result.total,
      compliance: result.compliance,
      non_compliance: result.non_compliance 
    }
  })
})

app.listen(config.port, () => {
  console.log(`Listening on port ${config.port}...`)
})

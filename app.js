'use strict'

const fs = require('fs')
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

app.post('/upload/targetlist', upload.single('targetList'), (req, res, next) => {
  res.send({
    filename: req.file.filename
  })
})

app.post('/check', (req, res) => {
  let filepath = `./${config.upload}${req.body.file}`
  if (fs.existsSync(filepath)) {
    let fcontent = fs.readFileSync(filepath)
    let flist = fcontent.toString().trim().split('\n')
    fcontent = ''
    let flines = flist.length
    let ftitle = flist[0]
    res.send({
      return: {
        code: 0,
        message: 'OK'
      },
      data: {
        lines: flines,
        title: ftitle
      }
    })
  } else {
    res.send({
      return: {
        code: 10,
        message: '文件不存在'
      }
    })
  }
})

app.post('/result/list', (req, res) => {
  req.setTimeout(120*1000)
  if (req.body.targetfile === undefined || req.body.basefile === undefined || req.body.marketfile === undefined) {
    res.send({
      return: {
        code: 10,
        message: '全量清单、全量营销清单或目标客户清单文件路径未定义'
      }
    })
  } else {
    let target = `./${config.upload}${req.body.targetfile}`
    let base = `./${config.upload}${req.body.basefile}`
    let market = `./${config.upload}${req.body.marketfile}`
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
  }
})

app.get('/download/result', (req, res) => {
  let filepath = __dirname + '/data/result.txt'
  res.download(filepath)
})

app.get('/download/resulterr', (req, res) => {
  let filepath = __dirname + '/data/result.err.txt'
  res.download(filepath)
})

app.listen(config.port, () => {
  console.log(`Listening on port ${config.port}...`)
})

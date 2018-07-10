'use strict'

const fs = require('fs')

module.exports = function (targetfile, basefile, marketfile) {
  const path = {
    target: targetfile,
    base: basefile,
    market: marketfile,
    result: 'data/result.txt',
    resulterr: 'data/result.err.txt',
    product_id: './data/product_id.json',
    discnt_code: './data/discnt_code.json',
    package_id: './data/package_id.json'
  }
  const remove_product_id = require(path.product_id).data
  function test_product_id (product_id) {
    return remove_product_id.includes(product_id)
  }
  function test_pre_product_id (product_id) {
    let flag = false
    let product_lst = product_id.split('@')
    product_lst.map(pid => {
      if (remove_product_id.includes(pid)) {
        flag = true
      }
    })
    return flag
  }
  const remove_discnt_code = require(path.discnt_code).data
  function test_discnt_code (discnt_code) {
    let flag = false
    let discnt_lst = discnt_code.split('@')
    discnt_lst.map(dcode => {
      if (remove_discnt_code.includes(dcode)) {
        flag = true
      }
    })
    return flag
  }
  const remove_package_id = require(path.package_id).data
  function test_package_id (package_id) {
    let flag = false
    let package_lst = package_id.split('@')
    package_lst.map(pid => {
      if (remove_package_id.includes(pid)) {
        flag = true
      }
    })
    return flag
  }

  // Read and parse target list file
  let target_data = fs.readFileSync(path.target)
  let target_lst = target_data.toString().trim().split('\n')
  for (let idx = 0; idx < target_lst.length; idx++) {
    target_lst[idx] =  target_lst[idx].split('\t').join('|')
  }

  let base_data = fs.readFileSync(path.base)
  // Set serial number as key and match for the 1st time
  let base_dict = {}
  for (let item of base_data.toString().trim().split('\n')) {
    base_dict[item.split('|')[1]] = item
  }
  for (let idx = 0; idx < target_lst.length; idx++) {
    if (base_dict[target_lst[idx].split('|')[0]] === undefined) {
      continue
    } else {
      target_lst[idx] = target_lst[idx] + '|' + base_dict[target_lst[idx].split('|')[0]]
    }
  }
  // Set uid as key and match for the 2nd time
  base_dict = {}
  for (let item of base_data.toString().trim().split('\n')) {
    base_dict[item.split('|')[0]] = item
  }
  for (let idx = 0; idx < target_lst.length; idx++) {
    if (base_dict[target_lst[idx].split('|')[0]] === undefined) {
      continue
    } else {
      target_lst[idx] = target_lst[idx] + '|' + base_dict[target_lst[idx].split('|')[0]]
    }
  }
  // Clear memory
  base_data = ''
  base_dict = {}

  // save temp data
  fs.writeFileSync(path.result, target_lst.join('\n'), 'utf8')

  // Get target data from trade list (It's too big)
  let uids = {}
  for (let item of target_lst) {
    uids[item.split('|')[2]] = true
  }
  target_lst = []
  let market_data = fs.readFileSync(path.market)
  let market_rawlst = market_data.toString().trim().split('\n')
  market_data = ''
  let market_lst = []
  for (let item of market_rawlst) {
    let item_id = item.split('|')[0]
    if (uids[item_id] === undefined) {
      continue
    } else {
      market_lst.push(item)
    }
  }
  uids = {}
  market_rawlst = []

  // Save target trade data in dict
  let market_dict = {}
  for (let item of market_lst) {
    let uid = item.split('|')[0]
    let itemlst = item.split('|').slice(1)
    if (market_dict[uid] === undefined) {
      market_dict[uid] = itemlst.join('|')
    } else {
      let oldlst = market_dict[uid].split('|')
      oldlst[0] = oldlst[0] + '@' + itemlst[0]
      oldlst[1] = oldlst[1] + '@' + itemlst[1]
      oldlst[2] = oldlst[2] + '@' + itemlst[2]
      oldlst[3] = oldlst[3] + '@' + itemlst[3]
      oldlst[4] = oldlst[4] + '@' + itemlst[4]
      oldlst[5] = oldlst[5] + '@' + itemlst[5]
      market_dict[uid] = oldlst.join('|')
    }
  }
  market_lst = []
  // Clean the data
  for (let uid in market_dict) {
    let discnt_code = new Set(market_dict[uid].split('|')[0].split('@'))
    if (discnt_code.has('(null)') && discnt_code.size > 1) {
      discnt_code.delete('(null)')
    }
    let discnt_name = new Set(market_dict[uid].split('|')[1].split('@'))
    if (discnt_name.has('(null)') && discnt_name.size > 1) {
      discnt_name.delete('(null)')
    }
    let package_id = new Set(market_dict[uid].split('|')[2].split('@'))
    if (package_id.has('(null)') && package_id.size > 1) {
      package_id.delete('(null)')
    }
    let package_name = new Set(market_dict[uid].split('|')[3].split('@'))
    if (package_name.has('(null)') && package_name.size > 1) {
      package_name.delete('(null)')
    }
    let product_id = new Set(market_dict[uid].split('|')[4].split('@'))
    if (product_id.has('(null)') && product_id.size > 1) {
      product_id.delete('(null)')
    }
    let product_name = new Set(market_dict[uid].split('|')[5].split('@'))
    if (product_name.has('(null)') && product_name.size > 1) {
      product_name.delete('(null)')
    }
    market_dict[uid] = `${[...discnt_code].join('@')}|${[...discnt_name].join('@')}|${[...package_id].join('@')}|${[...package_name].join('@')}|${[...product_id].join('@')}|${[...product_name].join('@')}`
  }

  target_data = fs.readFileSync(path.result)
  target_lst = target_data.toString().trim().split('\n')
  target_data = ''
  for (let idx = 0; idx < target_lst.length; idx++) {
    if (market_dict[target_lst[idx].split('|')[2]] === undefined) {
      continue
    } else {
      target_lst[idx] = target_lst[idx] + '|' + market_dict[target_lst[idx].split('|')[2]]
    }
  }
  market_dict = {}

  // Complete infos of empty
  for (let idx = 0; idx < target_lst.length;  idx++) {
    if (target_lst[idx].indexOf('|') === target_lst[idx].lastIndexOf('|')) {
      target_lst[idx] = target_lst[idx] + '|(null)'.repeat(24) + '|not_found'
    } else {
      target_lst[idx] = target_lst[idx] + '|'
    }
  }

  for (let idx = 0; idx < target_lst.length; idx++) {
    let itemlst = target_lst[idx].split('|')
    let item = {
      id: itemlst[0],
      tag: itemlst[1],
      user_id: itemlst[2],
      serial_number: itemlst[3],
      city_code: itemlst[4],
      product_id: itemlst[5],
      product_name: itemlst[6],
      second_card_tag: itemlst[7],
      arpu_01: itemlst[8],
      arpu_02: itemlst[9],
      arpu_03: itemlst[10],
      dou_01: itemlst[11],
      dou_02: itemlst[12],
      dou_03: itemlst[13],
      mon_01: itemlst[14],
      mon_02: itemlst[15],
      mon_03: itemlst[16],
      balance_id: itemlst[17],
      group_id: itemlst[18],
      group_cust_name: itemlst[19],
      discnt_code: itemlst[20],
      discnt_name: itemlst[21],
      package_id: itemlst[22],
      package_name: itemlst[23],
      pre_product_id: itemlst[24],
      pre_product_name: itemlst[25]
    }
    let taglst = []
    if (itemlst[itemlst.length-1].length) {
      taglst = itemlst[itemlst.length-1].split('@')
    }
    if (test_product_id(item.product_id)) {
      taglst.push('product_id')
    }
    if (test_discnt_code(item.discnt_code)) {
      taglst.push('discnt_code')
    }
    if (test_package_id(item.package_id)) {
      taglst.push('package_id')
    }
    if (item.second_card_tag === '1') {
      taglst.push('second_card')
    }
    if (test_pre_product_id(item.pre_product_id)) {
      taglst.push('pre_product_id')
    }
    itemlst[itemlst.length-1] = taglst.join('@')
    target_lst[idx] = itemlst.join('|')
  }

  let target_success = target_lst.filter(item => item.split('|')[item.split('|').length-1].length===0)
  let target_error = target_lst.filter(item => item.split('|')[item.split('|').length-1].length>0)
  fs.writeFileSync(path.result, target_success.join('\n'), 'utf8')
  fs.writeFileSync(path.resulterr, target_error.join('\n'), 'utf8')
  return {
    total: target_lst.length,
    compliance: target_success.length,
    non_compliance: target_error.length
  }
}
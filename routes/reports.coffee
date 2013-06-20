###
 * reports
 * @author: actuosus
 * Date: 18/03/2013
 * Time: 20:41
###

Report = require('../models').Report

exports.list = (req, res)->
  Report.find({}).sort('name').exec (err, docs)->
    res.render 'reports/list.ect', title: 'Reports', docs: docs

exports.item = (req, res)->
  Report.findById(req.params._id)
  .populate('author')
  .exec (err, doc)->
    res.render 'reports/item.ect', title: 'Report', doc: doc
#    res.render 'reports/app.ect', title: 'Report', doc: doc

exports.createForm = (req, res)->
  res.render 'reports/form.ect', title: 'Report', doc: {}

exports.create = (req, res)->
  console.log req.body
  if req.body.title
    report = new Report req.body
    report.author = req.user
    report.save (err, doc)->
      if err
        res.render 'reports/form.ect', title: 'Report', doc: req.body
      else
        res.redirect "/reports/#{doc.id}"
  else
    res.render 'reports/form.ect', title: 'Report', doc: req.body

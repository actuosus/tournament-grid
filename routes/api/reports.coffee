###
 * reports
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 12:16
###

Report = require('../../models').Report

exports.list = (req, res)->
  query = Report.find({})
  query.where('_id').in(req.query?.ids) if req.query?.ids
  query.exec (err, docs)->
    reports = docs.map (doc)-> doc.toObject virtuals: yes
    res.send reports: reports

exports.item = (req, res)->
  Report
  .where('_id', req.params._id)
  .findOne()
  .exec (err, doc)->
    if doc
      res.send report: doc.toObject(virtuals: yes)
    else
      res.send 404, error: 'not found'
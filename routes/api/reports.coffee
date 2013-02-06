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
  query.exec (err, docs)-> res.send reports: docs

exports.item = (req, res)->
  Report.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send report: doc
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
    unless err
      reports = docs.map (doc)-> doc.toObject virtuals: yes
      res.send reports: reports
    else
      res.send 404, errors: err

exports.item = (req, res)->
  Report
  .where('_id', req.params._id)
  .findOne()
  .deepPopulate('team_refs.players team_refs.team_id.players')
  .exec (err, doc)->
    if doc
      res.send report: doc.toObject(virtuals: yes)
    else
      res.send 404, errors: 'not found'

exports.getDump = (req, res)->
  Report
  .where('_id', req.params._id)
  .findOne()
  .exec (err, doc)->
    if doc
      res.send dump: doc.dump
    else
      res.send 404, errors: 'not found'

exports.dump = (req, res)->
  if req.body.html
    Report.findByIdAndUpdate req.params._id, {dump: req.body.html}, (err, doc)->
      if doc
        res.send dump: doc.dump
      else
        res.send 404, errors: 'not found'
  else
    res.send 400, error: 'html parameter required.'
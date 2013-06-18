###
 * Stage
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 05:14
###

Report = require('../../models').Report
Stage = require('../../models').Stage

exports.list = (req, res)->
  query = Stage.find({})
  query.where('_id').in(req.query?.ids) if req.query?.ids
  query.exec (err, docs)-> res.send stages: docs

exports.item = (req, res)->
  Stage.where('_id', req.params._id).findOne().exec (err, doc)->
    if doc
      res.send stage: doc
    else
      res.send 404, error: 'not found'

exports.create = (req, res)->
  if req.body?.stage
    await Report.findById req.body?.stage.report_id, defer err, report
    if report
      stage = req.body.stage
      s = new Stage stage
      await s.save defer err, doc
      report.stages.push s
      await report.save defer err, report
      res.send stage: s
    else
      res.send 400, error: "server error"
  else
    res.send 400, error: "server error"

exports.update = (req, res)->
  if req.body?.stage
    stage = req.body.stage
    await Stage.findByIdAndUpdate req.params._id, { $set: stage }, defer err, doc
    res.send stage: doc
  else
    res.send 400, error: "server error"

exports.delete = (req, res) ->
  if req.params?._id?
    await Stage.findById req.params._id, defer err, stage
#    await Report.findById stage.report_id, defer err, report
    if stage
      console.log stage
      Stage.remove {_id: req.params._id}, (err)->
        Report.findByIdAndUpdate(stage.report_id, {$pull : {stages : req.params._id}}, ->) if stage?.report_id
        res.status 204 unless err
        res.send()
    else
      res.send 404, error: 'nothing found'
  else
    res.send 400, error: "server error"
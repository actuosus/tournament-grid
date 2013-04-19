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
    res.send stage: doc

exports.create = (req, res)->
  exports.create = (req, res) ->
  if req.body?.stages
    stages = []
    for Stage, i in req.body.stages
      console.log Stage, i
      m = new Stage stage
      await m.save defer err, stages[i]
      console.log stages
    res.send stages: stages
  else if req.body?.stage
    await Report.findById req.body?.stage.report_id, defer err, report
    stage = req.body?.stage
    s = new Stage stage
    await s.save defer err, doc
    report.stages.push s
    await report.save defer err, report
    res.send stage: s
  else
    res.send 400, error: "server error"

exports.delete = (req, res) ->
  if req.body?.stages
    stages = []
    for id, i in req.body.stages
      console.log id
      await Stage.remove _id: id, defer err, stages[i]
    res.status 204
    res.send()
  else if req.params?._id?
    await Stage.findById req.params._id, defer err, stage
#    await Report.findById stage.report_id, defer err, report
    Stage.remove {_id: req.params._id}, (err)->
      Report.update({_id: stage.report_id}, {$pull : {stages : req.params._id}}) if stage.report_id
      res.status 204 unless err
      res.send()
  else
    res.send 400, error: "server error"
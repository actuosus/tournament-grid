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
      res.send 404, errors: 'not found'

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
      res.send 400, errors: "server error"
  else
    res.send 400, errors: "server error"

exports.update = (req, res)->
  if req.body?.stage
    stage = req.body.stage
    await Stage.findByIdAndUpdate req.params._id, { $set: stage }, defer err, doc
    res.send stage: doc
  else
    res.send 400, errors: "server error"

exports.delete = (req, res) ->
  id = req.params._id
  if id
    await Stage.findById id, defer err, stage
    if stage
      console.log stage
      Stage.remove {_id: id}, (err)->
        Report.findByIdAndUpdate(stage.report_id, {$pull : {stages : id}}, ->) if stage?.report_id
        res.status 204 unless err
        res.send()
    else
      # Trying to delete all references from all reports
      Report.find().exec (err, reports)->
        if reports
          reports.forEach (report)->
            stagesIds = report.stages.filter (stage)-> stage.toString() is id
            console.log 'Found stages', stagesIds
            if stagesIds.length
              stagesIds.forEach (stageId)->
                Report.findByIdAndUpdate report._id, {$pull: {stages: stageId}}, ->
          res.status 204 unless err
          res.send()
        else
          res.send 404, errors: 'nothing found'
  else
    res.send 400, errors: "server error"
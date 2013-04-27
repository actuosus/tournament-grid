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
      res.send report: doc.toObject(virtuals: yes)

exports.update = (req, res)->
  if req.body?.reports
    teams = []
    for team, i in req.body.teams
      console.log team, i
      m = new Player team
      await m.update(team, defer err, teams[i])
    res.send teams: teams
  else if req.body?.report
    report = req.body.report
    await Team.findByIdAndUpdate req.params._id, { $set: team }, defer err, doc
    team = teamClone
    console.log 'Body', team, teamClone
    #    socket.send {action: 'update', model: 'Team', _id: doc._id}
    if team.report_id
      console.log "Pushing team #{req.params._id} to report #{team.report_id}"
      Report.findById team.report_id, (reportErr, report)->
        report.team_refs.push team_id: doc._id, players: doc.players
        report.save()
    else
      console.log 'No report', doc
      if req.body?.report_id
        Report.findById req.body.report_id, (reportErr, report)->
          report.team_refs.filter((ref)-> ref.team_id.toString() is req.params._id).forEach (item)->
            report.team_refs.id(item._id).remove()
          report.save()

    #        socket.send {action: 'update', model: 'Report', _id: doc.report_id}
    res.send team: doc
  else
    res.send 400, error: "server error"
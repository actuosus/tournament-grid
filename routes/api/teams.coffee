###
 * teams
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:18
###

util = require 'util'
mongoose = require 'mongoose'

Team = require('../../models').Team
TeamRef = require('../../models').TeamRef
Report = require('../../models').Report

paginate = require('paginate')({ mongoose: mongoose })

#socket = require('../../io').getSocket()

random = ->
  func = arguments[Math.floor(Math.random() * arguments.length)]
  func.call() if typeof(func) is 'function'

exports.list = (req, res)->
  query = Team.find({})
  query.where('_id').in(req.query.ids) if req.query?.ids
  if req.query?.name
    reg = new RegExp req.query.name, 'i'
    query.regex 'name', reg
  if req.query?.select
    if (req.query.select instanceof Array) and req.query.select.length
      selection = {}
      req.query.select.forEach (_)-> selection[_] = 1
      query.select selection
    else
      query.select req.query.select
  query.populate('players')
  query.paginate {
    page: req.query.page
    perPage: 10
  }, (err, docs)->
    data = teams: docs
    if docs.pagination
      firstPage = (docs.pagination.pages.filter (_)-> _.isFirst)?[0]
      lastPage = (docs.pagination.pages.filter (_)-> _.isLast)?[0]
      if lastPage && req.query.page > lastPage.page
        res.send 404
      if firstPage && firstPage.page > req.query.page
        res.send 404
      data.pageCount = lastPage?.page
    res.send data


exports.item = (req, res)->
  Team.where(_id: req.params._id).populate('players').findOne().exec (err, doc)->
    if doc
      res.send team: doc
    else
      res.send 404

exports.create = (req, res) ->
  if req.body?.team
    team = req.body.team
    await new Team(team).save defer err, t
#    await new TeamRef({team_id: t._id, report_id: team.report_id}).save defer teamRefErr, teamRef if team.report_id
#    await Report.findByIdAndUpdate team.report_id, {$push: {team_refs: teamRef._id}}, defer updateErr, report if teamRef
    res.send team: t
  else
    res.send 400, errors: "server error"


exports.update = (req, res)->
  if req.body?.teams
    teams = []
    for team, i in req.body.teams
      console.log team, i
      m = new Player team
      await m.update(team, defer err, teams[i])
    res.send teams: teams
  else if req.body?.team
    team = req.body?.team
    teamClone = util._extend {}, team
    await Team.findByIdAndUpdate req.params._id, { $set: team }, defer err, doc
    team = teamClone
    console.log 'Body', team, teamClone
#    socket.send {action: 'update', model: 'Team', _id: doc._id}
#    if team.report_id
#      console.log "Pushing team #{req.params._id} to report #{team.report_id}"
#      Report.findById team.report_id, (reportErr, report)->
#        console.log doc._id
#        await TeamRef.create team_id: doc._id, players: doc.players, defer teamRefErr, teamRef
#        report.team_refs.push teamRef._id
#        report.save()
#    else

#    console.log 'No report', doc
#    if req.body?.report_id
#      Report.findById req.body.report_id, (reportErr, report)->
#        report.team_refs.filter((ref)-> ref.team_id.toString() is req.params._id).forEach (item)->
#          report.team_refs.id(item._id).remove()
#        report.save()

#        socket.send {action: 'update', model: 'Report', _id: doc.report_id}
    res.send team: doc
  else
    res.send 400, errors: "server error"


exports['delete'] = (req, res) ->
  if req.body?.teams
    teams = []
    for id, i in req.body.teams
      console.log id
      await Team.remove _id: id, defer err, teams[i]
    res.status 204
    res.send()
  else if req.params?._id?
    await Team.findById req.params._id, defer err, team
    if team
      Team.remove _id: req.params._id, (err)->
        # TODO Remove socket hack.
#        socket.send {action: 'remove', model: 'Team', _id: req.params._id}

        Report.findByIdAndUpdate(team.report_id, {$pull : {teams: req.params._id}}) if team.report_id
        res.status 204 unless err
        res.send()
    else
      res.send 404, errors: "server error"
  else
    res.send 400, errors: "server error"
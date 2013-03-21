###
 * teams
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:18
###

Team = require('../../models').Team

random = ->
  func = arguments[Math.floor(Math.random() * arguments.length)]
  func.call() if typeof(func) is 'function'

exports.list = (req, res)->
#  setTimeout ->
    query = Team.find({})
    query.where('_id').in(req.query?.ids) if req.query?.ids
    if req.query?.name
      reg = new RegExp req.query.name, 'i'
      query.regex 'name', reg
    query.exec (err, docs)-> res.send teams: docs
#  , Math.round(Math.random() * 1000)

exports.item = (req, res)->
  Team.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send team: doc

exports.create = (req, res) ->
  if req.body?.teams
    teams = []
    for team, i in req.body.teams
      console.log team, i
      t = new Team team
      t.name = team.name
      await t.save defer err, teams[i]
      console.log teams
    res.send teams: teams
  else if req.body?.team
    team = req.body?.team
    t = new Team team
    t.name = team.name
    await t.save defer err, doc
    res.send team: doc
  else
    res.send 401, error: "server error"

exports.delete = (req, res) ->
  if req.body?.teams
    teams = []
    for id, i in req.body.teams
      console.log id
      await Team.remove _id: id, defer err, teams[i]
    res.status 204
    res.send()
  else
    res.send 401, error: "server error"
###
 * team_refs
 * @author: actuosus
 * Date: 27/04/2013
 * Time: 06:33
###

util = require 'util'

Team = require('../../models').Team
TeamRef = require('../../models').TeamRef
Round = require('../../models').Round
Report = require('../../models').Report

#socket = require('../../io').getSocket()

exports.list = (req, res)->
#  unless req.query?.report_id
  query = TeamRef.find({})
  query.where('_id').in(req.query.ids) if req.query?.ids
  if req.query?.name
    reg = new RegExp req.query.name, 'i'
    query.regex 'name', reg
  query.exec (err, docs)->
    res.send team_refs: docs

exports.item = (req, res)->
  TeamRef.where('_id', req.params._id).findOne().exec (err, doc)->
    if doc
      res.send team_ref: doc
    else
      res.send 404

exports.create = (req, res) ->
  if req.body?.team_ref and req.body.team_ref.team_id
    teamRef = req.body.team_ref
    t = new TeamRef teamRef
    await t.save defer err, doc
    Round.findByIdAndUpdate(teamRef.round_id, {$push: {team_refs: t._id}}, ->) if teamRef.round_id
    Report.findByIdAndUpdate(teamRef.report_id, {$push: {team_refs: t._id}}, ->) if teamRef.report_id
    res.send team_ref: doc
  else
    res.send 400, errors: "server error"


exports.update = (req, res)->
  if req.body?.team_ref
    teamRef = req.body.team_ref
    teamRef.captain_id = null unless teamRef.captain_id

    await TeamRef.findByIdAndUpdate req.params._id, { $set: teamRef }, defer err, doc
    res.send team_ref: doc
  else
    res.send 400, errors: "server error"

exports.delete = (req, res) ->
  await TeamRef.findById req.params._id, defer err, teamRef
  if teamRef
    TeamRef.findByIdAndRemove req.params._id, (err)->
      # TODO Remove socket hack.
#      socket.send {action: 'remove', model: 'TeamRef', _id: req.params._id}

      Report.findByIdAndUpdate(teamRef.report_id, {$pull: {team_refs: teamRef._id}}, ->) if teamRef.report_id
      res.status 204 unless err
      res.send()
  else
    res.send 400, errors: "server error"
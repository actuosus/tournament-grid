###
 * players
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:18
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
Team = require('../../models').Team
TeamRef = require('../../models').TeamRef
Player = require('../../models').Player
Report = require('../../models').Report

socket = require('../../io').getSocket()

exports.list = (req, res)->
  setTimeout ->
    query = Player.find({})
    query.where('_id').in(req.query?.ids) if req.query?.ids
    if req.query?.name
      reg = new RegExp req.query.name, 'i'
      query.regex 'name', reg
    if req.query?.nickname
      reg = new RegExp req.query.nickname, 'i'
      query.regex 'nickname', reg
    query.exec (err, docs)-> res.send players: docs
  , Math.round(Math.random() * 1000)


exports.item = (req, res)->
  Player.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send player: doc


exports.create = (req, res) ->
  if req.body?.player
    player = req.body.player

    # Always creating player
    await new Player(player).save defer err, p

    if player.team_ref_id
      await TeamRef.findByIdAndUpdate player.team_ref_id, {$push: {players: p._id}}, defer err, teamRef
    else if player.report_id and not player.team_ref_id
      await TeamRef.findOneAndUpdate {team_id: player.team_id, report_id: player.report_id}, {$push: {players: p._id}}, defer err, teamRef
    else
      await Team.findByIdAndUpdate player.team_id, {$push: {players: p._id}}, defer err, team
  #    socket.send {action: 'create', model: 'Player', _id: p._id}
    res.send player: p
  else
    res.send 400, error: "server error"


exports.update = (req, res)->
  if req.body?.player
    player = req.body.player
    if not player.team_ref_id and player.report_id
      await Player.findByIdAndUpdate req.params._id, player, defer err, p
      await TeamRef.findOneAndUpdate {team_id: player.team_id, report_id: player.report_id}, {$pull: {players: p._id}}, defer err, teamRef
    else if player.team_ref_id
      await Player.findByIdAndUpdate req.params._id, player, defer err, p
      await TeamRef.findByIdAndUpdate player.team_ref_id, {$push: {players: p._id}}, defer err, teamRef
    res.send player: p
  else
    res.send 400, error: "server error"


exports.delete = (req, res) ->
  if req.body?.players
    players = []
    for id, i in req.body.players
      console.log id
      await Player.remove _id: id, defer err, players[i]
    res.status 204
    res.send()
  else if req.params?._id?
    await Player.findById req.params._id, defer err, player
    Player.findByIdAndRemove req.params._id, (removeErr)->

      # TODO Remove socket hack.
      socket.send {action: 'remove', model: 'Player', _id: req.params._id}

      Team.findByIdAndUpdate player.team_id, {$pull: {players: req.params._id}}, (updateErr, numberAffected, rawResponse)->
        Report.findByIdAndUpdate player.report_id, {$pull : {players: req.params._id}} if player.report_id
        res.status 204 unless updateErr
        res.send()
  else
    res.send 400, error: "server error"
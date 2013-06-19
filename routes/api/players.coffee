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

#socket = require('../../io').getSocket()

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
    if doc
      res.send player: doc
    else
      res.send 404, error: 'nothing found'


exports.create = (req, res) ->
  if req.body?.player
    player = req.body.player

    # Always creating player
    await new Player(player).save defer err, p

    if p
      if player.team_ref_id
        await TeamRef.findByIdAndUpdate player.team_ref_id, {$push: {players: p._id}}, defer err, teamRef
      else if player.report_id and not player.team_ref_id
        await TeamRef.findOneAndUpdate {team_id: player.team_id, report_id: player.report_id}, {$push: {players: p._id}}, defer err, teamRef
      else if req.query.report_id and not player.team_ref_id
        await TeamRef.findOneAndUpdate {team_id: player.team_id, report_id: req.query.report_id}, {$push: {players: p._id}}, defer err, teamRef
      else
        await Team.findByIdAndUpdate player.team_id, {$push: {players: p._id}}, defer err, team
    #    socket.send {action: 'create', model: 'Player', _id: p._id}
      res.send player: p
    else
      res.send 404, error: 'not found'
  else
    res.send 400, error: "server error"


exports.update = (req, res)->
  if req.body?.player
    player = req.body.player

    if not player.team_ref_id and player.report_id and player.team_id
      # Removing from team ref
      await TeamRef.findOneAndUpdate {team_id: player.team_id, report_id: player.report_id}, {$pull: {players: req.params._id}}, defer err, teamRef
    else if player.team_ref_id and player.report_id
      # It's moving from another team ref
      await TeamRef.find({report_id: player.report_id}).exec defer err, teamRefs
      if teamRefs
        teamRefs.forEach (teamRef)->
          playerIndexes = []
          teamRef.players.forEach (item, idx)->
            playerIndexes.push idx if item.toString() is req.params._id
          if playerIndexes.length
            playerIndexes.forEach (idx)-> teamRef.players.splice(idx, 1)
            teamRef.save()
#      await TeamRef.findOneAndUpdate {team_id: player.team_id, report_id: player.report_id}, {$pull: {players: p._id}}, defer err, oldTeamRef

      await TeamRef.findByIdAndUpdate player.team_ref_id, {$push: {players: req.params._id}}, defer err, newTeamRef
    else if player.team_ref_id
      # Just adding to team ref
      await TeamRef.findByIdAndUpdate player.team_ref_id, {$push: {players: req.params._id}}, defer err, teamRef
    else if player.team_id and req.query.report_id
      # Remove old reference first
      await TeamRef.find({report_id: req.query.report_id}).exec defer err, teamRefs
      if teamRefs
        teamRefs.forEach (teamRef)->
          playerIndexes = []
          teamRef.players.forEach (item, idx)->
            playerIndexes.push idx if item.toString() is req.params._id
          if playerIndexes.length
            playerIndexes.forEach (idx)-> teamRef.players.splice(idx, 1)
            teamRef.save()
      # Adding to the new team reference
      if teamRefs
        teamRefs.forEach (teamRef)->
          playerIndexes = []
          console.log teamRef.team_id.toString(), player.team_id
          if teamRef.team_id.toString() is player.team_id
            console.log teamRef.players
            teamRef.players.push req.params._id
            teamRef.save()
    # TODO Hacky
    res.send player: player
  else
    res.send 400, error: "server error"

# Should not be presented in API.
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
#      socket.send {action: 'remove', model: 'Player', _id: req.params._id}

      Team.findByIdAndUpdate player.team_id, {$pull: {players: req.params._id}}, (updateErr, numberAffected, rawResponse)->
        Report.findByIdAndUpdate player.report_id, {$pull : {players: req.params._id}} if player.report_id
        res.status 204 unless updateErr
        res.send()
  else
    res.send 400, error: "server error"
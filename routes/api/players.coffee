###
 * players
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:18
###

Team = require('../../models').Team
Player = require('../../models').Player

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
  if req.body?.players
    players = []
    for player, i in req.body.players
      await Team.findById player.team_id, defer err, team
      console.log team, player, i
      p = new Player player
      await p.save defer err, players[i]
      team.players.push p
      await team.save defer err, team
      console.log players
    res.send players: players
  else if req.body?.player
    await Team.findById req.body?.player.team_id, defer err, team
    p = new Player req.body?.player
    await p.save defer err, player
    team.players.push p
    await team.save defer err, team
    res.send player: p
  else
    res.send 400, error: "server error"

exports.update = (req, res)->
  if req.body?.players
    players = []
    for player, i in req.body.players
      console.log player, i
      m = new Player player
      await m.update(player, defer err, players[i])
    res.send players: players
  else if req.body?.player
    player = req.body?.player
    await Player.findById req.params._id, defer err, p
    if p
      await p.update(player, defer err, doc)
      await Team.findByIdAndUpdate player.team_id, {$push: {players: p._id}}, defer updateErr, team
      res.send player: p
    else
      res.send 400, error: "server error"
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
      Team.findByIdAndUpdate player.team_id, {$pull: {players: req.params._id}}, (updateErr, numberAffected, rawResponse)->
        res.status 204 unless updateErr
        res.send()
  else
    res.send 400, error: "server error"
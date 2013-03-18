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
      await Team.findOne player.team_id, defer err, team
      console.log team, player, i
      p = new Player player
      await p.save defer err, players[i]
      team.players.push p
      await team.save defer err, team
      console.log players
    res.send players: players
  else if req.body?.player
    await Team.findOne req.body?.player.team_id, defer err, team
    p = new Player req.body?.player
    await p.save defer err, player
    team.players.push p
    await team.save defer err, team
    res.send player: p
  else
    res.send 401, error: "server error"

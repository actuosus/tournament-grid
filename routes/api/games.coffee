###
 * games
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 05:14
###

Match = require('../../models').Match
Game = require('../../models').Game

exports.list = (req, res)->
  query = Game.find({})
  query.where('_id').in(req.query?.ids) if req.query?.ids
  query.exec (err, docs)-> res.send games: docs

exports.item = (req, res)->
  Game.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send game: doc

exports.create = (req, res)->
  if req.body?.games
    games = []
    for game, i in req.body.games
      console.log game, i
      g = new Game game
      await g.save defer err, games[i]
      console.log games
    res.send games: games
  else if req.body?.game
    await Match.findOne req.body?.game.match_id, defer err, match
    game = req.body?.game
    g = new Game game
    g.name = game.name
    await g.save defer err, doc
    match.games.push g
    await match.save defer err, match
    res.send game: doc
  else
    res.send 401, error: "server error"
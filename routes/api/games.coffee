###
 * games
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 05:14
###

Game = require('../../models').Game

exports.list = (req, res)->
  query = Game.find({})
  query.where('_id').in(req.query?.ids) if req.query?.ids
  query.exec (err, docs)-> res.send games: docs

exports.item = (req, res)->
  Game.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send game: doc
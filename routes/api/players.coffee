###
 * players
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:18
###

Player = require('../../models').Player

exports.list = (req, res)->
  query = Player.find({})
  query.where('_id').in(req.query?.ids) if req.query?.ids
  query.exec (err, docs)-> res.send players: docs

exports.item = (req, res)->
  Player.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send player: doc
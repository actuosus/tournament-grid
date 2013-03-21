###
 * players
 * @author: actuosus
 * Date: 20/03/2013
 * Time: 16:17
###

Player = require('../models').Player

exports.list = (req, res)->
  Player.find({}).sort('name').exec (err, docs)->
    res.render 'players/list', title: 'Players', docs: docs

exports.item = (req, res)->
  Player.findById(req.params._id).exec (err, doc)->
    res.render 'players/item', title: 'Player', doc: doc
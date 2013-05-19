###
 * players
 * @author: actuosus
 * Date: 20/03/2013
 * Time: 16:17
###

Player = require('../models').Player

exports.list = (req, res)->
  Player.find({}).sort('name').exec (err, docs)->
    res.render 'players/list.ect', title: 'Players', docs: docs

exports.item = (req, res)->
  Player.findById(req.params._id).populate('team_id').exec (err, doc)->
    if doc
      res.render 'players/item.ect', title: 'Player', doc: doc
    else
      res.statusCode = 404
      res.render '404.ect'
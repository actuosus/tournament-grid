###
 * games
 * @author: actuosus
 * Date: 18/03/2013
 * Time: 20:15
###

Game = require('../models').Game

exports.list = (req, res)->
  Game.find({}).sort('name').exec (err, docs)->
    res.render 'games/list.ect', title: 'Games', docs: docs

exports.item = (req, res)->
  Game.findById(req.params._id)
    .exec (err, doc)->
      console.log doc
      res.render 'games/item.ect', title: 'Game', doc: doc
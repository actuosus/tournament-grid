###
 * games
 * @author: actuosus
 * Date: 18/03/2013
 * Time: 20:15
###

Game = require('../models').Game

exports.list = (req, res)->
  Game.find({}).sort('name').exec (err, docs)->
    res.render 'games/list', title: 'Games', docs: docs
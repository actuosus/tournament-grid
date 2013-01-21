###
 * games
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:18
###

models = require '../../models'
Game = mongoose.model 'Game', models.GameSchema

exports.list = (req, res)-> Game.find({}).exec (err, docs)-> res.send docs
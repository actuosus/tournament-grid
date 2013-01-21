###
 * players
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:18
###

models = require '../../models'
Player = mongoose.model 'Player', models.PlayerSchema

exports.list = (req, res)-> Player.find({}).exec (err, docs)-> res.send docs
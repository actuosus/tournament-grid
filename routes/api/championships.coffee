###
 * championships
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:17
###

models = require '../../models'
Championship = mongoose.model 'Championship', models.ChampionshipSchema

exports.list = (req, res)-> Championship.find({}).exec (err, docs)-> res.send docs
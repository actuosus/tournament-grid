###
 * teams
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:18
###

models = require '../../models'
Team = mongoose.model 'Team', models.TeamSchema

exports.list = (req, res)-> Team.find({}).exec (err, docs)-> res.send docs
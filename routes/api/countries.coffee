###
 * countries
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:18
###

models = require '../../models'
Country = mongoose.model 'Country', models.CountrySchema

exports.list = (req, res)-> Country.find({}).exec (err, docs)-> res.send docs
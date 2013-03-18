###
 * championships
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:17
###

Championship = require('../../models').Championship

exports.list = (req, res)-> Championship.find({}).exec (err, docs)-> res.send docs


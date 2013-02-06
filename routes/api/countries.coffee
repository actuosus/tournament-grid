###
 * countries
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:18
###

Country = require('../../models').Country

exports.list = (req, res)-> Country.find({}).exec (err, docs)-> res.send countries: docs

exports.item = (req, res)->
  Country.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send country: doc
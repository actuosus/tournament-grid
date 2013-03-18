###
 * countries
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:18
###

Country = require('../../models').Country

exports.list = (req, res)->
  setTimeout ->
    query = Country.find({})
    query.where('_id').in(req.query?.ids) if req.query?.ids
    if req.query?.name
      reg = new RegExp req.query.name, 'i'
      query.regex 'name', reg
    query.sort('code')
    query.exec (err, docs)-> res.send countries: docs
  , Math.round(Math.random() * 1000)

exports.item = (req, res)->
  Country.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send country: doc
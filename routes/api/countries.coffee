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
      if req.language
        reg = new RegExp req.query.name, 'i'
      else
        reg = new RegExp req.query.name, 'i'
      query.regex '_name.'+req.language, reg
    query.sort 'code'
    query.exec (err, docs)-> res.send countries: docs
  , Math.round(Math.random() * 5000)

exports.item = (req, res)->
  Country.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send country: doc
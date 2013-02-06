###
 * results
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 12:24
###

Result = require('../../models').Result

exports.list = (req, res)->
  query = Result.find({})
  query.where('_id').in(req.query?.ids) if req.query?.ids
  query.exec (err, docs)-> res.send results: docs

exports.item = (req, res)->
  Result.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send result: doc
###
 * results
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 12:24
###

ResultSet = require('../../models').ResultSet
Result = require('../../models').Result

exports.list = (req, res)->
  query = Result.find({})
  query.where('_id').in(req.query?.ids) if req.query?.ids
  query.exec (err, docs)-> res.send results: docs

exports.item = (req, res)->
  Result.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send result: doc

exports.create = (req, res)->
  if req.body.result
    result = req.body.result
    console.log result
    await new Result(result).save defer err, r
    await ResultSet.findByIdAndUpdate result.result_set_id, {$push: {results: r._id}}, defer err, rs if result.result_set_id
    res.send result: r
  else
    res.send 400, errors: 'server error'

exports.update = (req, res)->
  if req.body.result_set
    result = req.body.result
    console.log result
    await Result.findByIdAndUpdate req.param._id, {$set:result}, defer err, r
#    await ResultSet.findByIdAndUpdate result.result_set_id, {$push: {results: r._id}}, defer err, rs if result.result_set_id
    res.send result: r
  else
    res.send 400, errors: 'server error'

exports.delete = (req, res)->
  Result.findByIdAndRemove req.param._id, (err)->
    unless err
      res.send 204
    else
      res.send 400, errors: err
###
 * result_sets
 * @author: actuosus
 * Date: 03/06/2013
 * Time: 16:01
###

ResultSet = require('../../models').ResultSet
Round = require('../../models').Round

exports.list = (req, res)->
  query = ResultSet.find({})
  query.where('_id').in(req.query?.ids) if req.query?.ids
  query.exec (err, docs)-> res.send result_sets: docs

exports.item = (req, res)->
  ResultSet.where('_id', req.params._id).findOne().exec (err, doc)->
    if doc
      res.send result_set: doc
    else
      res.send 404, error: 'nothing found'

exports.create = (req, res)->
  if req.body.result_set
    result_set = req.body.result_set
    console.log result_set
    await new ResultSet(result_set).save defer err, rs
    await Round.findByIdAndUpdate result_set.round_id, {$push: {result_sets: rs._id}}, defer err, r if result_set.round_id
    res.send result_set: rs
  else
    res.send 400, error: 'server error'

exports.update = (req, res)->
  if req.body.result_set
    resultSet = req.body.result_set
    console.log resultSet
    await ResultSet.findByIdAndUpdate req.params._id, resultSet, defer err, rs
#    await Round.findByIdAndUpdate resultSet.round_id, {$push: {result_sets: rs._id}}, defer err, r if resultSet.round_id
    res.send result_set: rs
  else
    res.send 400, error: 'server error'

exports.delete = (req, res) ->
  await ResultSet.findById req.params._id, defer err, resultSet
  if resultSet
    ResultSet.findByIdAndRemove req.params._id, (err)->
      # TODO Remove socket hack.
#      socket.send {action: 'remove', model: 'ResultSet', _id: req.params._id}

      console.log resultSet.round_id
      Round.findByIdAndUpdate(resultSet.round_id, {$pull: {result_sets: resultSet._id}}, ->) if resultSet.round_id
      res.status 204 unless err
      res.send()
  else
    res.send 400, error: "server error"
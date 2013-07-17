###
 * rounds
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 14:26
###

Round = require('../../models').Round
Stage = require('../../models').Stage

exports.list = (req, res)->
  query = Round.find({})
  query.where('_id').in(req.query?.ids) if req.query?.ids
  query.exec (err, docs)-> res.send rounds: docs

exports.item = (req, res)->
  Round.where('_id', req.params._id).findOne().exec (err, doc)->
    if doc
      res.send round: doc
    else
      res.send 404, errors: 'nothing found'

exports.create = (req, res) ->
  if req.body?.rounds
    rounds = []
    for round, i in req.body.rounds
      console.log round, i
      r = new Round round
      r.name = round.name
      await r.save defer err, rounds[i]
      console.log rounds
    res.send rounds: rounds
  else if req.body?.round
    await Stage.findById req.body?.round.stage_id, defer err, stage
    if stage
      round = req.body?.round
      r = new Round round
      r.name = round.name
      await r.save defer err, doc
      stage.rounds.push r
      await stage.save defer err, stage
      res.send round: doc
    else
      res.send 422, errors: {stage_id: 'required'}
  else
    res.send 400, errors: "server error"

exports.update = (req, res)->
  if req.body?.rounds
    rounds = []
    for round, i in req.body.rounds
      console.log round, i
      m = new Round round
      await m.update(round, defer err, rounds[i])
    res.send rounds: rounds
  else if req.body?.round
    round = req.body?.round
    await Round.findById req.params._id, defer err, r
    if r
#      await r.update(round, defer err, r)
      await Round.findByIdAndUpdate req.params._id, { $set: round }, defer err, r
      await Stage.findByIdAndUpdate round.stage_id, {$push: {rounds: r._id}}, defer updateErr, stage
      res.send round: r
    else
      res.send 404, errors: 'not found'
  else
    res.send 400, errors: "server error"

exports.delete = (req, res)->
  if req.params?._id?
    await Round.findById req.params._id, defer err, round
    if round
      Round.remove _id: req.params._id, (err)->
        # TODO Remove socket hack.
#        socket.send {action: 'remove', model: 'Round', _id: req.params._id}

        Stage.findByIdAndUpdate(round.stage_id, {$pull : {rounds: req.params._id}}) if round.stage_id
        res.status 204 unless err
        res.send()
    else
      res.send 404, errors: 'not found'
  else
    res.send 400, errors: "server error"
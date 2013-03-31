###
 * rounds
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 14:26
###

Round = require('../../models').Round
Stage = require('../../models').Stage

exports.list = (req, res)-> Round.find({}).exec (err, docs)-> res.send rounds: docs
exports.item = (req, res)->
  Round.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send round: doc

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
    round = req.body?.round
    r = new Round round
    r.name = round.name
    await r.save defer err, doc
    console.log stage.rounds
    stage.rounds.push r
    await stage.save defer err, stage
    console.log stage.rounds
    res.send round: doc
  else
    res.send 401, error: "server error"
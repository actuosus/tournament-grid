###
 * games
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:18
###

Round = require('../../models').Round
Match = require('../../models').Match

exports.list = (req, res)->
  query = Match.find({})
  query.where('_id').in(req.query?.ids) if req.query?.ids
  query.where('team1_id').in(req.query?.team_id) if req.query?.team_id
  query.exec (err, docs)-> res.send matches: docs

exports.create = (req, res)->
  if req.body?.matches
    matches = []
    for match, i in req.body.matches
      console.log match, i
      m = new Match match
#      m.name = match.name
      await m.save defer err, matches[i]
      console.log matches
    res.send matches: matches
  else if req.body?.match
    await Round.findById req.body?.match.round_id, defer err, round
    match = req.body?.match
    m = new Match match
    m.name = match.name
    await m.save defer err, doc
    round.matches.push m
    await round.save defer err, round
    res.send match: doc
  else
    res.send 400, error: "server error"

exports.update = (req, res)->
  if req.body?.matches
    matches = []
    for match, i in req.body.matches
      console.log match, i
      m = new Match match
      #      m.name = match.name
      await m.update(match, defer err, matches[i])
    res.send matches: matches
  else if req.body?.match
    match = req.body?.match
    await Match.findByIdAndUpdate req.params._id, { $set: match }, defer err, doc
#    await m.update(match, defer err, doc)
#    round.matches.push m
#    await round.save defer err, round
    res.send match: doc
  else
    res.send 400, error: "server error"
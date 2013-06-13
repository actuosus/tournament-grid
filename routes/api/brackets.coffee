###
 * brackets
 * @author: actuosus
 * Date: 22/05/2013
 * Time: 22:43
###

Bracket = require('../../models').Bracket
Stage = require('../../models').Stage

exports.list = (req, res)->
  query = Bracket.find({})
  query.where('_id').in(req.query?.ids) if req.query?.ids
  query.exec (err, docs)-> res.send brackets: docs

exports.item = (req, res)->
  Bracket.where('_id', req.params._id).findOne().exec (err, doc)->
    if doc
      res.send bracket: doc
    else
      res.send 404, error: 'nothing found'

exports.create = (req, res) ->
  if req.body?.brackets
    brackets = []
    for bracket, i in req.body.brackets
      console.log bracket, i
      r = new Bracket bracket
      r.name = bracket.name
      await r.save defer err, brackets[i]
      console.log brackets
    res.send brackets: brackets
  else if req.body?.bracket
    await Stage.findById req.body?.bracket.stage_id, defer err, stage
    if stage
      bracket = req.body?.bracket
      b = new Bracket bracket
      await b.save defer err, doc
      stage.brackets.push b
      await stage.save defer err, stage
      res.send bracket: doc
    else
      res.send 400, error: 'stage_id required'
  else
    res.send 400, error: "server error"

exports.update = (req, res)->
  if req.body?.brackets
    brackets = []
    for bracket, i in req.body.brackets
      console.log bracket, i
      m = new Bracket bracket
      await m.update(bracket, defer err, brackets[i])
    res.send brackets: brackets
  else if req.body?.bracket
    bracket = req.body?.bracket
    await Bracket.findById req.params._id, defer err, b
    if b
#      await b.update(bracket, defer err, doc)
      await Bracket.findByIdAndUpdate req.params._id, { $set: bracket }, defer err, b
      await Stage.findByIdAndUpdate bracket.stage_id, {$push: {brackets: b._id}}, defer updateErr, stage
      res.send bracket: b
    else
      res.send 400, error: "server error"
  else
    res.send 400, error: "server error"

exports.delete = (req, res) ->
  await Bracket.findById req.params._id, defer err, bracket
  if bracket
    await Bracket.findByIdAndRemove req.params._id, defer err
    res.send 204
  else
    res.send 404, error: "nothing found"

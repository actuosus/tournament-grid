###
 * games
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:18
###

Match = require('../../models').Match

exports.list = (req, res)->
  query = Match.find({})
  query.where('_id').in(req.query?.ids) if req.query?.ids
  query.where('team1_id').in(req.query?.team_id) if req.query?.team_id
  query.exec (err, docs)-> res.send matches: docs

exports.create = (req, res)->
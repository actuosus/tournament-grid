###
 * teams
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:18
###

Team = require('../../models').Team

exports.list = (req, res)-> Team.find({}).exec (err, docs)-> res.send teams: docs

exports.item = (req, res)->
  Team.where('_id', req.params._id).findOne().exec (err, doc)->
    res.send team: doc
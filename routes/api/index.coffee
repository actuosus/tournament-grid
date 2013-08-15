###
 * index
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 08:56
###

exports.index = (req, res)->
  res.send
    version: '1.0.0'

exports.logs = require './logs'

exports.countries = require './countries'
exports.games = require './games'
exports.matches = require './matches'
exports.players = require './players'
exports.reports = require './reports'
exports.resultSets = require './result_sets'
exports.results = require './results'
exports.rounds = require './rounds'
exports.brackets = require './brackets'
exports.stages = require './stages'
exports.teams = require './teams'
exports.team_refs = require './team_refs'
###
 * index
 * @author: actuosus
 * Date: 13/05/2013
 * Time: 02:47
###

mongoose = require 'mongoose'

exports.CountrySchema = require './country'
exports.GameSchema = require './game'
exports.MatchSchema = require './match'
exports.PlayerSchema = require './player'
exports.RaceSchema = require './race'
exports.ReportSchema = require './report'
exports.ResultSetSchema = require './result_set'
exports.ResultSchema = require './result'
exports.RoundSchema = require './round'
exports.BracketSchema = require './bracket'
exports.StageSchema = require './stage'
exports.TeamSchema = require './team'
exports.TeamRefSchema = require './team_ref'

console.log 'Registering core models…'

try
  exports.Bracket = mongoose.model 'Bracket', exports.BracketSchema
  exports.Country = mongoose.model 'Country', exports.CountrySchema
  exports.Game = mongoose.model 'Game', exports.GameSchema
  exports.Match = mongoose.model 'Match', exports.MatchSchema
  exports.Player = mongoose.model 'Player', exports.PlayerSchema
  exports.Race = mongoose.model 'Race', exports.RaceSchema
  exports.ResultSet = mongoose.model 'ResultSet', exports.ResultSetSchema
  exports.Report = mongoose.model 'Report', exports.ReportSchema
  exports.Result = mongoose.model 'Result', exports.ResultSchema
  exports.Round = mongoose.model 'Round', exports.RoundSchema
  exports.Stage = mongoose.model 'Stage', exports.StageSchema
  exports.Team = mongoose.model 'Team', exports.TeamSchema
  exports.TeamRef = mongoose.model 'TeamRef', exports.TeamRefSchema
catch e
  console.log 'Some troubles with registering', e
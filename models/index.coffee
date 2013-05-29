###
 * index
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:22
###

mongoose = require 'mongoose'

exports.UserSchema = require './user'
exports.LogSchema = require './log'

#exports.ChampionshipSchema = require './championship'
exports.CountrySchema = require './country'
exports.GameSchema = require './game'
exports.MatchSchema = require './match'
exports.PlayerSchema = require './player'
exports.RaceSchema = require './race'
exports.ReportSchema = require './report'
exports.ResultSchema = require './result'
exports.RoundSchema = require './round'
exports.StageSchema = require './stage'
exports.TeamSchema = require './team'
exports.TeamRefSchema = require './team_ref'

console.log 'Registering models…'

try
  exports.User = mongoose.model 'User', exports.UserSchema
  exports.Log = mongoose.model 'Log', exports.LogSchema

#  exports.Championship = mongoose.model 'Championship', exports.ChampionshipSchema
  exports.Country = mongoose.model 'Country', exports.CountrySchema
  exports.Game = mongoose.model 'Game', exports.GameSchema
  exports.Match = mongoose.model 'Match', exports.MatchSchema
  exports.Player = mongoose.model 'Player', exports.PlayerSchema
  exports.Race = mongoose.model 'Race', exports.RaceSchema
  exports.Report = mongoose.model 'Report', exports.ReportSchema
  exports.Result = mongoose.model 'Result', exports.ResultSchema
  exports.Round = mongoose.model 'Round', exports.RoundSchema
  exports.Stage = mongoose.model 'Stage', exports.StageSchema
  exports.Team = mongoose.model 'Team', exports.TeamSchema
  exports.TeamRef = mongoose.model 'TeamRef', exports.TeamRefSchema
catch e
  console.log 'Some troubles with registering', e

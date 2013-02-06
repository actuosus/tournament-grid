###
 * index
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:22
###

mongoose = require 'mongoose'

exports.ChampionshipSchema = require './championship'
exports.CountrySchema = require './country'
exports.GameSchema = require './game'
exports.MatchSchema = require './match'
exports.PlayerSchema = require './player'
exports.RoundSchema = require './round'
exports.TeamSchema = require './team'

console.log 'Registering models…'

exports.Championship = mongoose.model 'Championship', exports.ChampionshipSchema
exports.Country = mongoose.model 'Country', exports.CountrySchema
exports.Game = mongoose.model 'Game', exports.GameSchema
exports.Match = mongoose.model 'Match', exports.MatchSchema
exports.Player = mongoose.model 'Player', exports.PlayerSchema
exports.Round = mongoose.model 'Round', exports.RoundSchema
exports.Team = mongoose.model 'Team', exports.TeamSchema
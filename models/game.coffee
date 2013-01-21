###
 * game
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 02:59
###

Config = require '../conf'
conf = new Config
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

GameSchema = new Schema
  name: type: String
  description: type: String
  date: type: Date
  map_type: type: String
  type: type: enum
  status: type: String
  championship: type: ObjectId, ref: 'Championship'
  team1_id: type: ObjectId, ref: 'Team'
  team2_id: type: ObjectId, ref: 'Team'
  team1_points: type: Number
  team2_points: type: Number
  player1_points: type: Number
  player2_points: type: Number
  player1_race_id: type: Number
  player2_race_id: type: Number

module.exports = GameSchema
###
 * match
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

MatchSchema = new Schema
  name: type: String
  description: type: String # editable
  date: type: Date # editable
  map_type: type: String # editable
  type: type: String
  status: type: String
  championship: type: ObjectId, ref: 'Championship'
  entrant1_id: type: ObjectId, ref: 'Team' # editable
  entrant2_id: type: ObjectId, ref: 'Team' # editable
  entrant1_points: type: Number # editable
  entrant2_points: type: Number # editable
  player1_points: type: Number
  player2_points: type: Number
  player1_race_id: type: Number
  player2_race_id: type: Number
  round_id: type: ObjectId, ref: 'Round'

  games: [type: ObjectId, ref: 'Game'] # editable

module.exports = MatchSchema
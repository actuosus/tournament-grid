###
 * result_set
 * @author: actuosus
 * Date: 30/05/2013
 * Time: 21:28
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

ResultSetSchema = new Schema
  is_selected: type: Boolean
  entrant_id: type: ObjectId, ref: 'TeamRef'
  round_id: type: ObjectId, ref: 'Round'
  sort_index: type: Number

  position: type: Number
  matches_played: type: Number
  wins: type: Number
  draws: type: Number
  losses: type: Number
  points: type: Number
  difference: type: Number

  results: [type: ObjectId, ref: 'Result']
#  report_id: type: ObjectId, ref: 'Report'

module.exports = ResultSetSchema
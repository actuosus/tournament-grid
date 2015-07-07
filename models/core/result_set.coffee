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
  is_selected: type: Boolean, default: no
  entrant_id: type: ObjectId, ref: 'TeamRef'
  round_id: type: ObjectId, ref: 'Round'
  sort_index: type: Number

  automatic: type: Boolean, default: no

  position: type: Number
  matches_played: type: Number
  wins: type: Number
  draws: type: Number
  losses: type: Number
  points: type: Number
  difference: type: String

  results: [type: ObjectId, ref: 'Result']
#  report_id: type: ObjectId, ref: 'Report'

ResultSetSchema.virtual('id').get -> @_id.toHexString()
ResultSetSchema.virtual('type').get -> 'team'
ResultSetSchema.virtual('entrantType').get -> 'teamRef'
ResultSetSchema.set 'toJSON', virtuals: yes

module.exports = ResultSetSchema
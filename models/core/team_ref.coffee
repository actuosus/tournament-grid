###
 * team_ref
 * @author: actuosus
 * Date: 24/04/2013
 * Time: 06:36
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

TeamRefSchema = new Schema
  team_id: type: ObjectId, ref: 'Team', required: yes

  report_id: type: ObjectId, ref: 'Report'
  round_id: type: ObjectId, ref: 'Round'
  match_id: type: ObjectId, ref: 'Match'

  captain_id: type: ObjectId, ref: 'Player'

  players: [type: ObjectId, ref: 'Player']

module.exports = TeamRefSchema
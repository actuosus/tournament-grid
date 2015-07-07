###
 * team_ref
 * @author: actuosus
 * Date: 24/04/2013
 * Time: 06:36
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
fieldsAliasPlugin = require('mongoose-aliasfield')
deepPopulate = require('mongoose-deep-populate')

TeamRefSchema = new Schema
  team_id: type: ObjectId, ref: 'Team', required: yes, alias: 'team'

  report_id: type: ObjectId, ref: 'Report'
  round_id: type: ObjectId, ref: 'Round'
  match_id: type: ObjectId, ref: 'Match'

  captain_id: type: ObjectId, ref: 'Player'

  players: [type: ObjectId, ref: 'Player']

TeamRefSchema.plugin fieldsAliasPlugin
TeamRefSchema.plugin deepPopulate

module.exports = TeamRefSchema
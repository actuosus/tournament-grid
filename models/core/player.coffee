###
 * player
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 02:59
###

_ = require 'lodash'
mongoose = require 'mongoose'
socketNotifyPlugin = require '../../lib/mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

PlayerSchema = new Schema
  country_id: type: ObjectId, ref: 'Country'
  team_id: type: ObjectId, ref: 'Team'

  nickname: type: String, required: yes
  first_name: type: String
  middle_name: type: String
  last_name: type: String

  is_captain: type: Boolean, default: no

  # Extras
  gender: type: String, 'enum': ['male', 'female', 'undefined'], 'default': 'undefined'
  birthdate: type: Date
  about: type: String

PlayerSchema.virtual('fullName').get ->
  _.compact([@first_name, @last_name]).join(' ')

PlayerSchema.plugin socketNotifyPlugin

module.exports = PlayerSchema
###
 * player
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 02:59
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

PlayerSchema = new Schema
  country_id: type: ObjectId, ref: 'Country'
  team_id: type: ObjectId, ref: 'Team'

  nickname: type: String
  first_name: type: String
  middle_name: type: String
  last_name: type: String

  is_captain: type: Boolean

module.exports = PlayerSchema
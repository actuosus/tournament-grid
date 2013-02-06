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
  nickname: type: String
  realname: type: String
  country_id: type: ObjectId, ref: 'Country'
  team_id: type: ObjectId, ref: 'Team'

module.exports = PlayerSchema
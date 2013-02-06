###
 * team
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

TeamSchema = new Schema
  name: type: String
  country_id: type: ObjectId, ref: 'Country'
  profile_url: type: String
  players: [type: ObjectId, ref: 'Player']

module.exports = TeamSchema
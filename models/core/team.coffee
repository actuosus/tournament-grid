###
 * team
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 02:59
###

mongoose = require 'mongoose'
socketNotifyPlugin = require '../../lib/mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

TeamSchema = new Schema
  name: type: String, required: yes
  description: type: String
  is_pro: type: Boolean, default: no

  # Relations
  country_id: type: ObjectId, ref: 'Country'
  profile_url: type: String
  players: [type: ObjectId, ref: 'Player']

  # Extras
  site: type: String

TeamSchema.plugin socketNotifyPlugin

module.exports = TeamSchema
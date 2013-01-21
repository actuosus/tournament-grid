###
 * player
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

PlayerSchema = new Schema
  name: type: String
  country: type: ObjectId, ref: 'Country'

module.exports = PlayerSchema
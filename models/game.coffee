###
 * game
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 05:11
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

GameSchema = new Schema
  name: type: String
  link: type: String
  match_id: type: ObjectId, ref: 'Match'

module.exports = GameSchema
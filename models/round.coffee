###
 * round
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 14:23
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

RoundSchema = new Schema
  championship: type: ObjectId, ref: 'Championship'
  name: type: String
  sort_index: type: Number
  matches: [type: ObjectId, ref: 'Match']

module.exports = RoundSchema
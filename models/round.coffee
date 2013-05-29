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
  sort_index: type: Number
  championship: type: ObjectId, ref: 'Championship'
  name: type: String
  _name:
    ru: type: String
    en: type: String
    de: type: String
  stage_id: type: ObjectId, ref: 'Stage'
  matches: [type: ObjectId, ref: 'Match']

  team_refs: [type: ObjectId, ref: 'TeamRef']

module.exports = RoundSchema
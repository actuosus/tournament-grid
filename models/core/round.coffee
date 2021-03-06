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
deepPopulate = require('mongoose-deep-populate')

RoundSchema = new Schema
  sort_index: type: Number
  title: type: String
  _title:
    ru: type: String
    en: type: String
    de: type: String
  stage_id: type: ObjectId, ref: 'Stage'
  matches: [type: ObjectId, ref: 'Match']

  bracket_name: type: String

  team_refs: [type: ObjectId, ref: 'TeamRef']

  result_sets: [type: ObjectId, ref: 'ResultSet']

RoundSchema.plugin deepPopulate

module.exports = RoundSchema
###
 * stage
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 03:00
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

StageSchema = new Schema
  name: type: String
  _name:
    ru: type: String
    en: type: String
    de: type: String
  description: type: String
  report_id: type: ObjectId, ref: 'Report'
  visual_type: type: String # html
  sort_index: type: Number
  entrants_count: type: Number
  rounds: [type: ObjectId, ref: 'Round']
  rating: type: Number

module.exports = StageSchema
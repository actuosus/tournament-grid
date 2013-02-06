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
  report_id: type: ObjectId, ref: 'Report'
  visual_type: type: String
  sort_index: type: Number
  entrants_count: type: Number
  rounds: [type: ObjectId, ref: 'Round']

module.exports = StageSchema
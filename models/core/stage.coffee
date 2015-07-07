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
deepPopulate = require('mongoose-deep-populate')

StageSchema = new Schema
  title: type: String, required: yes
  _title:
    ru: type: String
    en: type: String
    de: type: String
  description: type: String
  visual_type: type: String, required: yes, enum: ['matrix', 'single', 'double', 'team', 'group'] # TODO What about html?
  sort_index: type: Number
  rating: type: Number
  entrants_number: type: Number

  # Relations
  report_id: type: ObjectId, ref: 'Report', required: yes
  brackets: [type: ObjectId, ref: 'Bracket']
  rounds: [type: ObjectId, ref: 'Round']

StageSchema.plugin deepPopulate

module.exports = StageSchema
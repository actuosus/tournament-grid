###
 * bracket
 * @author: actuosus
 * Date: 13/06/2013
 * Time: 21:12
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

BracketSchema = new Schema
  sort_index: type: Number
  title: type: String
  _title:
    ru: type: String
    en: type: String
    de: type: String
  stage_id: type: ObjectId, ref: 'Stage'
  rounds: [type: ObjectId, ref: 'Round']

module.exports = BracketSchema
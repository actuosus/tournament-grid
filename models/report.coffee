###
 * report
 * @author: actuosus
 * @fileOverview 
 * Date: 01/02/2013
 * Time: 20:18
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

ReportSchema = new Schema
  name: type: String
  _name:
    ru: type: String
    en: type: String
    de: type: String
  description: type: String
  _description:
    ru: type: String
    en: type: String
    de: type: String
  sponsors: type: String
  place: type: String
  _place:
    ru: type: String
    en: type: String
    de: type: String
  start_date: type: Date
  end_date: type: Date

  author: type: ObjectId, ref: 'User'


  stages: [type: ObjectId, ref: 'Stage']
  # Тип матча
  match_type: type: String # team, player
  # Game type
  discipline: type: String

  noRating: type: Boolean

ReportSchema.methods.loc = (key, lang)->
  console.log key, lang
  @["_#{key}"][lang] if @["_#{key}"]

module.exports = ReportSchema
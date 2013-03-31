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
  title: type: String
  _title:
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

  entrants: [type: ObjectId, ref: 'Teams']

  stages: [type: ObjectId, ref: 'Stage']
  # Тип матча
  match_type: type: String # team, player
  # Game type
  discipline: type: String

  noRating: type: Boolean

ReportSchema.methods.loc = (key, lang)->
#  console.log key, lang, @[key]
  if @["_#{key}"]
    @["_#{key}"][lang]
  else
    @[key]

module.exports = ReportSchema
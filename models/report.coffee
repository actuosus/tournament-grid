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
  stages: [type: ObjectId, ref: 'Stage']

  place: type: String
  start_date: type: Date
  end_date: type: Date
  sponsors: type: String

  # Тип матча
  match_type: type: String # team, player

  # Game type
  discipline: type: String

  noRating: type: Boolean

module.exports = ReportSchema
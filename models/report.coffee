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
  description: type: String
  sponsors: type: String
  place: type: String
  start_date: type: Date
  end_date: type: Date

  author: type: ObjectId, ref: 'User'


  stages: [type: ObjectId, ref: 'Stage']
  # Тип матча
  match_type: type: String # team, player
  # Game type
  discipline: type: String

  noRating: type: Boolean

module.exports = ReportSchema
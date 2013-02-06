###
 * result
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 02:59
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

ResultSchema = new Schema
  points: type: Number
  difference: type: String
  team_id: type: ObjectId, ref: 'Team'
  report_id: type: ObjectId, ref: 'Report'

module.exports = ResultSchema
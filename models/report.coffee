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
  start_date: type: Date
  stages: [type: ObjectId, ref: 'Stage']

module.exports = ReportSchema
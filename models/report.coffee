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
  matches: [type: ObjectId, ref: 'Match']
  visualType: type: String

module.exports = ReportSchema
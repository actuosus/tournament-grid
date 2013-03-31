###
 * log
 * @author: actuosus
 * Date: 29/03/2013
 * Time: 02:30
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

LogSchema = new Schema
  message: type: String
  date: type: Date
  level: type: Number
  data: type: Object

module.exports = LogSchema
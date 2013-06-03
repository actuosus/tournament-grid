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
  sort_index: type: Number
  name: type: String
  value: type: String

  result_set_id: type: ObjectId, ref: 'ResultSet'

module.exports = ResultSchema
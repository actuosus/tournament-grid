###
 * country
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 03:01
###

Config = require '../conf'
conf = new Config
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

CountrySchema = new Schema
  name: type: String
  englishName: type: String
  germanName: type: String
  code: type: String

module.exports = CountrySchema
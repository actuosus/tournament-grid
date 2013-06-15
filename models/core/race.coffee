###
 * race
 * @author: actuosus
 * Date: 17/04/2013
 * Time: 19:29
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

RaceSchema = new Schema
  identifier: type: String
  title: type: String
  _title:
    ru: type: String
    en: type: String
    de: type: String
  icon_url: type: String

module.exports = RaceSchema
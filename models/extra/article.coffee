###
 * article
 * @author: actuosus
 * Date: 02/04/2013
 * Time: 17:44
###

Config = require '../conf'
conf = new Config
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

ArticleSchema = new Schema
  title: type: String
  text: type: String
  date: type: Date

module.exports = ArticleSchema
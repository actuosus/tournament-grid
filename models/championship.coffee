###
 * championship
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 02:59
###

Config = require '../conf'
conf = new Config
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

ChampionshipSchema = new Schema
  name: type: String
  games: [type: ObjectId, ref: 'Game']
  start_date: type: Date

module.exports = ChampionshipSchema
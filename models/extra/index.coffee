###
 * index
 * @author: actuosus
 * Date: 13/05/2013
 * Time: 02:47
###

mongoose = require 'mongoose'

exports.UserSchema = require './user'
exports.LogSchema = require './log'

console.log 'Registering extra models…'

try
  exports.User = mongoose.model 'User', exports.UserSchema
  exports.Log = mongoose.model 'Log', exports.LogSchema
catch e
  console.log 'Some troubles with registering', e

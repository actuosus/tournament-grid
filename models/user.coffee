###
 * user
 * @author: actuosus
 * Date: 18/03/2013
 * Time: 20:25
###

mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

UserSchema = new Schema
  username: type: String
  password: type: String

UserSchema.methods.validPassword = (password)-> @password is password

module.exports = UserSchema
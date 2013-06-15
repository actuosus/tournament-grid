###
 * user
 * @author: actuosus
 * Date: 18/03/2013
 * Time: 20:25
###

crypto = require 'crypto'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

UserSchema = new Schema
  username: type: String
  password: type: String
  email: type: String

  language: type: String

UserSchema.methods.validPassword = (password)-> @password is password

UserSchema.virtual('gravatar').get(->
  "http://www.gravatar.com/avatar/#{crypto.createHash('md5').update(@email).digest('hex')}" if @email
)

module.exports = UserSchema
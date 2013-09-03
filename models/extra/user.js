// Generated by CoffeeScript 2.0.0-beta8-dev
void function () {
  var crypto, mongoose, ObjectId, Schema, UserSchema;
  crypto = require('crypto');
  mongoose = require('mongoose');
  Schema = mongoose.Schema;
  ObjectId = Schema.ObjectId;
  UserSchema = new Schema({
    username: String,
    password: String,
    email: String,
    role: String,
    language: String
  });
  UserSchema.methods.validPassword = function (password) {
    return this.password === password;
  };
  UserSchema.virtual('gravatar').get(function () {
    if (this.email)
      return 'http://www.gravatar.com/avatar/' + crypto.createHash('md5').update(this.email).digest('hex');
  });
  module.exports = UserSchema;
}.call(this);

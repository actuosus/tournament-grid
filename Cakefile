#option '-o', '--output [DIR]', 'directory for compiled code'

task 'db:seed', 'Seed database with fixtures', (options) ->
  path = require 'path'
  mongoose = require 'mongoose'

  Config = require './conf'
  conf = new Config()
  mongoose.connect conf.mongo
  models = require './models'

  fixtures = require './lib/fixtures'
  fixtures.load __dirname + '/fixtures', (err)->
    console.log "Cannot load fixtures. #{err}" if err
    process.exit()
#option '-o', '--output [DIR]', 'directory for compiled code'

{spawn, exec} = require 'child_process'
util = require 'util'
Config = require './conf'
conf = new Config()

task 'work', 'Start application server and open a browser', ->
  invoke 'run'

task 'run', 'Start application server', ->
  console.log 'Starting application server…'
  server = spawn 'node', ['server']
  server.stdout.setEncoding 'utf8'
  server.stderr.setEncoding 'utf8'
  server.stdout.on 'data', (data)->
    console.log '\t', data.replace '\n', ''
    if data.match 'Express server listening'
      invoke 'browse'
  server.stderr.on 'data', (data)->
    util.print data

task 'heroku:deploy', 'Deploy the project to Heroku', ->
  exec 'git push heroku master'

task 'browse', 'Open web browser', ->
  conf = new Config()
  url = "http://#{conf.hostname}:#{conf.port}/"
  console.log "Opening web browser at #{url}…"
  spawn 'open', [url]

task 'db:seed', 'Seed database with fixtures', (options) ->
  path = require 'path'
  mongoose = require 'mongoose'
  mongoose.connect conf.mongo
  models = require './models'

  fixtures = require './lib/fixtures'
  fixtures.load __dirname + '/fixtures', (err)->
    console.log "Cannot load fixtures. #{err}" if err
    process.exit()
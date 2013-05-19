###
 * teams
 * @author: actuosus
 * Date: 13/05/2013
 * Time: 05:32
###

request = require 'superagent'
should = require 'should'
api = require '../../app'
Config = require '../../conf'
conf = new Config

describe 'Teams', ->
  before (done)->
    # Configuring server port
    api.app.set 'port', conf.port
    api.models.Team.create {name: 'Nutbreaker'}, (err, doc)->
      # Starting the server
    api.init -> done()

  after (done)->
    api.teardown -> done()

  describe 'list', ->
    it 'should return the list of teams', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/api/teams")
        .end (res)->
          res.statusCode.should.equal 200
          done()

  describe 'item', ->
    it 'should return the one team', (done)->
      api.models.Team.find (err, docs)->
        team = docs[0]
        request
          .get("http://#{conf.hostname}:#{conf.port}/api/teams/#{team._id}")
          .end (res)->
            res.statusCode.should.equal 200
            res.body.team.name.should.equal team.name
            done()
###
 * players
 * @author: actuosus
 * Date: 13/05/2013
 * Time: 05:06
###

request = require 'superagent'
should = require 'should'
api = require '../../app'
Config = require '../../conf'
conf = new Config

describe 'Players', ->
  before (done)->
    # Configuring server port
    api.app.set 'port', conf.port
    api.models.Player.create {nickname: 'Jordan'}, (err, doc)->
      # Starting the server
    api.init -> done()

  after (done)->
    api.teardown -> done()

  describe 'list', ->
    it 'should return the list of players', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/api/players")
        .end (res)->
          res.statusCode.should.equal 200
          done()

  describe 'item', ->
    it 'should return the one player', (done)->
      api.models.Player.find (err, docs)->
        player = docs[0]
        request
          .get("http://#{conf.hostname}:#{conf.port}/api/players/#{player._id}")
          .end (res)->
            res.statusCode.should.equal 200
            res.body.player.nickname.should.equal player.nickname
            done()
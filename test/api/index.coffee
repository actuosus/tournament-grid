###
 * index
 * @author: actuosus
 * Date: 13/05/2013
 * Time: 03:06
###

request = require 'superagent'
chai = require 'chai'
#api = require '../../app'
#Config = require '../../conf'
#conf = new Config

#exports.countries = require './countries'
#
#exports.reports = require './reports'
#exports.stages = require './stages'
#exports.brackets = require './brackets'
#exports.rounds = require './rounds'
#exports.matches = require './matches'
#exports.games = require './games'
#exports.resultSets = require './result_sets'
#exports.teams = require './teams'
#exports.teamRefs = require './team_refs'
#exports.players = require './players'

describe 'API', ->
#  before (done)->
#    # Configuring server port
#    api.app.set 'port', conf.port
#      # Starting the server
#    api.init -> done()
#
#  after (done)-> api.teardown -> done()

  describe 'Entities', ->
    it 'should return nothing for unknown entity', (done)->
      url = "http://#{conf.hostname}:#{conf.port}/api/unknown"
      request.get(url).end (res)->
        res.status.should.equal 404
        request.post(url).end (res)->
          res.status.should.equal 404
          request.put(url).end (res)->
            res.status.should.equal 404
            request.del(url).end (res)->
              res.status.should.equal 404
              done()

  describe 'Authentication', ->
    it 'should has login method'
    it 'should has logout method'
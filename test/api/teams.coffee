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
  entity = name: 'team', plural: 'teams'
  namespace = "api/#{entity.plural}"

  before (done)->
    # Configuring server port
    api.app.set 'port', conf.port
      # Starting the server
    api.init ->
      api.models.Team.create {name: 'Nutbreaker'}, (err, doc)->
        api.models.Team.create {name: 'Another team'}, (err, doc)->
          api.models.Team.create {name: 'Third team'}, (err, doc)->
            done()

  after (done)->
    api.models.Team.collection.remove (err)-> console.log err
    api.teardown -> done()

  describe 'list', ->
    it 'should return the list of items', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .end (res)->
          res.statusCode.should.equal 200
          should.exist res.body.teams
          done()

    it 'should return the list of items by ids', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .end (res)->
          res.statusCode.should.equal 200
          should.exist res.body.teams
          ids = res.body.teams.map (_)-> _._id
          query = 'ids=' + ids.join("&ids=")
          request
            .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
            .query(query)
            .end (res)->
              res.statusCode.should.equal 200

              recievedIds = res.body.teams.map (_)-> _._id

              # TODO Resolve comparison.
#              ids.should.be.equal recievedIds

              done()

    it 'should return the list of items if querying by name substring', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .query(name: 'e')
        .end (res)->
          res.statusCode.should.equal 200

          should.exist res.body[entity.plural]

          # TODO Refine assertion.
          res.body[entity.plural].length.should.be.above 1

          done()

  describe 'item', ->
    it 'should return the one team', (done)->
      api.models.Team.find (err, docs)->
        team = docs[0]
        request
          .get("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{team._id}")
          .end (res)->
            res.statusCode.should.equal 200
            res.body.team.name.should.equal team.name
            done()
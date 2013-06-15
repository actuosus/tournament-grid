###
 * team_refs
 * @author: actuosus
 * Date: 13/06/2013
 * Time: 18:52
###

request = require 'superagent'
chai = require 'chai'
api = require '../../app'
Config = require '../../conf'
conf = new Config

describe 'TeamRefs', ->
  entity = name: 'team_ref', plural: 'team_refs'
  namespace = "api/#{entity.plural}"

  teamNamespace = 'api/teams'
  getTeamItems = (done)->
    request
      .get("http://#{conf.hostname}:#{conf.port}/#{teamNamespace}")
      .end (res)->
        res.status.should.equal 200
        done res.body.teams

  getItems = (done)->
    request
      .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
      .end (res)->
        res.status.should.equal 200
        items = res.body[entity.plural]
        items.should.exist
        done items

  before (done)->
    # Configuring server port
    api.app.set 'port', conf.port
    # Starting the server
    api.init ->
      api.models.Team.create {name: 'Referencial'}, (err, oneTeam)->
        api.models.Team.create {name: 'Different ref team'}, (err, anotherTeam)->
          api.models.TeamRef.create {team_id: oneTeam._id}, (err, teamRef)->
            api.models.TeamRef.create {team_id: anotherTeam._id}, (err, teamRef)->
              if teamRef then done() else throw err

  after (done)->
    api.teardown ->
      api.models.Team.collection.remove (err)-> console.log err
      api.models.TeamRef.collection.remove (err)-> console.log err
      done()

  describe 'list', ->
    it 'should return the list of items', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .end (res)->
          items = res.body[entity.plural]
          items.should.exist
          res.status.should.equal 200
          done()

    it 'should return the list of items by ids', (done)->
      getItems (docs)->
          ids = docs.map (_)-> _._id
          query = 'ids=' + ids.join("&ids=")
          request
            .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
            .query(query)
            .end (res)->
              res.status.should.equal 200

              recievedIds = res.body[entity.plural].map (_)-> _._id

              # TODO Resolve comparison.
              #              ids.should.be.equal recievedIds

              done()

  describe 'item', ->
    it 'should return the one item', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .end (res)->
          res.status.should.equal 200
          item = res.body[entity.plural][0]
          request
            .get("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
            .end (res)->
              res.status.should.equal 200

              item = res.body[entity.name]
              item.should.exist

              item.team_id.should.equal item.team_id

              done()

    it 'should return not found message', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}/unknown_id")
        .end (res)->
          res.status.should.equal 404

          done()

    it 'should create one item', (done)->
      getTeamItems (teams)->
        team = teams[0]
        data = {}
        data[entity.name] = {team_id: team}
        request
          .post("http://#{conf.hostname}:#{conf.port}/#{namespace}")
          .send(data)
          .end (res)->
            res.status.should.equal 200

            done()

    it 'should update one item', (done)->
      getItems (docs)->
        item = docs[0]
        getTeamItems (teams)->
          team = teams[0]
          data = {}
          data[entity.name] = {team_id: team._id}
          request
            .put("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
            .send(data)
            .end (res)->
              res.status.should.equal 200

              item = res.body[entity.name]
              item.should.exist

              item.team_id.should.equal team._id

              done()

    it 'should delete one item', (done)->
      getItems (docs)->
        item = docs[0]
        request
          .del("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
          .end (res)->
            res.status.should.equal 204

            request
              .get("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
              .end (res)->
                res.status.should.equal 404
                done()
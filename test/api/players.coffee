###
 * players
 * @author: actuosus
 * Date: 13/05/2013
 * Time: 05:06
###

request = require 'superagent'
chai = require 'chai'
api = require '../../app'
Config = require '../../conf'
conf = new Config

describe 'Players', ->
  entity = name: 'player', plural: 'players'
  namespace = "api/#{entity.plural}"

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
      api.models.Player.create {nickname: 'Jordan'}, (err, doc)->
        api.models.Player.create {nickname: 'Funky'}, (err, doc)->
          done()

  after (done)->
    api.teardown -> done()

  describe 'list', ->
    it 'should return the list of players', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/api/players")
        .end (res)->
          res.status.should.equal 200
          done()

    it 'should return the list of items by ids', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .end (res)->
          res.status.should.equal 200
          ids = res.body[entity.plural].map (_)-> _._id
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

    it 'should return the list of items if querying by nickname substring', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .query(nickname: 'n')
        .end (res)->
          res.status.should.equal 200

          items = res.body[entity.plural]
          items.should.exist

          # TODO Refine assertion.
          items.length.should.be.above 1

          done()

  describe 'item', ->
    it 'should return the one player', (done)->
      getItems (docs)->
        player = docs[0]
        request
          .get("http://#{conf.hostname}:#{conf.port}/api/players/#{player._id}")
          .end (res)->
            res.status.should.equal 200
            res.body.player.nickname.should.equal player.nickname
            done()

    it 'should return not found message for unknown id', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}/unknown_id")
        .end (res)->
          res.status.should.equal 404

          done()

    it 'should create one item', (done)->
      data = {}
      data[entity.name] =
        nickname: 'Master'
        first_name: 'Вася'
        last_name: 'Пупкин'
      request
        .post("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .send(data)
        .end (res)->
          res.status.should.equal 200

          item = res.body[entity.name]
          item.should.exist

          item.nickname.should.be.equal data[entity.name].nickname

          done()

    it 'should update one item', (done)->
      getItems (docs)->
        item = docs[0]
        newTitle = 'Updated item'
        data = {}
        data[entity.name] = title: newTitle
        request
          .put("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
          .send(data)
          .end (res)->
            res.status.should.equal 200

            res.body[entity.name].title.should.equal newTitle

            done()

    it 'should not be able to be deleted', (done)->
      getItems (docs)->
        item = docs[0]
        request
          .del("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
          .end (res)->
            res.status.should.equal 404

            done()

    it 'should be addable to the team reference'
    it 'should be movable from one team reference to another'
    it 'should be removable from the team reference'
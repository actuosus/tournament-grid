###
 * games
 * @author: actuosus
 * Date: 13/06/2013
 * Time: 20:01
###

request = require 'superagent'
should = require 'should'
api = require '../../app'
Config = require '../../conf'
conf = new Config

describe 'Games', ->
  entity = name: 'game', plural: 'games'
  namespace = "api/#{entity.plural}"

  getItems = (done)->
    request
      .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
      .end (res)->
        res.statusCode.should.equal 200
        items = res.body[entity.plural]
        should.exist items
        done items

  match = null

  before (done)->
    # Configuring server port
    api.app.set 'port', conf.port
    # Starting the server
    api.init ->
      api.models.Match.create {title: 'Some match'}, (err, doc)->
        match = doc
        api.models.Game.create {title: 'Some game'}, (err, doc)->
          api.models.Game.create {title: 'Another game'}, (err, doc)->
            if doc then done() else throw err

  after (done)->
    api.teardown -> done()

  describe 'list', ->
    it 'should return the list of items', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .end (res)->
          res.statusCode.should.equal 200
          done()

    it 'should return the list of items by ids', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .end (res)->
          res.statusCode.should.equal 200
          ids = res.body[entity.plural].map (_)-> _._id
          query = 'ids=' + ids.join("&ids=")
          request
            .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
            .query(query)
            .end (res)->
              res.statusCode.should.equal 200

              recievedIds = res.body[entity.plural].map (_)-> _._id

              # TODO Resolve comparison.
              #              ids.should.be.equal recievedIds

              done()

  describe 'item', ->
    it 'should return the one item', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .end (res)->
          res.statusCode.should.equal 200
          item = res.body[entity.plural][0]
          request
            .get("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
            .end (res)->
              res.statusCode.should.equal 200

              res.body[entity.name].title.should.equal item.title

              done()

    it 'should return not found message', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}/unknown_id")
        .end (res)->
          res.statusCode.should.equal 404

          done()

    it 'should create one item', (done)->
      data = {}
      data[entity.name] =
        title: 'Some new game'
        match_id: match._id
      request
        .post("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .send(data)
        .end (res)->
          res.statusCode.should.equal 200

          item = res.body[entity.name]
          should.exist item

          item.title.should.be.equal data[entity.name].title

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
            res.statusCode.should.equal 200

            res.body[entity.name].title.should.equal newTitle

            done()

    it 'should delete one item', (done)->
      getItems (docs)->
        item = docs[0]
        request
          .del("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
          .end (res)->
            res.statusCode.should.equal 204

            request
              .get("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
              .end (res)->
                res.statusCode.should.equal 404
                done()
###
 * result_sets
 * @author: actuosus
 * Date: 13/06/2013
 * Time: 21:03
###

request = require 'superagent'
chai = require 'chai'
api = require '../../app'
Config = require '../../conf'
conf = new Config

describe 'ResultSets', ->
  entity = name: 'result_set', plural: 'result_sets'
  namespace = "api/#{entity.plural}"

  getItems = (done)->
    request
      .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
      .end (res)->
        res.status.should.equal 200
        items = res.body[entity.plural]
        items.should.exist
        done items

  report = null

  before (done)->
    # Configuring server port
    api.app.set 'port', conf.port
    # Starting the server
    api.init ->
      api.models.ResultSet.create {wins: 2}, (err, doc)->
        api.models.ResultSet.create {wins: 2, draws: 2}, (err, doc)->
          if doc then done() else throw err

  after (done)->
    api.models.ResultSet.collection.remove (err)-> console.log err
    api.teardown -> done()

  describe 'list', ->
    it 'should return the list of items', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
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

              res.body[entity.name].wins.should.equal item.wins

              done()

    it 'should return not found message', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}/unknown_id")
        .end (res)->
          res.status.should.equal 404

          done()

    it 'should create one item', (done)->
      data = {}
      data[entity.name] =
        wins: 3
      request
        .post("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .send(data)
        .end (res)->
          res.status.should.equal 200

          item = res.body[entity.name]
          item.should.exist

          item.wins.should.be.equal data[entity.name].wins

          done()

    it 'should update one item', (done)->
      getItems (docs)->
        item = docs[0]
        data = {}
        data[entity.name] = wins: 23
        request
          .put("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
          .send(data)
          .end (res)->
            res.status.should.equal 200

            res.body[entity.name].wins.should.equal 23

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
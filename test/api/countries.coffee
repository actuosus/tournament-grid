###
 * countries
 * @author: actuosus
 * Date: 13/06/2013
 * Time: 20:01
###

request = require 'superagent'
should = require 'should'
api = require '../../app'
Config = require '../../conf'
conf = new Config

describe 'Country', ->

  entity = name: 'country', plural: 'countries'
  namespace = "api/#{entity.plural}"

  getItems = (done)->
    request
      .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
      .end (res)->
        res.statusCode.should.equal 200
        items = res.body[entity.plural]
        should.exist items
        done items

  before (done)->
    # Configuring server port
    api.app.set 'port', conf.port
    # Starting the server
    api.init ->
      api.models.Country.create {name: 'Россия'}, (err, doc)->
        done()

  after (done)->
    api.teardown -> done()

  describe 'list', ->
    it 'should return the list of items', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .end (res)->
          res.statusCode.should.equal 200
          items = res.body[entity.plural]
          should.exist items
          done()

  describe 'item', ->
    it 'should return the one item', (done)->
      getItems (docs)->
        item = docs[0]
        request
          .get("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
          .end (res)->
            res.statusCode.should.equal 200

            res.body[entity.name].name.should.equal item.name

            done()

    it 'should return not found message', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}/unknown_id")
        .end (res)->
          res.statusCode.should.equal 404

          done()

    it 'should not be able to be created', (done)->
      data = {}
      data[entity.name] = {name: 'Готсвана'}
      request
        .post("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .send(data)
        .end (res)->
          res.statusCode.should.equal 404

          done()

    it 'should not be able to be updated', (done)->
      getItems (docs)->
        item = docs[0]
        request
          .put("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
          .end (res)->
            res.statusCode.should.equal 404

            done()

    it 'should not be able to be deleted', (done)->
      getItems (docs)->
        item = docs[0]
        request
          .del("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
          .end (res)->
            res.statusCode.should.equal 404

            done()
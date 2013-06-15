###
 * reports
 * @author: actuosus
 * Date: 13/05/2013
 * Time: 02:58
###

request = require 'superagent'
chai = require 'chai'
api = require '../../app'
Config = require '../../conf'
conf = new Config

describe 'Reports', ->

  entity = name: 'report', plural: 'reports'
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
      api.models.Report.create {title: 'Some good report'}, (err, doc)->
        done()

  after (done)->
    api.teardown -> done()

  describe 'list', ->
    it 'should return the list of reports', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .end (res)->
          res.status.should.equal 200
          items = res.body[entity.plural]
          items.should.exist
          done()

  describe 'item', ->
    it 'should return the one report', (done)->
      getItems (docs)->
        item = docs[0]
        request
          .get("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
          .end (res)->
            res.status.should.equal 200

            res.body[entity.name].title.should.equal item.title

            done()

    it 'should return not found message', (done)->
      request
        .get("http://#{conf.hostname}:#{conf.port}/#{namespace}/unknown_id")
        .end (res)->
          res.status.should.equal 404

          done()

    it 'should not be able to be created', (done)->
      data = {}
      data[entity.name] = {some: 'thing'}
      request
        .post("http://#{conf.hostname}:#{conf.port}/#{namespace}")
        .send(data)
        .end (res)->
          res.status.should.equal 404

          done()

    it 'should not be able to be updated', (done)->
      getItems (docs)->
        item = docs[0]
        request
          .put("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
          .end (res)->
            res.status.should.equal 404

            done()

    it 'should not be able to be deleted', (done)->
      getItems (docs)->
        item = docs[0]
        request
          .del("http://#{conf.hostname}:#{conf.port}/#{namespace}/#{item._id}")
          .end (res)->
            res.status.should.equal 404

            done()
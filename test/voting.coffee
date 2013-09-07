###
 * voting
 * @author: actuosus
 * Date: 03/09/2013
 * Time: 01:24
###

request = require 'superagent'
chai = require 'chai'
api = require '../app'
Config = require '../conf'
conf = new Config

describe 'Stream voting', ->
  entity = name: 'bracket', plural: 'brackets'
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
  stage = null

  before (done)->
    # Configuring server port
    api.app.set 'port', conf.port
    # Starting the server
    api.init -> done()

  after (done)->
    api.teardown -> done()

  describe 'Moderator', ->
    it 'should be able to create', (done)->
      request
      .get("http://#{conf.hostname}:#{conf.port}/#{namespace}")
      .end (res)->
          res.status.should.equal 200
          done()
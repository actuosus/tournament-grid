###
 * reports
 * @author: actuosus
 * Date: 13/05/2013
 * Time: 02:58
###

request = require 'superagent'
should = require 'should'
api = require '../../app'
Config = require '../../conf'
conf = new Config

describe 'Reports', ->
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
        .get("http://#{conf.hostname}:#{conf.port}/api/reports")
        .end (res)->
          res.statusCode.should.equal 200
          done()

  describe 'item', ->
    it 'should return the one report', (done)->
      api.models.Report.find (err, docs)->
        report = docs[0]
        request
          .get("http://#{conf.hostname}:#{conf.port}/api/reports/#{report._id}")
          .end (res)->
            res.statusCode.should.equal 200

            res.body.report.title.should.equal report.title

            done()
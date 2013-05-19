###
 * report
 * @author: actuosus
 * Date: 13/05/2013
 * Time: 05:50
###

api = require '../../app'
Report = api.models.Report
should = require 'should'

describe 'Report', ->
  it 'must have name', ->
    report = new Report
    should.equal undefined, report.get 'name'
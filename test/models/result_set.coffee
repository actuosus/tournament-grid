###
 * result_set
 * @author: actuosus
 * Date: 13/06/2013
 * Time: 21:27
###

api = require '../../app'
ResultSet = api.models.ResultSet
should = require 'should'

describe 'ResultSet', ->
  it 'must have position', ->
    item = new ResultSet
    should.equal undefined, item.get 'position'

  it 'must have wins', ->
    item = new ResultSet
    should.equal undefined, item.get 'draws'

  it 'must have losses', ->
    item = new ResultSet
    should.equal undefined, item.get 'losses'

  it 'must have draws', ->
    item = new ResultSet
    should.equal undefined, item.get 'draws'

  it 'must have points', ->
    item = new ResultSet
    should.equal undefined, item.get 'points'

  it 'must have difference', ->
    item = new ResultSet
    should.equal undefined, item.get 'difference'
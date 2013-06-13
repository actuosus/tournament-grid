###
 * stage
 * @author: actuosus
 * Date: 13/06/2013
 * Time: 21:28
###

api = require '../../app'
Stage = api.models.Stage
should = require 'should'

describe 'Stage', ->
  it 'must have title', ->
    item = new Stage
    should.equal undefined, item.get 'title'

  it 'must have description', ->
    item = new Stage
    should.equal undefined, item.get 'description'
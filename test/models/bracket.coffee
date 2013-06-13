###
 * bracket
 * @author: actuosus
 * Date: 13/06/2013
 * Time: 21:27
###

api = require '../../app'
Bracket = api.models.Bracket
should = require 'should'

describe 'Bracket', ->
  it 'must have title', ->
    item = new Bracket
    should.equal undefined, item.get 'title'
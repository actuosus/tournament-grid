###
 * match
 * @author: actuosus
 * Date: 13/05/2013
 * Time: 06:05
###

api = require '../../app'
Match = api.models.Match
should = require 'should'

describe 'Match', ->
  it 'must have status', ->
    match = new Match
    should.equal undefined, match.get 'status'
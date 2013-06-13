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
  it 'must have title', ->
    item = new Match
    should.equal undefined, item.get 'title'

  it 'must have description', ->
    item = new Match
    should.equal undefined, item.get 'description'

  it 'must have date', ->
    item = new Match
    should.equal undefined, item.get 'date'

  it 'must have default status as "opened"', ->
    match = new Match
    should.equal 'opened', match.get 'status'
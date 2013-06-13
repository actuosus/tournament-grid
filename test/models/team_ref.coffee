###
 * team_ref
 * @author: actuosus
 * Date: 13/06/2013
 * Time: 21:28
###

api = require '../../app'
TeamRef = api.models.TeamRef
should = require 'should'

describe 'TeamRef', ->
  it 'must have reference to the team', ->
    item = new TeamRef
    should.equal undefined, item.get 'team_id'

  it 'must have players'#, ->
#    item = new TeamRef
#    should.equal [], item.get 'players'

  it 'must have captain', ->
    item = new TeamRef
    should.equal undefined, item.get 'captain_id'
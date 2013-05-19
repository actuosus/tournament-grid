###
 * team
 * @author: actuosus
 * Date: 13/05/2013
 * Time: 05:59
###

api = require '../../app'
Team = api.models.Team
should = require 'should'

describe 'Team', ->
  it 'must have name', ->
    team = new Team
    should.equal undefined, team.get 'name'
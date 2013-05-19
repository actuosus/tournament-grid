###
 * player
 * @author: actuosus
 * Date: 13/05/2013
 * Time: 06:04
###

api = require '../../app'
Player = api.models.Player
should = require 'should'

describe 'Player', ->
  it 'must have nickname', ->
    player = new Player
    should.equal undefined, player.get 'nickname'

  it 'must have first name', ->
    player = new Player
    should.equal undefined, player.get 'first_name'

  it 'must have last name', ->
    player = new Player
    should.equal undefined, player.get 'last_name'
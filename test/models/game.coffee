###
 * game
 * @author: actuosus
 * Date: 13/06/2013
 * Time: 21:27
###

api = require '../../app'
Game = api.models.Game
should = require 'should'

describe 'Game', ->
  it 'must have title', ->
    item = new Game
    should.equal undefined, item.get 'title'

  it 'must have link', ->
    item = new Game
    should.equal undefined, item.get 'link'
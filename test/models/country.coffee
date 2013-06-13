###
 * country
 * @author: actuosus
 * Date: 13/06/2013
 * Time: 21:27
###

api = require '../../app'
Country = api.models.Country
should = require 'should'

describe 'Country', ->
  it 'must have name', ->
    item = new Country
    should.equal undefined, item.get 'name'
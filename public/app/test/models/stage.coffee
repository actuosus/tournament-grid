###
 * stage
 * @author: actuosus
 * Date: 13/05/2013
 * Time: 08:28
###

describe 'App.Stage', ->
  it 'must have the number of entrants', ->
    single = null
    Em.run ->
      single = App.Stage.find 1
    single.get('entrantsNumber').should.be.greaterThan 0
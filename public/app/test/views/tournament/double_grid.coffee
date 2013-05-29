###
 * double_grid
 * @author: actuosus
 * Date: 28/05/2013
 * Time: 21:37
###

define [
  'cs!views/tournament/double_grid'
],->
  describe 'App.NewDoubleTournamentGridView', ->
    it 'rendering should be fast', ->
      Em.run ->
        for i in [1..10]
          App.NewDoubleTournamentGridView.create(
            entrantsNumber: 8
          ).append()
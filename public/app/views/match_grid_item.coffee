###
 * match_grid_item
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:43
###

define [
  'text!templates/match_grid_item.handlebars'
], (template)->
  Em.TEMPLATES.matchGridItem = Em.Handlebars.compile template
  App.MatchGridItemView = Em.View.extend
    templateName: 'matchGridItem'
    classNames: ['match-grid-item']

    didInsertElement: ->
#      console.log @get 'round.matches.length'
      @.$().height(300 / @get('round.matches.length')).css('margin-top', 280 / @get('round.matches.length'))
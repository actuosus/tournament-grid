###
 * match_grid_item
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 07:43
###

define [
  'text!templates/match/grid_item.handlebars'
], (template)->
  Em.TEMPLATES.matchGridItem = Em.Handlebars.compile template
  App.MatchGridItemView = Em.View.extend
    templateName: 'matchGridItem'
    classNames: ['match-grid-item']

    didInsertElement: ->
#      console.log @get 'round.matches.length'
      console.log 'App.MatchGridItemView', @get('content.winner')
      console.log 'childViews', @get('childViews')

      @get('childViews').forEach (view)=>
        if App.TeamGridItemView.detectInstance view
          if view.get('isWinner')
            style = view.$().position()
            style.left += view.$().width()
            style.top += 280 / @get('round.matches.length')
            connector = document.createElement('div')
            connector.className = 'connector'
            $(connector).css(style)
            @$().append(connector)

      @.$()
      .height(300 / @get('round.matches.length'))
      .css('margin-top', 280 / @get('round.matches.length'))
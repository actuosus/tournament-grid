###
 * team_grid_item
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:43
###

define [
  'text!templates/team_grid_item.handlebars'
], (template)->
  Em.TEMPLATES.teamGridItem = Em.Handlebars.compile template
  App.TeamGridItemView = Em.View.extend
    templateName: 'teamGridItem'
    classNames: ['team-grid-item']

    match: Ember.computed -> @get 'parentView.content'

    countryFlagClassName: (->
      'country-flag-icon-%@'.fmt @get 'content.country.code'
    ).property('content.country.code')

    refreshWinnerState: (->
#      console.log @get('match.winner.id'), @get('content.id')
      if @get('match.winner.id') and @get('content.id')
        if @get('match.winner.id') is @get('content.id')
          @.$().addClass 'team-winner'
        else
          @.$().addClass 'team-loser'
    ).observes('match.winner', 'content')
#
#    didInsertElement: ->
#      @refreshWinnerState()

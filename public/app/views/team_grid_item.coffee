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
    classNameBindings: ['isWinner:team-winner:team-loser']

    isWinner: (-> @get('parentView.content.winner.id') is @get('content.id')).property 'points', 'parentView.content.winner'

    click: (event)->
      if $(event.target).hasClass('team-points')
        @$('.team-points').css
          '-webkit-user-modify': 'read-write'
          '-webkit-user-select': 'text'
        @$('.team-points').keyup =>
          console.log @$('.team-points').text()
          points = parseInt(@$('.team-points').text(), 10)
          if points
            @get('parentView.content').set(@get('identifier')+'_points', points)
            console.log @get('parentView.content')
          @$('.team-points').unbind('keyup').css {'-webkit-user-modify': 'none'}
        @$('.team-points').focus().select()

    match: Ember.computed ->
      console.log @get('parentView.content'), (@get('parentView.content.winner.id') is @get('content.id'))
      @get 'parentView.content'

    countryFlagClassName: (->
      'country-flag-icon-%@'.fmt @get 'content.country.code'
    ).property('content.country.code')

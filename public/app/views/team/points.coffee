###
 * points
 * @author: actuosus
 * Date: 08/04/2013
 * Time: 09:13
###

define [
  'cs!../autocomplete_text_field'
], ->
  ###
  Represents team model in grid. Also can be used standalone.
  ###
  App.TeamPointsView = Em.View.extend
    classNames: ['team-points']
    contentBinding: 'parentView.content'
    contentIndexBinding: 'parentView.contentIndex'
    template: Em.Handlebars.compile '{{view.parentView.points}}'

    click: ->
      if @get('parentView.isEditable')
        @$().css
          '-webkit-user-modify': 'read-write'
          '-webkit-user-select': 'text'
        @$().keyup =>
          match = @get('match')
          points = parseInt @$().text(), 10
          if points >= 0 and match
            match.set('entrant' + (@get('contentIndex')+1) + '_points', points)
        @$().blur => @$().unbind('keyup').css {'-webkit-user-modify': 'none'}
        @$().focus().select()
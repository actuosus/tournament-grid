###
 * teams
 * @author: actuosus
 * Date: 01/04/2013
 * Time: 06:37
###

define [
  'cs!../core'
  'cs!../models/team'
  'cs!../views/team/form'
], ->
  App.TeamsController = Em.ArrayController.extend
    formView: App.TeamForm
    searchResults: []
    labelValue: 'name'
    search: (options)->
      @set 'content', App.Team.find options
    menuItemViewClass: Em.View.extend
      classNames: ['menu-item']
      classNameBindings: ['isSelected']
      template: Em.Handlebars.compile(
        '{{highlight view.content.name partBinding=parentView.highlight}}'
      )
      click: (event)->
        event.preventDefault()
        event.stopPropagation()
        @get('parentView').click(event)
        @set 'parentView.selection', @get 'content'
        @set 'parentView.value', @get 'content'
        @set 'parentView.isVisible', no
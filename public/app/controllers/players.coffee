###
 * players
 * @author: actuosus
 * Date: 01/04/2013
 * Time: 06:39
###

define [
  'cs!../core'
  'cs!../models/player'
  'cs!../views/player/form'
], ->
  App.PlayersController = Em.ArrayController.extend
    formView: App.PlayerForm
    searchResults: []
    labelValue: 'nickname'
    search: (options)->
      searchOptions = {}
      if options.name
        searchOptions.nickname = options.name
      @set 'content', App.Player.find searchOptions
    menuItemViewClass: Em.View.extend
      classNames: ['menu-item']
      classNameBindings: ['isSelected']
      template: Em.Handlebars.compile('{{view.content.nickname}}')
      click: (event)->
        event.preventDefault()
        event.stopPropagation()
        @get('parentView').click(event)
        @set 'parentView.selection', @get 'content'
        @set 'parentView.value', @get 'content'
        @set 'parentView.isVisible', no
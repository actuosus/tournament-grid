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

    menuItemViewClass: Em.ContainerView.extend
      classNames: ['menu-item']
      classNameBindings: ['isSelected']
      attributeBindings: ['title']
      titleBinding: 'content._id'
      childViews: ['countryFlagView', 'nameView', 'realNameView']

      countryFlagView: Em.View.extend
        tagName: 'i'
        classNames: ['country-flag-icon', 'team-country-flag-icon']
        classNameBindings: ['countryFlagClassName', 'hasFlag']
        attributeBindings: ['title']
        contentBinding: 'parentView.content'
        title: (-> @get 'content.country.name').property('content.country')
        hasFlag: (-> !!@get 'content.country.code').property('content.country')
        countryFlagClassName: (->
          'country-flag-icon-%@'.fmt @get 'content.country.code'
        ).property('content.country.code')

      nameView: Em.View.extend
        contentBinding: 'parentView.content'
        classNames: ['lineup-grid-item-name']
        template: Em.Handlebars.compile '{{view.content.nickname}}'

      realNameView: Em.View.extend
        contentBinding: 'parentView.content'
        classNames: ['lineup-grid-item-real-name']
        isVisibleBinding: 'hasShortName'
        hasShortName: (->
          shortName = @get('content.shortName')
          yes if shortName and shortName isnt ' '
        ).property('content.shortName')
        template: Em.Handlebars.compile '({{view.content.shortName}})'

      click: (event)->
        event.preventDefault()
        event.stopPropagation()
        @get('parentView').click(event)
        @set 'parentView.selection', @get 'content'
        @set 'parentView.value', @get 'content'
        @set 'parentView.isVisible', no

#    Em.View.extend
#      classNames: ['menu-item']
#      classNameBindings: ['isSelected']
#      template: Em.Handlebars.compile(
#        '<i {{bindAttr class=":country-flag-icon :team-country-flag-icon view.content.country.flagClassName"}}></i>'+
#        '{{view.content.nickname}}'+
#        '{{view.content.shortName}}'
#      )
#      click: (event)->
#        event.preventDefault()
#        event.stopPropagation()
#        @get('parentView').click(event)
#        @set 'parentView.selection', @get 'content'
#        @set 'parentView.value', @get 'content'
#        @set 'parentView.isVisible', no
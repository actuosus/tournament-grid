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

    sort: (result, options)->
      lowerCased = options.nickname.toLowerCase()
      result.sort (a,b)->
        lowerA = a.get('nickname').toLowerCase()
        lowerB = b.get('nickname').toLowerCase()
        if lowerA.indexOf(lowerCased) < lowerB.indexOf(lowerCased)
          return -1
        if lowerA.indexOf(lowerCased) > lowerB.indexOf(lowerCased)
          return 1
        if lowerA.indexOf(lowerCased) is lowerB.indexOf(lowerCased)
          return 0

    fetchAutocompleteResults: (value, target)->
      @set 'lastQuery', {nickname: value}
      @set 'content', App.Player.find {nickname: value}
      @set 'autocompleteTarget', target
      @get('content').addObserver 'isLoaded', @, 'contentLoaded'

    cancelFetchingOfAutocompleteResults: ->
      content = @get 'content'
      content.req?.abort()
      content.removeObserver 'isLoaded', @, 'contentLoaded'

    contentLoaded: ->
      @get('content').removeObserver 'isLoaded', @, 'contentLoaded'
      @get('autocompleteTarget').didFetchAutocompleteResults @sort @get('content').toArray(), @get 'lastQuery'

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
        @get('parentView').selectMenuItem @get 'content'
        @set 'parentView.selection', @get 'content'
        @set 'parentView.value', @get 'content'
        @get('parentView').click(event)
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
###
 * merged_entrants
 * @author: actuosus
 * Date: 19/04/2013
 * Time: 21:21
###

define [
  'cs!../core'
  'cs!../models/team'
  'cs!../views/team/form'
], ->
  App.MergedEntrantsController = Em.ArrayController.extend
    formView: App.TeamForm
    searchResults: []
    labelValue: 'name'

    content: []
    sources: []

    sourceContentChanged: (->
      console.log 'sourceContentChanged'
      sources = @get 'sources'
      content = @get 'content'
      sources.forEach (source)->
#        console.log source.get('content'), source.get('content.isLoaded')
        if source.get('content.isLoaded')
          source.get('content')?.forEach (item)->
            console.log item
            if App.TeamRef.detect item
              item = item.get 'team'
            content.pushObject item
  #        content.pushObjects = source.get('content')
      console.log 'content', @get('content')
      @set 'content.isLoaded', yes
    ).observes('sources.@each.isLoaded')

    search: (options)->
      sources = @get 'sources'
      sources.forEach (source)->
        source.search options

    menuItemViewClass: Em.ContainerView.extend
      classNames: ['menu-item']
      classNameBindings: ['isSelected']
      attributeBindings: ['title']
      titleBinding: 'content._id'
      childViews: ['countryFlagView', 'nameView']

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
        template: Em.Handlebars.compile '{{view.content.name}}'

      click: (event)->
        event.preventDefault()
        event.stopPropagation()
        @get('parentView').click(event)
        @set 'parentView.selection', @get 'content'
        @set 'parentView.value', @get 'content'
        @set 'parentView.isVisible', no
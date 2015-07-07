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

    search: (options)->
      sources = @get 'sources'
      @set 'content', []
      @set 'arrangedContent.isLoaded', no
      @set 'arrangedContent.isUpdating', yes
      sources.forEach (source)-> source.search options
#      @notifyPropertyChange 'arrangedContent'

    arrayDidChange: (content, start, removed, added)->
      idx = start
      while idx < start+added
        @get('content').pushObject content.objectAtContent idx
        idx++
      @set 'arrangedContent.isLoaded', @get('sources').every (item)-> item.get('content.isLoaded')
      @set 'arrangedContent.isUpdating', no

    arrayWillChange: (content, start, removedCount)->

    sourceContentChanged: (->
      sources = @get 'sources'
      #      content = @get 'content'
      sources.forEach (source)=>
        source.get('arrangedContent').addArrayObserver @
    ).observes('sources.@each.arrangedContent')

    menuItemViewClass: Em.ContainerView.extend
      classNames: ['menu-item']
      classNameBindings: ['isSelected', 'isTeamRef']
      attributeBindings: ['title']
      isTeamRef: (->
        App.TeamRef.detectInstance @get 'content'
      ).property('content')
      team: (->
        content = @get 'content'
        if App.TeamRef.detectInstance content
          content.get 'team'
        else
          content
      ).property('content')
      titleBinding: 'team._id'
      childViews: ['countryFlagView', 'nameView']

      countryFlagView: Em.View.extend
        tagName: 'i'
        classNames: ['country-flag-icon', 'team-country-flag-icon']
        classNameBindings: ['countryFlagClassName', 'hasFlag']
        attributeBindings: ['title']
        contentBinding: 'parentView.team'
        title: (-> @get 'content.country.name').property('content.country')
        hasFlag: (-> !!@get 'content.country.code').property('content.country')
        countryFlagClassName: (->
          'country-flag-icon-%@'.fmt @get 'content.country.code'
        ).property('content.country.code')

      nameView: Em.View.extend
        contentBinding: 'parentView.team'
        classNames: ['lineup-grid-item-name']
        render: (_)-> _.push @get 'content.name'
        nameChanged: (-> @rerender() ).observes('content.name')

      showAddingNotify: ->
        modalView = App.ModalView.create
          target: @get 'parentView.autocompleteView'
        modalView.on 'ok', -> @hide()
        modalView.pushObject Em.ContainerView.create(
          childViews: ['contentView', 'buttonsView']
          contentView: Em.View.create( render: (_)-> _.push('Команда уже добавлена') )
          buttonsView: Em.ContainerView.create
            classNames: ['buttons']
            childViews: ['okButton']
            okButton: Em.View.create
              classNames: ['btn', 'btn-primary']
              tagName: 'button'
              render: (_)-> _.push '_ok'.loc()
              click: -> @get('parentView.parentView.parentView').trigger('ok')
        )
        modalView.appendTo App.get 'rootElement'

      click: (event)->
        event.preventDefault()
        event.stopPropagation()
        unless @get 'isTeamRef'
          @get('parentView').click(event)
          @set 'parentView.selection', @get 'team'
          @set 'parentView.value', @get 'team'
          @set 'parentView.isVisible', no
        else
          @showAddingNotify()
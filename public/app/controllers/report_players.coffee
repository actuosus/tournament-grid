###
 * report_players
 * @author: actuosus
 * Date: 29/09/2013
 * Time: 20:57
###

define ['cs!../views/country_flag'],->
  App.ReportPlayersController = Em.ArrayController.extend
    searchResults: []

    search: (options)->
      @set 'searchQuery', options.name

    searchPath: 'name'
    searchQuery: ''
    searchByPlayer: no

    filterWithQuery: (query)->
      content = @get 'content'
      searchPath = @get 'searchPath'
      if query
        reg = new RegExp query, 'gi'
        result = content.filter (item)->
          name = item.get searchPath
          matches = no
          matches = yes if name?.match reg
          matches
      else
        result = content
      result.set 'isLoaded', yes
      result

    arrangedContent: (->
      searchQuery = @get 'searchQuery'
      @filterWithQuery searchQuery
    ).property('content', 'searchQuery')

    all: ->
      @set 'arrangedContent', @get 'stage.entrants'
      @set 'arrangedContent.isLoaded', yes

    showAll: (target)->
      @set 'autocompleteTarget', target
      @get('autocompleteTarget').didFetchAutocompleteResults @get 'content'

    cancelFetchingOfAutocompleteResults: ->

    fetchAutocompleteResults: (value, target)->
      @set 'lastQuery', {nickname: value}
      @set 'content', App.Player.find {nickname: value}
      @set 'autocompleteTarget', target
      @get('content').addObserver 'isLoaded', @, 'contentLoaded'

    menuItemViewClass: Em.ContainerView.extend
      classNames: ['menu-item']
      classNameBindings: ['isSelected']
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

      countryFlagView: App.CountryFlagView.extend
        contentBinding: 'parentView.team.country'

      nameView: Em.View.extend
        classNames: ['lineup-grid-item-name']
        render: (_)-> _.push @get 'parentView.team.name'
        teamNameChanged: (-> @rerender() ).observes('parentView.team.name')

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
        @get('parentView').selectMenuItem? @get 'content'
        @get('parentView').click(event)
        @set 'parentView.selection', @get 'team'
        @set 'parentView.value', @get 'team'
        @set 'parentView.isVisible', no

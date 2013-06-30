###
 * report_entrants
 * @author: actuosus
 * Date: 14/05/2013
 * Time: 18:55
###

define ['cs!../views/country_flag'],->
  App.ReportEntrantsController = Em.ArrayController.extend
#    sortProperties: ['team.name']
    searchResults: []

    search: (options)->
      @set 'searchQuery', options.name

    searchPath: 'team.name'
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

    cancelFetchingOfAutocompleteResults: ->

    fetchAutocompleteResults: (value, target)->
      @set 'autocompleteTarget', target
      @get('autocompleteTarget').didFetchAutocompleteResults @filterWithQuery value

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

      countryFlagView: App.CountryFlagView.extend
        contentBinding: 'parentView.team.country'

      nameView: Em.View.extend
        classNames: ['lineup-grid-item-name']
        template: Em.Handlebars.compile '{{view.parentView.team.name}}'

      showAddingNotify: ->
        modalView = App.ModalView.create
          target: @get 'parentView.autocompleteView'
        modalView.on 'ok', -> @hide()
        modalView.pushObject Em.ContainerView.create(
          childViews: ['contentView', 'buttonsView']
          contentView: Em.View.create(template: Em.Handlebars.compile('Команда уже добавлена'))
          buttonsView: Em.ContainerView.create
            classNames: ['buttons']
            childViews: ['okButton']
            okButton: Em.View.create
              classNames: ['btn', 'btn-primary']
              tagName: 'button'
              template: Em.Handlebars.compile "{{loc '_ok'}}"
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

###
 * report_entrants
 * @author: actuosus
 * Date: 14/05/2013
 * Time: 18:55
###

define ->
  App.ReportEntrantsController = Em.ArrayController.extend
#    sortProperties: ['team.name']
    searchResults: []

    search: (options)->
      @set 'searchQuery', options.name

    searchPath: 'team.name'
    searchQuery: ''
    searchByPlayer: no

    arrangedContent: (->
      content = @get 'content'
      searchQuery = @get 'searchQuery'
      searchPath = @get 'searchPath'
      if searchQuery
        reg = new RegExp searchQuery, 'gi'
        result = content.filter (item)->
          name = item.get searchPath
          matches = no
          matches = yes if name?.match reg
          matches
      else
        result = content
      result.set 'isLoaded', yes
      result
    ).property('content', 'searchQuery')

    all: ->
      @set 'arrangedContent', @get 'stage.entrants'
      @set 'arrangedContent.isLoaded', yes

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
        template: Em.Handlebars.compile '{{view.content.name}}'

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
        modalView.append()

      click: (event)->
        event.preventDefault()
        event.stopPropagation()
        @get('parentView').click(event)
        @set 'parentView.selection', @get 'team'
        @set 'parentView.value', @get 'team'
        @set 'parentView.isVisible', no

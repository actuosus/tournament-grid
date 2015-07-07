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

    trans: {
      'А': 'A',
      'а': 'a',
      'Б': 'B',
      'б': 'b',
      'В': 'V',
      'в': 'v',
      'Г': 'G',
      'г': 'g',
      'Д': 'D',
      'д': 'd',
      'Е': 'E',
      'е': 'e',
      'Ё': 'E',
      'ё': 'e',
      'Ж': 'Zh',
      'ж': 'zh',
      'З': 'Z',
      'з': 'z',
      'И': 'I',
      'и': 'i',
      'Й': 'Y',
      'й': 'y',
      'К': 'K',
      'к': 'k',
      'Л': 'L',
      'л': 'l',
      'М': 'M',
      'м': 'm',
      'Н': 'N',
      'н': 'n',
      'О': 'O',
      'о': 'o',
      'П': 'P',
      'п': 'p',
      'Р': 'R',
      'р': 'r',
      'С': 'S',
      'с': 's',
      'Т': 'T',
      'т': 't',
      'У': 'U',
      'у': 'u',
      'Ф': 'F',
      'ф': 'f',
      'Х': 'Kh',
      'х': 'kh',
      'Ц': 'Ts',
      'ц': 'ts',
      'Ч': 'Ch',
      'ч': 'ch',
      'Ш': 'Sh',
      'ш': 'sh',
      'Щ': 'Sch',
      'щ': 'sch',
      'ь': '',
      'Ы': 'Y',
      'ы': 'y',
      'ъ': '',
      'Э': 'E',
      'э': 'e',
      'Ю': 'Yu',
      'ю': 'yu',
      'Я': 'Ya',
      'я': 'ya'
    }

    filterWithQuery: (query)->
      content = @get 'content'
      console.log content
      searchPath = @get 'searchPath'
      if query
#         map = @get 'trans'
#         for _ of map
#           query = query.replace _, map[_]
        reg = new RegExp query, 'gi'
        result = content.filter (item)->
          name = item?.get searchPath
          matches = no
          matches = yes if name?.match reg
          matches
      else
        result = content
      if result
        result.set 'isLoaded', yes
        return result

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
      @set 'autocompleteTarget', target
      @get('autocompleteTarget').didFetchAutocompleteResults @filterWithQuery value

    menuItemViewClass: Em.ContainerView.extend
      classNames: ['menu-item']
      classNameBindings: ['isSelected', 'isTeamRef']
      attributeBindings: ['title']
      isTeamRef: (->
        App.TeamRef.detectInstance @get 'content'
      ).property('content')
      entrant: (->
        content = @get 'content'
        if App.TeamRef.detectInstance content
          content.get 'team'
        else
          content
      ).property('content')
      titleBinding: 'entrant._id'
      childViews: ['countryFlagView', 'nameView']

      countryFlagView: App.CountryFlagView.extend
        contentBinding: 'parentView.entrant.country'

      nameView: Em.View.extend
        classNames: ['lineup-grid-item-name']
        render: (_)-> _.push @get 'parentView.entrant.name'
        entrantNameChanged: (-> @rerender() ).observes('parentView.entrant.name')

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
        @set 'parentView.selection', @get 'entrant'
        @set 'parentView.value', @get 'entrant'
        @set 'parentView.isVisible', no

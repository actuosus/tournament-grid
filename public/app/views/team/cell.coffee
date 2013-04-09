###
 * cell
 * @author: actuosus
 * Date: 08/04/2013
 * Time: 09:09
###

define [
  'cs!../autocomplete_text_field'
], ->
  ###
  Represents team model in grid. Also can be used standalone.
  ###
  App.TeamCellView = Em.ContainerView.extend
    classNames: ['team-cell']
    classNameBindings: ['winnerClassName', 'isEditing', 'teamUndefined', 'isUpdating']
    childViews: [
      'countryFlagView',
      'nameView',
      'autocompleteView',
      'resetButtonView'
    ]

    matchBinding: 'parentView.match'
    isUpdatingBinding: 'match.isUpdating'

    teamUndefined: (-> !@get('content')).property('content')

    countryFlagView: Em.View.extend
      tagName: 'i'
      classNames: ['country-flag-icon', 'team-country-flag-icon']
      classNameBindings: ['countryFlagClassName', 'hasFlag']
      attributeBindings: ['title']
      title: (-> @get 'content.country.name').property('content.country')
      contentBinding: 'parentView.content'
      hasFlag: (-> !!@get 'content.country.code').property('content.country')
      countryFlagClassName: (->
        'country-flag-icon-%@'.fmt @get 'content.country.code'
      ).property('content.country.code')

    autocompleteView: App.AutocompleteTextField.extend
      isVisible: no
      controllerBinding: 'App.teamsController'

      filteredContent: (->
        content = @get 'content'
        entrants = @get 'parentView.match.round.stage.entrants'
        content.filter (item)-> not entrants.contains item
      ).property().volatile()

      contentFilter: (content)->
        return unless content
        entrants = @get 'parentView.match.round.stage.entrants'
        if entrants
          @set 'content', content.filter (item)->
            not entrants.contains item

      selectionChanged: (->
        oldTeam = @get 'parentView.content'
        newTeam = @get 'selection'
        identifier = oldTeam.get('identifier') if oldTeam
        newTeam.set 'identifier', identifier
        @set 'parentView.content', newTeam
        match = @get 'parentView.parentView.match'
        console.debug 'Match', match
        if match
#          match.get('entrants')[@get 'parentView.contentIndex'] = newTeam
          match.set "entrant#{@get('parentView.contentIndex')+1}", newTeam
        @set('isVisible', no)
      ).observes('selection')

      hasFocusChanged: (->
        unless @get 'hasFocus'
          @set('isVisible', no)
        else
          @set('isVisible', yes)
      ).observes('hasFocus')

      insertNewline: ->
        popup = @showAddForm(@)
        popup.onShow = =>
          popup.get('formView')?.focus()
        popup.onHide = =>
          @focus()

    nameView: Em.View.extend
      classNames: ['team-name']
      contentBinding: 'parentView.content'
      template: Em.Handlebars.compile '{{view.content.name}}'

      click: ->
        if @get('parentView.isEditable')
          unless @get('parentView.match.isLocked')
            @set('parentView.autocompleteView.isVisible', yes)
            @get('parentView.autocompleteView').focus()

    points: (->
      contentIndex = @get('contentIndex')
      console.log @get('match'), contentIndex
      @get("match.entrant#{contentIndex+1}_points")
    ).property()

    isEditing: no,
    isEditableBinding: 'App.isEditingMode'

    isWinner: (->
      @get('parentView.match.winner.clientId') is @get('content.clientId')
    ).property 'points', 'match.winner'

    winnerClassName: (->
      if @get('match.winner')
        if @get 'isWinner'
          return 'team-winner'
        else
          return 'team-loser'
      else
        return 'winner-undefined'
    ).property('match.winner')

    mouseEnter: ->
      if @get('isEditable')
        unless @get('match.isLocked')
          @set 'resetButtonView.isVisible', yes if @get 'content'

    mouseLeave: ->
      @set 'resetButtonView.isVisible', no

    resetButtonView: Em.View.extend
      tagName: 'button'
      classNames: ['btn-clean', 'remove-btn', 'team-reset-btn']
      attributeBindings: ['title']
      title: '_reset'.loc()
      template: Em.Handlebars.compile('&times;')
      isVisible: no

      contentChanged: (->
        @set 'isVisible', no unless @get 'parentView.content'
      ).observes('parentView.content')

      ###
       * Sets team binding to null.
      ###
      click: ->
        @set 'parentView.content', null
        match = @get 'parentView.match'
        if match
          match.get('entrants')[@get 'parentView.contentIndex'] = null
          match.set "entrant#{@get('parentView.contentIndex')+1}", null

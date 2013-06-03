###
 * cell
 * @author: actuosus
 * Date: 08/04/2013
 * Time: 09:09
###

define [
  'cs!../autocomplete_text_field'
  'cs!./lineup_popup'
], ->
  ###
  Represents team model in grid. Also can be used standalone.
  ###
  App.TeamCellView = Em.ContainerView.extend App.Editing,
    classNames: ['team-cell']
    classNameBindings: ['winnerClassName', 'isEditing', 'teamUndefined', 'isUpdating']
    childViews: ['countryFlagView', 'nameView']
    editingChildViews: ['autocompleteView', 'resetButtonView']

    isEditing: no,
    _isEditingBinding: 'App.isEditingMode'
    isEditableBinding: 'App.isEditingMode'

    matchBinding: 'parentView.content'
    isUpdatingBinding: 'match.isUpdating'

    teamUndefined: (-> !@get('content')).property('content')

    countryFlagView: App.CountryFlagView.extend
#      contentBinding: 'parentView.content'
      content: (->
        content = @get 'parentView.content'
        if App.TeamRef.detectInstance content
          content.get 'team'
        else
          content
      ).property('parentView.content')

    autocompleteView: App.AutocompleteTextField.extend
      isVisible: no
      controller: (->
        entrants = @get 'parentView.match.round.resultSetEntrants'
        entrants or App.get('reportEntrantsController')
      ).property('parentView.match.round.resultSetEntrants', 'App.reportEntrantsController')

      filteredContent: (->
        content = @get 'content'
        entrants = @get 'parentView.match.round.resultSetEntrants'
        if entrants
          content.filter (item)-> not entrants.contains item
        else
          content
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
        if App.TeamRef.detectInstance oldTeam
          @set 'parentView.content.team', newTeam
          @notifyPropertyChange('parentView.content')
        else
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
      tagName: 'a'
      classNames: ['team-name']
#      attributeBindings: ['href', 'target']
#      target: '_blank'
#      href: (-> "/teams/#{@get 'content.id'}").property('content')
      content: (->
        content = @get 'parentView.content'
        if App.TeamRef.detectInstance content
          content.get 'team'
        else
          content
      ).property('parentView.content')
#      contentBinding: 'parentView.content'
      template: Em.Handlebars.compile '{{view.content.name}}'

      click: ->
        autocompleteView = @get 'parentView.autocompleteView'
        if autocompleteView
          autocompleteView.set 'isVisible', yes
          autocompleteView.focus()

      mouseEnter: ->
        @set 'shouldShowPopup', yes
        Em.run.later =>
          if @get 'shouldShowPopup'
            @lineupPopup = App.TeamLineupPopupView.create
              target: @
              content: @get 'content'
              origin: 'top'
            @lineupPopup.append()
        , 300

      mouseLeave: ->
        @set 'shouldShowPopup', no
        @lineupPopup.hide() if @lineupPopup

    points: (->
      contentIndex = @get('contentIndex')
      console.log @get('match'), contentIndex
      @get("match.entrant#{contentIndex+1}_points")
    ).property()

    isWinner: (->
      @get('match.winner.clientId') is @get('content.clientId')
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

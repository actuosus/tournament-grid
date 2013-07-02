###
 * cell
 * @author: actuosus
 * Date: 08/04/2013
 * Time: 09:09
###

define [
  'cs!../autocomplete_text_field'
  'cs!./lineup_popup'
  'cs!../../mixins/editing'
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
        if content
          if App.TeamRef.detectInstance content
            content.get 'team.country'
          else
            content.get 'country'
      ).property('parentView.content')

    autocompleteView: App.TextField.extend
      isVisible: no
      isAutocomplete: yes

      autocompleteDelegate: (->
        App.ReportEntrantsController.create
          table: @get 'parentView.parentView.parentView'
          contentBinding: 'table.entrants'
      ).property()

      assignTeam: (team)->
        @set 'parentView.content', team
        match = @get 'parentView.match'
        match.set "entrant#{@get('parentView.contentIndex')+1}", team if match

      insertNewline: ->
        team = @get 'selection'
        team = team.get 'team' if App.TeamRef.detectInstance team
        @assignTeam team
        @_closeAutocompleteMenu()
        @set 'isVisible', no

      selectMenuItem: (entrant)->
        team = entrant
        team = entrant.get 'team' if App.TeamRef.detectInstance entrant
        @assignTeam team
        @_closeAutocompleteMenu()
        @set 'isVisible', no

      focusOut: -> @set 'isVisible', no

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
        if autocompleteView and not autocompleteView.isClass
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
            @lineupPopup.appendTo App.get 'rootElement'
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

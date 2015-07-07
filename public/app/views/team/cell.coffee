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
      content: (->
        content = @get 'parentView.content'
        if content.get('content')
          content = content.get('content')
        if content
          if App.TeamRef.detectInstance content
            content.get 'team.country'
          else
            content.get 'country'
      ).property('parentView.content.isLoaded')

    autocompleteView: App.TextField.extend
      isVisible: no
      isAutocomplete: yes

      autocompleteDelegate: (->
        matchType = App.get('report.match_type')
        if matchType is 'player'
          App.ReportEntrantsController.create
            searchPath: 'nickname'
            table: @get 'parentView.parentView.parentView'
            contentBinding: 'table.entrants'
        else
          App.ReportEntrantsController.create
            table: @get 'parentView.parentView.parentView'
            contentBinding: 'table.entrants'
      ).property()

      assignTeam: (entrant)->
        @set 'parentView.content', entrant
        match = @get 'parentView.match'
        match.set "entrant#{@get('parentView.contentIndex')+1}", entrant if match

      insertNewline: ->
        entrant = @get 'selection'
        entrant = entrant.get 'team' if App.TeamRef.detectInstance entrant
        @assignTeam entrant
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
      attributeBindings: ['href', 'target']
      target: '_blank'
      href: Ember.computed.oneWay 'parentView.content.link'
      name: (->
        content = @get 'parentView.content'
        if content.get('content')
          content = content.get('content')
        if content
          if App.TeamRef.detectInstance content
            return content.get 'team.name'
          if App.Player.detectInstance content
            return content.get('_data.nickname') or content.get('nickname')
          else
            return content.get 'name'
      ).property().volatile()

      nameChanged: (->
        if @get('parentView.content.isLoaded')
          name = @get('name')
          @rerender()
      ).observes('parentView.content.isLoaded').on('init')
      render: (_)-> _.push @get('name') if @get('name')

      click: ->
        autocompleteView = @get 'parentView.autocompleteView'
        if autocompleteView and not autocompleteView.isClass
          autocompleteView.set 'isVisible', yes
          setTimeout ->
            autocompleteView.focus()
          , 300

      mouseEnter: ->
        @set 'shouldShowPopup', yes
#         if @get 'content'
#           @set 'content.hasPlayersPopupShown', yes
        Em.run.later =>
          if @get('shouldShowPopup') and @get('content.teamRef')
            @lineupPopup = App.TeamLineupPopupView.create
              target: @
              container: @get('container')
              content: @get 'content.teamRef'
              origin: 'top'
            @lineupPopup.appendTo App.get 'rootElement'
            @set 'shouldShowPopup', no
        , 1000

      mouseLeave: ->
        @set 'shouldShowPopup', no
#         if @get 'content'
#           @set 'content.hasPlayersPopupShown', no
        @lineupPopup?.hide()

    points: (->
      contentIndex = @get('contentIndex')
      console.log @get('match'), contentIndex
      @get("match.entrant#{contentIndex+1}_points")
    ).property()

    isWinner: (->
      Em.isEqual @get('match.winner'), @get('content')
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
      render: (_)-> _.push '&times;'
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

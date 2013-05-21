###
 * team_grid_item
 * @author: actuosus
 * Date: 21/01/2013
 * Time: 07:43
###

define [
  'cs!../autocomplete_text_field'
  'cs!../number'
  'cs!../../mixins/moving_highlight'
], ->
  ###
  Represents team model in grid. Also can be used standalone.
  ###
  App.TeamGridItemView = Em.ContainerView.extend App.MovingHightlight, App.Editing,
    classNames: ['team-grid-item']
    classNameBindings: ['winnerClassName', 'isEditing', 'teamUndefined', 'isUpdating']
    childViews: ['countryFlagView', 'nameView', 'pointsView']

    editingChildViews: ['autocompleteView', 'resetButtonView']

    matchBinding: 'parentView.match'
    isUpdatingBinding: 'match.isUpdating'
    pointsIsVisible: yes

    teamUndefined: (-> !@get('content')).property('content')

    countryFlagView: App.CountryFlagView.extend
      contentBinding: 'parentView.content'

    autocompleteView: App.AutocompleteTextField.extend
      isVisible: no

      controllerBinding: 'App.teamsController'

      filteredContent: (->
        content = @get 'content'
        entrants = @get 'parentView.match.round.stage.entrants'
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
        @set 'parentView.content', newTeam
        match = @get 'parentView.parentView.match'
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
#      href: (->
#        "/teams/#{@get 'content.id'}"
#      ).property('content')
      template: Em.Handlebars.compile '{{view.content.name}}'#<a {{bindAttr href="view.href"}} target="_blank">

      click: ->
        if @get('parentView.isEditable')
          unless @get('parentView.match.isLocked')
            @set('parentView.autocompleteView.isVisible', yes)
            @get('parentView.autocompleteView').focus()

    points: (->
      contentIndex = @get('contentIndex')
      @get("match.entrant#{contentIndex+1}_points")
    ).property('match.entrant1_points', 'match.entrant2_points')

    pointsView: App.NumberView.extend
      tagName: 'div'
      classNames: ['team-points']
      contentBinding: 'parentView.content'
      contentIndexBinding: 'parentView.contentIndex'
      valueBinding: 'parentView.points'
      isEditableBinding: 'parentView.isEditable'
      isVisibleBinding: 'parentView.pointsIsVisible'
#      template: Em.Handlebars.compile '{{view.parentView.points}}'
      matchBinding: 'parentView.match'
      max: 99

      mouseEnter: -> @get('parentView').shouldShowLineupPopup = no

      valueChanged: (->
        match = @get('match')
        points = @get('value')
        if points >= 0 and match
          match.set('entrant' + (@get('contentIndex')+1) + '_points', points)
      ).observes('value')

#      click: ->
#        if @get('parentView.isEditable')
#          @$().css
#            '-webkit-user-modify': 'read-write'
#            '-webkit-user-select': 'text'
#          @$().keyup =>
#            match = @get('match')
#            points = parseInt @$().text(), 10
#            if points >= 0 and match
#              match.set('entrant' + (@get('contentIndex')+1) + '_points', points)
#          @$().blur => @$().unbind('keyup').css {'-webkit-user-modify': 'none'}
#          @$().focus().select()
#

    isEditing: no,
    isEditableBinding: 'App.isEditingMode'

    _isEditingBinding: 'App.isEditingMode'

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
      entrant = @get 'content'
      if entrant
        entrant.set('isHighlighted', yes)
#      @shouldShowLineupPopup = yes
#      Em.run.later =>
#        @showTeamLineupPopup() if @shouldShowLineupPopup
#      , 500

    teamLineupPopup: null

    showTeamLineupPopup: ->
      if not @teamLineupPopup or @teamLineupPopup.isDestroyed
        team = @get('content')
        if team
          @teamLineupPopup = App.PopupView.create(target: @, classNames: ['popup-lineup-grid-item'], showCloseButton: yes)
          @teamLineupPopup.pushObject(App.TeamLineupGridItem.create(content: team))
          @teamLineupPopup.append()
      else
        @teamLineupPopup.show()

    mouseLeave: ->
      @set 'resetButtonView.isVisible', no
      entrant = @get 'content'
      if entrant
        entrant.set('isHighlighted', no)

#      @shouldShowLineupPopup = no
#      @teamLineupPopup?.hide()

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
      Sets team binding to null.
      ###
      click: ->
        @set 'parentView.content', null
        match = @get 'parentView.match'
        if match
          match.get('entrants')[@get 'parentView.contentIndex'] = null
          match.set "entrant#{@get('parentView.contentIndex')+1}", null

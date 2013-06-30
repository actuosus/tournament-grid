###
 * team_grid_item
 * @author: actuosus
 * Date: 21/01/2013
 * Time: 07:43
###

define [
  'cs!../autocomplete_text_field'
  'cs!../number'
], ->
  ###
  Represents team model in grid. Also can be used standalone.
  ###
  App.TeamGridItemView = Em.ContainerView.extend App.Editing, #App.ContextMenuSupport,
    classNames: ['team-grid-item']
    classNameBindings: ['winnerClassName', 'teamUndefined']
    childViews: ['countryFlagView', 'nameView', 'pointsView']

#    shouldShowContextMenuBinding: 'App.isEditingMode'
#    contextMenuActions: ['reset']

    editingChildViews: ['autocompleteView', 'resetButtonView']

    matchBinding: 'parentView.match'
    pointsIsVisible: yes

    teamUndefined: Em.computed.empty 'content'

    content: (->
      content = @get 'content'
      if App.TeamRef.detectInstance content
        content.get 'team'
      else
        content
    ).property('content')

    countryFlagView: App.CountryFlagView.extend
      contentBinding: 'parentView.content.country'

    autocompleteView: App.TextField.extend
      isVisible: no
      isAutocomplete: yes

      autocompleteDelegate: (->
        console.log @get 'container'
#        App.TeamsController.create()
        @get('container').lookup('controller:reportEntrants')
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
      classNames: ['team-name']
#      href: (->
#        "/teams/#{@get 'content.id'}"
#      ).property('content')
      template: Em.Handlebars.compile '{{view.parentView.content.name}}'#<a {{bindAttr href="view.href"}} target="_blank">

      click: ->
        if @get('parentView._isEditing')
          @set('parentView.autocompleteView.isVisible', yes)
          @get('parentView.autocompleteView').trigger('focus')

    points: (->
      @get("match.entrant#{@get('contentIndex')+1}_points")
    ).property('match.entrant1_points', 'match.entrant2_points')

    pointsView: App.NumberView.extend
      tagName: 'div'
      classNames: ['team-points']
      contentBinding: 'parentView.content'
      contentIndexBinding: 'parentView.contentIndex'
      valueBinding: 'parentView.points'
      isEditableBinding: 'parentView._isEditing'
      isVisibleBinding: 'parentView.pointsIsVisible'
      matchBinding: 'parentView.match'
      max: 99

      valueChanged: (->
        match = @get('match')
        points = @get('value')
        if points >= 0 and match
          match.set('entrant' + (@get('contentIndex')+1) + '_points', points)
      ).observes('value')

    _isEditingBinding: 'App.isEditingMode'

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
      entrant = @get 'content'
      entrant.set('isHighlighted', yes) if entrant

    mouseLeave: ->
      @set 'resetButtonView.isVisible', no
      entrant = @get 'content'
      if entrant
        entrant.set('isHighlighted', no)

    reset: ->
      @set 'content', null
      match = @get 'match'
      if match
        match.get('entrants')[@get 'contentIndex'] = null
        match.set "entrant#{@get('contentIndex')+1}", null

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
      click: -> @get('parentView').reset()

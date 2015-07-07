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

#    matchBinding: 'parentView.match'
    pointsIsVisible: yes

    teamUndefined: Em.computed.empty 'content'

#    content: (->
#      content = @get 'content'
#      if App.TeamRef.detectInstance content
#        content.get 'team'
#      else
#        content
#    ).property('content')

    countryFlagView: App.CountryFlagView.extend
      contentBinding: 'parentView.content.country'

    autocompleteView: App.TextField.extend
      isVisible: no
      isAutocomplete: yes

      autocompleteDelegate: (->
        console.log @get 'container'
#        App.TeamsController.create()
        matchType = App.get('report.match_type')
        if matchType is 'player'
          @get('container').lookup('controller:players')
        else
          @get('container').lookup('controller:reportEntrants')
      ).property()

      assignEntrant: (entrant)->
        @set 'parentView.content', entrant
        match = @get 'parentView.match'
        match.set "entrant#{@get('parentView.contentIndex')+1}", entrant if match

      insertNewline: ->
        team = @get 'selection'
        team = team.get 'team' if App.TeamRef.detectInstance team
        @assignEntrant team
        @_closeAutocompleteMenu()
        @set 'isVisible', no

      selectMenuItem: (entrant)->
        team = entrant
        team = entrant.get 'team' if App.TeamRef.detectInstance entrant
        @assignEntrant team
        @_closeAutocompleteMenu()
        @set 'isVisible', no

      focusOut: -> @set 'isVisible', no

    activateEditing: ->
      if @get('_isEditing')
        @set('autocompleteView.isVisible', yes)
        setTimeout =>
          @get('autocompleteView').trigger('focus')
        , 300

    nameView: Em.View.extend
      classNames: ['team-name']
#      href: (->
#        "/teams/#{@get 'content.id'}"
#      ).property('content')
      name: (->
        content = @get 'parentView.content'
        if content?.get('content')
          content = content.get('content')
        if App.Team.detectInstance(content)
          return content.get 'name'
        if App.Player.detectInstance(content)
          return content.get 'nickname'
      ).property('parentView.content.isLoaded')
#      template: Em.Handlebars.compile '{{view.name}}'#<a {{bind-attr href="view.href"}} target="_blank">
      nameChanged: (-> @rerender() ).observes('name')
      render: (_)-> _.push @get('name') if @get('name')

      click: -> @get('parentView')?.activateEditing()

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
      if @get('_isEditing')
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
      render: (_)-> '&times;'
      isVisible: no

      contentChanged: (->
        @set 'isVisible', no unless @get 'parentView.content'
      ).observes('parentView.content')

      ###
      Sets team binding to null.
      ###
      click: -> @get('parentView').reset()

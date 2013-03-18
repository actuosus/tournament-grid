###
 * team_grid_item
 * @author: actuosus
 * Date: 21/01/2013
 * Time: 07:43
###

define [
  'cs!views/autocomplete_text_field'
], ->
  ###
  Represents team model in grid. Also can be used standalone.
  ###
  App.TeamGridItemView = Em.ContainerView.extend
    classNames: ['team-grid-item']
    classNameBindings: ['winnerClassName', 'isEditing', 'teamUndefined']
    childViews: '''countryFlagView nameView
     autocompleteView pointsView resetButtonView'''.w()

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
          match.get('entrants')[@get 'parentView.contentIndex'] = newTeam
          match.set "entrant#{@get('parentView.contentIndex')+1}", newTeam
        @set('isVisible', no)
      ).observes('selection')

      hasFocusChanged: (->
        unless @get 'hasFocus'
          @set('isVisible', no)
        else
          @set('isVisible', yes)
      ).observes('hasFocus')

    nameView: Em.View.extend
      classNames: ['team-name']
      contentBinding: 'parentView.content'
      template: Em.Handlebars.compile '{{view.content.name}}'

      click: ->
        unless @get('parentView.match.isLocked')
          @set('parentView.autocompleteView.isVisible', yes)
          @get('parentView.autocompleteView').focus()

    points: (->
      contentIndex = @get('contentIndex')
      @get("parentView.match.entrant#{contentIndex+1}_points")
    ).property()

    pointsView: Em.View.extend
      classNames: ['team-points']
      contentBinding: 'parentView.content'
      contentIndexBinding: 'parentView.contentIndex'
      template: Em.Handlebars.compile '{{view.parentView.points}}'

      click: ->
        @$().css
          '-webkit-user-modify': 'read-write'
          '-webkit-user-select': 'text'
        @$().keyup =>
          match = @get('parentView.parentView.match')
          points = parseInt @$().text(), 10
          if points >= 0 and match
            match.set('entrant' + (@get('contentIndex')+1) + '_points', points)
        @$().blur => @$().unbind('keyup').css {'-webkit-user-modify': 'none'}
        @$().focus().select()

    isEditing: no,
    match: Ember.computed -> @get 'parentView.match'

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
      unless @get 'match.isLocked'
        @set 'resetButtonView.isVisible', yes if @get 'content'

    mouseLeave: ->
      @set 'resetButtonView.isVisible', no

    resetButtonView: Em.View.extend
      tagName: 'button'
      classNames: ['btn-clean', 'team-reset-btn']
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

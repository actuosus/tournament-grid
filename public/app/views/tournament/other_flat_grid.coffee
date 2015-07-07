###
 * other_flat_grid
 * @author: actuosus
 * Date: 13/08/2013
 * Time: 11:39
###

define [
  'cs!../../core'
  'cs!../round/tournament_grid_item'
  'cs!../../mixins/map_control'
  'cs!./grid'
], ->
  App.OtherFlatTournamentGridView = Em.ContainerView.extend App.MapControl, App.ContextMenuSupport,
    classNames: ['tournament-grid-wrapper']
    entrantsNumber: 4

    childViews: ['toolboxView']

    toolboxView: Em.ContainerView.extend
      classNames: ['toolbox']
      childViews: ['resetButtonView', 'zoomInButtonView', 'zoomOutButtonView']

      mapViewBinding: 'parentView'

      zoomInButtonView: Em.View.extend
        tagName: 'button'
        classNames: ['btn-clean']
        mapViewBinding: 'parentView.mapView'
        render: (_)-> _.push '+'
        click: -> @get('mapView').zoomIn(animated = yes)

      zoomOutButtonView: Em.View.extend
        tagName: 'button'
        classNames: ['btn-clean']
        mapViewBinding: 'parentView.mapView'
        render: (_)-> _.push '-'
        click: -> @get('mapView').zoomOut(animated = yes)

      resetButtonView: Em.View.extend
        tagName: 'button'
        classNames: ['btn-clean']
        mapViewBinding: 'parentView.mapView'
        render: (_)-> _.push '☒'
        click: -> @get('mapView').reset(animated = yes)

    shouldShowContextMenuBinding: 'App.isEditingMode'
    contextMenuActions: ['edit', 'save', 'clear']

    edit: ->

    isSingle: yes

    initSharedEditor: ->
      @sharedEditor = App.TeamGridItemView.create
        classNames: ['flat-team-grid-item-editor']
        container: @get 'container'
      @pushObject @sharedEditor

    click: (event)->
      return unless App.get 'isEditingMode'
      entrantElement = null
      if $(event.target).hasClass('flat-team-grid-item')
        entrantElement = event.target
      if $(event.target).parent('.flat-team-grid-item').length
        entrantElement = $(event.target).parent('.flat-team-grid-item').get 0

      if $(event.target).hasClass('match-start-date')
        matchId = event.target.id.split('-')[1]
        match = App.store.findById(App.Match, matchId)
        date = match.get('date')
        event.target.$ = -> $(event.target)
        popup = @popup = App.PopupView.create target: event.target, parentView: @, container: @container
        @picker = Em.View.create
          willInsertElement: ->
            $el = @$()
            @$().datetimepicker
              dateFormat: 'dd.mm.yy'
              timeFormat: 'HH:mm'
              showAnim: 'show'
              showButtonPanel: no
              onClose: -> popup.hide()
              onSelect: -> match.set 'date', $el.datetimepicker 'getDate'
            @$().datetimepicker 'setDate', date if date
          willDestroyElement: -> @$().datetimepicker 'destroy'
        @popup.pushObject @picker
        @popup.appendTo App.get 'rootElement'

      @applySharedEditor entrantElement if entrantElement

    applySharedEditor: (element)->
      @initSharedEditor() unless @sharedEditor
      if @sharedEditor.state is 'inDOM'
        @sharedEditor.activateEditing()
        stage = @get 'stage'
        if stage
          roundIndex = parseInt element.getAttribute('data-round-index')
          matchIndex = parseInt element.getAttribute('data-match-index')
          entrantIndex = parseInt element.getAttribute('data-entrant-index')
          match = stage.getByPath "#{roundIndex}.#{matchIndex}"
          if match
            entrant = match.get "entrant#{entrantIndex+1}"
            console.log match, entrant
            @sharedEditor.set 'contentIndex', entrantIndex
            @sharedEditor.set 'match', match
            @sharedEditor.set 'content', entrant if entrant
            @sharedEditor.addObserver 'content', @, (sharedEditor)->
#              console.log(@, arguments))
              sharedEditor.removeObserver('content', @)
#              sharedEditor.get('autocompleteView').clear()
              entrant = sharedEditor.get('content')
              console.log 'Setting entrant', entrant
              $(element).empty()
              @renderCountryIcon element, entrant
              @renderEntrantName element, entrant
              @renderPoints element, match, entrantIndex
#        @sharedEditor.$().css({position: 'absolute', left: element.x, top: element.y, 'z-index': 2})
        @sharedEditor.get('element').style.webkitTransform = "matrix(1, 0, 0, 1, #{element.x}, #{element.y}"
        @sharedEditor.get('element').style.zIndex = 2
      @sharedEditor.on 'didInsertElement', =>
#        @sharedEditor.$().css({position: 'absolute', left: element.x, top: element.y, 'z-index': 2})
        @sharedEditor.get('element').style.webkitTransform = "matrix(1, 0, 0, 1, #{element.x}, #{element.y}"
        @sharedEditor.get('element').style.zIndex = 2

    renderDateForMatch: (match, roundIndex = 0, matchIndex = 0)->
      return unless match.get('date')
      element = @get 'element'
      rounds = @get 'content'
      margin = 30
      padding = 20
      matchMargin = 42
      entrantsMargin = 6
      itemWidth = 154
      itemHeight = 25
      matchesCount = Math.pow(2, rounds.length-1)
      height = matchesCount * itemHeight + (matchMargin * (matchesCount/2-1)) + padding * 2
      offsetLeft = roundIndex * margin

      currentMatchCount = Math.pow(2, rounds.length-2-roundIndex)
      console.log 'roundIndex', roundIndex, 'currentMatchCount', currentMatchCount, 'matchIndex', matchIndex

      left = itemWidth * roundIndex + offsetLeft + padding
      top = (height / currentMatchCount) * matchIndex + ((height / currentMatchCount) / 2) - itemHeight - 4

#      matchBorderElement = document.createElement 'div'
#      matchBorderElement.id = "border-#{roundIndex}-#{matchIndex}"
#      matchBorderElement.setAttribute 'data-match-id', match.get 'id'
#      matchBorderElement.style.position = 'absolute'
#      matchBorderElement.style.border = '1px solid rgba(255,0,0,0.2)'
#      matchBorderElement.style.width = itemWidth + 'px'
#      matchBorderElement.style.height = (height / currentMatchCount) + 'px'
#      matchBorderElement.style.webkitTransform = "translate(#{left}px, #{(height / currentMatchCount) * matchIndex}px)"
#      matchBorderElement.style.webkitTransform = "matrix(1, 0, 0, 1, #{left}, #{(height / currentMatchCount) * matchIndex})"
#      element.appendChild matchBorderElement

      dateElement = document.createElement 'span'
      dateElement.className = 'match-start-date flat-match-start-date'
      dateElement.id = 'date-' + match.get('id')
      dateElement.style.webkitTransform = "translate(#{left}px, #{top}px)"
#      dateElement.style.webkitTransform = "matrix(1, 0, 0, 1, #{left}, #{top})"
      dateElement.innerText = moment(match.get('date')).format 'DD.MM.YY'
      if match.get 'isPast'
        dateElement.classList.add 'is-past'
      element.appendChild dateElement

    renderPointsForMatch: (match, roundIndex, matchIndex)->
      element = @get 'element'
      itemWidth = 154
      itemHeight = 25
      margin = 40
      padding = 20
      offsetTop = (Math.pow(2, 2 - roundIndex))*(-1 + Math.pow(2, roundIndex)) * itemHeight
      offsetLeft = roundIndex * margin
      top = matchIndex * (itemHeight * 2) + offsetTop - 13
      left = itemWidth * roundIndex + offsetLeft + padding
      pointsElement = document.createElement 'span'
      pointsElement.className = 'match-start-date flat-match-start-date'
      pointsElement.style.webkitTransform = "translate(#{left}px, #{top}px)"
#      pointsElement.style.webkitTransform = "matrix(1, 0, 0, 1, #{left}, #{top})"
      pointsElement.innerText = match.get "entrant_#{1}_points"

    renderCountryIcon: (entrantElement, entrant)->
      countryIconElement = document.createElement 'span'
      countryIconElement.className = "country-flag-icon team-country-flag-icon #{entrant.get('country.flagClassName')} has-flag"
      entrantElement.appendChild countryIconElement

    renderEntrantName: (entrantElement, entrant)->
      entrantNameElement = document.createElement 'span'
      entrantNameElement.className = 'team-name'
      entrantNameElement.innerText = entrant.get 'name'

      entrantElement.appendChild entrantNameElement

    renderPoints: (entrantElement, match, entrantIndex)->
      pointsElement = document.createElement 'span'
      pointsElement.className = 'team-points'
      pointsElement.innerText = match.get "entrant#{entrantIndex + 1}_points"

      entrantElement.appendChild pointsElement

    renderGames: (match, roundIndex = 0, matchIndex = 0)->
      element = @get 'element'
      rounds = @get 'content'
      margin = 30
      padding = 20
      matchMargin = 42
      itemWidth = 154
      itemHeight = 25
      matchesCount = Math.pow(2, rounds.length-1)
      height = matchesCount * itemHeight + (matchMargin * (matchesCount/2-1)) + padding * 2
      offsetLeft = roundIndex * margin

      currentMatchCount = Math.pow(2, rounds.length-2-roundIndex)
      console.log 'roundIndex', roundIndex, 'currentMatchCount', currentMatchCount, 'matchIndex', matchIndex

      left = itemWidth * roundIndex + offsetLeft + padding + itemWidth
      top = (height / currentMatchCount) * matchIndex + ((height / currentMatchCount) / 2) - itemHeight - 4

      infoElement = document.createElement 'div'
      infoElement.className = 'games-info-bar flat-games-info-bar'
      infoElement.style.webkitTransform = "translate(#{left}px, #{top}px)"
#      infoElement.style.webkitTransform = "matrix(1, 0, 0, 1, #{left}, #{top})"

      if match.get 'link'
        infoLabelElement = document.createElement 'a'
        infoLabelElement.className = 'games-info-bar-label'
        infoLabelElement.href = match.get('link')
        infoLabelElement.target = '_blank'
        infoLabelElement.innerText = '_info'.loc()
        infoElement.appendChild infoLabelElement

      gamesContainer = document.createElement 'ul'
      gamesContainer.className = 'games-list'
      match.get('games').forEach (game, index)->
        console.log 'Adding game', game
        gameElement = document.createElement 'li'
        gameElement.className = 'games-list-item'
        gameLinkElement = document.createElement 'a'
        gameLinkElement.title = game.get 'title'
        gameLinkElement.href = game.get 'link'
        gameLinkElement.target = '_blank'
        gameLinkElement.innerText = index + 1
        gameElement.appendChild gameLinkElement
        gamesContainer.appendChild gameElement
      infoElement.appendChild gamesContainer
#      console.log infoElement
      element.appendChild infoElement
      infoElement.style.webkitTransform = "translate(#{left - $(infoElement).width()}px, #{top}px)"
#      infoElement.style.webkitTransform = "matrix(1, 0, 0, 1, #{left - $(infoElement).width()}, #{top})"

    matchLoaded: (match)->
      [roundIndex, matchIndex] = [match.get('round.sortIndex'), match.get('sortIndex')]
      @renderDateForMatch match, roundIndex, matchIndex
#      match.get('games').forEach (game, gameIndex)=>
#        console.log game
      match.get('games').on 'didLoad', => @renderGames(match, roundIndex, matchIndex)
      if match.get('games.isLoaded')
        @renderGames(match, roundIndex, matchIndex)
      match.get('entrants').forEach (entrant, entrantIndex)=>
        entrantElement = document.getElementById "entrant-#{roundIndex}-#{matchIndex}-#{entrantIndex}"
        if entrantElement
          unless entrant
            return
          console.log(entrant)
          if entrant.get 'isLoaded'
            @renderCountryIcon entrantElement, entrant
            @renderEntrantName entrantElement, entrant
          else
            entrant.on 'didLoad', =>
              @renderCountryIcon entrantElement, entrant
              @renderEntrantName entrantElement, entrant
          @renderPoints entrantElement, match, entrantIndex
          if entrantIndex is 0
            entrantElement.classList.add('team-winner') if match.get 'firstIsAWinner'
            entrantElement.classList.add('team-loser') if match.get 'firstIsALoser'
          if entrantIndex is 1
            entrantElement.classList.add('team-winner') if match.get 'secondIsAWinner'
            entrantElement.classList.add('team-loser') if match.get 'secondIsALoser'
#      console.log @, arguments

    applyPosition: (element, left, top)->
#      element.style.left = "#{left}px";
#      element.style.top = "#{top}px";
      element.style.webkitTransform = "translate(#{left}px, #{top}px)"
#      element.style.webkitTransform = "matrix(1, 0, 0, 1, #{left}, #{top})"

    renderBracket: (bracket)->
      element = @get 'element'
      rounds = bracket.get 'rounds'
      return unless rounds
      margin = 30
      padding = 20
      matchMargin = 42
      entrantsMargin = 6
      itemWidth = 154
      itemHeight = 25
      matchesCount = Math.pow(2, rounds.length-1)
      height = matchesCount * itemHeight + (matchMargin * (matchesCount/2-1)) + padding * 2
      width = @get('parentView').$().width() - 20

      @set 'contentView', @

      @canvas = document.createElement 'canvas'
      @canvas.style.width = width + 'px'
      @canvas.style.height = height + 'px'
      @ctx = @canvas.getContext '2d'

      @$().css width: width, height: height

      fragment = document.createDocumentFragment()
      @fragment = fragment

      rounds.forEach (round, roundIndex)=>
        #            offsetTop = roundIndex * itemHeight * 2
        offsetTop = (Math.pow(2, 2 - roundIndex))*(-1 + Math.pow(2, roundIndex)) * itemHeight
        offsetLeft = roundIndex * margin
        top = 0
        left = itemWidth * roundIndex + offsetLeft + padding

        roundTitleElement = document.createElement 'span'
        roundTitleElement.className = 'round-name round-title flat-round-title'
        roundTitleElement.innerText = round.get 'title'
        @applyPosition roundTitleElement, left, top
        fragment.appendChild roundTitleElement

        matches = round.get('matches')
        currentMatchCount = matches.length
        matches.forEach (match, matchIndex)=>
          entrants = match.get('entrants')

          # Rendering connector
          unless round.get 'isFinal'
            connectorContainerElement = document.createElement 'div'

            connectorHeight = 0
            if (matchIndex % 2)
              top = (height / currentMatchCount) * matchIndex + ((height / currentMatchCount) / 2) + (itemHeight + entrantsMargin) / 2 - entrantsMargin / 2 - ((height / currentMatchCount)/2)  + (itemHeight)/2
              connectorContainerElement.className = 'connector diff'
            else
              top = (height / currentMatchCount) * matchIndex + ((height / currentMatchCount) / 2) + (itemHeight + entrantsMargin) / 2 - entrantsMargin / 2
              connectorContainerElement.className = 'connector'

            connectorHeight = ((height / currentMatchCount)/2) - itemHeight/2

            if currentMatchCount is 1
              connectorHeight = 0

            connectorContainerElement.style.height = connectorHeight + 'px'
            @applyPosition connectorContainerElement, left + itemWidth + 5, top
            connectorOneElement = document.createElement 'div'
            connectorOneElement.className = 'one'
            connectorAnotherElement = document.createElement 'div'
            connectorAnotherElement.className = 'another'
            connectorContainerElement.appendChild connectorOneElement
            connectorContainerElement.appendChild connectorAnotherElement
            fragment.appendChild connectorContainerElement

          entrants.forEach (entrant, entrantIndex)=>
            top = (height / currentMatchCount) * matchIndex +
              ((height / currentMatchCount) / 2) +
              entrantIndex * itemHeight + entrantIndex * entrantsMargin -
              (itemHeight + entrantsMargin) / 2

            if round.get 'isFinal'
              top += (itemHeight + entrantsMargin) / 2

            entrantElement = document.createElement 'div'
            entrantElement.className = 'team-grid-item flat-team-grid-item'
            @applyPosition entrantElement, left, top
            entrantElement.x = left
            entrantElement.y = top
            fragment.appendChild entrantElement

            entrantElement.setAttribute('data-round-index', roundIndex)
            entrantElement.setAttribute('data-match-index', matchIndex)
            entrantElement.setAttribute('data-entrant-index', entrantIndex)
            entrantElement.id = "entrant-#{roundIndex}-#{matchIndex}-#{entrantIndex}"

      if @get('stage.visualType') is 'double'
        @renderBracketLabels(fragment)

      element.appendChild fragment

      rounds.forEach (round, roundIndex)=>
        matches = round.get('matches')
        matches.forEach (match, matchIndex)=>
          if match.get('isTruthy')
            @matchLoaded(match.get('content'))

    didInsertElement: ->
      console.time 'Flat grid'

      brackets = @get 'content'
      brackets.forEach (bracket)=>
        @renderBracket bracket

      console.timeEnd 'Flat grid'

    willDestroyElement: ->
      @fragment = null

    renderBracketLabels: (fragment)->
      winnerBracketLabelElement = document.createElement 'span'
      winnerBracketLabelElement.innerText = '_winner_bracket'.loc()
      winnerBracketLabelElement.className = 'tournament-bracket-name flat-tournament-bracket-name'
      @applyPosition winnerBracketLabelElement, 0, 0
      loserBracketLabelElement = document.createElement 'span'
      loserBracketLabelElement.innerText = '_loser_bracket'.loc()
      loserBracketLabelElement.className = 'tournament-bracket-name flat-tournament-bracket-name'
      @applyPosition loserBracketLabelElement, 0, 0
      fragment.appendChild(winnerBracketLabelElement)
      fragment.appendChild(loserBracketLabelElement)

    content: (->
      stage = @get 'stage'
      if stage.get('visualType') is 'single'
        @get 'singleContent'
      else
        @get 'doubleContent'
    ).property('entrantsNumber')

    createWinnerBracket: ->
      stage = @get('stage')
      entrantsNumber = @get('entrantsNumber') or stage?.get('entrantsNumber')
      Em.assert "You should provide entrantsNumber", entrantsNumber
      roundsCount = Math.log(entrantsNumber) / Math.log(2)-1
      rounds = []
      bracket = Em.Object.create
        name: 'Winner bracket'
        isWinnerBracket: yes
      for i in [roundsCount..0]
        matchesCount = Math.pow(2, i)-1
        roundName = "1/#{matchesCount+1} #{'_of_the_final'.loc()}"
        switch i
          when 0
            roundName = '_final'.loc()
          when 1
            roundName = '_semifinal'.loc()
        roundIndex = roundsCount - i
        round = App.RoundController.create
          stage: stage
          index: roundIndex
          sortIndex: roundIndex
          itemIndex: i
#            title: roundName
          parentReference: 'bracket'
          bracket: bracket
          bracketName: 'winner'
          matches: []
        matches = round.get 'matches'
        for j in [0..matchesCount]
          leftPath = rightPath = undefined
          if roundsCount-i-1 >= 0
            leftPath = "#{roundsCount-i-1}.#{j*2}"
            rightPath = "#{roundsCount-i-1}.#{j*2+1}"
          match = App.MatchController.create
            index: j
            itemIndex: j
            sortIndex: j
            leftPath: leftPath
            rightPath: rightPath
            parentNodePath: "#{roundsCount-i+1}.#{Math.floor(j/2)}"
            entrants: [null, null]
            round: round
            status: 'opened'
            isVisible: yes
          matches.push match
        rounds.push round
      bracket.set 'rounds', rounds
      bracket

    createLoserBracket: ->
      stage = @get('stage')
      entrantsNumber = @get('entrantsNumber') or stage?.get('entrantsNumber')
      Em.assert "You should provide entrantsNumber", entrantsNumber
      roundsCount = Math.log(entrantsNumber) / Math.log(2)-1
      rounds = []
      matchesCount = entrantsNumber/4
      rCount = roundsCount * 2 - 1
      bracket = Em.Object.create
        name: 'Loser bracket'
        isWinnerBracket: no
      counter = 0
      for r in [roundsCount-1..0]
        for n in [1..0]
          round = App.RoundController.create
            stage: stage
            index: roundsCount - rCount
            sortIndex: counter
            itemIndex: rCount--
            parentReference: 'bracket'
            bracket: bracket
            bracketName: 'loser'
            matches: []
          for m in [0...matchesCount]
            if rCount > 0
              parentNodePath = "#{rCount}.#{m}"
            else
              parentNodePath = null
            match = App.MatchController.create
              index: m
              itemIndex: m
              sortIndex: m
              parentNodePath: parentNodePath
              entrants: [null, null]
              round: round
              status: 'opened'
              isVisible: yes
            round.get('matches').push match
          rounds.push round
          counter++
        matchesCount /= 2

      bracket.set 'rounds', rounds
      bracket

    doubleContent: (->
      [
        @createWinnerBracket(),
        @createLoserBracket()
      ]
    ).property('entrantsNumber')

  # Rounds
    singleContent: (->
      stage = @get 'stage'
      stage.on 'matchLoaded', @matchLoaded.bind @
      entrantsNumber = @get('entrantsNumber') or stage?.get('entrantsNumber')
      roundsLength = stage?.get('round.length')
      if entrantsNumber
        roundsCount = Math.log(entrantsNumber) / Math.log(2)-1
      else if roundsLength
        roundsCount = roundsLength
      else
        return []

      bracket = Em.Object.create
        name: 'Single bracket'

      rounds = []
      for i in [roundsCount..0]
        matchesCount = Math.pow(2, i)-1
        roundName = "1/#{matchesCount+1} #{'_of_the_final'.loc()}"
        switch i
          when 0 then roundName = '_final'.loc()
          when 1 then roundName = '_semifinal'.loc()
        roundIndex = roundsCount - i
        actualRound = stage?.getByPath "#{roundIndex}"
        round = App.RoundController.create
          stage: stage
          content: actualRound
          index: roundIndex
          itemIndex: i
          sortIndex: roundIndex
          title: roundName
          parentReference: 'stage'
          matches: []
        for j in [0..matchesCount]
          leftPath = rightPath = undefined
          if roundsCount-i-1 >= 0
            leftPath = "#{roundsCount-i-1}.#{j*2}"
            rightPath = "#{roundsCount-i-1}.#{j*2+1}"
          match = App.MatchController.create
            index: j
            itemIndex: j
            sortIndex: j
            leftPath: leftPath
            rightPath: rightPath
            parentNodePath: "#{roundsCount-i+1}.#{Math.floor(j/2)}"
            round: round
          if actualRound
            actualMatch = actualRound.get('matches').objectAt(j)
            if actualMatch
              match.set 'content', actualMatch
          unless actualMatch
            match.set 'entrants', [null, null]
          round.get('matches').push match
        rounds.push round
      finalRound = App.RoundController.create
        stage: stage
        title: '_winner'.loc()
        itemIndex: -1
        parentReference: 'stage'
        isFinal: yes
        matches: []
      finalRound.get('matches').push App.MatchController.create
        isWinner: yes
        isFinal: yes
        itemIndex: -1
        entrants: [null]
        round: finalRound
      rounds.push finalRound
      bracket.set 'rounds', rounds
      [bracket]
    ).property('entrantsNumber')
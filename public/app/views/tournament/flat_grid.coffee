###
 * flat_grid
 * @author: actuosus
 * Date: 12/08/2013
 * Time: 23:35
###

define [
  'cs!../../core'
  'cs!../round/tournament_grid_item'
  'cs!../../mixins/map_control'
  'cs!./grid'
], ->
  App.FlatTournamentGridView = Em.View.extend
    classNames: ['tournament-grid-container']
    entrantsNumber: 4

    isSingle: yes

    didInsertElement: ->
      element = @get 'element'
      rounds = @get 'content'
      margin = 40
      entrantsMargin = 5
      itemWidth = 154
      itemHeight = 25
      matchesCount = Math.pow(2, rounds.length-1)
      height = matchesCount * itemHeight
      width = @get('parentView').$().width()-20

      @$().css width: width, height: height

      fragment = document.createDocumentFragment()
      @fragment = fragment

      console.time 'Flat grid'

      rounds.forEach (round, roundIndex)=>
        matches = round.get('matches')
        matches.forEach (match, matchIndex)=>
          entrants = match.get('entrants')
          #            offsetTop = roundIndex * itemHeight * 2
          offsetTop = (Math.pow(2, 2 - roundIndex))*(-1 + Math.pow(2, roundIndex)) * itemHeight
          offsetLeft = roundIndex * margin

          left = itemWidth * roundIndex + offsetLeft
          top = matchIndex * (itemHeight * 2) + offsetTop + itemHeight

          connectorContainerElement = document.createElement 'div'
          connectorContainerElement.className = 'connector'
#          connectorContainerElement.style.webkitTransform = 'translate('+ (left + itemWidth) + 'px,' + top + 'px)'
          connectorContainerElement.style.height = (itemHeight * 2) + 'px'
          connectorContainerElement.style.webkitTransform = "matrix(1, 0, 0, 1, #{left + itemWidth}, #{top}"
          connectorOneElement = document.createElement 'div'
          connectorOneElement.className = 'one'
          connectorAnotherElement = document.createElement 'div'
          connectorAnotherElement.className = 'another'
          connectorContainerElement.appendChild connectorOneElement
          connectorContainerElement.appendChild connectorAnotherElement

          fragment.appendChild connectorContainerElement

          entrants.forEach (entrant, entrantIndex)=>

            top = matchIndex * (itemHeight * 2) + (entrantIndex * itemHeight) + offsetTop

            entrantElement = document.createElement 'div'
            entrantElement.id = "entrant-#{entrantIndex}"
            entrantElement.className = 'flat-team-grid-item'

#            entrantElement.style.top = top + 'px'
#            entrantElement.style.left = left + 'px'
#            entrantElement.style.webkitTransform = 'translate('+ left + 'px,' + top + 'px)'
            entrantElement.style.webkitTransform = "matrix(1, 0, 0, 1, #{left}, #{top}"
            fragment.appendChild entrantElement

            match.onLoaded = ->
              entrants = match.get('entrants')
#              entrant = entrants.objectAt entrantIndex
#              country = entrant.get('country')

              dateElement = document.createElement 'span'
              pointsElement = document.createElement 'span'
              pointsElement.className = 'team-points'

              countryIconElement = document.createElement 'span'
              countryIconElement.className = "country-flag-icon team-country-flag-icon country-flag-icon-ru has-flag"

              entrantNameElement = document.createElement 'span'
              entrantNameElement.className = 'team-name'
              entrantNameElement.innerText = 'team-name'

              entrantElement.appendChild countryIconElement
              entrantElement.appendChild entrantNameElement
              entrantElement.appendChild pointsElement
      element.appendChild fragment
      console.timeEnd 'Flat grid'

    willDestroyElement: ->
      @fragment = null

  # Rounds
    content: (->
      stage = @get 'stage'
      entrantsNumber = @get('entrantsNumber') or stage?.get('entrantsNumber')
      roundsLength = stage?.get('round.length')
      if entrantsNumber
        roundsCount = Math.log(entrantsNumber) / Math.log(2)-1
      else if roundsLength
        roundsCount = roundsLength
      else
        return []

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
            date: new Date()
            leftPath: leftPath
            rightPath: rightPath
            parentNodePath: "#{roundsCount-i+1}.#{Math.floor(j/2)}"
            entrants: [null, null]
            round: round
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
      rounds
    ).property('entrantsNumber')
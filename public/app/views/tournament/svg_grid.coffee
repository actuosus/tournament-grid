###
 * svg_grid
 * @author: actuosus
 * Date: 11/08/2013
 * Time: 05:36
###

define [
  'cs!../../core'
  'cs!../round/tournament_grid_item'
  'cs!../../mixins/map_control'
  'cs!./grid'
], ->
  App.SVGTournamentGridView = Em.View.extend
    tagName: 'svg'
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

#      element.appendChild document.createProcessingInstruction 'xml-stylesheet', 'href="/app/stylesheets/svg.css" type="text/css"'

      rounds.forEach (round, roundIndex)=>
        matches = round.get('matches')
        matches.forEach (match, matchIndex)=>
          entrants = match.get('entrants')
          entrants.forEach (entrant, entrantIndex)=>

#            offsetTop = roundIndex * itemHeight * 2
            offsetTop = (Math.pow(2, 2 - roundIndex))*(-1 + Math.pow(2, roundIndex)) * itemHeight
            offsetLeft = roundIndex * margin

            left = itemWidth * roundIndex + offsetLeft
            top = matchIndex * (itemHeight * 2) + (entrantIndex * itemHeight) + offsetTop

            entrantElement = document.createElementNS 'http://www.w3.org/2000/svg', 'rect'
            entrantElement.setAttribute 'class', 'svg-team-grid-item'
            entrantElement.setAttribute 'x', left
            entrantElement.setAttribute 'y', top
            entrantElement.setAttribute 'width', itemWidth
            entrantElement.setAttribute 'height', itemHeight
            element.appendChild entrantElement

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

    contentView: Em.CollectionView.extend
      contentBinding: 'parentView.content'
      classNames: ['tournament-grid']

      didInsertElement: ->
        @_super()
        @$().width @get('content.length') * 181

      contentChanged: (->
        @$().width @get('content.length') * 181
      ).observes('content.length')

      mouseEnter: (event)->
        event.stopPropagation()

      itemViewClass: App.RoundGridItemView
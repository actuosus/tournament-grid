###
 * Canvas
 * @author: actuosus
 * Date: 11/08/2013
 * Time: 05:39
###

define [
  'fabric'
  'cs!../../core'
  'cs!../round/tournament_grid_item'
  'cs!../../mixins/map_control'
  'cs!./grid'
], ->
  App.CanvasTournamentGridView = Em.View.extend
    tagName: 'canvas'
    entrantsNumber: 4

    isSingle: yes

    didInsertElement: ->
      width = @get('parentView').$().width()-20
      height = 1000
      @$().css width: width
      console.log @$().css 'width'
      rounds = @get 'content'

      @canvas = new fabric.StaticCanvas @get 'element'
#      @canvas = @get 'element'
#      ctx = @canvas.getContext '2d'

      margin = 40
      entrantsMargin = 5
      itemWidth = 154
      itemHeight = 25
      matchesCount = Math.pow(2, rounds.length-1)

      @canvas.setWidth width
      @canvas.setHeight matchesCount * itemHeight

#      @canvas.width = width
#      @canvas.height = matchesCount * itemHeight

      @canvas.on 'mouse:down', (options)->
        console.log options
      #              options.target.set 'stroke', 'red'

      # create a rectangle with angle=45
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

            text = new fabric.Text( 'Teee', {#match.get('date')?.toString()
              left: left,
              top: top - 20,
              fontSize: 10,
              fontFamily: 'Arial'
            });

            rect = new fabric.Rect
              left: left,
              top: top
              fill: '#efefef',
              strokeWidth: 1,
              stroke: '#828282',
              width: 154,
              height: itemHeight
#              match: match
#              matchLoaded: -> #console.log('match loaded', @, arguments, match)

#            match.addObserver('content', rect, rect.matchLoaded);
            match.onLoaded = -> rect.set 'stroke', '#FF0000'

            @canvas.add rect
            @canvas.add text

#            ctx.fillStyle = '#efefef'
#            ctx.lineWidth = 1
#            ctx.strokeStyle = '#828282'
##            ctx.translate left, top
#            ctx.fillRect left, top, itemWidth, itemHeight
#            ctx.strokeRect left, top, itemWidth, itemHeight



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
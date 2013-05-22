###
 * double_grid
 * @author: actuosus
 * Date: 08/05/2013
 * Time: 18:27
###

define [
  'cs!../../core'
  'cs!../round/tournament_grid_item'
], ->
  App.NewDoubleTournamentGridView = Em.ContainerView.extend
    classNames: ['tournament-grid-wrapper']
    childViews: ['contentView']

    entrantsNumber: 32

    contentView: Em.ContainerView.extend
      classNames: ['tournament-grid-container']

      childViews: ['contentView', 'finalsView']

      entrantsNumberBinding: 'parentView.entrantsNumber'

      stageBinding: 'parentView.stage'

      setupWidth: ->
        entrantsNumber = @get('entrantsNumber')
        roundsCount = Math.log(entrantsNumber) / Math.log(2)
        console.log roundsCount
        rCount = roundsCount * 2
        @$().width rCount * 181

      entrantsNumberChanged: (-> @setupWidth()).observes('entrantsNumber')

      didInsertElement: ->
        @_super()
        @setupWidth()

      createWinnerBracket: ->
        stage = @get('stage')
        console.log 'Winner', stage
        entrantsNumber = @get('entrantsNumber')
        roundsCount = Math.log(entrantsNumber) / Math.log(2)-1
        rounds = []
        bracket = Em.Object.create
          name: 'Winner bracket'
          isWinnerBracket: yes
        for i in [roundsCount..0]
          matchesCount = Math.pow(2, i)-1
          console.debug "Round #{i}, #{matchesCount+1} matches."
          roundName = "1/#{matchesCount+1} #{'_of_the_final'.loc()}"
          switch i
            when 0
              roundName = '_final'.loc()
            when 1
              roundName = '_semifinal'.loc()
          roundIndex = roundsCount - i
          actualRound = stage?.getByPath "#{roundIndex}"
          round = App.RoundProxy.create
            content: actualRound
            index: roundIndex
            sort_index: roundIndex
            itemIndex: i
            name: roundName
            parentReference: 'bracket'
            bracket: bracket
            matches: []
          #        matches = round.get 'matches'
          for j in [0..matchesCount]
            leftPath = rightPath = undefined
            if roundsCount-i-1 >= 0
              leftPath = "#{roundsCount-i-1}.#{j*2}"
              rightPath = "#{roundsCount-i-1}.#{j*2+1}"
            match = App.MatchProxy.create
              index: j
              itemIndex: j
              sort_index: j
              leftPath: leftPath
              rightPath: rightPath
              parentNodePath: "#{roundsCount-i+1}.#{Math.floor(j/2)}"
              entrants: [null, null]
              round: round
            round.get('matches').push match
          rounds.push round
        bracket.set 'rounds', rounds
        bracket

      createLoserBracket: ->
        entrantsNumber = @get('entrantsNumber')
        roundsCount = Math.log(entrantsNumber) / Math.log(2)-1
        rounds = []
        matchesCount = entrantsNumber/4
        rCount = roundsCount * 2 - 1
        bracket = Em.Object.create
          name: 'Loser bracket'
          isWinnerBracket: no
        for r in [roundsCount-1..0]
          for n in [1..0]
            round = App.RoundProxy.create
              index: roundsCount - rCount
              sort_index: roundsCount - rCount
              itemIndex: rCount--
              parentReference: 'bracket'
              bracket: bracket
              matches: []
            for m in [0...matchesCount]
              if rCount > 0
                parentNodePath = "#{rCount}.#{m}"
              else
                parentNodePath = null
#              console.log parentNodePath
              match = App.MatchProxy.create
                index: m
                itemIndex: m
                sort_index: m
                parentNodePath: parentNodePath
                entrants: [null, null]
                round: round
#              console.log match.clientId
              round.get('matches').push match
            rounds.push round
          matchesCount /= 2

        bracket.set 'rounds', rounds
        bracket

      # Brackets
      content: (->
        [
          @createWinnerBracket(),
          @createLoserBracket()
        ]
      ).property('entrantsNumber')

      finalsView: Em.CollectionView.extend
        classNames: ['finals']
        content: (->
          rounds = []
          finalRound = App.RoundProxy.create
            name: '_final'.loc()
            itemIndex: -1
            parentReference: 'stage'
            matches: []
          finalRound.get('matches').push App.MatchProxy.create
            itemIndex: -1
            entrants: [null, null]
            round: finalRound
          rounds.push finalRound
          winnerRound = App.RoundProxy.create
            name: '_winner'.loc()
            itemIndex: -1
            parentReference: 'stage'
            matches: []
          winnerRound.get('matches').push App.MatchProxy.create
            isWinner: yes
            isFinal: yes
            itemIndex: -1
            entrants: [null]
            round: winnerRound
          rounds.push winnerRound
          rounds
        ).property('parentView.entrantsNumber')

        setupWidth: ->
          @$().width @get('content.length') * 181

        didInsertElement: ->
          @_super()
          @setupWidth()

        contentChanged: (->
          @setupWidth() if @$()
        ).observes('content.length')

        itemViewClass: App.RoundGridItemView

      contentView: Em.CollectionView.extend
        classNames: ['brackets']
        contentBinding: 'parentView.content'
        entrantsNumberBinding: 'parentView.entrantsNumber'

        setupWidth: ->
          console.log 'rounds', Math.max.apply(null, @get('content').mapProperty 'rounds.length')
          @$().width Math.max.apply(null, @get('content').mapProperty 'rounds.length') * 181

        didInsertElement: ->
          @_super()
          @setupWidth()

        contentChanged: (->
          @setupWidth() if @$()
        ).observes('content.length')

        itemViewClass: Em.ContainerView.extend
          classNames: ['tournament-bracket-container']
          childViews: ['titleView', 'contentView']
          entrantsNumberBinding: 'parentView.entrantsNumber'

          titleView: Em.View.extend
            classNames: ['tournament-bracket-name']
            contentBinding: 'parentView.content'
            template: Em.Handlebars.compile '{{view.content.name}}'

          contentView: Em.CollectionView.extend
            classNames: ['tournament-bracket']
            contentBinding: 'parentView.content.rounds'
            entrantsNumberBinding: 'parentView.entrantsNumber'

            itemViewClass: App.RoundGridItemView.extend
              entrantsNumberBinding: 'parentView.entrantsNumber'
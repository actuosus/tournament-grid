###
 * double_grid
 * @author: actuosus
 * Date: 08/05/2013
 * Time: 18:27
###

define [
  'cs!../../core'
  'cs!../team/list'
  'cs!../round/tournament_grid_item'
  'cs!../../mixins/map_control'
  'cs!./grid'
], ->
  App.NewDoubleTournamentGridView = App.TournamentGridView.extend App.ContextMenuSupport,
    classNames: ['tournament-grid-wrapper']

    shouldShowContextMenuBinding: 'App.isEditingMode'
    contextMenuActions: ['showTeamList']

    init: ->
      console.timeStamp 'Render NewDoubleTournamentGridView'
#      console.time 'NewDoubleTournamentGridView'
#      console.profile 'NewDoubleTournamentGridView'
      @_super()

    didInsertElement: ->
      @$().css width: @get('parentView').$().width()-20
#      console.timeEnd 'NewDoubleTournamentGridView'
#      console.profileEnd 'NewDoubleTournamentGridView'

    showTeamList: ->
      @teamListPopup = App.PopupView.createWithMixins(App.Movable, {showCloseButton: yes})
      reportEntrants = App.ReportEntrantsController.create
        contentBinding: 'App.report.teamRefs'
      listView = App.TeamListView.create
        controller: reportEntrants
        contentBinding: 'controller.arrangedContent'
      @teamListPopup.pushObject listView
      @teamListPopup.appendTo App.get 'rootElement'

    entrantsNumber: 32

    contentView: Em.ContainerView.extend
      classNames: 'tournament-grid-container'

      childViews: ['contentView', 'finalsView']

      entrantsNumberBinding: 'parentView.entrantsNumber'

      stageBinding: 'parentView.stage'

      setupWidth: ->
        entrantsNumber = @get('entrantsNumber')
        roundsCount = Math.log(entrantsNumber) / Math.log(2)
        rCount = roundsCount * 2
        @$().width (rCount * 181 + 20)

      entrantsNumberChanged: (-> @setupWidth()).observes('entrantsNumber')

      didInsertElement: ->
        @_super()
        @setupWidth()

      createWinnerBracket: ->
        stage = @get('stage')
        entrantsNumber = @get('entrantsNumber')
        Em.assert "You should provide entrantsNumber", entrantsNumber
        roundsLength = stage?.get('rounds.length')
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

#           actualRound = stage?.getByPath "#{roundIndex}"

          round = App.RoundController.create
            stage: stage
#             model: actualRound
            index: roundIndex
            sortIndex: roundIndex
            itemIndex: i
#            title: roundName
            parentReference: 'bracket'
            bracket: bracket
            bracketName: 'winner'
            matches: []
          @_findRoundFor stage, roundIndex, 'winner', round
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

      _findRoundFor: (stage, index, type, roundController)->
         round = @get('stage.rounds')?.find (_)=> _.get('sortIndex') is index and _.get('bracketName') is type
         if round
            roundController.set 'content', round

      createLoserBracket: ->
        stage = @get('stage')
        entrantsNumber = @get('entrantsNumber')
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
            roundIndex = roundsCount - rCount
#            actualRound = stage?.getByPath "#{roundIndex}"
            round = App.RoundController.create
              stage: stage
#               model: actualRound
              index: roundIndex
              sortIndex: counter
              itemIndex: rCount--
              parentReference: 'bracket'
              bracket: bracket
              bracketName: 'loser'
              matches: []
            @_findRoundFor stage, counter, 'loser', round
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

      # Brackets
      content: (->
        [
          @createWinnerBracket(),
          @createLoserBracket()
        ]
      ).property('entrantsNumber')

      finalsView: Em.CollectionView.extend
        classNames: ['finals']
        entrantsNumberBinding: 'parentView.entrantsNumber'
        content: (->
          rounds = []
          stage = @get('parentView.stage')
          entrantsNumber = @get('entrantsNumber')
          Em.assert "You should provide entrantsNumber", entrantsNumber
          roundsCount = Math.log(entrantsNumber) / Math.log(2)-1
          finalRound = App.RoundController.create
            stage: stage
#            title: '_final'.loc()
            itemIndex: -1
            sortIndex: roundsCount+2
            parentReference: 'stage'
            matches: []
            bracketName: ''
          finalMatch = App.MatchController.create
            isPreFinal: yes
            itemIndex: -1
            sortIndex: 0
            entrants: [null, null]
            round: finalRound
            status: 'opened'
            isVisible: yes
          finalRound.get('matches').pushObject finalMatch

          rounds.push finalRound

          # Winner
          winnerRound = App.RoundController.create
            stage: stage
#            title: '_winner'.loc()
            itemIndex: -1
            sortIndex: roundsCount+3
            parentReference: 'stage'
            matches: []
            bracketName: ''
          winnerMatch = App.MatchController.create
            isWinner: yes
            isFinal: yes
            itemIndex: -1
            sortIndex: 0
            entrants: [null]
            round: winnerRound
            status: 'opened'
            isVisible: yes
          winnerRound.get('matches').pushObject winnerMatch
          rounds.pushObject winnerRound
          rounds
        ).property('parentView.entrantsNumber')

        setupWidth: ->
          @$().width @get('content.length') * 181 - 2

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
          @$().width Math.max.apply(null, @get('content').mapProperty 'rounds.length') * 181 - 2

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
            nameChanged: (-> @rerender() ).observes('parentView.content.name')
            render: (_)-> _.push @get 'parentView.content.name'

          contentView: Em.CollectionView.extend
            classNames: ['tournament-bracket']
            contentBinding: 'parentView.content.rounds'
            entrantsNumberBinding: 'parentView.entrantsNumber'

            itemViewClass: App.RoundGridItemView.extend
              entrantsNumberBinding: 'parentView.entrantsNumber'
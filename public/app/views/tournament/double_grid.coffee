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
], ->
  App.NewDoubleTournamentGridView = Em.ContainerView.extend App.MapControl, App.ContextMenuSupport,
    classNames: ['tournament-grid-wrapper']
    childViews: ['contentView']

    shouldShowContextMenuBinding: 'App.isEditingMode'
    contextMenuActions: ['showTeamList']

#    init: ->
#      console.timeStamp 'Render NewDoubleTournamentGridView'
#      console.time 'NewDoubleTournamentGridView'
#      console.profile 'NewDoubleTournamentGridView'
#      @_super()

    didInsertElement: ->
      @$().css width: @get('parentView').$().width()
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
        @$().width rCount * 181

      entrantsNumberChanged: (-> @setupWidth()).observes('entrantsNumber')

      didInsertElement: ->
        @_super()
        @setupWidth()

      createWinnerBracket: ->
        stage = @get('stage')
        entrantsNumber = @get('entrantsNumber')
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
#          actualRound = stage?.getByPath "#{roundIndex}"
          round = App.RoundController.create
#            content: actualRound
            stage: stage
            index: roundIndex
            sortIndex: roundIndex
            itemIndex: i
            title: roundName
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
            matches.push match
          rounds.push round
        bracket.set 'rounds', rounds
        bracket

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
        content: (->
          rounds = []
          finalRound = App.RoundController.create
            title: '_final'.loc()
            itemIndex: -1
            parentReference: 'stage'
            matches: []
          finalRound.get('matches').push App.MatchController.create
            itemIndex: -1
            entrants: [null, null]
            round: finalRound
          rounds.push finalRound
          winnerRound = App.RoundController.create
            title: '_winner'.loc()
            itemIndex: -1
            parentReference: 'stage'
            matches: []
          winnerRound.get('matches').push App.MatchController.create
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
            template: Em.Handlebars.compile '{{view.parentView.content.name}}'

          contentView: Em.CollectionView.extend
            classNames: ['tournament-bracket']
            contentBinding: 'parentView.content.rounds'
            entrantsNumberBinding: 'parentView.entrantsNumber'

            itemViewClass: App.RoundGridItemView.extend
              entrantsNumberBinding: 'parentView.entrantsNumber'
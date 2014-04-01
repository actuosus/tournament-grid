###
 * single_grid
 * @author: actuosus
 * Date: 08/05/2013
 * Time: 17:59
###

define [
  'cs!../../core'
  'cs!../round/tournament_grid_item'
  'cs!../../mixins/map_control'
  'cs!./grid'
], ->
  App.NewTournamentGridView = App.TournamentGridView.extend
    entrantsNumber: 4

    isSingle: yes

    didInsertElement: ->
      @$().css width: @get('parentView').$().width()-20

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
#        actualRound = stage?.getByPath "#{roundIndex}"

        round = App.RoundController.create
          stage: stage
#          content: actualRound
          index: roundIndex
          itemIndex: i
          sortIndex: roundIndex
#          title: roundName
          parentReference: 'stage'
          matches: []
          bracketName: ''

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
            isPreFinal: i is 0
          round.get('matches').push match

        if i is 0 and entrantsNumber > 2
          # Third place
          console.log 'Third place'
          thirdPlaceMatch = App.MatchController.create
            label: '_third_place_playoff'.loc()
            isThirdPlace: yes
            itemIndex: -1
            sortIndex: 1
            entrants: [null, null]
            round: round
            isVisible: App.get('isEditingMode')
          round.get('matches').pushObject thirdPlaceMatch

        rounds.push round
      finalRound = App.RoundController.create
        stage: stage
#        title: '_winner'.loc()
        itemIndex: -1
        sortIndex: roundsCount+1
        parentReference: 'stage'
        isFinal: yes
        matches: []
        bracketName: ''
      finalRound.get('matches').push App.MatchController.create
        isWinner: yes
        isFinal: yes
        itemIndex: -1
        sortIndex: 0
        entrants: [null]
        round: finalRound
      rounds.push finalRound
      rounds
    ).property('entrantsNumber')

    editingChanged: (->
      preLastRound = @get('content').objectAt(@get('content.length')-2)
      thirdPlaceMatch = preLastRound.get('matches').find (_)-> _.get('sortIndex') is 1
      if thirdPlaceMatch
        if App.get 'isEditingMode'
          thirdPlaceMatch.set 'isVisible', yes
        else
          console.log thirdPlaceMatch
          unless thirdPlaceMatch.get 'content'
            thirdPlaceMatch.set 'isVisible', no
    ).observes('App.isEditingMode')

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
###
 * grid
 * @author: actuosus
 * Date: 08/05/2013
 * Time: 17:59
###

define [
  'cs!../../core'
  'cs!../round/tournament_grid_item'
], ->
  App.NewTournamentGridView = Em.ContainerView.extend
    classNames: ['tournament-grid-container']

    childViews: ['contentView']

    entrantsNumber: 4

    isSingle: yes

    toolboxView: Em.ContainerView.extend
      classNames: ['toolbox']
      childViews: ['triggerButtonView']

      triggerButtonView: Em.View.extend
        tagName: 'button'
        click: ->
          @toggleProperty 'parentView.parentView.isSingle'

  # Rounds
    content: (->
      stage = @get('stage')
      entrantsNumber = @get('entrantsNumber')
      roundsCount = Math.log(entrantsNumber) / Math.log(2)-1
      rounds = []
      for i in [roundsCount..0]
        matchesCount = Math.pow(2, i)-1
        console.debug "Round #{i}, #{matchesCount+1} matches."
        roundName = "1/#{matchesCount+1} #{'_of_the_final'.loc()}"
        switch i
          when 0 then roundName = '_final'.loc()
          when 1 then roundName = '_semifinal'.loc()
        roundIndex = roundsCount - i
        actualRound = stage?.getByPath "#{roundIndex}"
        round = App.RoundProxy.create
          content: actualRound
          index: roundIndex
          itemIndex: i
          name: roundName
          parentReference: 'stage'
          matches: []
        for j in [0..matchesCount]
          leftPath = rightPath = undefined
          if roundsCount-i-1 >= 0
            leftPath = "#{roundsCount-i-1}.#{j*2}"
            rightPath = "#{roundsCount-i-1}.#{j*2+1}"
          match = App.MatchProxy.create
            index: j
            itemIndex: j
            date: new Date()
            leftPath: leftPath
            rightPath: rightPath
            parentNodePath: "#{roundsCount-i+1}.#{Math.floor(j/2)}"
            entrants: [null, null]
            round: round
          round.get('matches').push match
        rounds.push round
      finalRound = App.RoundProxy.create
        name: '_winner'.loc()
        itemIndex: -1
        parentReference: 'stage'
        matches: []
      finalRound.get('matches').push App.MatchProxy.create
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
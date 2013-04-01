###
 * stage
 * @author: actuosus
 * @fileOverview Stage model.
 * Date: 06/02/2013
 * Time: 03:06
###

define ['cs!../core'],->
  App.Stage = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    description: DS.attr 'string'
    visual_type: DS.attr 'string'
    sort_index: DS.attr 'number'
    entrants_count: DS.attr 'number'

    isSingleElimination: yes

    parent: (-> @get 'report').property('report')
    children: (-> @get 'rounds').property('rounds')

    left: null
    right: null

    report: DS.belongsTo 'App.Report'

    rounds: DS.hasMany 'App.Round'
    brackets: DS.hasMany 'App.Bracket'

    rating: DS.attr 'number'

    _rounds: (->
      rounds = @get 'rounds'
      finalRound = rounds.createRecord
        itemIndex: -1
        parentReference: 'stage'
      finalRound.get('matches').createRecord
        isWinner: yes
        isFinal: yes
        itemIndex: -1
      Em.ArrayController.create content: rounds
    ).property('rounds')

    getDescendant: (child, idx)-> child.get('children').objectAt idx if child

    getByPath: (path, root = @)->
      if path
        splittedPath = path.split '.'
        lastChild = @getDescendant root, splittedPath[0]
        for idx in [1...splittedPath.length]
          lastChild = @getDescendant lastChild, splittedPath[idx]
        lastChild

    selectByPath: (startRoundIndex, startMatchIndex)->
      console.log startRoundIndex, startMatchIndex
      rounds = @get 'rounds'
      roundsLength = rounds.get('length')
      Em.beginPropertyChanges()
      for roundIndex in [startRoundIndex...roundsLength]
        console.log roundIndex
        round = rounds.objectAt roundIndex
        matchIndexToSelect = Math.floor(startMatchIndex / Math.pow(2, roundIndex))
        match = round.get('matches').objectAt(matchIndexToSelect)
        match.set('isSelected', yes) if match
      Em.endPropertyChanges()

    deselectByPath: (startMatchIndex)->
      rounds = @get 'rounds'
      Em.beginPropertyChanges()
      rounds.forEach (round, roundIndex)->
        matchIndexToSelect = Math.floor(startMatchIndex / Math.pow(2, roundIndex))
        match = round.get('matches').objectAt(matchIndexToSelect)
        match.set('isSelected', no) if match
      Em.endPropertyChanges()

    entrants: (->
      entrants = []
      rounds = @get 'rounds'
      rounds.forEach (round)->
        entrants = entrants.concat round.get 'entrants'

        round.get('matches').forEach (match)->
          entrant1 = match.get('entrant1')
          entrant2 = match.get('entrant2')
          entrant1.set('gamesPlayed', (entrant1.gamesPlayed + 1) || 1) if entrant1
          entrant2.set('gamesPlayed', (entrant2.gamesPlayed + 1) || 1) if entrant2
          if match.get('entrant1_points') > match.get('entrant2_points')
            entrant1.set('wins', (entrant1.wins + 1) || 1) if entrant1
            entrant2.set('loses', (entrant2.loses + 1) || 1) if entrant2
          else if match.get('entrant1_points') == match.get('entrant2_points')
            entrant1.set('draws', (entrant1.draws + 1) || 1) if entrant1
            entrant2.set('draws', (entrant2.draws + 1) || 1) if entrant2
          else
            entrant2.set('wins', (entrant2.wins + 1) || 1) if entrant2
            entrant1.set('loses', (entrant1.loses + 1) || 1) if entrant1

      entrants.uniq()
      Em.ArrayController.create
        content: entrants.uniq()
        itemController: 'entrant'
    ).property('rounds.@each.isLoaded')

    matches: (->
      console.log 'matches'
      matches = []
      rounds = @get 'rounds'
      console.log rounds.get('isLoaded')
      rounds.forEach (round)->
        round.get('matches').forEach (match)->
          matches.push match
      @notifyPropertyChange 'matches'
      matches
    ).property('rounds.@each.isLoaded')

    checkRounds: (->
      rounds = @get 'rounds'
      Em.beginPropertyChanges()
      rounds.forEach (round, roundIndex)->
        round.get('matches').forEach (match, matchIndex)->
          nextRound = rounds.objectAt(roundIndex + 1)
          if nextRound
            newMatchIndex = Math.floor(matchIndex/2)
            nextMatch = nextRound.get('matches').objectAt(newMatchIndex)
            if nextMatch
              winner = match.get 'winner'
              if winner
                console.debug "Setting entrant #{winner} for "+
                  "round #{roundIndex + 1} and "+
                  "match #{Math.floor(matchIndex/2)} "+
                  "for #{matchIndex%2}"
                console.debug 'And the winner is', winner
                currentWinner = nextMatch.get "entrant#{matchIndex}" or nextMatch.get('entrants').objectAt(matchIndex%2)
                console.debug currentWinner, winner, currentWinner isnt winner
                if currentWinner isnt winner
                  nextMatch.get('entrants').replace matchIndex%2, 1, [winner]
                  nextMatch.set "entrant#{matchIndex%2+1}", winner
                nextMatch.set 'isLocked', yes
              else
                nextMatch.get('entrants').replace matchIndex%2, 1, [null]
                nextMatch.set "entrant#{matchIndex%2+1}", null
      Em.endPropertyChanges()
    )

    losers: (->
      losers = []
      rounds = @get 'rounds'
      rounds.forEach (round, roundIndex)->
        round.get('matches').forEach (match, matchIndex)->
          loser = match.get 'loser'
          losers.push loser if loser
      losers
    ).property()

    createLoserBracket: (bracket, entrantsNumber)->
      roundsCount = Math.log(entrantsNumber*2) / Math.log(2)-1;
      rounds = bracket.get 'rounds'
      matchesCount = entrantsNumber/2
      rCount = roundsCount * 2 - 1
      for r in [roundsCount-1..0]
        for n in [1..0]
          round = rounds.createRecord
            itemIndex: rCount--
            parentReference: 'bracket'
          matches = round.get 'matches'
          for m in [0...matchesCount]
            if rCount > 0
              parentNodePath = "#{rCount}.#{m}"
            else
              parentNodePath = null
            console.log parentNodePath
            match = matches.createRecord
              itemIndex: m
              parentNodePath: parentNodePath
            console.log match.clientId
        matchesCount /= 2

  App.Stage.toString = -> 'Stage'
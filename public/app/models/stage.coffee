###
 * stage
 * @author: actuosus
 * @fileOverview Stage model.
 * Date: 06/02/2013
 * Time: 03:06
###

define ->
  App.Stage = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    description: DS.attr 'string'
    visual_type: DS.attr 'string'
    sort_index: DS.attr 'number'
    entrants_count: DS.attr 'number'

    parent: (-> @get 'report').property('report')
    children: (-> @get 'rounds').property('rounds')

    left: null
    right: null

    rounds: DS.hasMany 'App.Round'
    brackets: DS.hasMany 'App.Bracket'

    getDescendant: (child, idx)-> child.get('children').objectAt idx if child

    getByPath: (path)->
      splittedPath = path.split '.'
      lastChild = @getDescendant @, splittedPath[0]
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
      entrants.uniq()
    ).property().volatile()

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

  App.Stage.toString = -> 'Stage'

#0:3
#1:1
#2:0
#
#
#
#0:7
#1:3
#2:1
#3:0
#
#0:8
#1:4
#2:2
#3:1
#4:0
#
#0:9
#1:4
#2:2
#3:1
#4:0
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

    loc: (->
      console.log arguments
    ).property()

    name: DS.attr('string', {loc: {keyPath: '_name', defaultLanguage: 'ru'}})
    __name: ((a,b,c,d)->
      nameHash = @get '_name'
      currentLanguage = App.get('currentLanguage')
      value = ''
      if currentLanguage and nameHash
        value = nameHash[currentLanguage]
      unless value
        value = @get 'name'
      value
    ).property('_name', 'App.currentLanguage')

    _name: DS.attr('object')
    description: DS.attr 'string'
    visual_type: DS.attr 'string'
    sort_index: DS.attr 'number'
    entrants_count: DS.attr 'number'

    isSingleElimination: yes

    parent: (-> @get 'report').property('report')
    children: (-> @get 'rounds').property('rounds')

    treeItemChildren: (-> @get 'rounds').property('rounds')

    left: null
    right: null

    report: DS.belongsTo 'App.Report'

    rounds: DS.hasMany 'App.Round'
    brackets: DS.hasMany 'App.Bracket'

    rating: DS.attr 'number'

    entrantsNumber: DS.attr 'number'

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

      entrants.uniq()
#      Em.ArrayController.create
#        content: entrants.uniq()
#        itemController: 'entrant'
    ).property().volatile() #'rounds.@each.isLoaded'

    matches: (->
      console.log 'matches'
      matches = []
      rounds = @get 'rounds'
      console.log rounds.get('isLoaded')
      roundsLength = rounds.get 'length'
      rounds.forEach (round, roundIndex)->
#        round.set('itemIndex', roundsLength - roundIndex - 2)
        matchesLength = round.get('matches.length')
        round.get('matches').forEach (match, matchIndex)->
#          console.log matchesLength - matchIndex - 2
#          match.set('itemIndex', matchesLength - matchIndex - 2)
          matches.push match
      @notifyPropertyChange 'matches'
      matches
    ).property().volatile() #'rounds.@each.isLoaded'

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

#    selectTeam: (team)->
#      rounds = @get 'rounds'
#      rounds.forEach (round, roundIndex)->
#        round.get('matches').forEach (match, matchIndex)->
#          entrants = match.get('entrants')

    createWinnerBracket: (bracket, entrantsNumber)->
      unless bracket
        bracket = @get('brackets').createRecord(name: 'Winner bracket')
      roundsCount = Math.log(entrantsNumber*2) / Math.log(2)-1
      rounds = bracket.get 'rounds'
      for i in [roundsCount..0]
        matchesCount = Math.pow(2, i)-1
        console.debug "Round #{i}, #{matchesCount+1} matches."
        roundName = "1/#{matchesCount+1} #{'_of_the_final'.loc()}"
        switch i
          when 0
            roundName = '_final'.loc()
          when 1
            roundName = '_semifinal'.loc()
        round = rounds.createRecord
          itemIndex: i
          name: roundName
          parentReference: 'stage'
        matches = round.get 'matches'
        for j in [0..matchesCount]
          leftPath = rightPath = undefined
          if roundsCount-i-1 >= 0
            leftPath = "#{roundsCount-i-1}.#{j*2}"
            rightPath = "#{roundsCount-i-1}.#{j*2+1}"
          matches.createRecord
            itemIndex: j
            date: new Date()
            leftPath: leftPath
            rightPath: rightPath
            parentNodePath: "#{roundsCount-i+1}.#{Math.floor(j/2)}"


    createLoserBracket: (bracket, entrantsNumber)->
      roundsCount = Math.log(entrantsNumber*2) / Math.log(2)-1
      unless bracket
        bracket = @get('brackets').createRecord(name: 'Loser bracket')
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

    createTree: ()->
      matches = @get 'matches'
      map = Em.Map.create()
      matches.forEach (match)->
        entrant = match.get('entrants').objectAt(0)
        if map.has entrant
          entrantMatches = map.get entrant
          entrantMatches.push match
        else
          map.set entrant, [match]

      rootNode = App.Node.create()
      map.keys.forEach (entrant)->
        matches = map.get entrant
        matches.forEach (match)->
          rootNode.set 'left', App.Node.create(data: match)

  App.Stage.toString = -> 'Stage'
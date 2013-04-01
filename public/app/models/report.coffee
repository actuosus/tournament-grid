###
 * report
 * @author: actuosus
 * @fileOverview Report model.
 * Date: 06/02/2013
 * Time: 02:48
###

define ['cs!../core'],->
  App.Report = DS.Model.extend
    primaryKey: '_id'
    title: DS.attr 'string'
    description: DS.attr 'string'
    start_date: DS.attr 'date'
    end_date: DS.attr 'date'
    date: DS.attr 'date'
    place: DS.attr 'string'

    match_type: DS.attr 'string'

    stages: DS.hasMany 'App.Stage'
    entrants: DS.hasMany 'App.Team'

    createStage: (roundsCount)->
      stage = App.Stage.createRecord
        name: 'Test Stage'
        description: 'Testing grid layout'
        visual_type: 'grid'

      #      brackets = stage.get 'brackets'
      #
      #      winnerBracket = brackets.createRecord
      #        name: '_winners'.loc()
      #
      #      loserBracket = brackets.createRecord
      #        name: '_losers'.loc()
      #
      #      loserBracket.get('rounds').createRecord
      #        name: 'Wow'

      roundsCount = roundsCount or (Math.ceil(Math.random()*5))
      rounds = stage.get 'rounds'
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
        matches = round.get('matches')
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
        #            team1: App.Team.createRecord(identifier: 'team1')
        #            team2: App.Team.createRecord(identifier: 'team2')
#        if i is 0
#          console.log 'Zero!'
#          round = rounds.createRecord
#            itemIndex: -1
#            parentReference: 'stage'
#          round.get('matches').createRecord
#            isWinner: yes
#            isFinal: yes
#            itemIndex: -1
      stage

    createStageByEntrants: (entrantsNumber)->
      @createStage Math.log(entrantsNumber) / Math.log(2)-1

  App.Report.toString = -> 'Report'
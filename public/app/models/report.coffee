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

    # TODO Make localization
#    _title: DS.attr 'object'

    description: DS.attr 'string'
    start_date: DS.attr 'date'
    end_date: DS.attr 'date'
    date: DS.attr 'date'
    place: DS.attr 'string'

#   TODO Make localization
#    _place: DS.attr 'object'

    match_type: DS.attr 'string'

    stages: DS.hasMany 'App.Stage'

    teamRefs: DS.hasMany 'App.TeamRef'

    players: (->
      teamRefs = @get 'teamRefs'
      result = []
      teamRefs.forEach (ref)->
        players = ref.get 'players'
        players.forEach (player)->
#          # TODO Refine relations. This is kinda hacky.
          player._teamRef = ref
          result.push player
      result
    ).property().volatile()

    races: DS.hasMany 'App.Race'

    createStage: (roundsCount)->
      stage = App.Stage.createRecord
        name: 'Test Stage'
        description: 'Testing grid layout'
        visual_type: 'grid'

      roundsCount = roundsCount or (Math.ceil(Math.random()*5))
      rounds = stage.get 'rounds'
      for i in [roundsCount..0]
        matchesCount = Math.pow(2, i)-1
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
      stage

    createStageByEntrants: (entrantsNumber)->
      @createStage Math.log(entrantsNumber) / Math.log(2)-1

    createStageByRoundsNumber: (roundsNumber)->
      stage = App.Stage.createRecord()
      rounds = stage.get 'rounds'
      for i in [1..roundsNumber]
        rounds.createRecord parentReference: 'stage'
      stage

    createStageByMatchesNumber: (matchesNumber)->
      stage = App.Stage.createRecord()
      rounds = stage.get 'rounds'
      round = rounds.createRecord parentReference: 'stage'
      matches = round.get 'matches'
      for i in [1..matchesNumber]
        matches.createRecord date: new Date()
      stage

  App.Report.toString = -> 'Report'
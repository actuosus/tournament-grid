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

    stages: DS.hasMany('App.Stage', {inverse: 'report', key: 'stages'})

    teamRefs: DS.hasMany('App.TeamRef', {inverse: 'report', key: 'team_refs'})

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
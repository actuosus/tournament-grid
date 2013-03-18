###
 * round
 * @author: actuosus
 * @fileOverview Round model.
 * Date: 21/01/2013
 * Time: 14:25
###

define ->
  App.Round = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'

    parent: (-> @get 'stage').property('stage')
    children: (-> @get 'matches').property('matches')

    left: null
    right: null

    matches: DS.hasMany 'App.Match'

    stage: DS.belongsTo 'App.Stage'

    entrants: (->
      matches = @get 'matches'
      entrants = []
      matches.forEach (match)->
        entrants.push match.get 'entrant1'
        entrants.push match.get 'entrant2'
      entrants.uniq()
    ).property().volatile()

  App.Round.toString = -> 'Round'
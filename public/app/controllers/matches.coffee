###
 * matches
 * @author: actuosus
 * Date: 08/04/2013
 * Time: 06:59
###

define [
  'cs!../core'
],->
  App.MatchesController = Em.ArrayController.extend

    lastResults: null

    results: Ember.computed('@each.entrant1_points',
      '@each.entrant2_points',
      '@each.entrant1',
      '@each.entrant2', ->
        incrementPropertyForEntrant = (entrant, property, increment)->
          if results.has entrant
            result = results.get entrant
            if result
              result.incrementProperty property, increment
            else
              result = Ember.Object.create()
              result.incrementProperty property, increment
              results.set entrant, result
          else
            result = Ember.Object.create()
            result.incrementProperty property, increment
            results.set entrant, result

        unless @get 'round.automaticCountingDisabled'
          results = Em.Map.create()
          @forEach (match)->
            # TODO Only for closed matches

            entrant1 = match.get('entrant1')
            entrant2 = match.get('entrant2')
            entrant1_points = match.get('entrant1_points')
            entrant2_points = match.get('entrant2_points')

            incrementPropertyForEntrant entrant1, 'matchesPlayed' if entrant1
            incrementPropertyForEntrant entrant2, 'matchesPlayed' if entrant2

    #        incrementPropertyForEntrant entrant1, 'points', entrant1_points if entrant1_points
    #        incrementPropertyForEntrant entrant2, 'points', entrant2_points if entrant2_points

            if entrant1_points and entrant2_points
              if entrant1_points > entrant2_points
                incrementPropertyForEntrant entrant1, 'wins' if entrant1
                incrementPropertyForEntrant entrant2, 'losses' if entrant2
              else if entrant1_points is entrant2_points
                  incrementPropertyForEntrant entrant1, 'draws' if entrant1
                  incrementPropertyForEntrant entrant2, 'draws' if entrant2
              else
                incrementPropertyForEntrant entrant1, 'losses' if entrant1
                incrementPropertyForEntrant entrant2, 'wins' if entrant2
        else
          results = @get('lastResults')
          @forEach (match)->
            entrant1 = match.get('entrant1')
            entrant2 = match.get('entrant2')
            results.set entrant1, Ember.Object.create() unless results.has entrant1
            results.set entrant2, Ember.Object.create() unless results.has entrant2

        resultsArray = []
        results.forEach (entrant, result)->
          resultsArray.pushObject Em.Object.create entrant: entrant, result
        resultsArray.sort((a,b)-> a.get('wins') > b.get('wins')).forEach (result, index)-> result.set 'position', index+1

        lastResults = Ember.ArrayController.create content: resultsArray, sortProperties: ['position']
        @set 'lastResults', lastResults
    )
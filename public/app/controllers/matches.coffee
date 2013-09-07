###
 * matches
 * @author: actuosus
 * Date: 08/04/2013
 * Time: 06:59
###

define [
  'cs!../core'
],->
  inDateRange = (start, end, d)->
    (moment(start)?.isBefore(d, 'day') or moment(start)?.isSame d, 'day') and
      (moment(end)?.isAfter(d, 'day') or moment(end)?.isSame d, 'day')

  App.MatchesController = Em.ArrayController.extend

#    itemController: App.MatchController

    lastResults: null

    round: null

    sortProperties: ['date', 'sortIndex']

    matchTypeFilter: null
    entrantFilter: null
    periodFilter: null

    dateFilter: null
    startDateFilter: null
    endDateFilter: null

    filteredContent: (->
      content = @get 'content'
      matchTypeFilter = @get 'matchTypeFilter'
      entrantFilter = @get 'entrantFilter'
      periodType = @get 'periodFilter'

      date = @get 'dateFilter'
      startDate = @get 'startDateFilter'
      endDate = @get 'endDateFilter'

      if matchTypeFilter
        unless matchTypeFilter.get('id') is 'all'
          content = content.filter (item)->
            Em.isEqual(item.get('currentStatus'), matchTypeFilter.get('id'))

      if entrantFilter
        content = content.filter (item)->
          Em.isEqual(item.get('entrant1'), entrantFilter) or Em.isEqual(item.get('entrant2'), entrantFilter)
      if periodType and periodType.get('id') isnt 'all'
        content = content.filter (item)->
          d = item.get('date')
          return unless d
          switch periodType.get('id')
            when 'today'
              today = new Date()
              return d.getDate() is today.getDate() and
              d.getMonth() is today.getMonth() and
              d.getDay() is today.getDay()
            when 'tomorrow'
              tomorrow = moment().add('days', 1).toDate()
              return d.getDate() is tomorrow.getDate() and
                d.getMonth() is tomorrow.getMonth() and
                d.getDay() is tomorrow.getDay()
            when 'yesterday'
              yesterday = moment().add('days', -1).toDate()
              return d.getDate() is yesterday.getDate() and
              d.getMonth() is yesterday.getMonth() and
              d.getDay() is yesterday.getDay()
            when 'week'
              return inDateRange moment().startOf('day').add('weeks', -1), new Date(), d
            when 'month'
              return inDateRange moment().startOf('day').add('months', -1), new Date(), d
            when 'year'
              return inDateRange moment().startOf('day').add('years', -1), new Date(), d
            when 'date'
              return moment(date)?.isSame d, 'day'
            when 'period'
              return inDateRange startDate, endDate, d

      content
    ).property('matchTypeFilter', 'entrantFilter', 'periodFilter', 'dateFilter', 'startDateFilter', 'endDateFilter')

    pastMatchesForEntrant: (entrant)->
      if App.TeamRef.detectInstance entrant
        entrant = entrant.get('team')
      @get('content').filter (item)->
        if Em.isEqual(item.get('entrant1'), entrant) or Em.isEqual(item.get('entrant2'), entrant)
          item.get('currentStatus') is  'past'

    futureMatchesForEntrant: (entrant)->
      if App.TeamRef.detectInstance entrant
        entrant = entrant.get('team')
      @get('content').filter (item)->
        if Em.isEqual(item.get('entrant1'), entrant) or Em.isEqual(item.get('entrant2'), entrant)
          item.get('currentStatus') is 'future'

    hasPastOrFutureMatchesForEntrant: (entrant)->
      @pastMatchesForEntrant(entrant).length or
        @futureMatchesForEntrant(entrant).length

    results: (->
      Ember.ArrayController.create
        content: @get 'round.resultSets'
        sortProperties: ['position']
    ).property('round.resultSets.length')

    automaticCountingChanged: (->
      resultSets = @get 'round.resultSets'
      console.count 'automaticCountingChanged'
      return if not resultSets or not App.get('isEditingMode')

      # Reset
      resultSets.forEach (resultSet)->
        ['matchesPlayed', 'wins', 'losses', 'draws'].forEach (property)->
          resultSet.set property, 0 unless resultSet.get('isSaving')

      incrementPropertyForEntrant = (entrant, property, increment)->
        resultSet = resultSets.find (resultSet)-> Em.isEqual(resultSet.get('entrant.team'), entrant)
        resultSet.incrementProperty property, increment if resultSet and not resultSet.get('isSaving')

      unless @get 'round.automaticCountingDisabled'
        @forEach (match)->
          return unless match.get 'isClosed'
          entrant1 = match.get('entrant1')
          entrant2 = match.get('entrant2')
          entrant1_points = match.get('entrant1_points')
          entrant2_points = match.get('entrant2_points')

          incrementPropertyForEntrant entrant1, 'matchesPlayed' if entrant1
          incrementPropertyForEntrant entrant2, 'matchesPlayed' if entrant2

          unless Em.isEmpty(entrant1_points) and Em.isEmpty(entrant2_points)
            if entrant1_points > entrant2_points
              incrementPropertyForEntrant entrant1, 'wins' if entrant1
              incrementPropertyForEntrant entrant2, 'losses' if entrant2
            else if entrant1_points is entrant2_points
              incrementPropertyForEntrant entrant1, 'draws' if entrant1
              incrementPropertyForEntrant entrant2, 'draws' if entrant2
            else
              incrementPropertyForEntrant entrant1, 'losses' if entrant1
              incrementPropertyForEntrant entrant2, 'wins' if entrant2
         # TODO Should resovle autosaving.
#        resultSets.forEach (resultSet)-> resultSet?.save()
    ).observes(
      'round.automaticCountingDisabled',
      '@each.isClosed'
#      '@each.entrant2_points',
#      '@each.entrant1',
#      '@each.entrant2'
    )

    entrants: (->
      @get('round.resultSets').map (item)-> item.get 'entrant'
    ).property('round.resultSets.@each.entrant.isLoaded')

    _results: (->
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

        teamRefs = @get 'round.teamRefs'
        teamRefs?.forEach (ref)->
          team = ref.get('team')
          results.set ref, Ember.Object.create()

        resultSets = @get 'round.resultSets'
        resultSets?.forEach (resultSet)->
          entrant = resultSet.get('entrant')
          results.set entrant, Ember.Object.create()

        resultsArray = []
        controller = @
        results.forEach (entrant, result)->
          resultsArray.pushObject Em.Object.create controller: controller, entrant: entrant, result

        resultsArray.sort((a,b)-> a.get('wins') > b.get('wins')).forEach (result, index)-> result.set 'position', index+1

        lastResults = Ember.ArrayController.create
          content: resultsArray
          sortProperties: ['position']
        @set 'lastResults', lastResults
        lastResults
    ).property('@each.entrant1_points',
      '@each.entrant2_points',
      '@each.entrant1',
      '@each.entrant2',
      'round.teamRefs.length'
      'round.resultSets.length'
    )
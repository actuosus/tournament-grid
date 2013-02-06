###
 * app
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:31
###

require [
  'Faker'

  'cs!core'

  'cs!router'
  'cs!controllers'
  'cs!views'
  'cs!models'
], ->

  App.ApplicationController = Em.Controller.extend()
  App.ApplicationView = Em.View.extend
    templateName : 'application'

  App.ready = ->
    # Preloading countries
    App.countries = App.Country.find()

    matchGridView = App.MatchGridView.create content: App.Round.find()

#    matchesTableContainerView = App.MatchesTableContainerView.create
#      controller: App.MatchesTableController.create(teams: App.Team.find(), content: App.Match.find())
#    matchesTableContainerView.appendTo document.body

    stangingTableView = App.StangingTableView.create
      teams: App.Team.find()
      matches: App.Match.find()

    teamStandingsContainerView = App.NamedContainerView.create
      title: 'Командный зачёт'
      contentView: stangingTableView
    teamStandingsContainerView.appendTo '#content'

    teamsController = Em.ArrayController.create
      content: App.Team.find()
      sortProperties: ['gamesPlayed']

    gridView = App.GridView.create
      itemViewClass: App.MatchGridItemView
      content: App.Match.find()

    selectionStageContainerView = App.NamedContainerView.create
      title: 'Отборочный этап'
      contentView: gridView
    selectionStageContainerView.appendTo '#content'
#    teamStandingsTableView = App.TeamStandingsTableView.create content: teamsController
#    teamStandingsTableView.appendTo document.body

    championshipTableContainer = App.NamedContainerView.create
      title: 'Таблица результатов турнира'
      contentView: matchGridView
    championshipTableContainer.appendTo '#content'

    window.teamsController = teamsController

    window.matchGrid = matchGridView
#    window.teamStandingsTableView = teamStandingsTableView

    DS.RecordArray.reopen
      onLoad: (callback)->
        if @get 'isLoaded'
          callback this
        else
          that = @
          isLoadedFn = ->
            if that.get 'isLoaded'
              that.removeObserver 'isLoaded', isLoadedFn
              callback that
        @addObserver 'isLoaded', isLoadedFn
        @


    matches = App.store.find(App.Match, {}).onLoad (ra)->
      ra.forEach (match)->
        match.get('team1')?.set('gamesPlayed', (match.get('team1').gamesPlayed + 1) || 1)
        match.get('team2')?.set('gamesPlayed', (match.get('team1').gamesPlayed + 1) || 1)
        if match.get('team1_points') > match.get('team2_points')
          match.get('team1')?.set('wins', (match.get('team1').wins + 1) || 1)
          match.get('team2')?.set('loses', (match.get('team2').loses + 1) || 1)
        else if match.get('team1_points') == match.get('team2_points')
          match.get('team1')?.set('draws', (match.get('team1').draws + 1) || 1)
          match.get('team2')?.set('draws', (match.get('team2').draws + 1) || 1)
        else
          match.get('team2')?.set('wins', (match.get('team2').wins + 1) || 1)
          match.get('team1')?.set('loses', (match.get('team1').loses + 1) || 1)
        console.log 'team1', match.get 'team1'
        console.log 'team2', match.get 'team2'
#    matches.addObserver '@each.isLoaded', (matches)-> console.log(matches.isLoaded)


    App.teams = App.Team.find()
    App.peroids = Em.Object.create
      content: ['Период', 'Дата', 'Сегодня', 'Вчера', 'Неделя', 'Месяц']

  $ -> App.advanceReadiness()



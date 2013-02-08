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

    App.report = App.Report.find('511211b49709aab1ae000002')

    matchGridView = App.MatchGridView.create content: App.Round.find()

#    matchesTableContainerView = App.MatchesTableContainerView.create
#      controller: App.MatchesTableController.create(teams: App.Team.find(), content: App.Match.find())
#    matchesTableContainerView.appendTo document.body

    stangingTableView = App.StangingTableView.create
      teams: App.Team.find()
      matches: App.Match.find()

    stageView = Em.ContainerView.create
      classNames: ['stage-view']
      childViews: ['tabBarView', 'contentView']

      currentTabView: null

      setCurrentTabView: (@currentTabView)->
        console.log @currentTabView.get('content')
        @currentStage = @currentTabView.get 'content'
        console.log @currentStage.get 'rounds'
        switch @currentStage.get 'visual_type'
          when 'grid'
            contentView = App.MatchGridView.create content: @currentStage.get 'rounds'
            console.log contentView
          when 'matrix'
            contentView = App.GridView.create
              itemViewClass: App.MatchGridItemView
              stages: App.Stage.find()
              content: @currentStage.get('rounds.firstObject.matches')
            console.log contentView
#        @get('childViews').pushObject contentView
        @set 'currentView', contentView

      tabBarView: Em.View.extend
        classNames: ['i-listsTabs', 'i-listsTabs_bd']
        template: Em.Handlebars.compile '<ul class="b-listsTabs">{{#each view.content}}{{view view.itemViewClass contentBinding=this}}{{/each}}</ul>'

        selectChildView: (childView)->
          @get('childViews').forEach (child)=>
            properChild = child.get('childViews').objectAt 0
            if Em.isEqual(properChild , childView)
              @get('parentView').setCurrentTabView properChild
              properChild.$().addClass('active')
            else
              properChild .$().removeClass('active')
        itemViewClass: Em.View.extend
          tagName: 'li'
          classNames: ['item']
          template: Em.Handlebars.compile '{{name}}'
          click: ->
            @get('parentView').selectChildView(@)
        content: App.Stage.find()
      contentView: Em.View.extend()

    stageSelectorContainerView = App.NamedContainerView.create
      title: 'Таблица результатов турнира'
      contentView: stageView
    stageSelectorContainerView.appendTo '#content'

    window.stageView = stageView

    teamStandingsContainerView = App.NamedContainerView.create
      title: 'Командный зачёт'
      contentView: stangingTableView
    teamStandingsContainerView.appendTo '#content'

    teamsController = Em.ArrayController.create
      content: App.Team.find()
      sortProperties: ['gamesPlayed']

    gridView = App.GridView.create
      itemViewClass: App.MatchGridItemView
      stages: App.Stage.find()
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

    lineupView = App.GridView.create
      content: App.Team.find()
      itemViewClass: Em.View.extend
        tagName: 'table'
        classNames: ['table', 'lineup-grid-item']
        template: Em.Handlebars.compile(
          '<thead><tr><th colspan="2"><span class="lineup-grid-item-name"><i {{bindAttr class=":country-flag-icon :team-country-flag-icon view.content.countryFlagClassName"}}></i>{{view.content.name}}</span></th></tr></thead><tbody>{{#each view.content.players}}<tr><td><i {{bindAttr class=":country-flag-icon :team-country-flag-icon countryFlagClassName"}}></i>{{nickname}}</td><td><span class="realname">({{realname}})</span></td></tr>{{/each}}</tbody>'
        )

    lineupContainerView = App.NamedContainerView.create
      title: 'Состав команд'
      contentView: lineupView

    lineupContainerView.appendTo '#content'

    groupContainerView = App.NamedContainerView.create
      title: 'Групповой этап'
      contentView: App.GridView.create
        content: App.Stage.find()
        itemViewClass: Em.View.extend
          tagName: 'table'
          classNames: ['table', 'lineup-grid-item']
          template: Em.Handlebars.compile(
            '<thead><tr><th colspan="2"><span class="lineup-grid-item-name"><i {{bindAttr class=":country-flag-icon :team-country-flag-icon view.content.countryFlagClassName"}}></i>{{view.content.name}}</span></th></tr></thead><tbody>{{#each view.content.players}}<tr><td><i {{bindAttr class=":country-flag-icon :team-country-flag-icon countryFlagClassName"}}></i>{{nickname}}</td><td><span class="realname">({{realname}})</span></td></tr>{{/each}}</tbody>'
          )
        emptyViewClass: Em.View.extend
          template: Em.Handlebars.compile('Пока что ни одного этапа')

    groupContainerView.appendTo '#content'

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
#    matches.addObserver '@each.isLoaded', (matches)-> console.log(matches.isLoaded)


    App.teams = App.Team.find()
    App.peroids = Em.Object.create
      content: ['Период', 'Дата', 'Сегодня', 'Вчера', 'Неделя', 'Месяц']

  $ -> App.advanceReadiness()



###
 * application
 * @author: actuosus
 * @fileOverview Application initialization.
 * Date: 21/01/2013
 * Time: 07:31
###

define [
  'jquery'
  'Faker'
  'ember'
  'ember-data'

  'cs!./core'

  'cs!./router'
  'cs!./controllers'
  'cs!./views'
  'cs!./models'
  'cs!./fixtures'

  'text!./templates/lineup_grid_item.handlebars'

  'cs!./mixins/translatable'
  'cs!./mixins/collapsable'
  'cs!./translators/yandex'

], ($, Fakera,
    ember,
    emberData,
    core,
    router,
    controllers,
    views,
    models,
    fixtures,
    lineupGridItemTemplate)->
  Em.TEMPLATES.lineupGridItem = Em.Handlebars.compile lineupGridItemTemplate

#  App.ApplicationController = Em.Controller.extend()
#  App.ApplicationView = Em.View.extend
#    templateName : 'application'

  App.isEditingMode = no

  $(document.body).keydown (event)->
    if event.ctrlKey
      switch event.keyCode
        when 69 # e
          App.set 'isEditingMode', not App.get('isEditingMode')


  App.ready = ->
    App.set 'report', App.Report.find(window.currentReportId)

    App.EntrantsController = Em.ArrayController.extend
      searchResults: []
      search: ->
      searchQuery: ''
      arrangedContent: (->
        content = @get 'content'
        searchQuery = @get 'searchQuery'
        if searchQuery
          reg = new RegExp(searchQuery, 'gi')
          result = content.filter (item)->
            matches = no
            matches = yes if item.get('name').match reg
            matches
        else
          result = content
        result
      ).property('content', 'searchQuery')

    App.entrantsController = App.EntrantsController.create()

    App.set 'countriesController', Em.ArrayController.create
      content: []
      searchResults: []
      labelValue: 'name'
      sort: (result, options)->
        lowerCased = options.name.toLowerCase()
        result.sort (a,b)->
          lowerA = a.get('name').toLowerCase()
          lowerB = b.get('name').toLowerCase()
          if lowerA.indexOf(lowerCased) < lowerB.indexOf(lowerCased)
            return -1
          if lowerA.indexOf(lowerCased) > lowerB.indexOf(lowerCased)
            return 1
          if lowerA.indexOf(lowerCased) is lowerB.indexOf(lowerCased)
            return 0
      search: (options)->
#        @set 'content', App.Country.find options
        result = App.countries.filter (item, idx)->
          regexp = new RegExp(options.name, 'i')
#          if item.get('_name')
          if item.get('name')?.match regexp
            return yes
          if item.get('englishName')?.match regexp
            return yes
        @set 'content', @sort(result, options)
        @set 'content.isLoaded', yes
      menuItemViewClass: Em.View.extend
        classNames: ['menu-item', 'country-menu-item']
        classNameBindings: ['isSelected']
#        isSelectedBinding: 'content.isSelected'
        template: Em.Handlebars.compile(
          '<i {{bindAttr class=":country-flag-icon view.content.flagClassName"}}></i>'+
          '{{highlight view.content.name partBinding=parentView.highlight}}')
        mouseDown: (event)->
          event.stopPropagation()

        click: (event)->
          event.preventDefault()
          event.stopPropagation()
          @get('parentView').click(event)
          @set 'parentView.selection', @get 'content'
          @set 'parentView.value', @get 'content'
          @set 'parentView.isVisible', no

    App.set 'teamsController', Em.ArrayController.create
      formView: App.TeamForm
      searchResults: []
      labelValue: 'name'
      search: (options)->
        @set 'content', App.Team.find options
      menuItemViewClass: Em.View.extend
        classNames: ['menu-item']
        classNameBindings: ['isSelected']
        template: Em.Handlebars.compile(
          '{{highlight view.content.name partBinding=parentView.highlight}}'
        )
        click: (event)->
          event.preventDefault()
          event.stopPropagation()
          @get('parentView').click(event)
          @set 'parentView.selection', @get 'content'
          @set 'parentView.value', @get 'content'
          @set 'parentView.isVisible', no
    window.teamsController = teamsController
    App.playersController = Em.ArrayController.create
      formView: App.PlayerForm
      searchResults: []
      labelValue: 'nickname'
      search: (options)->
        searchOptions = {}
        if options.name
          searchOptions.nickname = options.name
        @set 'content', App.Player.find searchOptions
      menuItemViewClass: Em.View.extend
        classNames: ['menu-item']
        classNameBindings: ['isSelected']
        template: Em.Handlebars.compile('{{view.content.nickname}}')
        click: (event)->
          event.preventDefault()
          event.stopPropagation()
          @get('parentView').click(event)
          @set 'parentView.selection', @get 'content'
          @set 'parentView.value', @get 'content'
          @set 'parentView.isVisible', no

    stageView = Em.ContainerView.create
      classNames: ['stage-view']
      childViews: ['tabBarView', 'contentView']

      content: null

      setCurrentTabView: (@currentTabView)->
        @currentStage = @currentTabView.get 'content'
        switch @currentStage.get 'visual_type'
          when 'grid'
            contentView = App.TournamentGridView.create content: @currentStage
          when 'group'
            contentView = App.GroupGridView.create
              content: @currentStage.get 'rounds'
              entrants: @currentStage.get 'entrants'
          when 'matrix'
            contentView = App.GridView.create
              classNames: ['match-grid']
              itemViewClass: App.MatchGridItemView
              content: @currentStage.get 'matches'
          when 'team'
            teamsController = Em.ArrayController.create
              content: @currentStage.get('entrants')
              sortProperties: ['gamesPlayed']
            contentView = App.StangingTableView.create
              entrants: teamsController
              matches: @currentStage.get('rounds.firstObject.matches')
        @set 'currentView', contentView

      tabBarView: Em.View.extend
        classNames: ['i-listsTabs', 'i-listsTabs_bd']
        template: Em.Handlebars.compile '''
          <ul class="b-listsTabs">
          {{#each view.content}}
          {{view view.itemViewClass contentBinding=this}}
          {{/each}}
          {{#if App.isEditingMode}}
            <li class="item add"><button class="btn-clean add">+</button></li>
          {{/if}}

          </ul>
        '''

        didInsertElement: ->
          @selectChildView @get('childViews.firstObject.childViews.firstObject')

        click: (event)->
          if $(event.target).hasClass('add')
            @set 'parentView.currentView', App.StageForm.create(classNames: ['padded'], report: App.report)

        selectChildView: (childView)->
          @get('childViews').forEach (child)=>
            properChild = child.get('childViews').objectAt 0
            if Em.isEqual(properChild , childView)
              @get('parentView').setCurrentTabView properChild
              properChild.$().addClass('active')
            else
              properChild .$().removeClass('active')

#        itemViewClass: App.MultilingualEditableLabel.extend
        itemViewClass: Em.ContainerView.extend
          tagName: 'li'
          classNames: ['item']
          classNameBindings: 'isEditing'
          isEditingBinding: 'App.isEditingMode'
          childViews: ['nameView', 'removeButtonView']
          languages: App.languages
          attributeBindings: ['title']

          titleBinding: 'content.description'

          nameView: Em.View.extend
            contentBinding: 'parentView.content'
            template: Em.Handlebars.compile '{{name}}'

          removeButtonView: Em.View.extend
            tagName: 'button'
            contentBinding: 'parentView.content'
            isVisibleBinding: 'App.isEditingMode'
            classNames: ['btn-clean', 'remove-btn', 'remove']
            attributeBindings: ['title']
            title: '_remove'.loc()
            template: Em.Handlebars.compile '×'

            click: -> @get('content').deleteRecord()
#          valueBinding: 'content.name'
          click: ->
            @get('parentView').selectChildView(@)
        contentBinding: 'parentView.content'
      contentView: Em.View.extend()

    # Preloading countries
    App.countries = App.Country.find()
    App.anotherCountriesController = Em.ArrayController.create
      content: []

    stageSelectorContainerView = App.NamedContainerView.create
      title: '_tournament_results_table'.loc()
      contentView: stageView
      countriesIsUpdating: (controller)->
        console.log 'countriesIsUpdating', controller.get('content.isUpdating'), controller.get('content.isLoaded')
        unless controller.get('content.isUpdating')
          @set 'loaderView.isVisible', no
          @set 'statusTextView.value', ''
        else
          @set 'loaderView.isVisible', yes
          @set 'statusTextView.value', 'Countries loading…'
    App.anotherCountriesController.addObserver(
                    'content.isUpdating',
                    stageSelectorContainerView,
                    stageSelectorContainerView.countriesIsUpdating
                  )

    App.anotherCountriesController.set('content', App.Country.find())

    stageSelectorContainerView.appendTo '#content'

    window.stageView = stageView

    teamsController = Em.ArrayController.create
      contentBinding: 'App.report.entrants'
      sortProperties: ['gamesPlayed']

    lineupView = App.LineupView.create
      contentBinding: 'App.report.entrants'

    window.lineupView = lineupView

    lineupContainerView = App.NamedContainerView.create
      title: '_the_teams'.loc()
      childViews: [
        'titleView', 'toggleButtonView', 'contentView',
        'loaderView', 'statusTextView', 'searchBarView'
      ]
      searchBarView: Em.ContainerView.extend
        classNames: ['search-bar']
        childViews: ['textFieldView', 'clearButtonView']
        isVisibleBinding: 'App.isEditingMode'
        clearButtonView: Em.View.extend
          tagName: 'button'
          isVisibleBinding: 'parentView.textFieldView.isNotClearValue'
          classNames: ['btn-clean', 'remove-btn', 'remove']
          attributeBindings: ['title']
          title: '_remove'.loc()
          template: Em.Handlebars.compile '×'

          click: -> @set('parentView.textFieldView.value', '')
        textFieldView: Em.TextField.extend
          classNames: ['search-field']
          placeholder: '_filter'.loc()
          valueChanged: (->
            if @get 'value'
              @set 'isNotClearValue', yes
            else
              @$().val('')
              @$().focus()
              @set 'isNotClearValue', no
            App.entrantsController.set('searchQuery', @get 'value')
          ).observes('value')
      contentView: lineupView

    $('.link_pencil').click (event)->
      event.preventDefault()
      App.set 'isEditingMode', not App.get('isEditingMode')

      if lineupContainerView?.$()
        $(document.body).scrollTo(lineupContainerView.$(), 500, {offset: {top: -18}})
      else if stageSelectorContainerView?.$()
        $(document.body).scrollTo(stageSelectorContainerView.$(), 500, {offset: {top: -18}})

    App.report.didLoad = ->
      stageView.set('content', App.report.get('stages'))
      if App.report?.get('match_type') is 'team'
        lineupContainerView.appendTo '#content'

#    matches = App.store.find(App.Match, {}).onLoad (ra)->
#      ra.forEach (match)->
#        team1 = match.get('team1')
#        team2 = match.get('team2')
#        team1?.set('gamesPlayed', (team1.gamesPlayed + 1) || 1)
#        team2?.set('gamesPlayed', (team2.gamesPlayed + 1) || 1)
#        if match.get('team1_points') > match.get('team2_points')
#          team1?.set('wins', (team1.wins + 1) || 1)
#          team2?.set('loses', (team2.loses + 1) || 1)
#        else if match.get('team1_points') == match.get('team2_points')
#          team1?.set('draws', (team1.draws + 1) || 1)
#          team2?.set('draws', (team2.draws + 1) || 1)
#        else
#          team2?.set('wins', (team2.wins + 1) || 1)
#          team1?.set('loses', (team1.loses + 1) || 1)

    createRounds = (roundsCount)->
      rounds = []
      roundsCount = roundsCount or (Math.ceil(Math.random()*5))
      for i in [roundsCount..0]
        matches = []
#        console.log "Round #{i}, #{Math.pow(2, i)} matches."
        for j in [1..(Math.pow(2, i))]
          matches.push Em.ArrayController.create
            content: [
              Em.Object.create(name: Faker.Company.companyName())
              Em.Object.create(name: Faker.Company.companyName())
            ]
        rounds.push Em.ArrayController.create content: matches
      rounds

    createActualRounds = (roundsCount)->
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
        if i is 0
          console.log 'Zero!'
          round = rounds.createRecord
            itemIndex: -1
            parentReference: 'stage'
          round.get('matches').createRecord
            isWinner: yes
            itemIndex: -1
      stage

    createLoserBracket = (bracket, entrantsNumber)->
      roundsCount = Math.log(entrantsNumber*2) / Math.log(2)-1;
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

    createActualRoundsByEntrants = (entrantsNumber)->
      createActualRounds(Math.log(entrantsNumber) / Math.log(2)-1)

    window.createRounds = createRounds
    window.createActualRounds = createActualRounds
    window.createActualRoundsByEntrants = createActualRoundsByEntrants
    window.createLoserBracket = createLoserBracket

#    window.stage = createActualRoundsByEntrants(8)

    App.NamedContainerView.create(
      title: 'Tester'
      contentView: App.TesterView.create()
    ).appendTo('#content')

#    App.Folder = Ember.Object.extend({
#      treeItemIsExpanded: false,  # Default to not expanded
#      name: null
#    });
#
#    App.File = Ember.Object.extend({
#      name: null
#    });
#
#    App.someController = Ember.Object.create({
#      tree: [
#        App.Folder.create({
#        name: 'Folder 1',
#        treeItemChildren: [
#          App.File.create({ name: 'File 1' }),
#          App.File.create({ name: 'File 2' }),
#          App.File.create({ name: 'File 3' })
#        ]
#        }),
#        App.Folder.create({
#        name: 'Folder 2', treeItemChildren: []
#        }),
#        App.Folder.create({
#        name: 'Folder 3',
#        treeItemChildren: [
#          App.Folder.create({
#            name: 'My pictures',
#            treeItemChildren: [
#              App.File.create({ name: 'File 1' }),
#              App.File.create({ name: 'File 2' })
#            ]
#          }),
#          App.File.create({ name: 'File 5' })
#        ]
#        }),
#      ]
#    });
#
#    treeView = App.TreeView.create
#      contentBinding: 'App.someController.tree'
#
#    treeView.appendTo('#content')

    App.peroids = Em.ArrayController.create
      content: [
        Em.Object.create name:'Период', id: 'period'
        Em.Object.create name:'Дата', id: 'date'
        Em.Object.create name:'Сегодня', id: 'today'
        Em.Object.create name:'Вчера', id: 'yesterday'
        Em.Object.create name:'Неделя', id: 'week'
        Em.Object.create name:'Месяц', id: 'month'
      ]

    App.matchTypes = Em.ArrayController.create
      content: [
        Em.Object.create name:'_period'.loc(), id: 'period'
        Em.Object.create name:'_date'.loc(), id: 'date'
        Em.Object.create name:'_today'.loc(), id: 'today'
        Em.Object.create name:'_yesterday'.loc(), id: 'yesterday'
        Em.Object.create name:'_week'.loc(), id: 'week'
        Em.Object.create name:'_month'.loc(), id: 'month'
      ]

    App.visualTypes = Em.ArrayController.create
      content: [
        Em.Object.create name:'_grid'.loc(), id: 'grid'
        Em.Object.create name:'_group'.loc(), id: 'group'
        Em.Object.create name:'_matrix'.loc(), id: 'matrix'
        Em.Object.create name:'_team'.loc(), id: 'team'
      ]

    App.entrantsController.set('content', App.Team.find())

#  $ -> App.advanceReadiness()
  App.ready()



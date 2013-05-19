###
 * tabs
 * @author: actuosus
 * Date: 01/04/2013
 * Time: 06:57
###

define [
  'cs!../../core'
  'cs!../tournament_grid'
  'cs!../group_grid'
  'cs!../grid'
  'cs!../standing_table'
  'cs!../match/grid_container'
  'cs!../../controllers/matches'
  'cs!./form'
  'cs!../tab'
],->
  App.StageTabsView = App.TabView.extend
    classNames: ['stage-view']

    content: null
    currentStage: null

    currentStageDidLoad: -> @setViewForStage @currentStage

    setViewForStage: (stage)->
      switch @currentStage.get 'visual_type'
        when 'single', 'grid'
          @currentStage.get('matches')
          contentView = App.NewTournamentGridView.create
            entrantsNumber: @currentStage.get('entrantsNumber')
        when 'double'
          contentView = App.NewDoubleTournamentGridView.create
            entrantsNumber: @currentStage.get('entrantsNumber')
        when 'group'
          contentView = App.GroupGridView.create
            content: @currentStage.get 'rounds'
            entrants: @currentStage.get 'entrants'
        when 'matrix'
          matchesController = App.MatchesController.create(stage: @currentStage, contentBinding: 'stage.matches')
          contentView = App.MatchGridContainer.create
            stage: @currentStage
            content: matchesController
        when 'team'
          teamsController = Em.ArrayController.create
            content: @currentStage.get('entrants')
#            sortProperties: ['gamesPlayed']
          matchesController = App.MatchesController.create
            content: @currentStage.get('rounds.firstObject.matches')
          contentView = App.StangingTableView.create
            entrants: teamsController
            matches: matchesController
      @set 'currentView', contentView

    setCurrentTabView: (@currentTabView)->
      @currentStage = @currentTabView.get 'content'

      @get('controller.container').lookup('router:main').transitionTo('stage', @currentStage)

#      console.log '@currentStage', @currentStage, @currentStage.get 'visual_type'
#      @currentStage.on 'didLoad', @currentStageDidLoad.bind(@)
      @currentStage.addObserver 'data', @, @currentStageDidLoad
      @setViewForStage @currentStage

    contentView: Em.View.extend()

    tabBarView: Em.View.extend
      classNames: ['i-listsTabs', 'i-listsTabs_bd']
      contentBinding: 'parentView.content'
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

      click: (event)->
        if $(event.target).hasClass('add')
          @set 'parentView.currentView', App.StageForm.create(classNames: ['padded'], report: App.report)

      selectChildView: (childView)->
        @get('childViews').forEach (child)=>
          properChild = child #.get('childViews').objectAt 0
          if Em.isEqual(properChild , childView)
            @get('parentView').setCurrentTabView properChild
            properChild.$().addClass('active')
          else
            properChild .$().removeClass('active')

#        itemViewClass: App.MultilingualEditableLabel.extend
      itemViewClass: Em.ContainerView.extend
        tagName: 'li'
        classNames: ['item']
        classNameBindings: ['isEditing', 'content.isUpdating', 'active']#
        isEditingBinding: 'App.isEditingMode'
        childViews: ['nameView', 'removeButtonView']
        languages: App.languages
        attributeBindings: ['title']

        currentWhen: 'stage'

        contentChanged: (->
          console.log 'stage item content'
        ).observes('content.isLoaded')

        active: (->
          router = @get 'router'
          content = @get 'content'
          return unless router
          currentWithIndex = @currentWhen + '.index'
          router.isActive.apply(router, [@currentWhen].concat(content)) or
            router.isActive.apply(router, [currentWithIndex].concat(content))
        ).property('namedRoute', 'router.url')
#
        router: (->
          @get('controller.container')?.lookup('router:main')
        ).property()

        titleBinding: 'content.description'

        nameView: Em.View.extend
          contentBinding: 'parentView.content'
          template: Em.Handlebars.compile '{{view.content.name}}'

        deleteRecord: -> @get('content').deleteRecord()

        removeButtonView: App.RemoveButtonView.extend
          title: '_remove_stage'.loc()
          remove: -> @get('parentView').deleteRecord()
          click: (event)->
            event.stopPropagation()
            @_super()

        click: ->
          router = @get 'router'
          router.transitionTo 'stage', @get 'content'
          @get('parentView').selectChildView(@)

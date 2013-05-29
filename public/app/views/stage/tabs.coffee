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
            stage: @currentStage
            entrantsNumber: @currentStage.get('entrantsNumber')
        when 'double'
          contentView = App.NewDoubleTournamentGridView.create
            stage: @currentStage
            entrantsNumber: @currentStage.get('entrantsNumber')
        when 'group'
          contentView = App.GroupGridView.create
            content: @currentStage.get 'rounds'
            entrants: @currentStage.get 'entrants'
            showFilterForm: no
            tableItemViewClass: 'App.MatchGroupTableItemView'
        when 'matrix'
          matchesController = App.MatchesController.create(stage: @currentStage, contentBinding: 'stage.matches')
          contentView = App.MatchGridContainer.create
            stage: @currentStage
            content: matchesController
        when 'team'
          console.log @currentStage.get('entrants')
          teamsController = App.ReportEntrantsController.create
            searchPath: 'name'
            stage: @currentStage
            contentBinding: 'stage.entrants'
          matchesController = App.MatchesController.create
            content: @currentStage.get('rounds.firstObject.matches')
          contentView = App.StandingTableView.create
            classNames: ['for-team']
            entrants: teamsController
            matches: matchesController
            showFilterForm: yes
            tableItemViewClass: 'App.MatchTableItemView'
      @set 'currentView', contentView

    setCurrentTabView: (@currentTabView)->
      @currentStage = @currentTabView.get 'content'
      @get('controller.container')?.lookup('router:main').transitionTo('stage', @currentStage)
      @currentStage.addObserver 'data', @, @currentStageDidLoad
      @setViewForStage @currentStage

    contentView: Em.View.extend()

    tabBarView: Em.ContainerView.extend( App.ContextMenuSupport, {
      classNames: ['i-listsTabs', 'i-listsTabs_bd']
      contentBinding: 'parentView.content'
      childViews: ['tabsView']

      tabsView: Em.CollectionView.extend
        tagName: 'ul'
        classNames: 'b-listsTabs'
        contentBinding: 'parentView.content'
        itemViewClass: Em.ContainerView.extend( App.ContextMenuSupport, App.Editing, {
          tagName: 'li'
          classNames: ['item']
          classNameBindings: ['active', 'isFocused']
          childViews: ['nameView']
          attributeBindings: ['title']
          _isEditingBinding: 'App.isEditingMode'
          editingChildViews: ['removeButtonView']

          contextMenuActions: ['edit', 'deleteRecord:delete']

          titleBinding: 'content.description'

          edit: ->
            @popup = App.PopupView.create target: @
            @popup.pushObject App.StageForm.create content: @get 'content'
            @popup.append()

          deleteRecord: -> @get('content').deleteRecord()

          currentWhen: 'stage'

          active: (->
            router = @get 'router'
            content = @get 'content'
            return unless router
            currentWithIndex = @currentWhen + '.index'
            router.isActive.apply(router, [@currentWhen].concat(content)) or
              router.isActive.apply(router, [currentWithIndex].concat(content))
          ).property('namedRoute', 'router.url')

          router: (->
            @get('controller.container')?.lookup('router:main')
          ).property('controller')

          nameView: Em.View.extend
            contentBinding: 'parentView.content'
            template: Em.Handlebars.compile '{{view.content.name}}'

          removeButtonView: App.RemoveButtonView.extend
            title: '_remove_stage'.loc()
            deleteRecord: -> @get('parentView').deleteRecord()
            click: (event)->
              event.stopPropagation()
  #            @_super()

          click: ->
            router = @get 'router'
            router.transitionTo 'stage', @get 'content' if router
            @get('parentView.parentView').selectChildView(@)
        })

#      template: Em.Handlebars.compile '''
#                                      <ul class="b-listsTabs">
#                                        {{#each view.content}}
#                                          {{view view.itemViewClass contentBinding=this}}
#                                        {{/each}}
#                                        {{#if App.isEditingMode}}
#                                          <li {{bindAttr class=":item :add view.addActive:active"}}><button class="btn-clean add">+</button></li>
#                                        {{/if}}
#                                      </ul>
#                                      '''
#
      shouldShowContextMenuBinding: 'App.isEditingMode'
      contextMenuActions: ['add']

      add: -> @addItem()

      addActive: (->
        router = @get 'router'
        return unless router
        router.isActive.apply(router, ['stages.new'])
      ).property('router.url')

      router: (->
        @get('controller.container')?.lookup('router:main')
      ).property('controller')

      addItem: ->
        router = @get 'router'
        router.transitionTo 'stages.new' if router
        @set 'parentView.currentView', App.StageForm.create(classNames: ['padded'], report: App.report)

      click: (event)->
        if $(event.target).hasClass('add')
          @addItem()

      selectChildView: (childView)->
        @get('childViews.firstObject.childViews').forEach (child)=>
          properChild = child #.get('childViews').objectAt 0
          if Em.isEqual(properChild , childView)
            @get('parentView').setCurrentTabView properChild
    })
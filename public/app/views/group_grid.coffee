###
 * group_grid
 * @author: actuosus
 * Date: 31/03/2013
 * Time: 18:45
###

define [
  'cs!./grid',
  'cs!./loader'
  'cs!./standing_table',
  'cs!./editable_label',
  'cs!./multilingual_editable_label',
  'cs!./match/table_container'
  'cs!./remove_button'
  'cs!../controllers/matches'
  'cs!../mixins/context_menu_support'
  'cs!../mixins/moving_highlight'
  'cs!../mixins/editing'
], ->
  App.GroupGridView = App.GridView.extend App.ContextMenuSupport,
    classNames: ['lineup-grid', 'group-lineup-grid']

    shouldShowContextMenuBinding: 'App.isEditingMode'
    contextMenuActions: ['add:addRound']

    add: -> @get('content').createRecord()

    itemViewClass: Em.ContainerView.extend(App.ContextMenuSupport, {
      classNames: ['lineup-grid-item']
      classNameBindings: ['content.isDirty', 'content.isUpdating']
      childViews: ['contentView', 'matchesView']

      showFilterFormBinding: 'parentView.showFilterForm'
      tableItemViewClassBinding: 'parentView.tableItemViewClass'

      shouldShowContextMenuBinding: 'App.isEditingMode'
      contextMenuActions: ['save', 'deleteRecord:removeGroup']

      save: ->
        @get('content.store')?.commit()

      deleteRecord: ->
        @get('content').deleteRecord()
        @get('content.store')?.commit()

      contentView: Em.ContainerView.extend( App.Editing, App.MovingHightlight, {
        contentBinding: 'parentView.content'
        classNames: ['lineup-grid-item-name-container']
        childViews: ['titleView']

        editingChildViews: ['automaticCountingButtonView', 'addButtonView', 'removeButtonView']
        _isEditingBinding: 'App.isEditingMode'

        titleView: App.EditableLabel.extend
          isEditableBinding: 'App.isEditingMode'
          contentBinding: 'parentView.content'
          valueBinding: 'content.title'
          classNames: ['lineup-grid-item-name']

        addButtonView: Em.View.extend
          tagName: 'button'
          contentBinding: 'parentView.content'
          isVisibleBinding: 'App.isEditingMode'
          classNames: ['btn-clean', 'add-btn', 'add']
          attributeBindings: ['title']
          title: '_add_entrant'.loc()
          template: Em.Handlebars.compile '+'

          click: ->
            round = @get 'content'
            resultSets = @get 'content.resultSets'
            if resultSets?.createRecord
              resultSets.createRecord(round: round)

        automaticCountingButtonView: Em.View.extend
          tagName: 'button'
          classNames: ['btn', 'btn-primary', 'btn-mini', 'count-btn', 'count']
          attributeBindings: ['title']
          contentBinding: 'parentView.content'
          isVisibleBinding: 'App.isEditingMode'
          automaticCountingDisabledBinding: 'content.automaticCountingDisabled'
          label: (->
            if @get('automaticCountingDisabled')
              '_count'.loc()
            else
              '_dont_count'.loc()
          ).property('automaticCountingDisabled')
          title: (->
            if @get('automaticCountingDisabled')
              '_automatic_counting_disabled'.loc()
            else
              '_automatic_counting_enabled'.loc()
          ).property('automaticCountingDisabled')
          template: Em.Handlebars.compile '{{view.label}}'

          click: -> @toggleProperty 'automaticCountingDisabled'

        deleteRecord: ->
          @get('content').deleteRecord()
          @get('content.store')?.commit()

        removeButtonView: App.RemoveButtonView.extend
          title: '_remove_group'.loc()
          deleteRecord: -> @get('parentView').deleteRecord()

      })

      matchesView: App.StandingTableView.extend
        childViews: ['standingsView', 'contentView']
        entrantsBinding: 'parentView.content.entrants'
        showFilterFormBinding: 'parentView.showFilterForm'
        tableItemViewClassBinding: 'parentView.tableItemViewClass'
        matches: (->
          round = @get 'parentView.content'
          App.MatchesController.create content: round.get('matches'), round: round
        ).property 'parentView.content.matches'
        contentBinding: 'parentView.content.matches'
        contentView: App.MatchesTableContainerView.extend
          entrantsBinding: 'parentView.matches.entrants'
          contentBinding: 'parentView.matches'
          showFilterFormBinding: 'parentView.showFilterForm'
          tableItemViewClassBinding: 'parentView.tableItemViewClass'
    })
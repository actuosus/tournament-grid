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
], ->
  App.GroupGridView = App.GridView.extend App.ContextMenuSupport,
    classNames: ['lineup-grid', 'group-lineup-grid']

    shouldShowContextMenuBinding: 'App.isEditingMode'
    contextMenuActions: ['add']

    add: ->
      @get('content').createRecord()

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

      contentView: Em.ContainerView.extend( App.Editing, {
        contentBinding: 'parentView.content'
        classNames: ['lineup-grid-item-name-container']
        childViews: ['nameView', 'addButtonView']

        editingChildViews: ['automaticCountingButtonView', 'removeButtonView']
        _isEditingBinding: 'App.isEditingMode'

        nameView: App.EditableLabel.extend
          isEditableBinding: 'App.isEditingMode'
          contentBinding: 'parentView.content'
#          valuesBinding: 'content._name'
          valueBinding: 'content.name'
          classNames: ['lineup-grid-item-name']
#          languagesBinding: 'App.languages'
#          template: Em.Handlebars.compile '{{view.content.name}}'

        addButtonView: Em.View.extend
          tagName: 'button'
          contentBinding: 'parentView.content'
          isVisibleBinding: 'App.isEditingMode'
          classNames: ['btn-clean', 'add-btn', 'add']
          attributeBindings: ['title']
          title: '_add_entrant'.loc()
          template: Em.Handlebars.compile '+'

          click: ->
            console.debug 'Should add entrant.'
            teamRefs = @get 'content.teamRefs'
            if teamRefs?.createRecord
              teamRefs.createRecord()

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

        deleteRecord: -> @get('content').deleteRecord()

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
          contentBinding: 'parentView.matches'
          showFilterFormBinding: 'parentView.showFilterForm'
          tableItemViewClassBinding: 'parentView.tableItemViewClass'
    })
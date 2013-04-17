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
  'cs!./match/group_table_container'
  'cs!../controllers/matches'
], ->
  App.GroupGridView = App.GridView.extend
    classNames: ['lineup-grid', 'group-lineup-grid']

    itemViewClass: Em.ContainerView.extend
      classNames: ['lineup-grid-item']
      childViews: ['contentView', 'matchesView']

      contentView: Em.ContainerView.extend
        contentBinding: 'parentView.content'
        classNames: ['lineup-grid-item-name-container']
        childViews: ['nameView', 'addButtonView', 'automaticCountingButtonView', 'removeButtonView']

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
            console.debug 'Should add match.'
            content = @get 'content'
            if content.createRecord
              content.createRecord() if content
            if content.get('content')?.createRecord
              content.get('content')?.createRecord()

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

        removeButtonView: Em.View.extend
          tagName: 'button'
          contentBinding: 'parentView.content'
          isVisibleBinding: 'App.isEditingMode'
          classNames: ['btn-clean', 'remove-btn', 'remove']
          attributeBindings: ['title']
          title: '_remove'.loc()
          template: Em.Handlebars.compile '×'

          click: -> @get('content').deleteRecord()

      matchesView: App.StangingTableView.extend
        childViews: ['stadingsView', 'contentView']
        entrantsBinding: 'parentView.content.entrants'
        matches: (->
          actualContent = @get 'parentView.content.matches'
          App.MatchesController.create content: actualContent, round: @get 'parentView.content'
        ).property 'parentView.content.matches'
        contentBinding: 'parentView.content.matches'
        contentView: App.MatchesGroupTableContainerView.extend
          contentBinding: 'parentView.matches'
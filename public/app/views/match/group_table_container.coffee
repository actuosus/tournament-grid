###
 * group_table_container
 * @author: actuosus
 * Date: 31/03/2013
 * Time: 17:53
###

define [
  'cs!./group_table'
  'cs!../../mixins/collapsable'
], ()->
  App.MatchesGroupTableContainerView = Em.ContainerView.extend
    classNames: ['matches-table-container']
    childViews: ['headerView', 'tableContainerView']

    headerView: Em.ContainerView.extend
      classNames: ['matches-table-container-header']
      contentBinding: 'parentView.content'
      childViews: ['titleView', 'addButtonView', 'saveButtonView'],

      titleView: Em.View.extend
        classNames: ['matches-table-title']
        template: Em.Handlebars.compile('{{loc "_matches"}}')

      saveButtonView: Em.View.extend
        tagName: 'button'
        classNames: ['btn', 'btn-primary', 'btn-mini', 'save-btn', 'save']
        template: Em.Handlebars.compile '{{loc "_save"}}'
        isVisible: (->
          isEditingMode = App.get('isEditingMode')
          isDirty = no
          items = @get 'parentView.content'
          items.forEach (item)-> isDirty = yes if item.get 'isDirty'
          yes if isEditingMode and isDirty
        ).property('App.isEditingMode', 'parentView.content.@each.isDirty')

        click: ->
          dirtyItems
          items = @get 'parentView.content'
          dirtyItems = items.filterProperty 'isDirty'
          if dirtyItems.length
            first = dirtyItems[0]
            first.transaction.commit()

      addButtonView: Em.View.extend
        tagName: 'button'
        contentBinding: 'parentView.content'
        isVisibleBinding: 'App.isEditingMode'
        classNames: ['btn-clean', 'add-btn', 'add']
        attributeBindings: ['title']
        title: '_add'.loc()
        template: Em.Handlebars.compile '+'

        click: ->
          console.debug 'Should add match.'
          content = @get 'content'
          if content.createRecord
            content.createRecord() if content
          if content.get('content')?.createRecord
            content.get('content')?.createRecord()

          tableContainerView = @get 'parentView.parentView.tableContainerView'
          tableContainerView.set 'isCollapsed', yes


    tableContainerView: Em.ContainerView.extend(App.Collapsable,
      classNames: ['matches-table-container-inner']
      childViews: ['tableView']
      content: Em.computed.alias 'parentView.content'
      collapsed: yes
      toggleButtonTarget: Em.computed.alias 'parentView.headerView'
      tableView: App.MatchesGroupTableView.extend
        contentBinding: 'parentView.content'
    )
###
 * table_container
 * @author: actuosus
 * Date: 31/03/2013
 * Time: 17:53
###

define [
  'cs!./table'
  'cs!./filter_form'
  'cs!../../mixins/collapsable'
], ()->
  App.MatchesTableContainerView = Em.ContainerView.extend
    classNames: ['matches-table-container']
    childViews: ['headerView', 'tableContainerView']

    headerView: Em.ContainerView.extend( App.Editing, {
      classNames: ['matches-table-container-header']
      classNameBindings: ['isTargetCollapsed:is-target-collapsed:is-target-expanded']
      entrantsBinding: 'parentView.entrants'
      contentBinding: 'parentView.content'
      childViews: ['titleView', 'filterFormView']

      showFilterFormBinding: 'parentView.showFilterForm'

      _isEditingBinding: 'App.isEditingMode'

      editingChildViews: ['addButtonView']

      titleView: Em.View.extend
        classNames: ['matches-table-title']
        template: Em.Handlebars.compile('{{loc "_matches"}}')

      filterFormView: App.MatchFilterFormView.extend
        isVisibleBinding: 'parentView.showFilterForm'
        entrantsBinding: 'parentView.entrants'
        contentBinding: 'parentView.content'

      addButtonView: Em.View.extend
        tagName: 'button'
        contentBinding: 'parentView.content'
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
    })


    tableContainerView: Em.ContainerView.extend(App.Collapsable,
      classNames: ['matches-table-container-inner']
      childViews: ['tableView']
      content: Em.computed.alias 'parentView.content'
      collapsed: yes
      toggleButtonTarget: Em.computed.alias 'parentView.headerView'
      tableItemViewClassBinding: 'parentView.tableItemViewClass'
      tableView: App.MatchesTableView.extend
        contentBinding: 'parentView.content.filteredContent'
        itemViewClassBinding: 'parentView.tableItemViewClass'
    )
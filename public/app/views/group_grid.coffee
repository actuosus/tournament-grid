###
 * group_grid
 * @author: actuosus
 * Date: 31/03/2013
 * Time: 18:45
###

define ['cs!./grid', 'cs!./standing_table', 'cs!./match/group_table_container'], ->
  App.GroupGridView = App.GridView.extend
    classNames: ['lineup-grid', 'group-lineup-grid']

    itemViewClass: Em.ContainerView.extend
      classNames: ['lineup-grid-item']
      childViews: ['contentView', 'matchesView']

      contentView: Em.ContainerView.extend
        contentBinding: 'parentView.content'
        classNames: ['lineup-grid-item-name-container']
        childViews: ['nameView', 'removeButtonView']

        nameView: Em.View.extend
          contentBinding: 'parentView.content'
          classNames: ['lineup-grid-item-name']
          template: Em.Handlebars.compile '{{view.content.name}}'

        removeButtonView: Em.View.extend
          tagName: 'button'
          contentBinding: 'parentView.content'
          isVisibleBinding: 'App.isEditingMode'
          classNames: ['btn-clean', 'remove-btn', 'remove']
          attributeBindings: ['title']
          title: '_remove'.loc()
          template: Em.Handlebars.compile '×'

          click: -> @get('content').deleteRecord()

      matchesView: App.StangingTableView.extend(App.Collapsable,
        childViews: ['stadingsView', 'contentView', 'toggleButtonView']
        appendableViewBinding: 'contentView'
        entrantsBinding: 'parentView.content.entrants'
        matchesBinding: 'parentView.content.matches'
        contentBinding: 'parentView.content.matches'
        collapsed: yes
        contentView: App.MatchesGroupTableContainerView.extend
          contentBinding: 'parentView.matches'
      )
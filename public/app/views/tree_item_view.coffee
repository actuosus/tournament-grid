###
 * tree_item_view
 * @author: actuosus
 * Date: 23/03/2013
 * Time: 04:10
###

define ->
  App.TreeItemView = Em.ContainerView.extend
    classNames: ['tree-item']
    childViews: ['nestedTreeView']

    nestedTreeView: (->
      App.TreeView.extend
        classNames: ['tree-nested']
        isVisible: Em.computed.bool('parentView.isExpanded'), # Ember isVisible handling considers undefined to be visible
#        allowSelection: @getPath('parentView.rootTreeView.allowSelection'),
#        allowReordering: @getPath('parentView.rootTreeView.allowReordering'),
        content: @get 'content.treeItemChildren'
        itemViewClass: @get 'parentView.rootTreeView.itemViewClass'
        isNested: yes
    ).property('content')

    treeItemViewClass: (->
      Em.View.extend
        classNames: ['tree-item-view-content'],
        contentIndexBinding: 'parentView.contentIndex',
        handlebars: (->
          return @get('parentView.parentView.rootTreeView').handlebarsForItem(@get('content'));
        ).property('content').cacheable()
    ).property()
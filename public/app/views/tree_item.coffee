###
 * tree_item_view
 * @author: actuosus
 * Date: 23/03/2013
 * Time: 04:10
###

define ['cs!../core'], ->
  App.TreeItemView = Em.ContainerView.extend
    classNames: ['tree-item']
    childViews: ['treeItemViewClass']

    init: ->
      @_super()
      childViews = @get 'childViews'
      if childViews and @get('isExpanded') and @get('hasChildren')
        childViews.pushObject @get('nestedTreeView').create()

    isExpanded: ((key, value)->
      if arguments.length is 1
        return @_isExpanded if this._isExpanded isnt undefined
        return @get('content.treeItemIsExpanded') or @get('defaultIsExpanded')
      else
        @_isExpanded = value
        value
    ).property('content.treeItemIsExpanded', 'defaultIsExpanded').cacheable()

    isExpandedChanged: (->
      childViews = @get 'childViews'
      if childViews.length is 1
        if childViews and @get('isExpanded') and @get('hasChildren')
          childViews.pushObject @get('nestedTreeView').create()
    ).observes('isExpanded')

    hasChildren: (->
      not Ember.isNone @get 'content.treeItemChildren'
    ).property 'content.treeItemChildren'

    mouseUp: (event)->
      event.stopPropagation()
      @toggleProperty 'isExpanded'

    nestedTreeView: (->
      content = @get 'content'
      if @get 'hasChildren'
        App.TreeView.extend
          classNames: ['tree-nested']
          isVisible: Em.computed.bool('parentView.isExpanded'), # Ember isVisible handling considers undefined to be visible
  #        allowSelection: @getPath('parentView.rootTreeView.allowSelection'),
  #        allowReordering: @getPath('parentView.rootTreeView.allowReordering'),
          content: @get 'content.treeItemChildren'
          itemViewClass: @get 'parentView.rootTreeView.itemViewClass'
          isNested: yes
      else
        Em.View.extend()
#      else
#        treeItemViewClass = @get 'treeItemViewClass'
#        treeItemViewClass.create({'content', content})
    ).property('content')

    treeItemViewClass: (->
      Em.View.extend
        classNames: ['tree-item-view-content'],
        contentBinding: 'parentView.content'
        contentIndexBinding: 'parentView.contentIndex',
        nameChanged: (-> @rerender() ).observes('content.name')
        render: (_)-> _.push @get 'content.name'
    ).property()
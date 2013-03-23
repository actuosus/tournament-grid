###
 * tree_view
 * @author: actuosus
 * Date: 23/03/2013
 * Time: 04:09
###

define ['cs!views/tree_item_view'], ->
  App.TreeView = Em.CollectionView.extend
    classNames: ['tree']

    itemViewClass: App.TreeItemView

    isNested: no

    nestingLevel: (->
      'level-%@'.fmt(this.getPath('treeLevel'))
    ).property('treeLevel')

    treeLevel: (->
      (@getPath('parentTreeView.treeLevel') || 0) + 1
    ).property('parentTreeView.treeLevel')

    parentTreeView: (->
      if @get('isNested') then @getPath('parentView.parentView') else undefined
    ).property('isNested', 'parentView.parentView')

    rootTreeView: (->
      @getPath('parentTreeView.rootTreeView') || @
    ).property('parentTreeView.rootTreeView')
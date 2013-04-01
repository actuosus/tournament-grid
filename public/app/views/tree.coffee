###
 * tree
 * @author: actuosus
 * Date: 23/03/2013
 * Time: 04:09
###

define [
  'cs!../core'
  'cs!./tree_item'
], ->
  App.TreeView = Em.CollectionView.extend
    classNames: ['tree']

    itemViewClass: App.TreeItemView

    isNested: no

    nestingLevel: (->
      'level-%@'.fmt(@get('treeLevel'))
    ).property('treeLevel')

    treeLevel: (->
      (@get('parentTreeView.treeLevel') || 0) + 1
    ).property('parentTreeView.treeLevel')

    parentTreeView: (->
      if @get('isNested') then @get('parentView.parentView') else undefined
    ).property('isNested', 'parentView.parentView')

    rootTreeView: (->
      @get('parentTreeView.rootTreeView') || @
    ).property('parentTreeView.rootTreeView')
###
 * grid
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 07:41
###

define ['cs!../core'],->
  App.GridView = Em.CollectionView.extend
#    templateName: 'grid'
    classNames: ['grid']

#    reorderDelegate: null

    emptyView: App.EmptyView

#    didReorderContent: (content)->
#      delegate = @get 'reorderDelegate'
#      if delegate
#        Ember.run.next ->
#          delegate.didReorderContent content
#
#    isValidDrop: (itemDragged, newParent, dropTarget)->
#      delegate = @get 'reorderDelegate'
#      if delegate and delegate.isValidDrop
#        delegate.isValidDrop(itemDragged, newParent, dropTarget)
#      else
#        return yes
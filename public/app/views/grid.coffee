###
 * grid
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 07:41
###

define ->
  App.GridView = Em.CollectionView.extend
    templateName: 'grid'
    classNames: ['grid']

    # Isotope
#    didInsertElement: ->
#      @$().isotope({masonry: {columnWidth: 114}})
#
#    arrayDidChange: (content, start, removed, added)->
#      @_super content, start, removed, added
#      itemViewClass = this.get('itemViewClass')
#      childViews = this.get('childViews')
#      addedViews = []
#      len = if content then content.get('length') else 0
#      if len
#        idx = start-1
#        addedItems = while ++idx < start+added
#          childViews[idx]
#        setTimeout (=>
#          $items = $(addedItems.map (item)-> item.get('element'))
#          @$().isotope('insert', $items)
#        ), 50
#
#    arrayWillChange: (content, start, removedCount)->
#      childViews = @get('childViews')
#      len = childViews.get('length')
#      removingAll = removedCount is len
#
#      idx = start + removedCount
#      removedItems = while --idx >= start
#        childViews[idx]
#
#      $items = $(removedItems.map (item)-> item.get('element'))
#
#      if @.state isnt 'preRender'
#        this.$().isotope 'remove', $items, =>

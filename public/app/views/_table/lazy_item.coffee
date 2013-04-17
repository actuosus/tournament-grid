###
 * lazy_item
 * @author: actuosus
 * Date: 16/04/2013
 * Time: 22:29
###

define ->
  App.LazyItemView = Ember.View.extend
    itemIndex: null
    prepareContent: Ember.K
    teardownContent: Ember.K
    rowHeightBinding: 'parentView.rowHeight'

    top: Ember.computed ->
      @get('itemIndex') * @get('rowHeight')
    .property 'itemIndex', 'rowHeight'

    isVisible: Ember.computed ->
      no if not @get 'content'
    .property 'content'
###
 * row
 * @author: actuosus
 * Date: 16/04/2013
 * Time: 21:28
###

define [
  'ember'
  'cs!./lazy_item'
  'cs!./cell'
], ()->
  App.TableRowView = Ember.CollectionView.extend
    tagName: 'tr'
    classNames: ['table-row']
    row:      Ember.computed.alias 'content'
    columns:  Ember.computed.alias 'parentView.columns'
    contentBinding:  'columns'
    itemViewClass: 'App.TableCellView'
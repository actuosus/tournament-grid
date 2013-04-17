###
 * row
 * @author: actuosus
 * Date: 16/04/2013
 * Time: 21:28
###

define [
  'ember'
  'cs!./cell'
], ()->
  App.TableHeaderRowView = Ember.CollectionView.extend
    tagName: 'tr'
    classNames: ['table-header-row']
    itemViewClass: 'App.TableHeaderCellView'
    columns: Ember.computed.alias 'content'
###
 * header
 * @author: actuosus
 * Date: 16/04/2013
 * Time: 21:44
###

define [
  'ember'
  'cs!./header/row'
], (Ember)->
  App.TableHeaderContainerView = Ember.CollectionView.extend
    tagName: 'table'
    classNames: ['table-header']
    columnsBinding: 'controller.columns'
    content: Ember.computed ->
      [@get('columns')]
    .property 'columns'
    itemViewClass: 'App.TableHeaderRowView'
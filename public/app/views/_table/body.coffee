###
 * body
 * @author: actuosus
 * Date: 16/04/2013
 * Time: 21:44
###

define [
  'ember'
], (Ember)->
  App.TableBodyContainerView = Ember.CollectionView.extend
    tagName: 'table'
    classNames: ['table-body']
    columnsBinding: 'controller.tableColumns'
#    content: null
    contentBinding: 'controller.bodyContent'
    itemViewClass:  Ember.computed.alias 'controller.tableRowViewClass'
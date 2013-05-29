###
 * group_table
 * @author: actuosus
 * Date: 31/03/2013
 * Time: 17:50
###

define [
  'cs!./group_table_item'
  'cs!../../core'
  'cs!../number'
], ->
  App.MatchesGroupTableView = Em.CollectionView.extend
    tagName: 'table'
    classNames: ['matches-group-table', 'table']

    itemViewClass: App.MatchGroupTableItemView
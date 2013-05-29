###
 * matches_table
 * @author: actuosus
 * @fileOverview
 * Date: 28/01/2013
 * Time: 22:24
###

define [
  'cs!./group_table_item'
  'cs!./table_item'
],->
  App.MatchesTableView = Em.CollectionView.extend
    tagName: 'table'
    classNames: ['matches-table', 'table']

    itemViewClass: App.MatchTableItemView
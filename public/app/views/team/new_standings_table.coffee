###
 * new_standings_table
 * @author: actuosus
 * Date: 16/04/2013
 * Time: 19:16
###

define ['cs!../table/main'],->
  App.StangingTableController = Ember.Table.TableController.extend
    hasHeader: yes
    hasFooter: no
    numFixedColumns: 0
    numRows: 100000
    rowHeight: 30

    columnNames: Ember.computed ->
      ['position', 'team.name', 'matchesPlayed', 'wins', 'draws', 'lossed', 'points', 'difference']
    .property()

    columns: Ember.computed ->
      @get('columnNames').map (key, index) ->
        Ember.Table.ColumnDefinition.create
          index: index
          columnWidth: 100
          headerCellName: key
          contentPath: key
    .property()

#    content: Ember.computed ->
#      App.LazyDataSource.create
#        content: new Array(@get('numRows'))
#    .property 'numRows'

  App.NewTeamStandingsTableView = Ember.Table.TablesContainer.extend
    controller: Ember.computed ->
      App.StangingTableController.create content: @get 'content'
    .property()
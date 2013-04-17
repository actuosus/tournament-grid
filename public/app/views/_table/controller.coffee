###
 * controller
 * @author: actuosus
 * Date: 16/04/2013
 * Time: 22:03
###

define [
  'ember'
  'cs!./row'
], ()->
  App.TableRow = Ember.ObjectProxy.extend
    content:  null
    isHovering: no
    isSelected: no
    isShowing:  yes
    isActive:   no
  App.RowArrayProxy = Ember.ArrayProxy.extend
    tableRowClass: null
    content: null
    rowContent: Ember.computed( -> []).property()
    objectAt: (idx) ->
      row = @get('rowContent')[idx]
      return row if row
      tableRowClass = @get 'tableRowClass'
      item  = @get('content').objectAt(idx)
      row   = tableRowClass.create content: item
      @get('rowContent')[idx] = row
      row
  App.TableController = Ember.Controller.extend
    columns: null
    tableRowViewClass: 'App.TableRowView'
    bodyContent: Ember.computed ->
      App.RowArrayProxy.create
        tableRowClass: App.TableRow
        content: @get('content')
    .property 'content'
    prepareTableColumns: Ember.observer (tableColumns)->
      # Some maintenance on the columns for percent resizing
      columns = if Ember.isArray(tableColumns) then tableColumns else @get("tableColumns")
      for col, i in columns
        col.set("_nextColumn", columns.objectAt(i + 1))
        col.set("controller", this)
    , "tableColumns.@each", "tableColumns"
    tableColumns: Ember.computed ->
      columns         = @get 'columns'
      return Ember.A() unless columns
      @prepareTableColumns columns
      columns
    .property 'columns.@each'
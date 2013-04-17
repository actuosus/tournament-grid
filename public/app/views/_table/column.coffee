###
 * column
 * @author: actuosus
 * Date: 16/04/2013
 * Time: 22:20
###

define ->
  App.TableColumn = Ember.Object.extend
    identifier: null
    width: 100
    getCellContent: (row) ->
      identifier = @get 'identifier'
      Ember.assert "You must either provide a identifier or override " +
      "getCellContent in your column definition", identifier
      Ember.get row, identifier
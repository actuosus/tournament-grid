###
 * team_standings_table
 * @author: actuosus
 * Date: 28/01/2013
 * Time: 22:13
###

define [
  'text!../../templates/team/standings_table.handlebars'
  'cs!../../core'
  'cs!./standings_table_item'
  'cs!../match/table_popup'
], (template)->
  Em.TEMPLATES.teamStandingsTable = Em.Handlebars.compile template
  App.TeamStandingsTableView = Em.View.extend App.ContextMenuSupport,
    tagName: 'table'
    templateName: 'teamStandingsTable'
    classNames: ['team-standings-table', 'table']

    shouldShowContextMenuBinding: 'App.isEditingMode'
    contextMenuActions: ['addEntrant']

    addEntrant: ->
      @get('content.content').createRecord()

    showSorterOnColumn: (element)->
      @sorter = App.TableSorterView.create()
      console.log(@sorter)
      $(element).append(@sorter.createElement().get('element'))

    click: (event)->
      if $(event.target).hasClass('header-item-position')
        if @content.get('sortProperties').contains('position')
          @content.set('sortAscending', !@content.get('sortAscending'))
        else
          @content.set('sortProperties', ['position'])
      if $(event.target).hasClass('header-item-name')
        if @content.get('sortProperties').contains('entrant.name')
          @content.set('sortAscending', !@content.get('sortAscending'))
        else
          @content.set('sortProperties', ['entrant.name'])
      if $(event.target).hasClass('header-item-matches-played')
        if @content.get('sortProperties').contains('matchesPlayed')
          @content.set('sortAscending', !@content.get('sortAscending'))
        else
          @content.set('sortProperties', ['matchesPlayed'])
      if $(event.target).hasClass('header-item-wins')
        if @content.get('sortProperties').contains('wins')
          @content.set('sortAscending', !@content.get('sortAscending'))
        else
          @content.set('sortProperties', ['wins'])
      if $(event.target).hasClass('header-item-draws')
        if @content.get('sortProperties').contains('draws')
          @content.set('sortAscending', !@content.get('sortAscending'))
        else
          @content.set('sortProperties', ['draws'])
      if $(event.target).hasClass('header-item-losses')
        if @content.get('sortProperties').contains('losses')
          @content.set('sortAscending', !@content.get('sortAscending'))
        else
          @content.set('sortProperties', ['losses'])
      if $(event.target).hasClass('header-item-points')
        if @content.get('sortProperties').contains('points')
          @content.set('sortAscending', !@content.get('sortAscending'))
        else
          @content.set('sortProperties', ['points'])
      if $(event.target).hasClass('header-item-difference')
        if @content.get('sortProperties').contains('difference')
          @content.set('sortAscending', !@content.get('sortAscending'))
        else
          @content.set('sortProperties', ['difference'])

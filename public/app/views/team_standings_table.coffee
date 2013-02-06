###
 * team_standings_table
 * @author: actuosus
 * @fileOverview 
 * Date: 28/01/2013
 * Time: 22:13
###

define [
  'text!templates/team_standings_table.handlebars'
], (template)->
  Em.TEMPLATES.teamStandingsTable = Em.Handlebars.compile template
  App.TeamStandingsTableView = Em.View.extend
    tagName: 'table'
    templateName: 'teamStandingsTable'
    classNames: ['team-standings-table', 'table']

    showSorterOnColumn: (element)->
      @sorter = App.TableSorterView.create()
      console.log(@sorter)
      $(element).append(@sorter.createElement().get('element'))

#    mouseEnter: (event)->
#      if $(event.target).hasClass('header-item')
#        @showSorterOnColumn(event.target)

    click: (event)->
#      if $(event.target).hasClass('header-item-number')
#        if @content.get('sortProperties').contains('name')
#          @content.set('sortAscending', !@content.get('sortAscending'))
#        else
#          @content.set('sortProperties', ['name'])
      if $(event.target).hasClass('header-item-name')
        if @content.get('sortProperties').contains('name')
          @content.set('sortAscending', !@content.get('sortAscending'))
        else
          @content.set('sortProperties', ['name'])
      if $(event.target).hasClass('header-item-games-played')
        if @content.get('sortProperties').contains('gamesPlayed')
          @content.set('sortAscending', !@content.get('sortAscending'))
        else
          @content.set('sortProperties', ['gamesPlayed'])
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
      if $(event.target).hasClass('header-item-loses')
        if @content.get('sortProperties').contains('loses')
          @content.set('sortAscending', !@content.get('sortAscending'))
        else
          @content.set('sortProperties', ['loses'])

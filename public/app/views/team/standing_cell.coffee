###
 * standing_cell
 * @author: actuosus
 * Date: 03/06/2013
 * Time: 16:35
###

define [
  'cs!./cell'
],->
  App.TeamStandingCellView = App.TeamCellView.extend
    autocompleteView: App.TextField.extend
      isVisible: no
      isAutocomplete: yes

      autocompleteDelegate: (->
        console.debug @get 'container'
#        App.TeamsController.create()
        @get('container').lookup('controller:reportEntrants')
      ).property()

      assignTeam: (team)->
        @set 'parentView.content', team
        match = @get 'parentView.match'
        match.set "entrant#{@get('parentView.contentIndex')+1}", team if match

      insertNewline: ->
        @assignTeam @get 'selection'
        @_closeAutocompleteMenu()
        @set 'isVisible', no

      selectMenuItem: (team)->
        @assignTeam team
        @_closeAutocompleteMenu()
        @set 'isVisible', no

      focusOut: -> @set 'isVisible', no
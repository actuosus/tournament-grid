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
    autocompleteView: App.AutocompleteTextField.extend
      isVisible: no
      controllerBinding: 'App.reportTeamsController'

      filteredContent: (->
        content = @get 'content'
        entrants = @get 'parentView.match.round.stage.entrants'
        if entrants
          content.filter (item)-> not entrants.contains item
        else
          content
      ).property().volatile()

      contentFilter: (content)->
        return unless content
        entrants = @get 'parentView.match.round.stage.entrants'
        if entrants
          @set 'content', content.filter (item)->
            not entrants.contains item

      selectionChanged: (->
#        oldTeam = @get 'parentView.content'
        newTeam = @get 'selection'
        teamRef = App.get('report.teamRefs').find (item)-> Em.isEqual(item.get('team'), newTeam)

        @set 'parentView.content', teamRef
        @notifyPropertyChange('parentView.content')

        @set('isVisible', no)
      ).observes('selection')

      hasFocusChanged: (->
        unless @get 'hasFocus'
          @set('isVisible', no)
        else
          @set('isVisible', yes)
      ).observes('hasFocus')

      insertNewline: ->
        popup = @showAddForm(@)
        popup.onShow = =>
          popup.get('formView')?.focus()
        popup.onHide = =>
          @focus()
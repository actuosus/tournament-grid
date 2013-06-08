###
 * lineup_container
 * @author: actuosus
 * Date: 01/04/2013
 * Time: 07:09
###

define [
  'cs!../core'
  'cs!./named_container'
  'cs!./autocomplete_text_field'
  'cs!./lineup'
], ->
  App.LineupContainerView = App.NamedContainerView.extend App.Editing,
    title: '_the_teams'.loc()
    description: '_the_teams_that_participate_in_the_report'.loc()
    childViews: ['titleView', 'toggleButtonView', 'contentView']
    editingChildViews: ['toolbarView']
    _isEditingBinding: 'App.isEditingMode'

    toolbarView: Em.ContainerView.extend
      childViews: ['searchBarView', 'autocompleteTextFieldView']

      searchBarView: Em.ContainerView.extend
        classNames: ['search-bar']
        childViews: ['textFieldView', 'clearButtonView']
        isVisibleBinding: 'App.isEditingMode'
        clearButtonView: Em.View.extend
          tagName: 'button'
          isVisibleBinding: 'parentView.textFieldView.isNotClearValue'
          classNames: ['btn-clean', 'remove-btn', 'remove']
          attributeBindings: ['title']
          title: '_remove'.loc()
          template: Em.Handlebars.compile '×'

          click: -> @set('parentView.textFieldView.value', '')

        textFieldView: Em.TextField.extend
          classNames: ['search-field']
          placeholder: '_filter'.loc()
          keyUp: (event)->
            switch event.keyCode
              when 27 then @set 'value', ''
          isNotClearValue: (-> !!@get('value')).property('value')
          valueChanged: (->
            if @get 'value'
              @set 'isNotClearValue', yes
            else
              @$().val('')
              @$().focus()
              @set 'isNotClearValue', no
            @set('parentView.parentView.parentView.contentView.controller.searchQuery', @get 'value')
          ).observes('value')

      autocompleteTextFieldView: App.EntrantTextField.extend
        classNames: ['add-team-field']
        isAutocomplete: yes
        autocompleteDelegate: (->
          App.TeamsController.create()
        ).property()

        attributeBindings: ['title']
        title: '_enter_team_name_to_filter_the_teams_and_search_for_team_to_add'.loc()
        placeholder: '_team_name'.loc()

        addTeam: (team)->
          report = App.get('report')

          if App.Team.detectInstance(team) and report
            teamRefs = report.get('teamRefs')
            entrants = teamRefs.map (ref)-> ref.get('team')
            return if entrants.contains team
            teamRef = teamRefs.createRecord team: team
            team.get('players').on 'didLoad', ->
              team.get('players').forEach (player)->
                teamRef.get('players').addObject player
              teamRef.store.commit()
            team.get('players').fetch()
            teamRef.store.commit()

        insertNewline: ->
          @addTeam @get 'selection'

        selectMenuItem: (team)->
          @addTeam team


#      _autocompleteTextFieldView: App.AutocompleteTextField.extend
#        classNames: ['add-team-field']
#        placeholder: '_team_name'.loc()
#  #      controllerBinding: 'App.teamsController'
#        controller: (->
#          App.MergedEntrantsController.create({
#            sources: [
#              App.TeamsController.create(),
#              App.EntrantsController.create({
#                contentBinding: 'App.report.teamRefs'
#                arrangedContent: Em.ArrayProxy.create(type: App.TeamRef, content: [])
#              })
#            ]
#          })
#        ).property()
#        attributeBindings: ['title']
#        title: '_enter_team_name_to_filter_the_teams_and_search_for_team_to_add'.loc()
#
#        filteredContent: (->
#          content = @get 'content'
#          entrants = App.get 'report.teamRefs'
#          teams = entrants.map (item)-> item.get('team')
#          content?.filter (item)-> App.TeamRef.detectInstance(item) or not teams.contains item
#        ).property('content.isLoaded', 'content.length', 'App.report.teamRefs.content.length')
#
#  #      textValueChanged: (->
#  #        @set('parentView.contentView.controller.searchQuery', @get 'textFieldView.value')
#  #      ).observes('textFieldView.value')
#
#        showAddForm: (target)->
#          autocomplete = @
#          team = @get 'parentView.content'
#          popup = App.PopupView.create target: target
#          formView = @get 'controller.formView'
#          form = formView.create
#            value: @get('textFieldView').$().val()
#            popupView: popup
#            didCreate: (entrant)=>
#              report = App.get('report')
#              teamRef = report.get('teamRefs').createRecord
#                team: entrant
#                report: report
#
#  #            App.store.commit()
#              Em.run.later ->
#                teamRef.store.commit()
#              , 2000
#              popup.hide()
#          popup.set 'formView', form
#          popup.set 'contentView', form
#          popup.pushObject form
#          popup.append()
#
#  #      insertNewline: ->
#  #        player = @get 'value'
#  #        unless player
#  #          @showAddForm(@)
#
#        valueChanged: (->
#          team = @get 'value'
#          report = App.get('report')
#
#          if App.Team.detectInstance(team) and report
#            teamRefs = report.get('teamRefs')
#            entrants = teamRefs.map (ref)-> ref.get('team')
#            return if entrants.contains team
#            teamRef = teamRefs.createRecord team: team
#            team.get('players').on 'didLoad', ->
#              team.get('players').forEach (player)->
#                teamRef.get('players').addObject player
#              teamRef.store.commit()
#            team.get('players').fetch()
#            teamRef.store.commit()
#
#            @set 'textFieldView.value', ''
#            @get('textFieldView').$().val('')
#  #          team.set 'report', report
#  #          team.store.commit()
#        ).observes('value')

    contentView: App.LineupView.extend
      contentBinding: 'parentView.controller'
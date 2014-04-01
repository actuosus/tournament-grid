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
          type: 'search'
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
            teamRef.on 'didCreate', ->
              players = teamRef.get('players')
              team.get('players').on 'didLoad', ->
                team.get('players').forEach (player)->
                  player.set 'teamRef', teamRef
                  player.save()
                  players.addObject player
#              teamRef.save()
              if team.get('players.isLoaded')
                team.get('players').forEach (player)->
                  Em.run.later ->
                    player.set 'teamRef', teamRef
                    player.save()
                    players.addObject player
                  , 1000
              players.fetch()
            teamRef.save()

        insertNewline: ->
          @addTeam @get 'selection'

        selectMenuItem: (team)->
          @addTeam team

        showAddForm: (target)->
          popup = App.PopupView.create target: target
          formView = @get 'autocompleteDelegate.formView'
          form = formView.create
            value: @get('textFieldView').$().val()
            popupView: popup
            didCreate: (entrant)=>
              report = App.get('report')
              teamRef = report.get('teamRefs').createRecord
                team: entrant
                report: report
              Em.run.later ->
                teamRef.store.commit()
              , 2000
              popup.hide()
          popup.set 'formView', form
          popup.set 'contentView', form
          popup.pushObject form
          popup.appendTo App.get 'rootElement'

    contentView: App.LineupView.extend
      contentBinding: 'parentView.controller'
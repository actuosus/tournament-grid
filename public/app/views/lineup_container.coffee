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
], ->
  App.LineupContainerView = App.NamedContainerView.extend
    title: '_the_teams'.loc()
    description: '_the_teams_that_participate_in_the_report'.loc()
    childViews: [
      'titleView', 'toggleButtonView', 'contentView',
      'loaderView', 'statusTextView', 'searchBarView',
      'autocompleteTextFieldView'
    ]
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
          @set('parentView.parentView.contentView.controller.searchQuery', @get 'value')
        ).observes('value')

    addEntrantButtonView: Em.View.extend
      tagName: 'button'
      classNames: ['btn-clean', 'add-btn', 'add', 'add-team-btn']
      template: Em.Handlebars.compile '+'
      isVisibleBinding: 'App.isEditingMode'

      click: ->
        team = App.Team.createRecord()
        report = App.get('report')
        team.set 'name', @$('.name').val()
        team.set 'report', report

    autocompleteTextFieldView: App.AutocompleteTextField.extend
      classNames: ['add-team-field']
      placeholder: '_team_name'.loc()
      controller: (->
        App.MergedEntrantsController.create({
          sources: [
#            App.teamsController,
            App.EntrantsController.create({
              contentBinding: 'App.report.teamRefs'})
          ]
        })
      ).property()
      isVisibleBinding: 'App.isEditingMode'
      attributeBindings: ['title']
      title: '_enter_team_name_to_filter_the_teams_and_search_for_team_to_add'.loc()

#      filteredContent: (->
#        content = @get 'content'
#        entrants = App.get 'report.teamRefs'
#        teams = entrants.map (item)-> item.get('team')
#        content?.filter (item)-> not teams.contains item
#      ).property().volatile()

#      textValueChanged: (->
#        @set('parentView.contentView.controller.searchQuery', @get 'textFieldView.value')
#      ).observes('textFieldView.value')

      showAddForm: (target)->
        autocomplete = @
        team = @get 'parentView.content'
        popup = App.PopupView.create target: target
        formView = @get 'controller.formView'
        form = formView.create
          value: @get('textFieldView').$().val()
          popupView: popup
          didCreate: (entrant)=>
            report = App.get('report')
            report.get('teamRefs').createRecord
              team: entrant
              report: report
#            App.store.commit()
            popup.hide()
        popup.set 'formView', form
        popup.set 'contentView', form
        popup.get('childViews').push form
        popup.append()

      insertNewline: ->
        player = @get 'value'
        unless player
          @showAddForm(@)

      valueChanged: (->
        team = @get 'value'
        report = App.get('report')
        if team and report
          teamRef = report.get('teamRefs').createRecord({team: team})
          teamRef.store.commit()
          @set 'textFieldView.value', ''
          @get('textFieldView').$().val('')
#          team.set 'report', report
#          team.store.commit()
      ).observes('value')
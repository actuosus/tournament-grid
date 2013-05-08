###
 * lineup_grid_item
 * @author: actuosus
 * Date: 22/03/2013
 * Time: 21:19
###

define [
  'cs!../../mixins/moving_highlight'
  'cs!../autocomplete_text_field'
  'cs!../editable_label'
  'cs!../player/lineup_grid_item'
  'cs!../remove_button'
  'cs!./ask_move_form'
], ->
  App.TeamLineupGridItem = Em.ContainerView.extend
    classNames: ['lineup-grid-item', 'team-lineup-grid-item']
    classNameBindings: ['content.isDirty']
    childViews: ['teamNameView', 'playersView', 'addPlayerView']

    teamNameView: Em.ContainerView.extend(App.MovingHightlight,
      contentBinding: 'parentView.content.team'
      classNames: ['lineup-grid-item-name-container']
      childViews: ['countryFlagView', 'nameView', 'autocompleteTextFieldView', 'removeButtonView']#'editButtonView',

      countryFlagView: Em.View.extend
        tagName: 'i'
        classNames: ['country-flag-icon', 'team-country-flag-icon']
        classNameBindings: ['countryFlagClassName', 'hasFlag']
        attributeBindings: ['title']
        title: (-> @get 'content.country.name').property('content.country')
        contentBinding: 'parentView.content'
        hasFlag: (-> !!@get 'content.country.code').property('content.country')
        countryFlagClassName: (->
          'country-flag-icon-%@'.fmt @get 'content.country.code'
        ).property('content.country.code')

      nameView: Em.View.extend
        contentBinding: 'parentView.content'
        classNames: ['lineup-grid-item-name']
        href: (->
          '/teams/%@'.fmt @get 'content.id'
        ).property('content')
        attributeBindings: ['title']
        title: (->
          @get('content.id') if App.get('isEditingMode')
        ).property('App.isEditingMode')
        template: Em.Handlebars.compile '<a {{bindAttr href="view.href"}}>{{view.content.name}}</a>'

      autocompleteTextFieldView: App.AutocompleteTextField.extend
        placeholder: '_team_name'.loc()
        controllerBinding: 'App.teamsController'
        isVisibleBinding: 'parentView.content.isNew'

        showAddForm: (target)->
          autocomplete = @
          team = @get 'parentView.content'
          popup = App.PopupView.create target: target
          formView = @get 'controller.formView'
          form = formView.create
            value: @get('textFieldView').$().val()
            popupView: popup
            entrant: @get('entrant')
            createRecord: ->
              country = @get 'countrySelectView.value'
              report = App.get('report')
              team.set 'country', country
              team.set 'name', @$('.name').val()
              team.set 'report', report
              team.on 'didCreate', => @didCreate team
              team.on 'becameError', =>
                console.log arguments
              team.store.commit()
            didCreate: (entrant)=>
              @set('selection', entrant)
              autocomplete.set 'parentView.content', entrant
              popup.hide()
          popup.set 'formView', form
          popup.set 'contentView', form
          popup.get('childViews').push form
          popup.append()

        valueChanged: (->
          report = App.get('report')
          @set 'parentView.content', App.TeamRef.createRecord({team: @get('value'), report: report})
        ).observes('value')

      editButtonView: Em.View.extend
        tagName: 'button'
        contentBinding: 'parentView.content'
        isVisibleBinding: 'App.isEditingMode'
        classNames: ['btn-clean', 'edit-btn', 'edit']
        attributeBindings: ['title']
        title: '_edit'.loc()
        template: Em.Handlebars.compile '✎'

        click: ->
          popup = App.PopupView.create target: @
          popup.get('childViews').push(
            App.TeamForm.create
              popupView: popup
              nameBinding: 'parentView.entrant.name'
              entrant: @get('parentView.entrant')
              didUpdate: (entrant)=> popup.hide()
          )
          popup.append()

      deleteRecord: ->
        team = @get 'content'
        teamRef = App.get('report').get('teamRefs').find (tr)->
          Em.isEqual tr.get('team'), team

        teamRef?.deleteRecord()
        teamRef?.store.commit()

      removeButtonView: App.RemoveButtonView.extend
        title: '_remove_team'.loc()
        remove: -> @get('parentView').deleteRecord()

    )
    playersView: Em.CollectionView.extend
      classNames: ['lineup-grid-item-players']
      teamRefBinding: 'parentView.content'
      contentBinding: 'parentView.content.players'

      itemViewClass: App.PlayerLineupGridItemView

    addPlayerView: Em.ContainerView.extend
      classNames: ['lineup-grid-item-player-row']
      childViews: ['contentView']
      isVisibleBinding: 'App.isEditingMode'

      contentView: App.AutocompleteTextField.extend
        controllerBinding: 'App.playersController'
        teamRefBinding: 'parentView.parentView.content'
        entrantBinding: 'parentView.parentView.content'

        filteredContent: (->
          content = @get 'content'
          entrants = @get 'teamRef.players'
          content?.filter (item)-> not entrants.contains item
        ).property().volatile()

        addPlayer: (player)->
          report = App.get('report')
          reportPlayers = report.get 'players'
          teamRef = @get('teamRef')
          players = teamRef.get('players')

          # Moving existing player
          if reportPlayers.contains player
            console.log '_move_player_to_from'.loc player.get('nickname'), player.get('teamRef.team.name'), teamRef.get('team.name')
            modalView = App.ModalView.create
              target: @get 'parentView.parentView'
            askMoveForm = App.AskMoveForm.create
              description: '_move_player_to_from'.loc player.get('nickname'), player.get('teamRef.team.name'), teamRef.get('team.name')
            askMoveForm.on 'no', -> modalView.hide()
            askMoveForm.on 'yes', ->
              oldTeamRef = player.get('teamRef')
              oldTeamRef.get('players').removeObject(player)

              players.addObject player
              player.set 'teamRef', teamRef
              player.set 'report', report
              teamRef.store.commit()

              modalView.hide()
            modalView.get('childViews').push askMoveForm
            modalView.append()
            return

          players.addObject player
          player.set 'teamRef', teamRef

          teamRef.store.commit()

          @get('textFieldView')?.$().val('')

        insertNewline: ->
          player = @get 'value'
          unless player
            popup = @showAddForm(@)
            popup.onShow = => popup.get('formView')?.focus()
            popup.onHide = (player)=>
              @addPlayer player
              @focus()
          else
            @addPlayer player

        valueChanged: (->
          player = @get 'value'
          @addPlayer player if player
        ).observes('value')

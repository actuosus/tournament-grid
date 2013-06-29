###
 * lineup_grid_item
 * @author: actuosus
 * Date: 22/03/2013
 * Time: 21:19
###

define [
  'cs!../../mixins/moving_highlight'
  'cs!../autocomplete_text_field'
  'cs!../entrant_text_field'
  'cs!../editable_label'
  'cs!../player/lineup_grid_item'
  'cs!../remove_button'
  'cs!./ask_move_form'
], ->
  App.TeamLineupGridItem = Em.ContainerView.extend App.Editing, App.Droppable,
    classNames: ['lineup-grid-item', 'team-lineup-grid-item']
    classNameBindings: ['content.isDirty', 'content.isVisualySelected']
    childViews: ['teamNameView', 'playersView']
    editingChildViews: ['addPlayerView']

    _isEditingBinding: 'App.isEditingMode'

    drop: (event)->
      viewId = event.originalEvent.dataTransfer.getData 'Text'
      view = Em.View.views[viewId]

      teamRef = @get 'content'

      Em.run.next @, ->
        player = view.get('content')
        player.set 'teamRef', teamRef

      @_super event

    willInsertElement: ->
      $(@get 'element').css scale: 0

    didInsertElement: ->
      @$().transition scale: 1

    teamNameView: Em.ContainerView.extend(App.MovingHightlight, App.Editing, App.Draggable,
      contentBinding: 'parentView.content.team'
      classNames: ['lineup-grid-item-name-container']
      childViews: ['countryFlagView', 'nameView']

      _isEditingBinding: 'parentView._isEditing'
      isDraggableBinding: '_isEditing'

      editingChildViews: ['removeButtonView']

      countryFlagView: App.CountryFlagView.extend
        contentBinding: 'parentView.content.country'

      nameView: Em.View.extend
        contentBinding: 'parentView.content'
        classNames: ['lineup-grid-item-name']
        href: Em.computed.alias 'content.link'
        attributeBindings: ['title']
        title: (->
          @get('content.id') if App.get('isEditingMode')
        ).property('App.isEditingMode')
        template: Em.Handlebars.compile '<a target="_blank" {{bindAttr href="view.href"}}>{{view.content.name}}</a>'

        valueChanged: (->
          report = App.get('report')
          @set 'parentView.content', App.TeamRef.createRecord({team: @get('value'), report: report})
        ).observes('value')

      mouseEnter: ->
        @set 'publicMenuButtonView.isVisible', true

      mouseLeave: ->
        @set 'publicMenuButtonView.isVisible', no

      publicMenuButtonView: Em.View.extend
        tagName: 'button'
        isVisible: no
        classNames: ['btn-clean', 'public-menu-btn']
        template: Em.Handlebars.compile '⌄'

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
          popup.appendTo App.get 'rootElement'

      deleteRecord: ->
        team = @get 'content'
        teamRef = App.get('report').get('teamRefs').find (tr)->
          Em.isEqual tr.get('team'), team

        teamRef?.deleteRecord()
        teamRef?.store.commit()

      removeButtonView: App.RemoveButtonView.extend
        title: '_remove_team'.loc()
        deleteRecord: -> @get('parentView').deleteRecord()

    )
    playersView: Em.CollectionView.extend
      classNames: ['lineup-grid-item-players']
      teamRefBinding: 'parentView.content'
      contentBinding: 'parentView.content.players'

      itemViewClass: App.PlayerLineupGridItemView.extend(App.Draggable)

    addPlayerView: Em.ContainerView.extend
      classNames: ['lineup-grid-item-player-row']
      childViews: ['contentView']
      isVisibleBinding: 'App.isEditingMode'

      contentView: App.EntrantTextField.extend
        isAutocomplete: yes
        autocompleteDelegate: (->
          App.PlayersController.create()
        ).property()

        entrantBinding: 'parentView.parentView.content'
        teamRefBinding: 'parentView.parentView.content'

        insertNewline: ->
          player = @get 'selection'
          player.set 'teamRef', @get('teamRef')
          player.set 'report', App.get('report')
          player.store.commit()

          if not @_autocompleteMenu.isDestroyed
            @_autocompleteMenu.hide()

        selectMenuItem: (player)->
          player.set 'teamRef', @get('teamRef')
          player.set 'report', App.get('report')
          player.store.commit()


#      contentView: App.AutocompleteTextField.extend
#        controllerBinding: 'App.playersController'
#        teamRefBinding: 'parentView.parentView.content'
#        entrantBinding: 'parentView.parentView.content'
#        attributeBindings: 'title'
#        title: '_enter_player_name'.loc()
#        placeholder: '_player_nickname'.loc()
#
#        filteredContent: (->
#          content = @get 'content'
#          entrants = @get 'teamRef.players'
#          content?.filter (item)-> not entrants.contains item
#        ).property('content.length', 'teamRef.players.length', 'some')
#
#        addPlayer: (player)->
#          report = App.get('report')
#          reportPlayers = report.get 'players'
#          team = @get('teamRef.team')
#          teamRef = @get('teamRef')
#          players = @get('teamRef.players')
#
#          # Moving existing player
#          if reportPlayers.contains player
#            modalView = App.ModalView.create
#              classNames: ['team']
#              target: @get 'parentView.parentView'
#            askMoveForm = App.AskMoveForm.create
#              description: '_move_player_to_from'.loc player.get('nickname'), player.get('_teamRef.team.name'), teamRef.get('team.name')
#            askMoveForm.on 'no', -> modalView.hide()
#            askMoveForm.on 'yes', =>
#              oldTeamRef = player.get('_teamRef')
#              oldTeamRef.get('players').removeObject player
#
#              player.set 'teamRef', teamRef
#              player.set 'team', team
#              players.addObject player
#              teamRef.store.commit()
#              @notifyPropertyChange 'filteredContent'
#              @get 'filteredContent'
#
#              modalView.hide()
##            howIsTheCaptainForm = App.HowIsTheCaptainForm.create
##              content: [player]
#            modalView.pushObject askMoveForm
##            modalView.pushObject howIsTheCaptainForm
#            modalView.appendTo App.get 'rootElement'
#            return
#
#          player.set 'teamRef', teamRef
#          player.set 'team', team
#          players.addObject player
#          # TODO Should resolve captain.
##          teamRef.set('captain', player) if player.get 'isCaptain'
#          teamRef.store.commit()
#
#          @notifyPropertyChange 'filteredContent'
#
#          @get('textFieldView')?.$().val('')
#
#        insertNewline: ->
#          player = @get 'value'
#          unless player
#            popup = @showAddForm(@)
#            popup.onShow = => popup.get('formView')?.focus()
#            popup.onHide = (player)=>
#              if player
#                @addPlayer player
#                @focus()
#          else
#            @addPlayer player
#
#        valueChanged: (->
#          player = @get 'value'
#          @addPlayer player if player
#        ).observes('value')

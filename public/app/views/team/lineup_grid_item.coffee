###
 * lineup_grid_item
 * @author: actuosus
 * Date: 22/03/2013
 * Time: 21:19
###

define [
  'ehbs!linkedName'
  'cs!../../mixins/moving_highlight'
  'cs!../autocomplete_text_field'
  'cs!../entrant_text_field'
  'cs!../editable_label'
  'cs!../player/lineup_grid_item'
  'cs!../remove_button'
  'cs!./ask_move_form'
], ->
  App.TeamLineupGridItem = Em.ContainerView.extend App.Editing,
    classNames: ['lineup-grid-item', 'team-lineup-grid-item']
    classNameBindings: ['content.isDirty', 'content.isSaving', 'content.isVisualySelected']
    childViews: ['teamNameView', 'playersView']
    editingChildViews: ['addPlayerView']

    _isEditingBinding: 'App.isEditingMode'

#    drop: (event)->
#      viewId = event.originalEvent.dataTransfer.getData 'Text'
#      view = Em.View.views[viewId]
#
#      teamRef = @get 'content'
#
#      Em.run.next @, ->
#        player = view.get('content')
#        player.set 'teamRef', teamRef
#
#      @_super event

    willInsertElement: -> $(@get 'element').css scale: 0

    didInsertElement: -> @$().transition scale: 1

    teamNameView: Em.ContainerView.extend(App.MovingHightlight, App.Editing,
      teamRefsBinding: 'parentView.parentView.content'
      contentBinding: 'parentView.content.team'
      classNames: ['lineup-grid-item-name-container']
      childViews: ['countryFlagView', 'nameView']

      _isEditingBinding: 'parentView._isEditing'
#      isDraggableBinding: '_isEditing'

      editingChildViews: ['removeButtonView']

      countryFlagView: App.CountryFlagView.extend
        contentBinding: 'parentView.content.country'

      nameView: Em.View.extend
        contentBinding: 'parentView.content'
        classNames: ['lineup-grid-item-name']
        href: Em.computed.alias 'content.link'
        name: Em.computed.alias 'content.name'
        attributeBindings: ['title']
        title: (->
          if App.get('isEditingMode')
            @get('content.id')
          else
            @get('content.name')
        ).property('App.isEditingMode')

#        templateName: 'linkedName'

        render: (_)-> _.push ('<a target="_blank" href="' + @get('href') + '">' + @get('name') + '</a>')
        nameChanged: (-> @rerender() ).observes('name')

        valueChanged: (->
          report = App.get('report')
          @set 'parentView.content', App.TeamRef.createRecord({team: @get('value'), report: report})
        ).observes('value')

#      mouseEnter: ->
#        @set 'publicMenuButtonView.isVisible', true
#
#      mouseLeave: ->
#        @set 'publicMenuButtonView.isVisible', no
#
#      publicMenuButtonView: Em.View.extend
#        tagName: 'button'
#        isVisible: no
#        classNames: ['btn-clean', 'public-menu-btn']
#        render: (_)-> _.push '⌄'

      editButtonView: Em.View.extend
        tagName: 'button'
        contentBinding: 'parentView.content'
        isVisibleBinding: 'App.isEditingMode'
        classNames: ['btn-clean', 'edit-btn', 'edit']
        attributeBindings: ['title']
        title: '_edit'.loc()
        render: (_)-> _.push '✎'

        click: ->
          popup = App.PopupView.create target: @, parentView: @, container: @container
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

        @get('teamRefs')?.removeObject(teamRef) if teamRef
        teamRef?.deleteRecord()
        teamRef?.save()

      removeButtonView: App.RemoveButtonView.extend
        title: '_remove_team'.loc()
        deleteRecord: -> @get('parentView').deleteRecord()

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

      contentView: App.EntrantTextField.extend
        isAutocomplete: yes
        autocompleteDelegate: (->
          App.PlayersController.create()
        ).property()

        entrantBinding: 'parentView.parentView.content'
        teamRefBinding: 'parentView.parentView.content'

        insertNewline: ->
          player = @get 'selection'
          return unless player
          player.set 'teamRef', @get('teamRef')
          player.set 'report', App.get('report')
          player.save()
          player.store.flushPendingSave()

          if not @_autocompleteMenu.isDestroyed
            @_autocompleteMenu.hide()

        selectMenuItem: (player)->
          player.set 'teamRef', @get('teamRef')
          player.set 'report', App.get('report')
          player.save()
          player.store.flushPendingSave()
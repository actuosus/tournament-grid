###
 * item
 * @author: actuosus
 * Date: 23/05/2013
 * Time: 22:35
###

define [
  'cs!../game/info_bar'
  'cs!../team/grid_item_container'
], ->
  App.MatchItemView = Em.ContainerView.extend App.ContextMenuSupport,
    classNames: ['match-item']
    childViews: ['dateView', 'infoBarView', 'contentView']
    classNameBindings: ['content.isSelected','content.isVisualySelected', 'content.isDirty', 'content.isSaving', 'content.isPast', 'content.invalid']
    attributeBindings: ['title']
    titleBinding: 'content.description'

    shouldShowContextMenuBinding: 'App.isEditingMode'
    contextMenuActions: ['open', 'close', 'edit', 'save', 'deleteRecord:delete']

    open: -> @get('content').open()
    close: -> @get('content').close()
    save: -> @get('content.store').commit()
    edit: ->
      popup = App.PopupView.create target: @
      popup.pushObject(
        App.MatchForm.create
          popupView: popup
          match: @get('match')
          content: @get('match')
          title: @get 'match.title'
          description: @get 'match.description'
          didUpdate: => popup.hide()
      )
      popup.append()

    deleteRecord: -> @get('content').deleteRecord()

#    didInsertElement: ->
#      @$().css scale: 0
#      @$().transition scale: 1

    isEditable: (->
      isEditingMode = App.get('isEditingMode')
      status = @get 'content.status'
      currentStatus = @get 'content.currentStatus'
      isEditingMode and status is 'opened'
    ).property('App.isEditingMode', 'content.status', 'content.currentStatus')

    _isEditingBinding: 'App.isEditingMode'

    mouseEnter: ->
      @set 'editControlsView.isVisible', yes

      node = @get 'content'
      while node
        node.set('isSelected', yes)
        node = node.get('parentNode')

    mouseLeave: ->
      @set 'editControlsView.isVisible', no

      node = @get 'content'
      while node
        node.set('isSelected', no)
        node = node.get('parentNode')

    click: ->
      url = @get 'content.url'
      # Redirect to match URL
      document.location.href = url if url

    dateView: App.DateWithPopupView.extend
      classNames: ['match-start-date']
      contentBinding: 'parentView.content.date'
      format: 'DD.MM.YY'
      showPopupBinding: 'App.isEditingMode'

    infoBarView: App.GamesInfoBarView.extend
      contentBinding: 'parentView.content.games'
      showInfoLabel: yes
      classNames: ['match-info-bar']

    contentView: Em.CollectionView.extend
      classNames: ['match-grid-item-entrants']
      matchBinding: 'parentView.content'
      contentBinding: 'parentView.content.entrants'

      itemViewClass: App.TeamGridItemContainerView.extend( App.Droppable, {
        matchBinding: 'parentView.match'

#        dragOver: (event)->
#          viewId = event.originalEvent.dataTransfer.getData 'Text'
#          view = Em.View.views[viewId]
#          content = view.get 'content'
#          console.log App.Team.detectInstance content
#          event.preventDefault() if App.Team.detectInstance content

        drop: (event)->
          viewId = event.originalEvent.dataTransfer.getData 'Text'
          view = Em.View.views[viewId]
          team = view.get 'content'
          Em.run.next @, => @set 'content', team
          @_super event
      })

    editControlsView: Em.ContainerView.extend
      isVisible: no
      classNames: ['match-grid-item-edit-controls']
      childViews: ['closeButtonView', 'saveButtonView']#'removeButtonView',
      contentBinding: 'parentView.content'

      closeButtonView: Em.View.extend
        tagName: 'button'
        classNames: ['btn', 'btn-primary', 'btn-mini', 'close-btn', 'close']
        contentBinding: 'parentView.content'
        template: Em.Handlebars.compile '{{view.actionLabel}}'

        actionLabel: (->
          switch @get 'content.status'
            when 'closed'
              '_open'.loc()
            when 'opened'
              '_close'.loc()
        ).property('content.status')

        isVisible: (->
          isEditingMode = App.get 'isEditingMode'
          isOpenable = @get 'content.isOpenable'
          yes if isEditingMode and isOpenable
        ).property('App.isEditingMode', 'content.isDirty', 'content.isOpenable')

        click: ->
          match = @get 'content'
          switch @get 'content.status'
            when 'closed'
              match.open()
            when 'opened'
              match.close()

      saveButtonView: Em.View.extend
        tagName: 'button'
        classNames: ['btn', 'btn-primary', 'btn-mini', 'save-btn', 'save']
        template: Em.Handlebars.compile '{{loc "_save"}}'

        isVisible: (->
          isDirty = @get 'parentView.content.isDirty'
          if isDirty
            yes
          else
            no
        ).property('parentView.content.isDirty')

        click: ->
          match = @get 'parentView.content'
          transaction = match.get('transaction')
          transaction.commit() if transaction

      editButtonView: Em.View.extend
        tagName: 'button'
        contentBinding: 'parentView.content'
        isVisibleBinding: 'App.isEditingMode'
        classNames: ['btn-clean', 'edit-btn', 'edit']
        attributeBindings: ['title']
        title: '_edit'.loc()

        click: ->
          team = @get('content')
          team.deleteRecord()
          team.store.commit()

      removeButtonView: Em.View.extend
        tagName: 'button'
        contentBinding: 'parentView.content'
        isVisibleBinding: 'App.isEditingMode'
        classNames: ['btn-clean', 'remove-btn', 'remove']
        attributeBindings: ['title']
        title: '_remove'.loc()
        template: Em.Handlebars.compile '×'

        click: ->
          team = @get('content')
          team.deleteRecord()
          team.store.commit()
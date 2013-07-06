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
  App.MatchItemView = Em.ContainerView.extend App.MatchDelegate,
    classNames: ['match-item']
    childViews: ['dateView', 'infoBarView', 'lockView', 'contentView']
    classNameBindings: [
      'content.isSelected',
#      'content.isVisualySelected',
      'content.isDirty',
      'content.isSaving',
      'content.isPast',
      'content.invalid']
    attributeBindings: ['title']
    titleBinding: 'content.description'

    isEditable: (->
      isEditingMode = App.get('isEditingMode')
      status = @get 'content.status'
      isEditingMode and status is 'opened'
    ).property('App.isEditingMode', 'content.status')

    _isEditingBinding: 'isEditable'

    mouseEnter: ->
      node = @get 'content'
      while node
        node.set('isSelected', yes)
        node = node.get('parentNode')

    mouseLeave: ->
      node = @get 'content'
      while node
        node.set('isSelected', no)
        node = node.get('parentNode')

#    click: ->
#      url = @get 'content.url'
#      # Redirect to match URL
#      document.location.href = url if url

    dateView: App.DateWithPopupView.extend
      classNames: ['match-start-date']
      contentBinding: 'parentView.content.date'
      format: 'DD.MM.YY'
      showPopupBinding: 'App.isEditingMode'

    lockView: Em.View.extend
      tagName: 'i'
      classNames: ['icon-lock']
      classNameBindings: ['parentView.content.isClosed']
      isVisibleBinding: 'parentView._isEditing'

      doubleClick: ->
        if @get 'parentView.content.isOpened'
          @get('parentView').close()
        else
          @get('parentView').open()

    infoBarView: App.GamesInfoBarView.extend
      contentBinding: 'parentView.content.games'
#      showInfoLabel: yes
      classNames: ['match-info-bar']

    contentView: Em.CollectionView.extend
      classNames: ['match-grid-item-entrants']
      contentBinding: 'parentView.content.entrants'

      itemViewClass: App.TeamGridItemView.extend( App.Droppable, {
        matchBinding: 'parentView.parentView.content'

        drop: (event)->
          viewId = event.originalEvent.dataTransfer.getData 'Text'
          view = Em.View.views[viewId]
          team = view.get 'content'
          Em.run.next @, => @set 'content', team
          @_super event
      })
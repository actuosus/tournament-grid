###
 * context_menu_support
 * @author: actuosus
 * Date: 23/05/2013
 * Time: 22:15
###

define ->
  App.ContextMenuSupport = Ember.Mixin.create

    contextMenuActionsChanged: (->
      @createMenuItems()
    ).observes('contextMenuActions')

    createMenuItems: ->
      contextMenuActions = @get 'contextMenuActions'
      if contextMenuActions
        contextMenuItems = []
        contextMenuActions.forEach (actionItem)->
          [action, title] = actionItem.split ':'
          title = action unless title
          contextMenuItems.pushObject App.MenuItem.create
            action: action
            title: "_#{title.decamelize()}".loc()
        @set 'contextMenuItems', contextMenuItems

    init: ->
      classNames = @get 'classNames'
      if classNames
        classNames.push 'context-menu'
      @_super()

    contextMenu: (event)->
      console.log 'ContextMenuSupport', event
      return unless @get 'shouldShowContextMenu'
      event.preventDefault()
      event.stopPropagation()
      contextMenuActions = @get 'contextMenuActions'
      if contextMenuActions
        @createMenuItems()
      @contextMenuView = App.MenuView.create
        sender: event
        content: @get 'contextMenuItems'
        target: @get('contextMenuTarget') or @
      @contextMenuView.append()
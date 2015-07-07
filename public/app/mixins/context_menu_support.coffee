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

    createMenuItems: (target)->
      contextMenuActions = @get 'contextMenuActions'
      if contextMenuActions
        contextMenuItems = []
        contextMenuActions.forEach (actionItem)->
          [action, title] = actionItem.split ':'
          title = action unless title
          target._actions ?= {}
          target._actions[action] = target[action]
          contextMenuItems.pushObject App.MenuItem.create
            action: action
            title: "_#{title.decamelize()}".loc()
        @set 'contextMenuItems', contextMenuItems

#    TODO Should mark context menu enabled items appropriately.
#    init: ->
#      classNames = @get 'classNames'
#      if classNames
#        classNames.push 'context-menu'
#      @_super()

    contextMenu: (event)->
      return unless @get 'shouldShowContextMenu'
      event.preventDefault()
      event.stopPropagation()
      contextMenuActions = @get 'contextMenuActions'
      contextMenuTarget = @get('contextMenuTarget') or @
      if contextMenuActions
        @createMenuItems(contextMenuTarget)
      @contextMenuView = App.MenuView.create
        sender: event
        content: @get 'contextMenuItems'
        target: contextMenuTarget
      @contextMenuView.appendTo App.get 'rootElement'
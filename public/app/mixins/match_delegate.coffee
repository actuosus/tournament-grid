###
 * match_delegate
 * @author: actuosus
 * Date: 03/06/2013
 * Time: 14:34
###

define ->
  App.MatchDelegate = Em.Mixin.create App.ContextMenuSupport,
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
          match: @get('content')
          content: @get('content')
          title: @get 'match.title'
          description: @get 'match.description'
          didUpdate: => popup.hide()
      )
      popup.append()

    deleteRecord: -> @get('content').deleteRecord()
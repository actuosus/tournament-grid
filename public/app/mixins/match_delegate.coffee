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
    save: ->
      console.log('Will save match', @get('content'))
      content = @get 'content'
      if App.TeamRef.detectInstance(content.get('entrant1.content'))
        @get('content').set('entrant1', content.get('entrant1.content.team'))
      if App.TeamRef.detectInstance(content.get('entrant2.content'))
        @get('content').set('entrant2', content.get('entrant2.content.team'))
      @get('content')?.save()

    edit: ->
      popup = App.PopupView.create target: @, parentView: @, container: @container
      popup.pushObject(
        App.MatchForm.create
          popupView: popup
          match: @get('content')
          content: @get('content')
          title: @get 'match.title'
          description: @get 'match.description'
          didUpdate: => popup.hide()
      )
      popup.appendTo App.get 'rootElement'

    deleteRecord: ->
      @get('content')?.deleteRecord()
      @get('content')?.save()
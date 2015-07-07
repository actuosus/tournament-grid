###
 * games_info_bar
 * @author: actuosus
 * @fileOverview
 * Date: 06/02/2013
 * Time: 05:30
###

define [
  'ehbs!game/matchItemView',
  'cs!./form'
  'cs!../match/form'
  'cs!../remove_button'
], ->
  App.GamesInfoBarView = Em.ContainerView.extend( App.Editing, {
    classNames: ['games-info-bar']
    isEditable: no

    _isEditingBinding: 'App.isEditingMode'

    childViews: ['infoLabelView', 'gamesView']
    editingChildViews: ['addButtonView']

    matchBinding: 'parentView.content'
    
    showInfoLabel: Em.computed.notEmpty 'match.link'

    infoLabelView: Em.View.extend
      tagName: 'a'
      attributeBindings: ['href', 'target']
      target: '_blank'
      href: Em.computed.alias 'match.link'
      classNames: ['games-info-bar-label']
      isVisibleBinding: 'parentView.showInfoLabel'
      render: (_)-> _.push '_info'.loc()

      matchBinding: 'parentView.match'

      click: (event)->
        return unless App.get('isEditingMode')
        popup = App.PopupView.create target: @, parentView: @, container: @container
        popup.pushObject(
          App.MatchForm.create
            popupView: popup
            match: @get('match')
            content: @get('match')
            title: @get 'match.title'
            description: @get 'match.description'
            didUpdate: => popup.hide()
        )
        popup.appendTo App.get 'rootElement'


    gamesView: Em.CollectionView.extend
      tagName: 'ul'
      classNames: ['games-list']
      contentBinding: 'parentView.content'

      itemViewClass: Em.View.extend( App.ContextMenuSupport, {
        tagName: 'li'
        classNames: 'games-list-item'
        classNameBindings: ['isUpdating']
        attributeBindings: ['title']
        titleBinding: 'content.title'
        templateName: 'game/matchItemView'
        
        index: (-> @get('contentIndex') + 1).property('contentIndex')

        shouldShowContextMenuBinding: 'App.isEditingMode'
        contextMenuActions: ['edit', 'deleteRecord:delete']

        edit: ->
          popup = App.PopupView.create target: @, parentView: @, container: @container
          popup.pushObject(
            App.GameForm.create
              popupView: popup
              match: @get('match')

            # TODO Should be proper form
              title: @get 'content.title'
              link: @get 'content.link'
              didUpdate: => popup.hide()
          )
          popup.appendTo App.get 'rootElement'

        deleteRecord: -> @get('content').deleteRecord().get('store').commit()
        click: (event)->
          return unless App.get('isEditingMode')
          event.preventDefault()
          @edit()
      })


    addButtonView: Em.View.extend
      isVisibleBinding: 'App.isEditingMode'
      classNames: 'games-create-button'
      attributeBindings: ['title']
      title: '_add_game'.loc()
      tagName: 'button'
      render: (_)-> _.push '+'

      matchBinding: 'parentView.match'

      click: ->
        popup = App.PopupView.create target: @, parentView: @, container: @container
        popup.pushObject(
          App.GameForm.create
            popupView: popup
            match: @get('match')
            didCreate: => popup.hide()
        )
        popup.appendTo App.get 'rootElement'
  })
###
 * games_info_bar
 * @author: actuosus
 * @fileOverview
 * Date: 06/02/2013
 * Time: 05:30
###

define [
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
      hrefBinding: 'match.link'
      classNames: ['games-info-bar-label']
      isVisibleBinding: 'parentView.showInfoLabel'
      template: Em.Handlebars.compile "{{loc '_info'}}"

      matchBinding: 'parentView.match'

      click: (event)->
        return unless App.get('isEditingMode')
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
        template: Em.Handlebars.compile '<a target="_blank" {{bindAttr href="view.content.link" title="view.content.title"}}>{{view.index}}</a>'
        
        index: (-> @get('contentIndex') + 1).property('contentIndex')

        shouldShowContextMenuBinding: 'App.isEditingMode'
        contextMenuActions: ['edit', 'deleteRecord:delete']

        edit: ->
          popup = App.PopupView.create target: @
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

        deleteRecord: -> @get('content').deleteRecord().commit()
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
      template: Em.Handlebars.compile '<button class="btn-clean create-btn">+</button>'

      matchBinding: 'parentView.match'

      click: ->
        popup = App.PopupView.create target: @
        popup.pushObject(
          App.GameForm.create
            popupView: popup
            match: @get('match')
            didCreate: => popup.hide()
        )
        popup.appendTo App.get 'rootElement'
  })
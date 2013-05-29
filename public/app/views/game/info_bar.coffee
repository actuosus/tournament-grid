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
    showInfoLabel: no
    isEditable: no

    _isEditingBinding: 'App.isEditingMode'

    childViews: ['infoLabelView', 'gamesView']
    editingChildViews: ['addButtonView']

    matchBinding: 'parentView.content'

    infoLabelView: Em.View.extend
      classNames: ['games-info-bar-label']
      isVisibleBinding: 'parentView.showInfoLabel'
      template: Em.Handlebars.compile "{{loc '_info'}}"

      matchBinding: 'parentView.match'

      click: ->
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
        popup.append()


    gamesView: Em.CollectionView.extend
      tagName: 'ul'
      classNames: ['games-list']
      contentBinding: 'parentView.content'

      itemViewClass: Em.View.extend( App.ContextMenuSupport, {
        tagName: 'li'
        classNames: 'games-list-item'
        classNameBindings: ['isUpdating']
        attributeBindings: ['title']
        title: Em.computed.alias 'content.title'
        template: Em.Handlebars.compile '<a target="_blank" {{bindAttr href="link" title="title"}}>{{view.content.contentIndex}}</a>'
        contextMenuActions: ['edit', 'delete']

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
          popup.append()

        delete: -> @get('content').deleteRecord()
        click: ->
          return unless App.get('isEditingMode')
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
        popup.append()
  })
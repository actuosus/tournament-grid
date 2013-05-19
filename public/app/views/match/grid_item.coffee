###
 * match_grid_item
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 07:43
###

define [
  'cs!../game/info_bar'
  'cs!../team/grid_item_container'
], ->
  App.MatchGridItemView = Em.ContainerView.extend
    classNames: ['match-grid-item']
    childViews: ['dateView', 'infoBarView', 'contentView', 'editControlsView']#'saveButtonView',
    classNameBindings: ['content.isSelected', 'content.isDirty']
    attributeBindings: ['title']
    titleBinding: 'content.description'

    isEditable: (->
      isEditingMode = App.get('isEditingMode')
      status = @get 'content.status'
    ).property('App.isEditingMode', 'content.status')

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

    dateView: App.DateField.extend
      classNames: ['match-start-date']
      contentBinding: 'parentView.content.date'

      value: (->
        moment(@get 'content.date').format('DD.MM.YY HH:mm:ss')
      ).property('content')

#      valueChanged: (->
#        @set 'content', @get 'value'
#      ).observes('value')


    infoBarView: App.GamesInfoBarView.extend
      contentBinding: 'parentView.content.games'
      showInfoLabel: yes
      classNames: ['match-info-bar']

    contentView: Em.CollectionView.extend
      classNames: ['match-grid-item-entrants']
      matchBinding: 'parentView.content'
      contentBinding: 'parentView.content.entrants'

      itemViewClass: App.TeamGridItemContainerView.extend
        matchBinding: 'parentView.match'

    editControlsView: Em.ContainerView.extend
      classNames: ['match-grid-item-edit-controls']
      childViews: ['removeButtonView', 'closeButtonView', 'saveButtonView']
      contentBinding: 'parentView.content'

#      isVisibleChanged: (->
#        isVisible = @get 'isVisible'
#        if isVisible
#          @$().css({right: 0}).animate({right: -10})
#        else
#          @$().css({display: 'block'}).animate({right: 0}, => @$().css({display: 'none'}))
#      ).observes('isVisible')

      closeButtonView: Em.View.extend
        tagName: 'button'
        classNames: ['btn', 'btn-primary', 'btn-mini', 'close-btn', 'close']
        contentBinding: 'parentView.content'
        template: Em.Handlebars.compile '{{view.actionLabel}}'

        actionLabel: (->
          console.log @get('content'), @get('content.status')
          switch @get 'content.status'
            when 'closed'
              '_open'.loc()
            when 'opened'
              '_close'.loc()
        ).property('content.status')

        isVisible: (->
          isEditingMode = App.get('isEditingMode')
          yes if isEditingMode
        ).property('App.isEditingMode', 'parentView.content.isDirty')

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
          isEditingMode = App.get('isEditingMode')
          isDirty = @get 'parentView.content.isDirty'
          yes if isEditingMode and isDirty
        ).property('App.isEditingMode', 'parentView.content.isDirty')

        click: ->
          match = @get 'parentView.content'
          match.transaction.commit() if match

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
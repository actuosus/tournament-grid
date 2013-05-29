###
 * menu
 * @author: actuosus
 * Date: 18/03/2013
 * Time: 15:06
###

define ['cs!../core'],->
  App.MenuView = Em.CollectionView.extend
    classNames: ['menu']
    attributeBindings: ['aria-role']
    'aria-role': 'menu'

    selection: null
    value: null

    sender: null
    eventDelegate: null

    itemViewClass: Em.View.extend(Ember.TargetActionSupport, {
      classNames: ['menu-item']
      classNameBindings: ['content.isDisabled']
      template: Em.Handlebars.compile '{{view.content.title}}'
      attributeBindings: ['aria-role']
      'aria-role': 'menu-item'
      target: (->
        target = @get 'content.target'
        if target
          target
        else
          @get 'parentView.target'
      ).property('content.target')
      actionBinding: 'content.action'
      click: ->
        console.log 'Menu click'
        @triggerAction()
        @get('parentView').hide()
    })

    didInsertElement: ->
      @_super()
      sender = @get 'sender'
      target = @get('target')
      unless @get 'sender'
        offset = target.$().offset() if target
      else
        sender
        offset = {left: sender.pageX, top: sender.pageY}

      target.set 'isFocused', yes if target

      @$().css(offset)
      $(document.body).bind('mousedown.menu', @onDocumentMouseDown.bind(@))
      @show()

    mouseDown: (event)->
      event.stopPropagation()

    onDocumentMouseDown: (event)->
      $(document.body).unbind('mousedown.menu')
      @hide()

    onShow: Em.K
    onHide: Em.K

    show: (args)->
      if @$()
        @$().transition({ scale: 1 }, 300, (=> @onShow(args)))

    hide: (args)->
      target = @get('target')
      target.set 'isFocused', no if target
      if @$()
        @$().transition({ scale: 0 }, 300, (=> @onHide(args); @destroy()))

    click: (event)->
      eventDelegate = @get 'eventDelegate'
      eventDelegate.click event if eventDelegate

    selectionChanged: (->
      index = @get('content').indexOf @get 'selection'
      childViews = @get 'childViews'
      previouslySelected = childViews.filterProperty 'isSelected'
      if previouslySelected.length
        previouslySelected.forEach (item)-> item.set 'isSelected', no
      selected =  @get('content').objectAt(index)
      selectedView = childViews.objectAt(index)
      if @$() and selectedView?.$()
        @$().scrollTo(selectedView.$())
      selectedView.set('isSelected', yes) if selected
#      selected.set('isSelected', yes) if selected
    ).observes('selection')

    isVisibleChanged: (->
      target = @get 'target'
      $target = target.$()
      if target and $target
        offset = $target.offset()
        height = $target.height()
        offset.top += height
        @.$().css(offset)
        @.$().width($target.width())
    ).observes('isVisible')

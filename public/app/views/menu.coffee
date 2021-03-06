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
      titleChanged: (-> @rerender() ).observes('content.title')
      render: (_)-> _.push @get 'content.title'
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
        @triggerAction()
        @get('parentView').hide()
    })

    willInsertElement: ->
      @_super()
      element = @get 'element'
      sender = @get 'sender'
      target = @get 'target'
      unless @get 'sender'
        offset = target.$().offset() if target
        offset.top += target.$().height()
      else
        sender
        offset = {left: sender.pageX, top: sender.pageY}

      rootElement = App.get('rootElement')
      if rootElement
        rootElementOffset = $(rootElement).offset()
        offset.top -= rootElementOffset.top
        offset.left -= rootElementOffset.left

      target.set 'isFocused', yes if target

      $(element).css({transformOrigin: "#{target.$().width()/2} 0"})
      $(element).css offset
      $(element).css 'min-width', @get 'minWidth' if @get 'minWidth'
      $(document.body).bind('mousedown.menu', @onDocumentMouseDown.bind(@))

    selectNext: ->
      index = @get('content').indexOf @get 'selection'
      @set 'selection', @get('content').objectAt(index+1)

    selectPrevious: ->
      index = @get('content').indexOf @get 'selection'
      @set 'selection', @get('content').objectAt(index-1)

    didInsertElement: ->
      @_super()
      @show()

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
      target.set 'isFocused', no if target and not target.isDestroyed
      if @$()
        @$().transition({ scale: 0 }, 300, (=> @onHide(args); @destroy()))

    mouseDown: (event)->
      event.stopPropagation()

    click: (event)->
      eventDelegate = @get 'eventDelegate'
      eventDelegate.click event if eventDelegate

    selectMenuItem: (item)->
      target = @get('target')
      if target and target.selectMenuItem
        target.selectMenuItem item

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

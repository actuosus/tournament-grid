###
 * language_menu
 * @author: actuosus
 * Date: 21/03/2013
 * Time: 03:22
###

define ['cs!../core'], ->
  App.LanguageMenuView = Em.CollectionView.extend
    useFlags: no
    target: null
    classNames: ['language-menu']
    contentBinding: 'parentView.content'
    selectionBinding: 'parentView.selection'

    itemViewClass: Em.View.extend
      tagName: 'button'
      classNames: ['language-selector-item', 'btn-clean']
      classNameBindings: ['isSelected']
      attributeBindings: ['title']
      contentChanged: (-> @rerender() ).observes('content')
      render: (_)-> _.push @get 'content'
      title: (-> @get 'content').property('content')
      countryFlagClassName: (->
        'country-flag-icon-%@'.fmt(@get('content'))
      ).property('content')
      selectionBinding: 'parentView.selection'
      click: (event)->
        event.preventDefault()
        @set 'selection', @get 'content'
        @set 'parentView.isVisible', no

      mouseEnter: (event)->
        @set 'selection', @get 'content'

    didInsertElement: ->
      @_super()
      target = @get('target')
      if target
#        @$().css({transformOrigin: '-10px 30px', scale: 0})
        offset = target.$().offset()
        targetWidth = target.$().width()
        targetHeight = target.$().height()
#        offset.left += targetWidth
#        offset.top += targetHeight/2 - 30
        @$().css(offset)
    mouseLeave: ->
      @set 'isVisible', no
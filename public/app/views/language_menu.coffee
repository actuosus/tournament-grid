###
 * language_menu
 * @author: actuosus
 * Date: 21/03/2013
 * Time: 03:22
###

define ->
  App.LanguageMenuView = Em.CollectionView.extend
    target: null
    classNames: ['language-menu']
    contentBinding: 'parentView.content'
    selectionBinding: 'parentView.selection'
    itemViewClass: Em.View.extend
      tagName: 'button'
      classNames: ['language-selector-item', 'btn-clean']
      classNameBindings: ['isSelected']
      template: Em.Handlebars.compile '{{view.content}}'
      selectionBinding: 'parentView.selection'
      click: (event)->
        event.preventDefault()
        @set 'selection', @get 'content'

      mouseEnter: (event)->
        @set 'selection', @get 'content'

    didInsertElement: ->
      target = @get('target')
      if target
#        @$().css({transformOrigin: '-10px 30px', scale: 0})
        offset = target.$().offset()
        targetWidth = target.$().width()
        targetHeight = target.$().height()
#        offset.left += targetWidth
        offset.top += targetHeight/2 - 30
        @$().css(offset)
    mouseLeave: ->
      @set 'isVisible', no
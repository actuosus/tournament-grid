###
 * collapsable
 * @author: actuosus
 * Date: 25/03/2013
 * Time: 01:20
###

define ['cs!../core'], ->
  App.Collapsable = Ember.Mixin.create
    classNames: ['collapsible']
    classNameBindings: ['collapsed']
    childViews: ['toggleButtonView']

    isCollapsed: no
    collapsed: no

    toggleButtonView: Em.View.extend
      tagName: 'button'
      classNames: ['btn-clean', 'toggle-btn']
      classNameBindings: ['collapsed:toggle-btn-collapsed']
      attributeBindings: ['title']
      collapsedBinding: 'collapseTarget.collapsed'
      title: (->
        if @get 'collapsed'
          '_expand'.loc()
        else
          '_collapse'.loc()
      ).property 'collapsed'

      click: ->
#        width = @$().width()
#        height = @$().height()
        @get('collapseTarget').toggle()
#        @line.animate('path':"M0 #{height}L#{width/2} 0L#{width} #{height}", 300)

#      didInsertElement: ->
#        width = @$().width()
#        height = @$().height()
#        @paper = Raphael @.get('element'), width, height
#        @line = @paper.path "M0 0L#{width/2} #{height}L#{width} 0"
#        @line.attr 'stroke-width', 2

    init: ->
      @_super()
      toggleButtonTarget = @get 'toggleButtonTarget'
#      if toggleButtonAppendViewBinding.isClass
#        toggleButtonAppendViewBinding.prototype.childViews?.pushObject 'toggleButtonView'
#        toggleButtonAppendViewBinding.prototype.toggleButtonView = @get 'toggleButtonView'
      if toggleButtonTarget.isInstance
        toggleButtonView = @get('toggleButtonView').create(collapseTarget: @)
        toggleButtonTarget.get('childViews').pushObject toggleButtonView

    didInsertElement: -> @$().hide() if @get 'collapsed'

    toggle: ->
      if @get 'collapsed'
        @expand()
      else
        @collapse()

    isCollapsedChanged: (->
      if @get 'isCollapsed'
        @expand()
      else
        @collapse()
    ).observes('isCollapsed')

    collapse: ->
      contentView = @
      if contentView
        contentView.$().slideUp 300, => @set 'collapsed', yes

    expand: ->
      contentView = @
      if contentView
        contentView.$().slideDown 300, => @set 'collapsed', no
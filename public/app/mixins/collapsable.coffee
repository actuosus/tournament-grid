###
 * collapsable
 * @author: actuosus
 * Date: 25/03/2013
 * Time: 01:20
###

define ['cs!core'], ->
  App.Collapsable = Ember.Mixin.create
    classNames: ['collapsible']
    classNameBindings: ['collapsed']
    childViews: ['toggleButtonView']
    collapsed: no

    toggleButtonView: Em.View.extend
      tagName: 'button'
      classNames: ['btn-clean', 'toggle-btn']
      classNameBindings: ['collapsed:toggle-btn-collapsed']
      attributeBindings: ['title']
      collapsedBinding: 'parentView.collapsed'
      title: (->
        if @get 'collapsed'
          '_expand'.loc()
        else
          '_collapse'.loc()
      ).property 'collapsed'
      click: -> @get('parentView').toggle()

    appendableView: null

    init: ->
      @_super()
      appendableView = @get 'appendableView'
      if appendableView
        appendableView.get('childViews').pushObject @get 'toggleButtonView'


#    didInsertElement: ->
#      if @get 'collapsed'
#        @$().height(0)

    toggle: ->
      if @get 'collapsed'
        @expand()
      else
        @collapse()

    collapse: ->
      contentView = @get('contentView')
      if contentView
        @get('contentView').$().slideUp 300, => @set 'collapsed', yes

    expand: ->
      contentView = @get('contentView')
      if contentView
        @get('contentView').$().slideDown 300, => @set 'collapsed', no
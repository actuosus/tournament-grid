###
 * named_container
 * @author: actuosus
 * @fileOverview
 * Date: 06/02/2013
 * Time: 05:47
###

define ->
  App.NamedContainerView = Em.ContainerView.extend
    classNames: ['block-container', 'named-container']
    classNameBindings: ['collapsed']
    childViews: ['titleView', 'toggleButtonView', 'contentView'],
    collapsed: no

    titleView: Em.View.extend
      tagName: 'p'
      classNames: ['b-profileBlock__title']
      classNameBindings: ['collapsed:close']
      titleBinding: 'parentView.title'
      collapsedBinding: 'parentView.collapsed'

      template: Em.Handlebars.compile('{{view.title}}')
#      click: -> @get('parentView').toggle()

    contentView: Em.View.extend()

    toggleButtonView: Em.View.extend
      tagName: 'button'
      classNames: ['btn-clean', 'b-profileBlock__toggle-button']
      attributeBindings: ['title']
      collapsedBinding: 'parentView.collapsed'
      title: (->
        if @get 'collapsed'
          '_expand'.loc()
        else
          '_collapse'.loc()
      ).property 'collapsed'
      click: -> @get('parentView').toggle()

    toggle: ->
      if @get 'collapsed'
        @expand()
      else
        @collapse()

    collapse: ->
      @get('contentView').$().slideUp => @set 'collapsed', yes

    expand: ->
      @get('contentView').$().slideDown => @set 'collapsed', no
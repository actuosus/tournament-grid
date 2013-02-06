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
    childViews: ['titleView', 'contentView'],
    collapsed: no
    titleView: Em.View.extend
      tagName: 'h2'
      classNames: ['named-container-title']
      titleBinding: 'parentView.title'
      collapsedBinding: 'parentView.collapsed'
      actionButtonLabel: (->
        if @get 'collapsed'
          'Развернуть'
        else
          'Свернуть'
      ).property 'collapsed'

      template: Em.Handlebars.compile('{{view.title}} <button type="button" class="toggle-btn toggle-btn-expand pull-right" {{bindAttr title="view.actionButtonLabel"}}><i {{bindAttr class="view.collapsed:icon-chevron-down:icon-chevron-up"}}></i></button>')
      didInsertElement: ->
        @.$('.toggle-btn').click =>
          @get('parentView').toggle()

    contentView: Em.View.extend()

    toggle: ->
      if @get 'collapsed'
        @expand()
      else
        @collapse()

    collapse: ->
      @get('contentView').$().slideUp => @set 'collapsed', yes

    expand: ->
      @get('contentView').$().slideDown => @set 'collapsed', no
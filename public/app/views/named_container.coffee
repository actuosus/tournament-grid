###
 * named_container
 * @author: actuosus
 * @fileOverview
 * Date: 06/02/2013
 * Time: 05:47
###

define ['spin'], (Spinner)->
  App.NamedContainerView = Em.ContainerView.extend
    classNames: ['block-container', 'named-container']
    classNameBindings: ['collapsed']
    childViews: [
      'titleView', 'toggleButtonView', 'contentView',
      'loaderView', 'statusTextView'
    ],
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

    loaderView: Em.View.extend
      classNames: ['loader']
      isVisible: no
      attributeBindings: ['title']
      title: '_loading'.loc()
      isLoadingBinding: 'parentView.isLoading'
      didInsertElement: ->
        opts =
          lines: 15, # The number of lines to draw
          length: 2, # The length of each line
          width: 1, # The line thickness
          radius: 5, # The radius of the inner circle
          corners: 1, # Corner roundness (0..1)
          rotate: 0, # The rotation offset
          color: '#000', # #rgb or #rrggbb
          speed: 2, # Rounds per second
          trail: 60, # Afterglow percentage
          shadow: false, # Whether to render a shadow
          hwaccel: false, # Whether to use hardware acceleration
          className: 'spinner', # The CSS class to assign to the spinner
          zIndex: 2e9, # The z-index (defaults to 2000000000)
          top: 'auto', # Top position relative to parent in px
          left: 'auto' # Left position relative to parent in px
        spinner = new Spinner(opts).spin @get 'element'

    statusTextView: Em.View.extend
      classNames: ['status-text']
      value: null
      template: Em.Handlebars.compile '{{view.value}}'

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
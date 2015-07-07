###
 * named_container
 * @author: actuosus
 * @fileOverview
 * Date: 06/02/2013
 * Time: 05:47
###

define [
  'spin',
  'cs!../mixins/editing'
], (Spinner)->
  App.NamedContainerView = Em.ContainerView.extend App.Editing,
    classNames: ['block-container', 'named-container']
    classNameBindings: ['collapsed']
    childViews: [
      'titleView', 'toolbarView', 'toggleButtonView', 'contentView'
    ]
    collapsed: no

    editingChildViews: ['helpButtonView']

    _isEditingBinding: 'App.isEditingMode'

    titleView: Em.View.extend
      tagName: 'p'
      classNames: ['b-profileBlock__title']
      classNameBindings: ['collapsed:close']
      attributeBindings: ['title']
      titleBinding: 'parentView.description'
      textBinding: 'parentView.title'
      collapsedBinding: 'parentView.collapsed'
      textChanged: (-> @rerender() ).observes('text')
      render: (_)-> _.push @get 'text'
      doubleClick: -> @get('parentView').toggle()

    toolbarView: Em.ContainerView.extend()
#      childViews: ['loaderView', 'statusTextView']
#
#      loaderView: Em.View.extend
#        classNames: ['loader']
#        isVisible: no
#        attributeBindings: ['title']
#        title: '_loading'.loc()
#        isLoadingBinding: 'parentView.isLoading'
#        didInsertElement: ->
#          @_super()
#          opts =
#            lines: 15, # The number of lines to draw
#            length: 2, # The length of each line
#            width: 1, # The line thickness
#            radius: 5, # The radius of the inner circle
#            corners: 1, # Corner roundness (0..1)
#            rotate: 0, # The rotation offset
#            color: '#000', # #rgb or #rrggbb
#            speed: 2, # Rounds per second
#            trail: 60, # Afterglow percentage
#            shadow: false, # Whether to render a shadow
#            hwaccel: false, # Whether to use hardware acceleration
#            className: 'spinner', # The CSS class to assign to the spinner
#            zIndex: 2e9, # The z-index (defaults to 2000000000)
#            top: 'auto', # Top position relative to parent in px
#            left: 'auto' # Left position relative to parent in px
#          spinner = new Spinner(opts).spin @get 'element'
#
#      statusTextView: Em.View.extend
#        classNames: ['status-text']
#        value: null
#        template: Em.Handlebars.compile '{{view.value}}'

    contentView: Em.View.extend
      templateBinding: 'parentView.template'

    helpButtonView: Em.View.extend
      tagName: 'button'
      classNames: ['btn', 'btn-round', 'help-btn']
      attributeBindings: ['title']
      title: '_help'.loc()
      render: (_)-> _.push '?'

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
      @get('contentView').$().slideUp App.animation.duration, => @set 'collapsed', yes

    expand: ->
      @get('contentView').$().slideDown App.animation.duration, => @set 'collapsed', no
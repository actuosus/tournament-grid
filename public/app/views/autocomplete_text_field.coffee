###
 * autocomplete_text_field
 * @author: actuosus
 * @fileOverview Autocompleting text field with content binding.
 * Date: 03/03/2013
 * Time: 20:31
###

define ['spin', 'cs!views/menu'], (Spinner)->
  App.AutocompleteTextField = Em.ContainerView.extend
    classNames: ['autocomplete-text-field']
    childViews: 'textFieldView loaderView addButtomView statusIconView'.w()

    value: null
    selection: null
    placeholder: null

    contentBinding: 'controller.arrangedContent'

    filteredContent: (-> @get 'content').property().volatile()

    selectNext: ->
      index = @get('content').indexOf @get 'selection'
      @set 'selection', @get('content').objectAt(index+1)

    selectPrevious: ->
      index = @get('content').indexOf @get 'selection'
      @set 'selection', @get('content').objectAt(index-1)

    hasFocusChanged: (->
      if @get 'hasFocus'
        @set 'menuView.isVisible', yes
      else
        unless @get 'menuView.hasFocus'
          @set 'menuView.isVisible', no
    ).observes('hasFocus')

    select: (event)->
      @get('textFieldView').$().select()

    focus: (event)->
      @get('textFieldView').$().focus().select()

    textFieldView: Em.TextField.extend
      classNames: ['text-field']
#      attributeBindings: ['type']
      lastValue: null
      type: 'text'
      tagName: 'input'
      placeholderBinding: 'parentView.placeholder'

      selectionChanged: (->
        @$().val(@get 'parentView.selection.name')
      ).observes 'parentView.selection'

      valueChanged: (->
        controller = @get 'parentView.controller'
        value = @get 'value'
        if value and value isnt @get 'lastValue'
          controller.search name: value
        @set 'lastValue', value
      ).observes 'value'

      focusIn: ->
        @set 'parentView.hasFocus', yes
        @$().select()

      focusOut: (event)->
        setTimeout (-> @set 'parentView.hasFocus', no).bind(@), 150

      keyDown: (event)->
#        console.log event.keyCode
        switch event.keyCode
          when 40 # down
            event.preventDefault()
            @get('parentView').selectNext()
          when 38 # up
            event.preventDefault()
            @get('parentView').selectPrevious()

      insertNewline: ->
        menuView = @get 'parentView.menuView'
        @$().val(@get 'parentView.selection.name')
        menuView.set 'isVisible', no

    contentLoaded: (->
      return unless @get 'hasFocus'
      content = @get 'filteredContent'
      unless @get 'content.isLoaded'
        @addButtomView.set 'isVisible', no
        @loaderView.set('isVisible', yes)
#        @cancelButtomView.set('isVisible', yes)
      else
        @loaderView.set('isVisible', no)
#        @cancelButtomView.set('isVisible', no)
        unless @get 'menuView'
          menuView = App.MenuView.create
            content: content
            autocompleteView: @
            highlightBinding: 'autocompleteView.textFieldView.lastValue'
            selectionBinding: 'autocompleteView.selection'
            itemViewClass: @get('controller.menuItemViewClass')
          menuView.append()
          setTimeout((->
            if @get('textFieldView').$()
              offset = @$().offset()
              height = @$().height()
              offset.top += height
              menuView.$().css(offset)
              menuView.$().width(@$().width())
              ).bind(@), 100)
          @set 'menuView', menuView
        else
          @set('menuView.content', content)
          @set('menuView.isVisible', yes)
      unless content.length
        @addButtomView.set 'isVisible', yes
      else
        @addButtomView.set 'isVisible', no
    ).observes 'content.isLoaded'

    loaderView: Em.View.extend
      classNames: ['loader', 'non-selectable']
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

    addButtomView: Em.View.extend
      tagName: 'button'
      classNames: ['add-btn', 'non-selectable']
      attributeBindings: ['title']
      title: '_add_entrant'.loc()
      template: Em.Handlebars.compile '+'
      click: ->
        popup = App.PopupView.create target: @
        formView = @get 'parentView.controller.formView'
        popup.get('childViews').push(
          formView.create
            value: @get('parentView.textFieldView').$().val()
            popupView: popup
            entrant: @get('parentView.entrant')
            didCreate: (entrant)=>
              @set('parentView.selection', entrant)
              popup.hide()
        )
        popup.append()

    cancelButtomView: Em.View.extend
      tagName: 'button'
      classNames: ['cancel-btn', 'non-selectable']
      isVisible: no
      template: Em.Handlebars.compile '✖'

    statusIconView: Em.View.extend
      tagName: 'i'
      classNames: ['icon-status', 'non-selectable']
      isVisible: no

    content: null

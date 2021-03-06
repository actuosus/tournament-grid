###
 * autocomplete_text_field
 * @author: actuosus
 * @fileOverview Autocompleting text field with content binding.
 * Date: 03/03/2013
 * Time: 20:31
###

define [
  'cs!./menu'
  'cs!./loader'
], ->
  App.AutocompleteTextField = Em.ContainerView.extend
    classNames: ['autocomplete-text-field']
    childViews: 'textFieldView loaderView addButtomView statusIconView'.w()

    value: null
    selection: null
    placeholder: null
    title: null
    required: null

    hasFocus: no

    contentBinding: 'controller.arrangedContent'

    ###
      * Allow to filter content
    ###
    filteredContent: (-> @get 'content').property().volatile()

    selectNext: ->
      index = @get('content').indexOf @get 'selection'
      @set 'selection', @get('content').objectAt(index+1)

    selectPrevious: ->
      index = @get('content').indexOf @get 'selection'
      @set 'selection', @get('content').objectAt(index-1)

    hasFocusChanged: (->
      menuView = @get 'menuView'
      if menuView
        if @get 'hasFocus'
          menuView.set 'isVisible', yes
        else
          unless menuView.get 'hasFocus'
            menuView.set 'isVisible', no
      @notifyPropertyChange('content.isLoaded')
    ).observes('hasFocus')

    select: (event)->
      @get('textFieldView').$().select()

    focus: (event)->
      @get('textFieldView').$().focus().select()

    _fetchAutocompleteResults: ()->
      controller = @get 'parentView.controller'
      value = @get 'value'
      if controller and @get('shouldSearch') and value and value isnt @get 'lastValue'
        controller.search name: value

    textFieldView: Em.TextField.extend
      classNames: 'text-field'
      attributeBindings: ['required', 'title']
      requiredBinding: 'parentView.required'
      titleBinding: 'parentView.title'
      placeholderBinding: 'parentView.placeholder'

      lastValue: null

      shouldSearch: yes

      selectionChanged: (->
        labelValue = @get 'parentView.controller.labelValue'
        if labelValue
          @$().val(@get 'parentView.selection.'+labelValue)
        else
          @$().val(@get 'parentView.selection.name')
        @set 'shouldSearch', no
      ).observes 'parentView.selection'

      valueChanged: (->
        controller = @get 'parentView.controller'
        value = @get 'value'
        if controller and @get('shouldSearch') and value and value isnt @get 'lastValue'
          controller.search name: value
        @set 'lastValue', value
        @set 'shouldSearch', yes
        @set 'parentView.value', null
      ).observes 'value'

      focus: ->
        console.log 'Just focus'

      focusIn: ->
        console.log 'Just focusIn'
        @set 'parentView.hasFocus', yes

      focusOut: (event)->
        console.log 'Just focusOut'
        setTimeout (=> @set 'parentView.hasFocus', no), 150

      keyDown: (event)->
        console.log 'keydown'
        switch event.keyCode
          when 40 # down
            event.preventDefault()
            event.stopPropagation()
            @get('parentView').selectNext()
          when 38 # up
            event.preventDefault()
            event.stopPropagation()
            @get('parentView').selectPrevious()

      keyUp: (event)->
        console.log 'keyup'
        parentView = @get 'parentView'

        switch event.keyCode
          when 27
            @$().val('')
          when 8
            parentView.set 'selection', null unless @get 'value'

      insertNewline: (event)->
        parentView = @get 'parentView'
        menuView = parentView.get 'menuView'
        labelValue = @get 'parentView.controller.labelValue'
        if labelValue
          @$().val(parentView.get 'selection.'+labelValue) if parentView.get 'selection.name'
        else
          @$().val(parentView.get 'selection.name') if parentView.get 'selection.name'
        menuView?.set 'isVisible', no
        parentView.set 'value', @get 'parentView.selection'
        parentView.insertNewline(event)

    insertNewline: Em.K

    showAll: ->
      @set 'hasFocus', yes
      @get('controller')?.all()

    contentLoaded: (->
      return unless @get 'hasFocus'
      content = @get 'filteredContent'
      if @get 'content.isLoaded'
        if not @get('menuView') or @get('menuView').isDestroyed
          menuView = App.MenuView.create
            content: content
            autocompleteView: @
            highlightBinding: 'autocompleteView.textFieldView.lastValue'
            valueBinding: 'autocompleteView.value'
            selectionBinding: 'autocompleteView.selection'
            itemViewClass: @get('controller.menuItemViewClass')
            target: @
          menuView.appendTo App.get 'rootElement'
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
      if @addButtomView?.isInstance
        unless content?.length
          @addButtomView.set 'isVisible', yes
        else
          @addButtomView.set 'isVisible', no
    ).observes 'content.isLoaded', 'filteredContent'

    loaderView: App.LoaderView

    addButtomView: Em.View.extend
      tagName: 'button'
      classNames: ['add-btn', 'non-selectable']
      attributeBindings: ['title']
      title: '_add_entrant'.loc()
      render: (_)-> _.push '+'
      click: -> @get('parentView').showAddForm(@)

    showAddForm: (target)->
      popup = App.PopupView.create target: target, parentView: @, container: @container
      formView = @get 'controller.formView'
      form = formView.create
        value: @get('textFieldView').$().val()
        popupView: popup
        entrant: @get('entrant')
        didCreate: (entrant)=>
          @set('value', entrant)
          popup.hide(entrant)
      popup.set 'formView', form
      popup.set 'contentView', form
      popup.pushObject form
      popup.appendTo App.get 'rootElement'
      popup

    cancelButtomView: Em.View.extend
      tagName: 'button'
      classNames: ['cancel-btn', 'non-selectable']
      isVisible: no
      render: (_)-> _.push '✖'

    statusIconView: Em.View.extend
      tagName: 'i'
      classNames: ['icon-status', 'non-selectable']
      isVisible: no
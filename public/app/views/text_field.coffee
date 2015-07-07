###
 * text_field
 * @author: actuosus
 * Date: 07/06/2013
 * Time: 05:41
###

define [
  'cs!./loader'
],->
  App.TextField = Em.ContainerView.extend
    childViews: ['textFieldView', 'loaderView', 'cancelButtomView', 'statusIconView']

    classNames: ['autocomplete-text-field']

    isAutocomplete: no
    autocompleteDelegate: null
    isLoading: no

    selection: null

    clear: ->
      @set 'textFieldView.value', ''

    textFieldView: Em.TextField.extend
      classNames: 'text-field'
#      isVisibleBinding: 'parentView.isVisible'
      isAutocompleteBinding: 'parentView.isAutocomplete'
      attributeBindings: ['autocomplete']
      autocomplete: (->
        'off' if @get('parentView.isAutocomplete')
      ).property('parentView.isAutocomplete')
      nameBinding: 'parentView.name'
      requiredBinding: 'parentView.required'
      placeholderBinding: 'parentView.placeholder'
      actionBinding: 'parentView.action'
      valueBinding: 'parentView.value'

      focusIn: (event)->
        @get('parentView').trigger('focusIn')

      focusOut: (event)->
        @get('parentView').trigger('focusOut')

      keyDown: (event)->
        switch event.keyCode
          when 27 # Esc
            @$().val ''
            @get('parentView').cancelFetchingOfAutocompleteResults()
            @get('parentView')._closeAutocompleteMenu()
          when 40 # down
            event.preventDefault()
            event.stopPropagation()
            @get('parentView').autocompleteMenuSelectNext()
          when 38 # up
            event.preventDefault()
            event.stopPropagation()
            @get('parentView').autocompleteMenuselectPrevious()
          when 13 # enter
            event.preventDefault()
            event.stopPropagation()
            @insertNewline event

      keyUp: (event)->
        switch event.keyCode
          when 40,38 # down, up
            event.preventDefault()
            event.stopPropagation()
            return
        if (event.which is 8 or event.which > 31) and @get 'isAutocomplete'
          @get('parentView')._fetchAutocompleteResults()

      insertNewline: (event)->
        @get('parentView').insertNewline(event)

    focus: (event)-> @get('textFieldView').$().focus()

    focusIn: ->
      if @_autocompleteMenu and !@_autocompleteMenu.isDestroyed
        @_autocompleteMenu.show()

    insertNewline: Em.K

    loaderView: App.LoaderView.extend
      isVisibleBinding: 'parentView.isLoading'

    cancelButtomView: Em.View.extend
      tagName: 'button'
      classNames: ['cancel-btn', 'non-selectable']
      attributeBindings: ['title']
      title: '_cancel'.loc()
      isVisible: (->
        @get 'parentView.isLoading'
      ).property('parentView.isLoading')
      render: (_)-> _.push '✖'
      click: ->
        @get('parentView').cancelFetchingOfAutocompleteResults()

    statusIconView: Em.View.extend
      tagName: 'img'
      classNames: ['icon-status', 'non-selectable']
      isVisible: no

    _fetchAutocompleteResults: ->
      newValue = @$('input').val()
      if newValue
        @cancelFetchingOfAutocompleteResults()
        @set 'isLoading', yes
        @get('autocompleteDelegate').fetchAutocompleteResults newValue, @
      else
        @_closeAutocompleteMenu()

    cancelFetchingOfAutocompleteResults: ->
      @set 'isLoading', no
      @get('autocompleteDelegate').cancelFetchingOfAutocompleteResults()

    didFetchAutocompleteResults: (results)->
      @set 'isLoading', no
      if results.length is 0
        @_closeAutocompleteMenu()
        return
      if not @_autocompleteMenu or @_autocompleteMenu.isDestroyed
        @_createAutocompleteMenu(results)
      else if not @_autocompleteMenu?.isDestroyed
        @_autocompleteMenu.set 'content', results

    _createAutocompleteMenu: (results)->
      menuItemViewClass = @get('autocompleteDelegate.menuItemViewClass')
      menuViewOptions =
        minWidth: @$().width()
        target: @
        content: results
        selectionBinding: 'target.selection'
      menuViewOptions.itemViewClass = menuItemViewClass if menuItemViewClass
      @_autocompleteMenu = App.MenuView.create menuViewOptions
      @_autocompleteMenu.appendTo App.get('rootElement')

    selectMenuItem: Em.K

    becameHidden: ->
      @_closeAutocompleteMenu()

    _closeAutocompleteMenu: ->
      if @_autocompleteMenu
        @_autocompleteMenu.hide()
        @_autocompleteMenu = null

    autocompleteMenuSelectNext: ->
      if @_autocompleteMenu and !@_autocompleteMenu.isDestroyed
        @_autocompleteMenu.selectNext()

    autocompleteMenuselectPrevious: ->
      if @_autocompleteMenu and !@_autocompleteMenu.isDestroyed
        @_autocompleteMenu.selectPrevious()


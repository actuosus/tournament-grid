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

    textFieldView: Em.TextField.extend
      classNames: 'text-field'
#      isVisibleBinding: 'parentView.isVisible'
      isAutocompleteBinding: 'parentView.isAutocomplete'
      nameBinding: 'parentView.name'
      requiredBinding: 'parentView.required'
      placeholderBinding: 'parentView.placeholder'
      actionBinding: 'parentView.action'
      valueBinding: 'parentView.value'

      focusIn: (event)->
        @get('parentView').trigger('focusIn')

      focusOut: (event)->
        @get('parentView').trigger('focusIn')

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
      template: Em.Handlebars.compile '✖'
      click: ->
        @get('parentView').cancelFetchingOfAutocompleteResults()

    statusIconView: Em.View.extend
      tagName: 'img'
      classNames: ['icon-status', 'non-selectable']
      isVisible: no

    _fetchAutocompleteResults: ->
      newValue = @$('input').val()
      if newValue
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
        menuItemViewClass = @get('autocompleteDelegate.menuItemViewClass')
        menuViewOptions =
          minWidth: @$().width()
          target: @
          content: results
          selectionBinding: 'target.selection'
        menuViewOptions.itemViewClass = menuItemViewClass if menuItemViewClass
        @_autocompleteMenu = App.MenuView.create menuViewOptions
        @_autocompleteMenu.append()
      else if not @_autocompleteMenu?.isDestroyed
        @_autocompleteMenu.set 'content', results

    selectMenuItem: Em.K

    _closeAutocompleteMenu: ->
      if @_autocompleteMenu
        @_autocompleteMenu.hide()
        @_autocompleteMenu = null

    autocompleteMenuSelectNext: ->
      unless @_autocompleteMenu?.isDestroyed
        @_autocompleteMenu.selectNext()

    autocompleteMenuselectPrevious: ->
      unless @_autocompleteMenu?.isDestroyed
        @_autocompleteMenu.selectPrevious()


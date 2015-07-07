###
 * country_select
 * @author: actuosus
 * Date: 15/03/2013
 * Time: 17:20
###

define ['ehbs!countrySelectCurrentValue', 'cs!./combobox'], ->
  App.CountrySelectView = App.ComboBoxView.extend
    classNames: ['country-select']
    classNameBindings: ['hasValue']
    valueBinding: 'autocompleteTextFieldView.selection'

    valueChanged: (->
      @set 'autocompleteTextFieldView.selection', @get 'value'
    ).observes('value')

    currentValueView: Em.View.extend
      classNames: ['current-value']
      contentBinding: 'parentView.value'
      isVisibleBinding: 'parentView.hasValue'
      templateName: 'countrySelectCurrentValue'
    hasValue: (->
      !!@get 'autocompleteTextFieldView.selection'
    ).property('autocompleteTextFieldView.selection')

    autocompleteTextFieldView: App.TextField.extend
      isAutocomplete: yes
      placeholder: '_country'.loc()
      requiredBinding: 'parentView.required'
      titleBinding: 'parentView.title'
      childViews: 'textFieldView loaderView statusIconView'.w()
      autocompleteDelegate: (->
        @get('parentView.controller')
      ).property()

      selectionChanged: (->
        selection = @get 'selection'
        if selection
            @get('textFieldView').$().removeAttr 'placeholder'
        else
            @get('textFieldView').$().attr 'placeholder', @get 'placeholder'
      ).observes('selection')

      insertNewline: ->
        @set 'parentView.selection', @get 'selection'
        @set 'parentView.value', @get 'selection'
        @_closeAutocompleteMenu()

      showAll: -> @get('autocompleteDelegate')?.showAll(@)

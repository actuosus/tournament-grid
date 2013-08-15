###
 * country_select
 * @author: actuosus
 * Date: 15/03/2013
 * Time: 17:20
###

define ['cs!./combobox'], ->
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
      template: Em.Handlebars.compile(
        '<i {{bindAttr class=":country-flag-icon view.content.flagClassName"}}></i>'+
        '{{view.content.name}}'
      )
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

      insertNewline: ->
        @set 'parentView.selection', @get 'selection'
        @set 'parentView.value', @get 'selection'
        @_closeAutocompleteMenu()

      showAll: -> @get('autocompleteDelegate')?.showAll(@)

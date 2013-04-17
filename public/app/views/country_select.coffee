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
    currentValueView: Em.View.extend
      classNames: ['current-value']
      contentBinding: 'parentView.autocompleteTextFieldView.selection'
      template: Em.Handlebars.compile(
        '<i {{bindAttr class=":country-flag-icon view.content.flagClassName"}}></i>'
#        '{{view.parentView.currentLabel}}'
      )
    hasValue: (->
      !!@get 'autocompleteTextFieldView.selection'
    ).property('autocompleteTextFieldView.selection')
    autocompleteTextFieldView: App.AutocompleteTextField.extend
      placeholder: '_country'.loc()
      requiredBinding: 'parentView.required'
      titleBinding: 'parentView.title'
      childViews: 'textFieldView loaderView statusIconView'.w()
      controllerBinding: 'parentView.controller'
      click: -> @select()


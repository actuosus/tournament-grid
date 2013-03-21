###
 * country_select
 * @author: actuosus
 * Date: 15/03/2013
 * Time: 17:20
###

define ['cs!views/combobox'], ->
  App.CountrySelectView = App.ComboBoxView.extend
    classNames: ['country-select']
    currentValueView: Em.View.extend
      classNames: ['current-value']
      contentBinding: 'parentView.autocompleteTextFieldView.selection'
      contentChanged: (-> console.log @get 'content').observes('content')
      template: Em.Handlebars.compile(
        '<i {{bindAttr class=":country-flag-icon view.content.flagClassName"}}></i>'+
        '{{view.parentView.currentLabel}}')


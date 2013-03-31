###
 * tester
 * @author: actuosus
 * Date: 29/03/2013
 * Time: 04:01
###

define [
  'cs!./country_select'
  'cs!./autocomplete_text_field'
  'cs!./multilingual_text_field'
  'cs!./editable_label'
  'cs!./multilingual_editable_label'
], ->
  App.TesterView = Em.ContainerView.extend
    childViews: 'countrySelectView autocompleteTextFieldView multilingualTextFieldView editableLabel multilingualEditableLabel'.w()
    countrySelectView: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'label', template: Em.Handlebars.compile('Country selector'))
      contentView: App.CountrySelectView.extend(controller: App.countriesController)
    autocompleteTextFieldView: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'label', template: Em.Handlebars.compile('Autocomplete text field'))
      contentView: App.AutocompleteTextField.extend(controller: App.teamsController)
    multilingualTextFieldView: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'label', template: Em.Handlebars.compile('Multilingual text field'))
      contentView: App.MultilingualTextField.extend(languages: App.languages.content)
    editableLabel: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'label', template: Em.Handlebars.compile('Editable label'))
      contentView: App.EditableLabel.extend(value: 'Some thing')
    multilingualEditableLabel: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'label', template: Em.Handlebars.compile('Multilingual editable label'))
      contentView: App.MultilingualEditableLabel.extend(value: 'Слоники', languages: App.languages.content)
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
  'cs!./player/form'
  'cs!./game/form'
  'cs!./team/form'
  'cs!./stage/form'
  'cs!./_table/container'
  'cs!./_table/column'
], ->
  App.TesterView = Em.ContainerView.extend
    classNames: ['padded']
    childViews: [
      'countrySelectView'
      'autocompleteTextFieldView'
      'multilingualTextFieldView'
      'editableLabel'
      'multilingualEditableLabel'
      'playerForm'
      'teamForm'
      'gameForm'
      'stageForm'
      'checkbox'
      'table'
    ]
    countrySelectView: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'h3', template: Em.Handlebars.compile('Country selector'))
      contentView: App.CountrySelectView.extend(controller: App.countriesController)
    autocompleteTextFieldView: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'h3', template: Em.Handlebars.compile('Autocomplete text field'))
      contentView: App.AutocompleteTextField.extend(controller: App.teamsController)
    multilingualTextFieldView: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'h3', template: Em.Handlebars.compile('Multilingual text field'))
      contentView: App.MultilingualTextField.extend(languages: App.languages.content)
    editableLabel: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'h3', template: Em.Handlebars.compile('Editable label'))
      contentView: App.EditableLabel.extend(value: 'Some thing')
    multilingualEditableLabel: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'h3', template: Em.Handlebars.compile('Multilingual editable label'))
      contentView: App.MultilingualEditableLabel.extend(value: 'Слоники', languages: App.languages.content)

    playerForm: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'h3', template: Em.Handlebars.compile('Player form'))
      contentView: App.PlayerForm.extend()

    teamForm: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'h3', template: Em.Handlebars.compile('Team form'))
      contentView: App.TeamForm.extend()

    gameForm: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'h3', template: Em.Handlebars.compile('Game form'))
      contentView: App.GameForm.extend()

    stageForm: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'h3', template: Em.Handlebars.compile('Stage form'))
      contentView: App.StageForm.extend()

    checkbox: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'h3', template: Em.Handlebars.compile('Checkbox'))
      contentView: Em.Checkbox.extend()

    table: Em.ContainerView.extend
      childViews: ['labelView', 'contentView']
      classNames: ['control-row']
      labelView: Em.View.extend(tagName: 'h3', template: Em.Handlebars.compile('Table'))
      contentView: App.TableContainerView.extend
        controller: Ember.computed ->
          cont = App.TableController.extend
            columnNames: ['a', 'b']

            columns: Ember.computed ->
              @get('columnNames').map (key, index) ->
                App.TableColumn.create(
                  index: index
                  columnWidth: 100
                  headerCellName: key
                  identifier: key)
            .property()
          cont.create(
            content: [
              Em.Object.create({a: 1, b: 2})
              Em.Object.create({a: 3, b: 8})
              Em.Object.create({a: 2, b: 0})
            ]
          )
        .property()
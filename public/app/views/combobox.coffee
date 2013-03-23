###
 * combobox
 * @author: actuosus
 * @fileOverview
 * Date: 08/03/2013
 * Time: 05:21
###

define ['cs!views/autocomplete_text_field'], ->
  App.ComboBoxView = Em.ContainerView.extend
    classNames: ['select', 'combobox']
    childViews: [
      'currentValueView',
      'disclosureButtonView',
      'autocompleteTextFieldView'
#      'selectView'
      ]
    valueBinding: 'autocompleteTextFieldView.selection'
    currentValueView: Em.View.extend
      classNames: ['current-value']
      template: Em.Handlebars.compile '{{view.parentView.currentLabel}}'
      contentBinding: 'parentView.autocompleteTextFieldView.selection'
    disclosureButtonView: Em.View.extend
      classNames: ['disclosure-button', 'non-selectable']
      attributeBindings: ['title']
      menuViewBinding: 'parentView.autocompleteTextFieldView.menuView'
      title: (->
        if @get('menuView.isVisible')
          '_hide_list'.loc()
        else
          '_show_list'.loc()
      ).property('menuView.isVisible')
      template: Em.Handlebars.compile("""
                                      {{#if view.menuView.isVisible}}
                                        <i class="disclosure-icon">▴</i>
                                      {{else}}
                                        <i class="disclosure-icon">▾</i>
                                      {{/if}}
                                       """)
      click: ->
        if @get('menuView.isVisible')
          @set('menuView.isVisible', no)
        else
          @set('menuView.isVisible', yes)

    autocompleteTextFieldView: App.AutocompleteTextField.extend
      controllerBinding: 'parentView.controller'
      click: -> @select()
#    selectView: Em.Select.extend
#      contentBinding: 'parentView.content'
#      optionLabelPathBinding: 'content.name'
#      optionValuePathBinding: 'content.id'
#    selectionBinding: 'selectView.selection'
#    valueBinding: 'selectView.value'

    currentLabel: (->
      @get 'autocompleteTextFieldView.selection.name'
    ).property('value')
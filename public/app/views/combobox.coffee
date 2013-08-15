###
 * combobox
 * @author: actuosus
 * @fileOverview
 * Date: 08/03/2013
 * Time: 05:21
###

define ['cs!./autocomplete_text_field'], ->
  App.ComboBoxView = Em.ContainerView.extend
    classNames: ['select', 'combobox']
    childViews: [
      'currentValueView',
      'disclosureButtonView',
      'autocompleteTextFieldView',
      'resetButtonView'
      ]

    selectionBinding: 'autocompleteTextFieldView.selection'

    selectionChanged: (->
      @set 'value', @get 'selection'
      @get('autocompleteTextFieldView.textFieldView')?.$().val('')
    ).observes('selection')

    valueBinding: 'autocompleteTextFieldView.selection'

    currentValueView: Em.View.extend
      classNames: ['current-value']
      template: Em.Handlebars.compile '{{view.parentView.currentLabel}}'
      contentBinding: 'parentView.autocompleteTextFieldView.selection'

    disclosureButtonView: Em.View.extend
      classNames: ['disclosure-button', 'non-selectable']
      attributeBindings: ['title']
      menuViewBinding: 'parentView.autocompleteTextFieldView._autocompleteMenu'

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
      click: -> @get('parentView.autocompleteTextFieldView').showAll()

    autocompleteTextFieldView: App.TextField.extend
      isAutocomplete: yes
      autocompleteDelegate: (->
        @get('parentView.controller')
      ).property()

      insertNewline: ->
        @set 'parentView.selection', @get 'selection'
        @set 'parentView.value', @get 'selection'
        @_closeAutocompleteMenu()

      showAll: -> @get('autocompleteDelegate')?.showAll(@)

    resetButtonView: Em.View.extend
      tagName: 'button'
      classNames: ['btn-clean', 'remove-btn']
      attributeBindings: ['title', 'type']
      type: 'button'
      title: '_reset'.loc()
      template: Em.Handlebars.compile('&times;')
      isVisible: Em.computed.notEmpty 'parentView.selection'

      click: -> @get('parentView').reset()

    reset: -> @set 'selection', null

    currentLabel: (->
      @get 'autocompleteTextFieldView.selection.name'
    ).property('value')
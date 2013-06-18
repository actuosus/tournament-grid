###
 * entrant_text_field
 * @author: actuosus
 * Date: 08/06/2013
 * Time: 23:17
###

define ['cs!./text_field'], ->
  App.EntrantTextField = App.TextField.extend
    childViews: ['textFieldView', 'loaderView', 'cancelButtomView', 'statusIconView', 'addEntrantButtonView']

    addEntrantButtonView: Em.View.extend
      tagName: 'button'
      classNames: ['add-btn', 'non-selectable']
      attributeBindings: ['title']
      title: '_add_entrant'.loc()
      template: Em.Handlebars.compile '+'
      click: -> @get('parentView').showAddForm(@)

    showAddForm: (target)->
      popup = App.PopupView.create target: target
      formView = @get 'autocompleteDelegate.formView'
      form = formView.create
        value: @get('textFieldView').$().val()
        popupView: popup
        entrant: @get('entrant')
        didCreate: (entrant)=>
          @set('value', entrant)
          popup.hide(entrant)
      popup.set 'formView', form
      popup.set 'contentView', form
      popup.pushObject form
      popup.appendTo App.get 'rootElement'
      popup
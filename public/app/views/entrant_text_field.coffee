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

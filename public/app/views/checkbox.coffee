###
 * checkbox
 * @author: actuosus
 * Date: 28/04/2013
 * Time: 16:09
###

define [
  'cs!../core'
], ->
  App.CheckboxView = Em.ContainerView.extend
    classNames: ['checkbox']
    classNameBindings: ['checked', 'hasFocus:focus']
    childViews: ['checkboxView']
    checked: no
    hasFocus: no
    checkboxView: Em.Checkbox.extend
      checkedBinding: 'parentView.checked'
      focusIn: -> @set 'parentView.hasFocus', yes
      focusOut: -> @set 'parentView.hasFocus', no
###
 * editable_label
 * @author: actuosus
 * Date: 17/03/2013
 * Time: 09:47
###

define ['cs!../core'],->
  App.EditableLabel = Em.View.extend
    classNames: ['editable-label']
    classNameBindings: ['isEmpty']
    template: Em.Handlebars.compile '{{view.value}}'
    isEditable: yes

    value: null

    isEmpty: (-> !@get('value')).property('value')

    click: ->
      if @get 'isEditable'
        @$().attr 'contentEditable', ''

    focusOut: ->
      if @get 'isEditable'
        @set 'value', @$().text()
        @$().removeAttr 'contentEditable'

#    keyUp: ->
#      @set 'value', @$().text()
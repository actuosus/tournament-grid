###
 * editable_label
 * @author: actuosus
 * Date: 17/03/2013
 * Time: 09:47
###

define ['cs!../core'],->
  App.EditableLabel = Em.View.extend
    classNames: ['editable-label']
    classNameBindings: ['isEmpty', 'isEditable']
#    template: Em.Handlebars.compile '{{view.value}}'
    isEditable: yes

    value: null

    isEmpty: (-> !@get('value')).property('value')

    didInsertElement: ->
      @$().text(@get 'value')

    isEditableChanged: (->
      unless @get 'isEditable'
        @$().removeAttr 'contentEditable'
    ).observes('isEditable')

    click: ->
      if @get 'isEditable'
        @$().attr 'contentEditable', ''
        @$().attr 'tabIndex', 0
        @$().focus()
        @$().select()

    mouseEnter: ->
      if @get 'isEditable'
        @$().addClass('active')

    mouseLeave: ->
      if @get 'isEditable'
        @$().removeClass('active')

#    focusIn: ->
#      @$().select()

    focusOut: ->
      if @get 'isEditable'
        text = @$().text()
        @setValue (text)
        @$().removeAttr 'contentEditable'

    setValue: (value)->
      @set('value', value) if @get('value') isnt value

    _valueChanged: (->
      @$().text(@get 'value') if @$()
    ).observes('value')


#    keyUp: ->
#      @set 'value', @$().text()
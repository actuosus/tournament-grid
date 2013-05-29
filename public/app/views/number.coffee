###
 * number
 * @author: actuosus
 * Date: 08/04/2013
 * Time: 14:20
###

define [
  'cs!../core'
  'cs!./editable_label'
],->
  App.NumberView = App.EditableLabel.extend
    tagName: 'span'
    classNames: ['number']

    value: null

#    template: Em.Handlebars.compile '{{view.value}}'

    step: 1
    min: 0
    max: 100

    _valueChanged: (->
      if @get('value') isnt null
        @$().text(@get 'value') if @$()
    ).observes('value')

    stepUp: ->
      value = @get 'value'
      newValue = value + @get('step')
      if newValue >= @get('min') and newValue <= @get('max')
        @incrementProperty 'value', @get 'step'

    stepDown: ->
      value = @get 'value'
      newValue = value - @get('step')
      if newValue >= @get('min') and newValue <= @get('max')
        @incrementProperty 'value', -@get 'step'

    mouseWheel: (event)->
      if @get('isEditable') and @get('hasFocus')
        event.preventDefault()
        if event.originalEvent.wheelDelta > 0
          @stepUp()
        else
          @stepDown()

    keyDown: (event)->
      if @get 'isEditable'
        switch event.keyCode
          when 38 # up
            event.preventDefault()
            @stepUp()
          when 40 # down
            event.preventDefault()
            @stepDown()


    setValue: (value)->
      value = parseFloat(value) if value
      @set('value', value) if @get('value') isnt value
###
 * number_input
 * @author: actuosus
 * Date: 28/04/2013
 * Time: 11:21
###

define [
  'cs!../core'
], ->
  App.NumberInputView = Em.ContainerView.extend
    classNames: ['input', 'input-number']
    childViews: ['fieldView', 'addOnView']

    stepping: 'binary'

    addOnView: Em.ContainerView.extend
      classNames: ['add-on']
      childViews: ['stepUpButtonView', 'stepDownButtonView']

      stepUpButtonView: Em.View.extend
        classNames: ['step-up', 'non-selectable']
        render: (_)-> _.push '▴'

        interval: null

        mouseDown: ->
          @get('parentView.parentView').stepUp()
          $(document).bind('mouseup.number', @mouseUp.bind(@))
          @set 'interval', setInterval (->@get('parentView.parentView').stepUp()).bind(@), 150

        mouseLeave: -> @mouseUp()

        mouseUp: ->
          $(document).unbind('mouseup.number')
          clearInterval @get 'interval'

#        click: ->
#          @get('parentView.parentView').stepUp()

      stepDownButtonView: Em.View.extend
        classNames: ['step-down', 'non-selectable']
        render: (_)-> _.push '▾'

        mouseDown: ->
          @get('parentView.parentView').stepDown()
          $(document).bind('mouseup.number', @mouseUp.bind(@))
          @set 'interval', setInterval (->@get('parentView.parentView').stepDown()).bind(@), 150

        mouseLeave: -> @mouseUp()

        mouseUp: ->
          $(document).unbind('mouseup.number')
          clearInterval @get 'interval'

#        click: ->
#          @get('parentView.parentView').stepDown()

    fieldView: Em.TextField.extend
      tagName: 'input'
      type: 'number'

      attributeBindings: ['step', 'min', 'max', 'required']

      stepBinding: 'parentView.step'
      minBinding: 'parentView.min'
      maxBinding: 'parentView.max'
      valueBinding: 'parentView.value'
      requiredBinding: 'parentView.required'

      keyDown: (event)->
        switch event.keyCode
          when 38 # up
            event.preventDefault()
            @get('parentView').stepUp()
          when 40 # down
            event.preventDefault()
            @get('parentView').stepDown()

    internalValue: 0
    internalStep: 1
    internalMin: 0
    internalMax: 100

    willInsertElement: ->
      if @get('stepping') is 'binary'
        @set 'internalMin', Math.log(@get('min'))/Math.log(2)
        @set 'internalMax', Math.log(@get('max'))/Math.log(2)
        @set 'internalStep', parseInt(@get('step'), 10) or 1
      if @get('stepping') is 'float'
        @set 'internalMin', parseFloat @get('min')
        @set 'internalMax', parseFloat @get('max')
        @set 'internalStep', parseFloat(@get('step')) or 1

    mouseWheel: (event)->
      event.preventDefault()
      if event.originalEvent.wheelDelta > 0
        @stepUp()
      else
        @stepDown()

    stepUp: ->
      max = @get 'internalMax'
      step = @get 'internalStep'
      value = @get 'internalValue'
      newValue = value + step
      if newValue <= max
        @set 'internalValue', newValue

    stepDown: ->
      min = @get 'internalMin'
      step = @get 'internalStep'
      value = @get 'internalValue'
      newValue = value - step
      if newValue >= min
        @set 'internalValue', newValue

    internalValueChanged: (->
      internalValue = @get 'internalValue'
      if @get('stepping') is 'binary'
        @set 'value', Math.pow(2, internalValue)
      else
        @set 'value', internalValue
    ).observes('internalValue')

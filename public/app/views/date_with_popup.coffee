###
 * date_with_popup
 * @author: actuosus
 * Date: 21/05/2013
 * Time: 14:05
###

define ->
  App.DateWithPopupView = Em.View.extend
    tagName: 'span'
    classNames: ['date-with-popup']
    attributeBindings: ['title']

    dateFormat: ''
    timeFormat: ''
    format: 'DD.MM.YY HH:mm:ss'
    titleFormat: 'DD.MM.YY HH:mm:ss'

    showPopup: yes

    title: (->
      date = @get 'content'
      if date and moment(date).isValid()
        moment(date).format @get 'titleFormat'
      else
        ''
    ).property('content')

    value: (->
      date = @get 'content'
      format = @get 'format'
      if date and moment(date).isValid()
        if format.indexOf(' ') isnt -1
          splits = format.split(' ')
          value = '<span class="date">'
          value += moment(date).format splits[0]
          value += '</span> '
          value += '<span class="time">'
          value += moment(date).format splits[1]
          value += '</span>'
        else
          return moment(date).format @get 'format'
      else
        return ''
    ).property('content')

    valueChanged: (-> @rerender() ).observes('value')
    render: (_)-> _.push @get 'value'

    click: ->
      return unless @get 'showPopup'
      dateView = @
      date = @get 'content'
      @popup = App.PopupView.create target: @, parentView: @, container: @container
      @picker = Em.View.create
        willInsertElement: ->
#          $el = @$()
          @$().datetimepicker
            dateFormat: 'dd.mm.yy'
            timeFormat: 'HH:mm'
            showAnim: 'show'
            showButtonPanel: no
            onClose: -> dateView.popup.hide()
#            onSelect: -> dateView.set 'content', $el.datetimepicker 'getDate'
          @$().datetimepicker 'setDate', date if date
        willDestroyElement: -> @$().datetimepicker 'destroy'
      @okButton = Em.View.create
        tagName: 'button'
        classNames: ['btn', 'btn-primary']
        attributeBindings: ['title']
        title: '_ok'.loc()
        render: (_)-> _.push '_ok'.loc()
        click: ->
          dateView.set 'content', dateView.picker.$().datetimepicker 'getDate'
          dateView.popup.hide()
      @popup.pushObject @picker
      @popup.pushObject @okButton
      @popup.appendTo App.get 'rootElement'
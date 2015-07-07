###
 * remove_button
 * @author: actuosus
 * Date: 28/04/2013
 * Time: 15:38
###

define [
  'cs!../core'
], ->
  App.RemoveButtonView = Em.View.extend
    tagName: 'button'
    contentBinding: 'parentView.content'
    isVisibleBinding: 'App.isEditingMode'
    classNames: ['btn-clean', 'remove-btn', 'remove', 'non-selectable']
    attributeBindings: ['title']
    title: '_remove'.loc()
    confirmLabel: '_remove_confirmation'.loc()
    shouldShowConfirmation: no

    shouldShowConfirmationChanged: (-> @rerender() ).observes('shouldShowConfirmation')
    render: (_)->
      strings = ''
      strings += @get('confirmLabel') if @get 'shouldShowConfirmation'
      _.push strings + ' ×'

    useConfirmation: no

    deleteRecord: Em.K

    mouseLeave: ->
      @set 'shouldShowConfirmation', no

    click: ->
      if @get('useConfirmation') and not @get('shouldShowConfirmation')
        @set 'shouldShowConfirmation', yes
        return
      if @get 'shouldShowConfirmation'
        if @get('parentView.deleteRecord')
          @get('parentView').deleteRecord()
        else
          @deleteRecord()
      else
        @set 'shouldShowConfirmation', yes

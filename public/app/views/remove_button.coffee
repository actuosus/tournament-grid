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
    classNames: ['btn-clean', 'remove-btn', 'remove']
    attributeBindings: ['title']
    title: '_remove'.loc()
    confirmLabel: '_remove_confirmation'.loc()
    shouldShowConfirmation: no
    template: Em.Handlebars.compile '{{#if view.shouldShowConfirmation}}{{view.confirmLabel}} {{/if}}×'

    remove: Em.K

    mouseLeave: ->
      @set 'shouldShowConfirmation', no

    click: ->
      if @get 'shouldShowConfirmation'
        @remove()
      else
        @set 'shouldShowConfirmation', yes

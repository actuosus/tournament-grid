###
 * select
 * @author: actuosus
 * Date: 01/02/2013
 * Time: 23:12
###

define [
  'ehbs!select',
  'cs!../core'
],->
  App.SelectView = Em.Select.extend
    tagName: 'div'
    templateName: 'select'
    selectionBinding: 'childViews.firstObject.selection'
    valueBinding: 'childViews.firstObject.value'
    currentLabel: (->
      @get 'childViews.firstObject.selection.name'
    ).property 'value'
    classNames: ['select']
    click: (event)->
      if $(event.target).hasClass('disclosure-button')
        @get('childViews.firstObject').$().select().focus()
###
 * select
 * @author: actuosus
 * @fileOverview 
 * Date: 01/02/2013
 * Time: 23:12
###

define ->
  App.SelectView = Em.Select.extend
    tagName: 'div'
    template: Em.Handlebars.compile '<div class="current-value">{{view.currentLabel}}</div><div class="disclosure-button"><i class="disclosure-icon">▾</i></div>{{view Em.Select optionLabelPath=content.name optionValuePath=content.id contentBinding=view.content promptBinding=parentView.prompt}}'
    valueBinding: 'childViews.firstObject.value'
    currentLabel: (-> @get 'childViews.firstObject.selection.name' ).property('value')
    valueChanged: (-> console.log @get 'value').observes('value')
    classNames: ['select']
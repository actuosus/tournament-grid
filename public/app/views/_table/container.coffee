###
 * container
 * @author: actuosus
 * Date: 16/04/2013
 * Time: 21:28
###

define [
  'ember'
  'cs!./controller'
  'cs!./header'
  'cs!./body'
  'cs!./footer'
], ()->
  App.TableContainerView = Ember.ContainerView.extend
    classNames: 'table-container'
    childViews: ['headerView', 'bodyView', 'footerView']
    headerView: App.TableHeaderContainerView.extend
      controllerBinding: 'parentView.controller'
    bodyView: App.TableBodyContainerView.extend
      controllerBinding: 'parentView.controller'
    footerView: App.TableFooterContainerView.extend
      controllerBinding: 'parentView.controller'
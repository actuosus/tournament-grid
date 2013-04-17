###
 * footer
 * @author: actuosus
 * Date: 16/04/2013
 * Time: 21:44
###

define [
  'ember'
], (Ember)->
  App.TableFooterContainerView = Ember.CollectionView.extend
    classNames: ['table-footer']
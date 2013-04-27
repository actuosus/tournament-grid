###
 * adapter
 * @author: actuosus
 * Date: 24/04/2013
 * Time: 10:57
###

define [
  'cs!./core'
], ->
  App.Adapter = DS.RESTAdapter.extend
    bulkCommit: no
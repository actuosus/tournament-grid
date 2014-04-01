###
 * form
 * @author: actuosus
 * Date: 28/04/2013
 * Time: 17:02
###

define [
  'cs!../core'
], ->
  App.FormView = Em.View.extend
    content: null
    tagName: 'form'
    classNames: ['form']

    didCreate: Em.K
    didUpdate: Em.K
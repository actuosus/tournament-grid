###
 * application
 * @author: actuosus
 * Date: 07/06/2013
 * Time: 00:54
###

define [
  'text!../templates/application.hbs'
], (template)->
  Em.TEMPLATES.application = Em.Handlebars.compile template

  App.ApplicationView = Em.View.extend
    templateName: 'application'
    attributeBindings: ['aria-role']
    'aria-role': 'application'
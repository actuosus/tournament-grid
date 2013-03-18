###
 * form
 * @author: actuosus
 * @fileOverview Stage form
 * Date: 12/03/2013
 * Time: 06:12
###

define [
  'text!templates/stage/form.handlebars'
], (template)->
  Em.TEMPLATES.stageForm = Em.Handlebars.compile template
  App.StageForm = Em.View.extend
    tagName: 'form'
    classNames: ['stage-form']
    templateName: 'stageForm'
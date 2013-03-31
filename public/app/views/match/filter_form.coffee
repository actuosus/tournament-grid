###
 * match_filter_form
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 07:45
###

define [
  'text!../../templates/match/filter_form.handlebars'
  'cs!../../core'
], (template)->
  Em.TEMPLATES.matchFilterForm = Em.Handlebars.compile template
  App.MatchFilterFormView = Em.View.extend
    templateName: 'matchFilterForm'
    classNames: ['match-filter-form']
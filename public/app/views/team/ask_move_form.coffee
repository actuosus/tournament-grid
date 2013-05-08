###
 * ask_move_form
 * @author: actuosus
 * Date: 06/05/2013
 * Time: 16:38
###

define [
  'cs!../../core'
], ->
  App.AskMoveForm = Em.ContainerView.extend
    childViews: ['titleView', 'descriptionView', 'buttonsView']

    titleView: Em.View.extend
      template: Em.Handlebars.compile "<h2>{{loc '_are_you_sure_to_move'}}</h2>"

    descriptionView: Em.View.extend
      descriptionBinding: 'parentView.description'
      template: Em.Handlebars.compile "<p>{{view.description}}</p>"

    buttonsView: Em.ContainerView.extend
      classNames: ['buttons']
      childViews: ['yesButton', 'noButton'],
      yesButton: Em.View.extend
        classNames: ['btn', 'btn-primary']
        tagName: 'button'
        template: Em.Handlebars.compile "{{loc '_yes'}}"
        click: -> @get('parentView.parentView').trigger('yes')
      noButton: Em.View.extend
        classNames: ['btn']
        tagName: 'button'
        template: Em.Handlebars.compile "{{loc '_no'}}"
        click: -> @get('parentView.parentView').trigger('no')


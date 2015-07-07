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
      render: (_)-> _.push "<h2>#{'_are_you_sure_to_move'.loc()}</h2>"

    descriptionView: Em.View.extend
      descriptionBinding: 'parentView.description'
      render: (_)-> _.push "<p>#{@get('description')}</p>"
      descriptionChanged: (->).observes('description')

    buttonsView: Em.ContainerView.extend
      classNames: ['buttons']
      childViews: ['yesButton', 'noButton'],
      yesButton: Em.View.extend
        classNames: ['btn', 'btn-primary']
        tagName: 'button'
        render: (_)-> _.push '_yes'.loc()
        click: -> @get('parentView.parentView').trigger('yes')
      noButton: Em.View.extend
        classNames: ['btn']
        tagName: 'button'
        render: (_)-> _.push '_no'.loc()
        click: -> @get('parentView.parentView').trigger('no')


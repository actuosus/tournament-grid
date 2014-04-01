###
 * action_bar
 * @author: actuosus
 * Date: 14/10/2013
 * Time: 02:48
###

define ->
  App.ActionBarView = Em.CollectionView.extend
    classNames: ['action-bar']

    itemViewClass: Em.View.extend(Ember.TargetActionSupport, {
      tagName: 'button'
      classNames: ['action-bar-item', 'btn', 'btn-mini']
      classNameBindings: ['content.isDisabled', 'content.isHidden']
      template: Em.Handlebars.compile '{{view.content.title}}'

      target: (->
        target = @get 'content.target'
        if target
          target
        else
          @get 'parentView.target'
      ).property('content.target')
      actionBinding: 'content.action'
      click: -> @triggerAction()
    })
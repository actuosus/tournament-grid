###
 * how_is_the_captain_form
 * @author: actuosus
 * Date: 14/05/2013
 * Time: 12:54
###

define ->
  App.HowIsTheCaptainForm = Em.ContainerView.extend
    childViews: ['titleView', 'selectionView']

    selection: null

    titleView: Em.View.extend
      template: Em.Handlebars.compile "<h2>{{loc '_how_is_the_captain'}}</h2>"

    selectionView: Em.CollectionView.extend
      contentBinding: 'parentView.content'
      selectionBinding: 'parentView.selection'
      itemViewClass: App.PlayerLineupGridItemView.extend
        classNameBindings: ['isSelected']

        isSelected: (->
          Em.isEqual @get('content'), @get('selection')
        ).property('selection')

        click: -> @set 'selection', @get 'content'
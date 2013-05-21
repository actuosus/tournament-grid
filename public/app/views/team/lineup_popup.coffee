###
 * lineup_popup
 * @author: actuosus
 * Date: 21/05/2013
 * Time: 14:23
###

define ->
  App.TeamLineupPopupView = App.PopupView.extend
    classNames: ['small-popup', 'team-lineup-popup']
    childViews: ['teamNameView', 'playersView']

    teamNameView: Em.ContainerView.extend
      contentBinding: 'parentView.content'
      classNames: ['lineup-list-name-container']
      childViews: ['nameView']

      nameView: Em.View.extend
        contentBinding: 'parentView.content'
        classNames: ['lineup-list-name']
        href: (->
          '/teams/%@'.fmt @get 'content.id'
        ).property('content')
        attributeBindings: ['title']
        title: (->
          @get('content.id') if App.get('isEditingMode')
        ).property('App.isEditingMode')
        template: Em.Handlebars.compile '<a target="_blank" {{bindAttr href="view.href"}}>{{view.content.name}}</a>'

        valueChanged: (->
          report = App.get('report')
          @set 'parentView.content', App.TeamRef.createRecord({team: @get('value'), report: report})
        ).observes('value')

    playersView: Em.CollectionView.extend
      classNames: ['team-lineup-popup-players']
      teamRefBinding: 'parentView.content'
      contentBinding: 'parentView.content.players'

      itemViewClass: Em.ContainerView.extend
        classNames: ['team-lineup-popup-players-item']
        childViews: ['countryFlagView', 'nameView']
        countryFlagView: App.CountryFlagView.extend
          contentBinding: 'parentView.content.country'
        nameView: Em.View.extend
          classNames: ['team-lineup-popup-players-item-name']
          contentBinding: 'parentView.content'
          template: Em.Handlebars.compile '{{view.content.nickname}}'
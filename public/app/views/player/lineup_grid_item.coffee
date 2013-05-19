###
 * lineup_grid_item
 * @author: actuosus
 * Date: 28/04/2013
 * Time: 10:53
###

define [
  'cs!../../core'
  'cs!../remove_button'
],->
  App.PlayerLineupGridItemView = Em.ContainerView.extend
    classNames: ['lineup-grid-item-player-row']
    classNameBindings: ['content.isSaving', 'content.isDirty']
    childViews: ['countryFlagView', 'nameView', 'realNameView', 'captianMarkerView', 'removeButtonView']

    teamRefBinding: 'parentView.teamRef'

    countryFlagView: Em.View.extend
      tagName: 'i'
      classNames: ['country-flag-icon', 'team-country-flag-icon']
      classNameBindings: ['countryFlagClassName', 'hasFlag']
      attributeBindings: ['title']
      contentBinding: 'parentView.content'
      titleBinding: 'content.country.name'
      hasFlag: (-> !!@get 'content.country.code').property('content.country')
      countryFlagClassName: (->
        'country-flag-icon-%@'.fmt @get 'content.country.code'
      ).property('content.country.code')

    raceFlagView: Em.View.extend
      tagName: 'i'
      classNames: ['race-flag-icon']
      classNameBindings: ['countryFlagClassName', 'hasFlag']
      attributeBindings: ['title']
      title: (-> @get 'content.race.name').property('content.race')
      contentBinding: 'parentView.content'
      hasFlag: (-> !!@get 'content.race.code').property('content.race')
      countryFlagClassName: (->
        'country-flag-icon-%@'.fmt @get 'content.country.code'
      ).property('content.country.code')

    nameView: Em.View.extend
      contentBinding: 'parentView.content'
      classNames: ['lineup-grid-item-name']
      attributeBindings: ['title']
      href: (->
        '/players/%@'.fmt @get 'content.id'
      ).property('content.id')
      title: (->
        @get('content.id') if App.get('isEditingMode')
      ).property('App.isEditingMode')
      template: Em.Handlebars.compile '<a target="_blank" {{bindAttr href="view.href"}}>{{view.content.nickname}}</a>'

    realNameView: Em.View.extend
      contentBinding: 'parentView.content'
      classNames: ['lineup-grid-item-real-name']
      isVisibleBinding: 'hasShortName'
      hasShortName: (->
        shortName = @get('content.shortName')
        yes if shortName and shortName isnt ''
      ).property('content.shortName')
      template: Em.Handlebars.compile '({{view.content.shortName}})'

    captianMarkerView: Em.View.extend
      contentBinding: 'parentView.content'
      teamRefBinding: 'parentView.teamRef'
      classNames: ['lineup-grid-item-captain-marker']
      isVisible: (->
        Em.isEqual @get('teamRef.captain'), @get('content')
      ).property('teamRef.captain')
      attributeBindings: ['title']
      title: '_captain'.loc()
      template: Em.Handlebars.compile 'К'

    deleteRecord: ->
      report = App.get('report')
      player = @get('content')
#      teamRef = App.report.get('teamRefs').find (tr)->
#        tr.get('players').find (item)->
#          item.id is player.id
      teamRef = @get 'teamRef'
      players = teamRef.get('players')
      # Just removing from team ref
      players.removeObject player
      player.set 'team', teamRef.get('team')
      player.set 'report', report
      player.store.commit()

    removeButtonView: App.RemoveButtonView.extend
      title: '_remove_player'.loc()
      remove: -> @get('parentView').deleteRecord()

    doubleClick: ->
      teamRef = @get 'teamRef'
      teamRef.set 'captain', @get 'content'
      teamRef.store.commit()
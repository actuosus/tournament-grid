###
 * lineup_grid_item
 * @author: actuosus
 * Date: 28/04/2013
 * Time: 10:53
###

define ->
  App.PlayerLineupGridItemView = Em.ContainerView.extend
    classNames: ['lineup-grid-item-player-row']
    classNameBindings: ['content.isSaving']
    childViews: ['countryFlagView', 'nameView', 'realNameView', 'captianMarkerView', 'removeButtonView']

    countryFlagView: Em.View.extend
      tagName: 'i'
      classNames: ['country-flag-icon', 'team-country-flag-icon']
      classNameBindings: ['countryFlagClassName', 'hasFlag']
      attributeBindings: ['title']
      title: (-> @get 'content.country.name').property('content.country')
      contentBinding: 'parentView.content'
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
      title: (->
        @get('content.id') if App.get('isEditingMode')
      ).property('App.isEditingMode')
      template: Em.Handlebars.compile '{{view.content.nickname}}'

    realNameView: Em.View.extend
      contentBinding: 'parentView.content'
      classNames: ['lineup-grid-item-real-name']
      isVisibleBinding: 'hasShortName'
      hasShortName: (->
        shortName = @get('content.shortName')
        yes if shortName and shortName isnt ' '
      ).property('content.shortName')
      template: Em.Handlebars.compile '({{view.content.shortName}})'

    captianMarkerView: Em.View.extend
      contentBinding: 'parentView.content'
      classNames: ['lineup-grid-item-captain-marker']
      isVisibleBinding: 'content.isCaptain'
      attributeBindings: ['title']
      title: '_captain'.loc()
      template: Em.Handlebars.compile 'К'

    removeButtonView: Em.View.extend
      tagName: 'button'
      contentBinding: 'parentView.content'
      isVisibleBinding: 'App.isEditingMode'
      classNames: ['btn-clean', 'remove-btn', 'remove']
      attributeBindings: ['title']
      title: '_remove_player'.loc()
      confirmLabel: '_remove_confirmation'.loc()
      shouldShowConfirmation: no
      template: Em.Handlebars.compile '{{#if view.shouldShowConfirmation}}{{view.confirmLabel}} {{/if}}×'

      remove: ->
        report = App.get('report')
        player = @get('content')
        teamRef = App.report.get('teamRefs').find (tr)->
          tr.get('players').find (item)->
            item.id is player.id
        players = teamRef.get('players')
        # Just removing from team ref
        players.removeObject player
        #            player.deleteRecord()
        #            player.set 'teamRef', null
        player.set 'team', teamRef.get('team')
        player.set 'report', report
        player.store.commit()

      mouseLeave: ->
        @set 'shouldShowConfirmation', no

      click: ->
        if @get 'shouldShowConfirmation'
          @remove()
        else
          @set 'shouldShowConfirmation', yes

###
 * lineup_grid_item
 * @author: actuosus
 * Date: 22/03/2013
 * Time: 21:19
###

define [
  'cs!../../mixins/moving_highlight'
  'cs!../autocomplete_text_field'
  'cs!../editable_label'
], ->
  App.TeamLineupGridItem = Em.ContainerView.extend
    classNames: ['lineup-grid-item']
    childViews: ['teamNameView', 'playersView', 'addPlayerView']

    teamNameView: Em.ContainerView.extend(App.MovingHightlight,
      contentBinding: 'parentView.content'
      classNames: ['lineup-grid-item-name-container']
      childViews: ['countryFlagView', 'nameView', 'removeButtonView']#'editButtonView',

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

      nameView: App.EditableLabel.extend
        valueBinding: 'parentView.content.name'
        classNames: ['lineup-grid-item-name']
        isEditableBinding: 'App.isEditingMode'
        valueChanged: (->
          team = @get 'parentView.content'
          if team
            team.store.commit()
        ).observes('value')
#        template: Em.Handlebars.compile '{{view.content.name}}'

      editButtonView: Em.View.extend
        tagName: 'button'
        contentBinding: 'parentView.content'
        isVisibleBinding: 'App.isEditingMode'
        classNames: ['btn-clean', 'edit-btn', 'edit']
        attributeBindings: ['title']
        title: '_edit'.loc()
        template: Em.Handlebars.compile '✎'

        click: ->
          popup = App.PopupView.create target: @
          popup.get('childViews').push(
            App.TeamForm.create
              popupView: popup
              nameBinding: 'parentView.entrant.name'
              entrant: @get('parentView.entrant')
              didUpdate: (entrant)=> popup.hide()
          )
          popup.append()

      removeButtonView: Em.View.extend
        tagName: 'button'
        contentBinding: 'parentView.content'
        isVisibleBinding: 'App.isEditingMode'
        classNames: ['btn-clean', 'remove-btn', 'remove']
        attributeBindings: ['title']
        title: '_remove'.loc()
        template: Em.Handlebars.compile '×'

        click: ->
          team = @get('content')
          container = @get('parentView.parentView.parentView.content')
          team.deleteRecord()
          team.store.commit()
          if container
            container.removeObject(team)
    )
    playersView: Em.CollectionView.extend
      classNames: ['lineup-grid-item-players']
      contentBinding: 'parentView.content.players'

      contentChanged: (->
        console.log 'players changed'
        team = @get 'parentView.content'
        team.set('proxy', false) if team.get('proxy')
      ).observes('content.length')

      itemViewClass: Em.ContainerView.extend
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

        nameView: Em.View.extend
          contentBinding: 'parentView.content'
          classNames: ['lineup-grid-item-name']
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
          isVisibleBinding: 'content.is_captain'
          attributeBindings: ['title']
          title: '_captain'.loc()
          template: Em.Handlebars.compile 'К'

        removeButtonView: Em.View.extend
          tagName: 'button'
          contentBinding: 'parentView.content'
          isVisibleBinding: 'App.isEditingMode'
          classNames: ['btn-clean', 'remove-btn', 'remove']
          template: Em.Handlebars.compile '×'

          click: ->
            player = @get('content')
            console.log player
            player.deleteRecord()

    addPlayerView: Em.ContainerView.extend
      classNames: ['lineup-grid-item-player-row']
      childViews: ['contentView']
      isVisibleBinding: 'App.isEditingMode'

      contentView: App.AutocompleteTextField.extend
        controllerBinding: 'App.playersController'
        entrantBinding: 'parentView.parentView.content'

        addPlayer: (player)->
          team = @get('parentView.parentView.content')
          players = team.get('players')
          players.pushObject player
          player.store.commit()

        insertNewline: ->
          player = @get 'value'
          unless player
            popup = @showAddForm(@)
            popup.onShow = => popup.get('formView')?.focus()
            popup.onHide = => @focus()
          else
            @addPlayer player

        valueChanged: (->
          player = @get 'value'
          @addPlayer player if player
        ).observes('value')

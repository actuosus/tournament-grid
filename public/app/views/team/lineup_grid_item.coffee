###
 * lineup_grid_item
 * @author: actuosus
 * Date: 22/03/2013
 * Time: 21:19
###

define ['cs!mixins/moving_highlight'], ->
  App.TeamLineupGridItem = Em.ContainerView.extend
    classNames: ['lineup-grid-item']
    childViews: ['teamNameView', 'playersView', 'addPlayerView']

    teamNameView: Em.ContainerView.extend(App.MovingHightlight,
      contentBinding: 'parentView.content'
      classNames: ['lineup-grid-item-name-container']
      childViews: ['countryFlagView', 'nameView', 'editButtonView', 'removeButtonView']

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
        template: Em.Handlebars.compile '{{view.content.name}}'

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

        click: -> @get('content').deleteRecord()
    )
    playersView: Em.CollectionView.extend
      classNames: ['lineup-grid-item-players']
      contentBinding: 'parentView.content.players'

      itemViewClass: Em.ContainerView.extend
        classNames: ['lineup-grid-item-player-row']
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
            console.log @get('content')
            @get('content').deleteRecord()

    addPlayerView: Em.ContainerView.extend
      classNames: ['lineup-grid-item-player-row']
      childViews: ['contentView']
      isVisibleBinding: 'App.isEditingMode'
      contentView: App.AutocompleteTextField.extend
        controllerBinding: 'App.playersController'
        entrantBinding: 'parentView.parentView.content'

        insertNewline: ->
          popup = @showAddForm(@)
          popup.onShow = =>
            popup.get('formView')?.focus()
          popup.onHide = =>
            @focus()


#        selectionChanged: (->
#          player = @get 'selection'
#          @get('parentView.parentView.content.players').pushObject player
#        ).observes('selection')

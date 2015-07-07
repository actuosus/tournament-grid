###
 * menu_item
 * @author: actuosus
 * Date: 07/06/2013
 * Time: 05:36
###

define [
  'cs!../country_flag'
  'cs!../modal'
],->
  App.EntrantMenuItem = Em.ContainerView.extend
    classNames: ['menu-item']
    classNameBindings: ['isSelected', 'isTeamRef']
    attributeBindings: ['title']

    isTeamRef: (->
      App.TeamRef.detectInstance @get 'content'
    ).property('content')

    team: (->
      content = @get 'content'
      if App.TeamRef.detectInstance content
        content.get 'team'
      else
        content
    ).property('content')

    titleBinding: 'team._id'

    childViews: ['countryFlagView', 'nameView']

    countryFlagView: App.CountryFlagView.extend
      contentBinding: 'parentView.team.country'

    nameView: Em.View.extend
      contentBinding: 'parentView.team'
      classNames: ['lineup-grid-item-name']
      nameChanged: (-> @rerender() ).observes('content.name')
      render: (_)-> _.push @get 'content.name'

    showAddingNotify: ->
      modalView = App.ModalView.create
        target: @get 'parentView.autocompleteView'
      modalView.on 'ok', -> @hide()
      modalView.pushObject Em.ContainerView.create(
        childViews: ['contentView', 'buttonsView']
        contentView: Em.View.create(render: (_)-> _.push 'Команда уже добавлена')
        buttonsView: Em.ContainerView.create
          classNames: ['buttons']
          childViews: ['okButton']
          okButton: Em.View.create
            classNames: ['btn', 'btn-primary']
            tagName: 'button'
            render: (_)-> _.push '_ok'.loc()
            click: -> @get('parentView.parentView.parentView').trigger('ok')
      )
      modalView.appendTo App.get 'rootElement'

    click: (event)->
      event.preventDefault()
      event.stopPropagation()
      @get('parentView').selectMenuItem @get 'team'
      @get('parentView').click(event)
      @set 'parentView.selection', @get 'team'
      @set 'parentView.value', @get 'team'
      @set 'parentView.isVisible', no

###
 * lineup_container
 * @author: actuosus
 * Date: 01/04/2013
 * Time: 07:09
###

define [
  'cs!../core'
  'cs!./named_container'
], ->
  App.LineupContainerView = App.NamedContainerView.extend
    title: '_the_teams'.loc()
    childViews: [
      'titleView', 'toggleButtonView', 'contentView',
      'loaderView', 'statusTextView', 'searchBarView',
      'addEntrantButtonView'
    ]
    searchBarView: Em.ContainerView.extend
      classNames: ['search-bar']
      childViews: ['textFieldView', 'clearButtonView']
      isVisibleBinding: 'App.isEditingMode'
      clearButtonView: Em.View.extend
        tagName: 'button'
        isVisibleBinding: 'parentView.textFieldView.isNotClearValue'
        classNames: ['btn-clean', 'remove-btn', 'remove']
        attributeBindings: ['title']
        title: '_remove'.loc()
        template: Em.Handlebars.compile '×'

        click: -> @set('parentView.textFieldView.value', '')

      textFieldView: Em.TextField.extend
        classNames: ['search-field']
        placeholder: '_filter'.loc()
        keyUp: (event)->
          switch event.keyCode
            when 27 then @set 'value', ''
        isNotClearValue: (-> !!@get('value')).property('value')
        valueChanged: (->
          if @get 'value'
            @set 'isNotClearValue', yes
          else
            @$().val('')
            @$().focus()
            @set 'isNotClearValue', no
          @set('parentView.parentView.contentView.controller.searchQuery', @get 'value')
        ).observes('value')

    addEntrantButtonView: Em.View.extend
      tagName: 'button'
      classNames: ['btn-clean', 'add-btn', 'add', 'add-team-btn']
      template: Em.Handlebars.compile '+'
      click: ->
        team = App.Team.createRecord()
        report = App.get('report')
        team.set 'name', @$('.name').val()
        team.set 'report', report
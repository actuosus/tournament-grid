###
 * teams
 * @author: actuosus
 * Date: 01/04/2013
 * Time: 06:37
###

define [
  'cs!../core'
  'cs!../models/team'
  'cs!../views/team/form'
], ->
  App.TeamsController = Em.ArrayController.extend
    formView: App.TeamForm
    searchResults: []
    labelValue: 'name'

#    contentLoaded: (->
##      console.log 'App.TeamsController', 'content.isLoaded', @get('content.isLoaded'), @get('content')
#      @set 'isLoaded', yes
#    ).observes('content.isLoaded')

    search: (options)->
      @set 'isLoaded', no
      @set 'content', App.Team.find options

    menuItemViewClass: Em.ContainerView.extend
      classNames: ['menu-item']
      classNameBindings: ['isSelected']
      attributeBindings: ['title']
      titleBinding: 'content._id'
      childViews: ['countryFlagView', 'nameView']

      countryFlagView: Em.View.extend
        tagName: 'i'
        classNames: ['country-flag-icon', 'team-country-flag-icon']
        classNameBindings: ['countryFlagClassName', 'hasFlag']
        attributeBindings: ['title']
        contentBinding: 'parentView.content'
        title: (-> @get 'content.country.name').property('content.country')
        hasFlag: (-> !!@get 'content.country.code').property('content.country')
        countryFlagClassName: (->
          'country-flag-icon-%@'.fmt @get 'content.country.code'
        ).property('content.country.code')

      nameView: Em.View.extend
        contentBinding: 'parentView.content'
        classNames: ['lineup-grid-item-name']
        template: Em.Handlebars.compile '{{view.content.name}}'

      click: (event)->
        event.preventDefault()
        event.stopPropagation()
        @get('parentView').click(event)
        @set 'parentView.selection', @get 'content'
        @set 'parentView.value', @get 'content'
        @set 'parentView.isVisible', no
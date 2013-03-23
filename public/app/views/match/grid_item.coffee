###
 * match_grid_item
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 07:43
###

define [
  'cs!views/game/info_bar'
  'cs!views/team/grid_item'
], ->
  App.MatchGridItemView = Em.ContainerView.extend
    classNames: ['match-grid-item']
    childViews: ['dateView', 'infoBarView', 'contentView']
    classNameBindings: ['content.isSelected']

    mouseEnter: ->
      node = @get 'content'
      while node
        node.set('isSelected', yes)
        node = node.get('parentNode')

    mouseLeave: ->
      node = @get 'content'
      while node
        node.set('isSelected', no)
        node = node.get('parentNode')

    dateView: App.EditableLabel.extend
      classNames: ['match-start-date']
      contentBinding: 'parentView.content.date'

      value: (->
        moment(@get 'content.date').format('DD.MM.YY')
      ).property('content')
#              template: Em.Handlebars.compile('{{moment view.content.date format=DD.MM.YY}}')

    infoBarView: App.GamesInfoBarView.extend
      contentBinding: 'parentView.content.games'
      showInfoLabel: yes
      classNames: ['match-info-bar']

    contentView: Em.CollectionView.extend
      classNames: ['match-grid-item']
      matchBinding: 'parentView.content'
      contentBinding: 'parentView.content.entrants'

      itemViewClass: App.TeamGridItemView

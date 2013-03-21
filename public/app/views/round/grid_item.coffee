###
 * grid_item
 * @author: actuosus
 * Date: 19/03/2013
 * Time: 16:08
###

define ['cs!views/team/grid_item'
        'cs!views/game/info_bar'
], ->
  App.RoundGridItemView = Em.ContainerView.extend
    classNames: ['tournament-round-container']
    childViews: ['nameView', 'contentView']

    nameView: App.EditableLabel.extend
      classNames: ['round-name']
      valueBinding: 'parentView.content.name'

    contentView: Em.CollectionView.extend
      classNames: ['tournament-round']
      roundBinding: 'content'
      contentBinding: 'parentView.content.matches'
      attributeBindings: ['title']

      titleBinding: 'parentView.content.itemIndex'

      itemViewClass: Em.ContainerView.extend
        classNames: ['tournament-match']
        childViews: ['dateView', 'infoBarView', 'connectorView', 'contentView']
        classNameBindings: ['content.isSelected']
        roundIndexBinding: 'parentView.parentView.contentIndex'

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

        didInsertElement: ->
#          console.log (@get 'content')
          height = 45
          match = @get 'content'
          if match.get('isWinner')
            @set 'connectorView.isVisible', no
            @set 'dateView.isVisible', no
            @set 'infoBarView.isVisible', no
          @$().css(height: height * 2)
          if @get('parentView.parentView.contentIndex') is 0
            if @get('contentIndex') is 0
              null
          else
            currentIndex = Math.pow(2, @get('roundIndex')) - 1
            if @get('contentIndex') is 0
              @$().css marginTop: currentIndex * height
            else
              @$().css marginTop: currentIndex * (height * 2)

        connectorView: Em.View.extend
          classNames: ['connector']
          template: Em.Handlebars.compile('<div class="one"></div><div class="another"></div>')
          contentIndexBinding: 'parentView.contentIndex'
          roundIndexBinding: 'parentView.roundIndex'
          didInsertElement: ->
            height = 45
            roundIndex = @get 'roundIndex'
            contentIndex = @get 'contentIndex'
            currentIndex = Math.pow(2, roundIndex)
            if contentIndex%2
              top = -(currentIndex * height) + height
              @$().addClass('diff')
            else
              top = 39
            @$().css {top: top, left: 156, height: currentIndex * height - (19/2)}

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

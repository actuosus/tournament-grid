###
 * tournament_grid_item
 * @author: actuosus
 * Date: 19/03/2013
 * Time: 16:08
###

define ['cs!../team/grid_item'
        'cs!../game/info_bar'
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
          lastNode = null
          while node
            unless Em.isEqual(node, lastNode)
              node.set('isSelected', yes)
              lastNode = node
              node = node.get('parentNode')
            else
              break

        mouseLeave: ->
          node = @get 'content'
          lastNode = null
          while node
            unless Em.isEqual(node, lastNode)
              node.set('isSelected', no)
              lastNode = node
              node = node.get('parentNode')
            else
              break

        didInsertElement: ->
#          console.log (@get 'content')
          height = 45
          match = @get 'content'
          roundIndex = @get('roundIndex')
          currentIndex = Math.pow(2, roundIndex) - 1
          if match.get('isWinner')
            @set 'connectorView.isVisible', no
            @set 'dateView.isVisible', no
            @set 'infoBarView.isVisible', no
          @$().css(height: height * 2)
#          console.log match.get('itemIndex'), match.get('round.itemIndex')
          if (match.get('itemIndex') is -1) and (match.get('round.itemIndex') is -1)
#            console.log currentIndex
            @$().css marginTop: Math.floor(match.get('round.stage.rounds.firstObject.matches.length')/2) * (height*2)
            return
          if @get('parentView.parentView.contentIndex') is 0
            if @get('contentIndex') is 0
              null
          else
            if @get('contentIndex') is 0
              @$().css marginTop: currentIndex * height
            else
              @$().css marginTop: currentIndex * (height * 2)

        connectorView: Em.View.extend
          classNames: ['connector']
          template: Em.Handlebars.compile('<div class="one"></div><div class="another"></div>')
          contentBinding: 'parentView.content'
          contentIndexBinding: 'parentView.contentIndex'
          roundIndexBinding: 'parentView.roundIndex'
          didInsertElement: ->
            height = 45
            roundIndex = @get 'roundIndex'
            contentIndex = @get 'contentIndex'
            currentIndex = Math.pow(2, roundIndex)

            match = @get 'content'

            console.log match.get('itemIndex'), match.get('round.itemIndex')

            if contentIndex%2
              top = -(currentIndex * height) + height
              @$().addClass('diff')
            else
              top = 39
            if (match.get('itemIndex') is 0) and (match.get('round.itemIndex') is 0)
              @$().css top: top, left: 156, height: 0
              return
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
#          shouldShowInfoLabel: (->
#            @get('content.length') > 0
#          ).property('content.length')
          showInfoLabel: yes
          classNames: ['match-info-bar']

        contentView: Em.CollectionView.extend
          classNames: ['match-grid-item-entrants']
          matchBinding: 'parentView.content'
          contentBinding: 'parentView.content.entrants'

          itemViewClass: App.TeamGridItemView

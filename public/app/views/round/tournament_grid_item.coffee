###
 * tournament_grid_item
 * @author: actuosus
 * Date: 19/03/2013
 * Time: 16:08
###

define ['cs!../team/grid_item_container'
        'cs!../game/info_bar'
], ->
  App.RoundGridItemView = Em.ContainerView.extend
    classNames: ['tournament-round-container']
    classNameBindings: ['content.isDirty']
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
        childViews: ['dateView', 'infoBarView', 'connectorView', 'contentView', 'saveButtonView']
        classNameBindings: ['content.isSelected', 'content.isFinal', 'content.isDirty']
        attributeBindings: ['title']
        roundIndexBinding: 'parentView.parentView.contentIndex'

        titleBinding: 'content.description'

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
          @_super()
#          console.log (@get 'content')
          height = 45
          match = @get 'content'
          roundIndex = @get('roundIndex')
          currentIndex = Math.pow(2, roundIndex) - 1
          contentIndex = @get('contentIndex')
#          console.log contentIndex
          if match.get('isWinner')
            @set 'connectorView.isVisible', no
            @set 'dateView.isVisible', no
            @set 'infoBarView.isVisible', no
          @$().css(height: height * 2)
#          console.log roundIndex
          if (match.get('itemIndex') is -1) and (match.get('round.itemIndex') is -1)
#            console.log currentIndex
            @$().css marginTop: Math.floor(match.get('round.stage.rounds.firstObject.matches.length')/2) * (height*2)
            return
          if roundIndex is 0
            if contentIndex is 0
              null
          else
            if contentIndex is 0
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
            @_super()
            height = 45
            roundIndex = @get 'roundIndex'
            contentIndex = @get 'contentIndex'
            currentIndex = Math.pow(2, roundIndex)

            match = @get 'content'

#            console.log match.get('itemIndex'), match.get('round.itemIndex')

            if contentIndex%2
              top = -(currentIndex * height) + height
              @$().addClass('diff')
            else
              top = 39
            if (match.get('itemIndex') is 0) and (match.get('round.itemIndex') is 0)
              @$().css top: top, left: 156, height: 0
              return
            if match.get('round.matches.length') is 1
              @$().css top: top, left: 156, height: 0
              return
            @$().css {top: top, left: 156, height: currentIndex * height - (19/2)}

        saveButtonView: Em.View.extend
          tagName: 'button'
          classNames: ['btn', 'btn-primary', 'btn-mini', 'save-btn', 'save']
          template: Em.Handlebars.compile '{{loc "_save"}}'
          isVisible: (->
            isEditingMode = App.get('isEditingMode')
            isDirty = @get 'parentView.content.isDirty'
            yes if isEditingMode and isDirty
          ).property('App.isEditingMode', 'parentView.content.isDirty')

          click: ->
            match = @get 'parentView.content'

            if match
              match.transaction.commit()

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

          itemViewClass: App.TeamGridItemContainerView.extend
            matchBinding: 'parentView.match'

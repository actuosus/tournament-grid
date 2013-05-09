###
 * tournament_grid_item
 * @author: actuosus
 * Date: 19/03/2013
 * Time: 16:08
###

define [
  'cs!../team/grid_item_container'
  'cs!../game/info_bar'
  'cs!../date_field'
], ->
  App.RoundGridItemView = Em.ContainerView.extend
    classNames: ['tournament-round-container']
    classNameBindings: ['content.isDirty']
    childViews: ['nameView', 'contentView']

    nameView: App.EditableLabel.extend
      classNames: ['round-name']
      valueBinding: 'parentView.content.name'
      isEditableBinding: 'App.isEditingMode'

    contentView: Em.CollectionView.extend
      classNames: ['tournament-round']
      roundBinding: 'content'
      contentBinding: 'parentView.content.matches'
      attributeBindings: ['title']

      titleBinding: 'parentView.content.itemIndex'

      entrantsNumberBinding: 'parentView.entrantsNumber'

      itemViewClass: Em.ContainerView.extend
        classNames: ['tournament-match']
        childViews: ['dateView', 'infoBarView', 'connectorView', 'contentView']#, 'saveButtonView'
        classNameBindings: ['content.isSelected', 'content.isFinal', 'content.isDirty']
        attributeBindings: ['title']
        roundIndexBinding: 'parentView.parentView.contentIndex'
        roundsBinding: 'parentView.parentView.parentView.content'
        entrantsNumberBinding: 'parentView.entrantsNumber'

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
          height = 45
          match = @get 'content'
          roundIndex = @get('roundIndex')
          currentIndex = Math.pow(2, roundIndex) - 1
          contentIndex = @get('contentIndex')
          if match.get('isFinal')
            @set 'connectorView.isVisible', no
            @set 'dateView.isVisible', no
            @set 'infoBarView.isVisible', no
          styles = {height: height * 2}

          bracket = match.get('round.bracket')

          if (match.get('itemIndex') is -1) and (match.get('round.itemIndex') is -1)
            console.debug 'Winner', @get('parentView.parentView.parentView.parentView.entrantsNumber')
            entrantsNumber = @get('parentView.parentView.parentView.parentView.entrantsNumber')
            roundsCount = Math.log(entrantsNumber) / Math.log(2)-1
            matchesCount = Math.pow(2, roundsCount)-1
            styles.marginTop = matchesCount/2 * (height*2)
            @$().css styles
            return
          if roundIndex is 0
            if contentIndex is 0
              null
          else
            if bracket
              unless bracket.get('isWinnerBracket')
                # TODO Revise weird formula
                currentIndex = Math.ceil(Math.pow(2, Math.floor((roundIndex-1)/2 + ((roundIndex-1)%2))) - 1)
                console.log 'Loser', roundIndex, currentIndex
            if contentIndex is 0
              styles.marginTop = currentIndex * height
            else
              styles.marginTop = currentIndex * (height * 2)

          @$().css styles

        connectorView: Em.View.extend
          classNames: ['connector']
          template: Em.Handlebars.compile('<div class="one"></div><div class="another"></div>')
          contentBinding: 'parentView.content'
          contentIndexBinding: 'parentView.contentIndex'
          roundIndexBinding: 'parentView.roundIndex'

          entrantsNumberBinding: 'parentView.entrantsNumber'

          didInsertElement: ->
            @_super()
            height = 45
            roundIndex = @get 'roundIndex'
            contentIndex = @get 'contentIndex'
            currentIndex = Math.pow(2, roundIndex)

            match = @get 'content'
            bracket = match.get('round.bracket')

            styles = {left: 156}

            if bracket
              # TODO Revise weird formula
              index = (n)-> Math.ceil(Math.pow(2, Math.floor((n)/2 + ((n)%2))) - 1)

              unless bracket.get('isWinnerBracket')
                currentIndex = index(roundIndex) - index(roundIndex-1)
                if match.get('round.itemIndex') is 0
                  entrantsNumber = @get('entrantsNumber')
                  console.log 'index(roundIndex-1)', index(roundIndex-1)
                  _height = (index(roundIndex-1) * height) + 30 + 13 + 20 + 15 + (entrantsNumber/2 * height) + 6
                  styles.top = -_height
                  styles.height = _height + 15 + 24
                  @$().addClass('diff')
                  @$().css styles
                  return
              else
                if match.get('round.itemIndex') is 0
                  entrantsNumber = @get('entrantsNumber')
                  styles.top = 39
                  styles.height = 0
                  styles.width = 181 * (Math.log(entrantsNumber) / Math.log(2) - 2) + 24
                  @$().css styles
                  return
            styles.height = currentIndex * height - (19/2)
            if contentIndex%2
              styles.top = -(currentIndex * height) + height
              @$().addClass('diff')
            else
              styles.top = 39
            if match.get('round.matches.length') is 1
              styles.height = 0

            @$().css styles

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
          isEditableBinding: 'App.isEditingMode'

          value: (->
            moment(@get 'content.date').format('DD.MM.YY')
          ).property('content')

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

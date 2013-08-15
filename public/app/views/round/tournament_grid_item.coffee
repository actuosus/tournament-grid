###
 * tournament_grid_item
 * @author: actuosus
 * Date: 19/03/2013
 * Time: 16:08
###

define [
  'cs!../team/grid_item_container'
  'cs!../game/info_bar'
  'cs!../match/grid_item'
], ->
  App.RoundGridItemView = Em.ContainerView.extend
    classNames: 'tournament-round-container'
    classNameBindings: ['content.isDirty']
    attributeBindings: ['title']
    childViews: ['titleView', 'contentView']
    titleBinding: 'content.sortIndex'

    titleView: App.EditableLabel.extend
      # TODO Rename to round-title in CSS
      classNames: ['round-name', 'round-title']
      contentBinding: 'parentView.content'
      valueBinding: 'content.title'
      isEditableBinding: 'App.isEditingMode'
      valueChanged: (->
        @set 'content.title', @get 'value'
        @get('content').save()
      ).observes('value')

    contentView: Em.CollectionView.extend
      classNames: ['tournament-round']
      roundBinding: 'content'
      contentBinding: 'parentView.content.matches'

      entrantsNumberBinding: 'parentView.entrantsNumber'

      didInsertElement: ->
        round = @get 'parentView.content'
#        console.log round
        roundIndex = round.get('sortIndex')
        bracketName = round.get 'bracketName'
        if bracketName is 'loser' and roundIndex%2
          @$().css('padding-top', 45)

      itemViewClass: App.MatchItemView.extend
        classNames: ['tournament-match']
        classNameBindings: ['content.isFinal']
        childViews: ['dateView', 'infoBarView', 'contentView', 'connectorView', 'lockView']
        roundIndexBinding: 'parentView.parentView.contentIndex'
        roundsBinding: 'parentView.parentView.parentView.content'
        entrantsNumberBinding: 'parentView.entrantsNumber'

        isEditable: (->
          App.get('isEditingMode') and (@get('content.status') is 'opened')
        ).property('App.isEditingMode', 'content.status')

        _isEditingBinding: 'isEditable'

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
          if match.get('isThirdPlace')
            @set 'connectorView.isVisible', no

          styles = {height: height * 2}
          bracket = match.get('round.bracket')

          if (match.get('itemIndex') is -1) and (match.get('round.itemIndex') is -1)
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

            styles = {left: 159}

            if bracket
              # TODO Revise weird formula
              index = (n)-> Math.ceil(Math.pow(2, Math.floor((n)/2 + ((n)%2))) - 1)

              entrantsNumber = @get('entrantsNumber')
              unless bracket.get('isWinnerBracket')
                currentIndex = index(roundIndex) - index(roundIndex-1)
                if match.get('round.itemIndex') is 0
                  _height = (index(roundIndex-1) * height) + 30 + 13 + 20 + 15 + (entrantsNumber/2 * height) + 6
                  styles.top = -_height
                  styles.height = _height + 15 + 24
                  @$().addClass('diff')
                  @$().css styles
                  return
              else
                if match.get('round.itemIndex') is 0
                  styles.top = 42
                  styles.height = 0
                  styles.width = 181 * (Math.log(entrantsNumber) / Math.log(2) - 2) + 24
                  @$().css styles
                  return
            styles.height = currentIndex * height - (19/2)
            if contentIndex%2
              styles.top = -(currentIndex * height) + height
              @$().addClass('diff')
            else
              styles.top = 42
            if match.get('round.matches.length') is 1
              styles.height = 0

            @$().css styles

        contentView: Em.CollectionView.extend
          classNames: ['match-grid-item-entrants']
          matchBinding: 'parentView.content'
          contentBinding: 'parentView.content.entrants'
          _isEditingBinding: 'parentView._isEditing'

          itemViewClass: App.TeamGridItemView.extend( App.Droppable, {
            matchBinding: 'parentView.parentView.content'
            _isEditingBinding: 'parentView._isEditing'

            pointsIsVisible: Em.computed.not 'match.isFinal'

            drop: (event)->
              viewId = event.originalEvent.dataTransfer.getData 'Text'
              view = Em.View.views[viewId]
              teamRef = view.get 'content'
              Em.run.next @, => @set 'content', teamRef.get('team')
              @_super event
          })

###
 * menu
 * @author: actuosus
 * Date: 18/03/2013
 * Time: 15:06
###

define ['cs!../core'],->
  App.MenuView = Em.CollectionView.extend
    classNames: ['menu']
    selection: null
    value: null

    eventDelegate: null

    click: (event)->
      eventDelegate = @get 'eventDelegate'
      if eventDelegate
        eventDelegate.click event

    selectionChanged: (->
      index = @get('content').indexOf @get 'selection'
      childViews = @get 'childViews'
      previouslySelected = childViews.filterProperty 'isSelected'
      if previouslySelected.length
        previouslySelected.forEach (item)-> item.set 'isSelected', no
      selected =  @get('content').objectAt(index)
      selectedView = childViews.objectAt(index)
      console.log selected

      if @$() and selectedView.$()
        @$().scrollTo(selectedView.$())
      selectedView.set('isSelected', yes) if selected
#      selected.set('isSelected', yes) if selected
    ).observes('selection')

    isVisibleChanged: (->
      target = @get 'target'
      $target = target.$()
      if target and $target
        offset = $target.offset()
        height = $target.height()
        offset.top += height
        @.$().css(offset)
        @.$().width($target.width())
    ).observes('isVisible')

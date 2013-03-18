###
 * menu
 * @author: actuosus
 * Date: 18/03/2013
 * Time: 15:06
###

define ->
  App.MenuView = Em.CollectionView.extend
    classNames: ['menu']
    selection: null
    selectionChanged: (->
      index = @get('content').indexOf @get 'selection'
      previouslySelected = @get('content').filterProperty 'isSelected'
      if previouslySelected.length
        previouslySelected.forEach (item)-> item.set 'isSelected', no
      selected =  @get('content').objectAt(index)
      console.log selected
      selected.set('isSelected', yes) if selected
    ).observes('selection')

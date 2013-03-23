###
 * list
 * @author: actuosus
 * Date: 23/03/2013
 * Time: 04:03
###

define ->
  App.GameListView = Em.CollectionView.extend
    classNames: ['game-list']
    itemViewClass: Em.View.extend
      classNames: ['game-list-item']
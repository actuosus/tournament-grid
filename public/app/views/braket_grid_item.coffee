###
 * braket_grid_item
 * @author: actuosus
 * Date: 15/03/2013
 * Time: 16:47
###

define ->
  App.BraketView = Em.ContainerView.extend
    childViews: ['nameView', 'contentView']
    nameView: Em.View.extend
      classNames: ['bracket-name']
    contentView: Em.CollectionView.extend
      classNames: ['bracket-items']
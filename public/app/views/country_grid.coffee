###
 * country_grid
 * @author: actuosus
 * Date: 04/06/2013
 * Time: 23:10
###

define ->
  App.CountryGridView = Em.CollectionView.extend
    classNames: 'country-grid'

    itemViewClass: App.CountryFlagView.extend
      classNames: 'country-grid-item'
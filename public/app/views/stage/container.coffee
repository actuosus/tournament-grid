###
 * container
 * @author: actuosus
 * Date: 07/06/2013
 * Time: 03:20
###

define [
  'cs!../named_container'
  'cs!./tabs'
], ->
  App.StagesContainerView = App.NamedContainerView.extend
    title: '_tournament_results_table'.loc()
    contentView: App.StageTabsView
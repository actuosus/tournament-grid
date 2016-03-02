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

    dump: ->
      url = "#{App.config.local.api.host}/#{App.config.local.api.namespace}/reports/#{window.grid.reportId}/dump"
      console.log 'Will send', @$().html()
      $.ajax
        url: url
        method: 'post'
        data: html: @$().html()
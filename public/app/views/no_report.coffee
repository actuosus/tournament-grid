###
 * no_report
 * @author: actuosus
 * Date: 02/07/2013
 * Time: 18:16
###

define ->
  App.NoReportView = App.NamedContainerView.extend
    title: 'No report'
    contentView: Em.View.extend
      template: Em.Handlebars.compile 'Cannot find report.'
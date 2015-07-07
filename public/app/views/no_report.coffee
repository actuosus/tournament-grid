###
 * no_report
 * @author: actuosus
 * Date: 02/07/2013
 * Time: 18:16
###

define ['cs!./named_container'], ->
  App.NoReportView = App.NamedContainerView.extend
    title: 'No report'
    contentView: Em.View.extend
      render: (_)-> _.push 'Cannot find report.'
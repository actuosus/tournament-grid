###
 * table_sorter
 * @author: actuosus
 * @fileOverview
 * Date: 01/02/2013
 * Time: 20:03
###

define ['cs!../core'],->
  App.TableSorterView = Em.View.extend
    classNames: ['table-sorter']

    template: Em.Handlebars.compile '''
      <i class="icon-chevron-down"></i><i class="icon-chevron-up"></i>')'''
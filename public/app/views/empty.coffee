###
 * empty
 * @author: actuosus
 * Date: 07/06/2013
 * Time: 03:51
###

define ->
  App.EmptyView = Em.View.extend
    classNames: ['empty-view']
    template: Em.Handlebars.compile '{{loc "_waiting_to_be_filled"}}'
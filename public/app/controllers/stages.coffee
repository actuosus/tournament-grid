###
 * stages
 * @author: actuosus
 * Date: 19/05/2013
 * Time: 20:09
###

define ->
  App.StagesController = Em.ArrayController.extend
    sortProperties: ['sortIndex', '']
    content: null
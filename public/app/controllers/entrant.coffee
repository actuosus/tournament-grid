###
 * entrant
 * @author: actuosus
 * Date: 01/04/2013
 * Time: 11:04
###

define [
  'cs!../core'
],->
  App.EntrantController = Em.ObjectController.extend
    gamesPlayed: 1
    wins: 2
    loses: 3

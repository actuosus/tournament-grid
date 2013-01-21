###
 * app
 * @author: actuosus
 * @fileOverview 
 * Date: 21/01/2013
 * Time: 07:31
###

require [
  'Faker'

  'cs!core'
  'cs!controllers'
  'cs!views'
  'cs!models'
], ->

  App.ApplicationController = Em.Controller.extend()
  App.ApplicationView = Em.View.extend
    templateName : 'application'

  $ -> App.initialize()

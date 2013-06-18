###
 * notifications
 * @author: actuosus
 * Date: 18/06/2013
 * Time: 17:16
###

define ->
  App.NotificationsController = Em.ArrayController.extend
    requestPermission: ->
      window.webkitNotifications.requestPermission()
    createNotification: (options)->
      if window.webkitNotifications.checkPermission() is 0
        window.webkitNotifications.createNotification(options.icon, options.title, options.content)
      else
        @requestPermission()
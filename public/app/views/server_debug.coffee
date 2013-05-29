###
 * server_debug
 * @author: actuosus
 * Date: 24/05/2013
 * Time: 22:56
###

define ->
  App.ServerDebugView = Em.ContainerView.extend
    classNames: ['server-debug-container']
    childViews: ['requestWaitIntervalView']

    requestWaitIntervalView: Em.View.extend
      template: Em.Handlebars.compile """
                                       <input type="range" min="0" max="1000" class="start" {{bindAttr value="view.start"}}/>
                                       <input type="range" min="1000" max="10000" class="end" {{bindAttr value="view.end"}}/>
                                       """
      didInsertElement: ->
        @$('.start').change => @set 'start', @$('.start').val()
        @$('.end').change => @set 'end', @$('.end').val()
      start: 0
      end: 0
      startChanged: (->
        console.log @get 'start'
        App.set 'debug.wait.start', @get 'start'
      ).observes('start')
      endChanged: (->
        console.log @get 'end'
        App.set 'debug.wait.end', @get 'end'
      ).observes('end')
###
 * loader
 * @author: actuosus
 * Date: 10/04/2013
 * Time: 04:59
###

define [
  'spin'
  'cs!../core'
], (Spinner)->
  App.LoaderView = Em.View.extend
    classNames: ['loader', 'non-selectable']
    isVisible: no
    attributeBindings: ['title']
    title: '_loading'.loc()
    isLoadingBinding: 'parentView.isLoading'

    didInsertElement: ->
      @_super()
      opts =
        lines: 15, # The number of lines to draw
        length: 2, # The length of each line
        width: 1, # The line thickness
        radius: 5, # The radius of the inner circle
        corners: 1, # Corner roundness (0..1)
        rotate: 0, # The rotation offset
        color: '#000', # #rgb or #rrggbb
        speed: 2, # Rounds per second
        trail: 60, # Afterglow percentage
        shadow: false, # Whether to render a shadow
        hwaccel: false, # Whether to use hardware acceleration
        className: 'spinner', # The CSS class to assign to the spinner
        zIndex: 2e9, # The z-index (defaults to 2000000000)
        top: 'auto', # Top position relative to parent in px
        left: 'auto' # Left position relative to parent in px
      spinner = new Spinner(opts).spin @get 'element'

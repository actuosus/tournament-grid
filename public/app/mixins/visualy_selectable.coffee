###
 * visualy_selectable
 * @author: actuosus
 * Date: 24/05/2013
 * Time: 08:08
###

define ->
  App.VisualySelectable = Em.Mixin.create
    maskView: null

    mouseDown: (event)->
      $(document.body).addClass 'non-selectable'
      $(document.body).bind('mousemove.selectable', @onDocumentMouseMove.bind(@))
      $(document.body).bind('mouseup.selectable', @mouseUp.bind(@))
      maskView = Em.View.create classNames: ['selection-mask']
      @startMousePosition =
        x: event.pageX
        y: event.pageY
      maskView.on 'didInsertElement', ->
        maskView.$().css(left: event.pageX + 1, top: event.pageY + 1)
      maskView.append()
      @set 'maskView', maskView

    onDocumentMouseMove: (event)->
      width = event.pageX - @startMousePosition.x
      height = event.pageY - @startMousePosition.y
      $maskView = @get('maskView').$()
      if width < 0
        $maskView.css 'left', @startMousePosition.x - Math.abs(width)
      else
        $maskView.css 'left', @startMousePosition.x
      if height < 0
        $maskView.css 'top', @startMousePosition.y - Math.abs(height)
      else
        $maskView.css 'top', @startMousePosition.y
      $maskView.css
        width: Math.abs(width)
        height: Math.abs(height)

      childViews = @get('selectableElementsView.childViews')
      if childViews
        @set('visualSelection', [])
        childViews.forEach (view)=>
          intersects = @intersects $maskView, view.$()
          if intersects
            @get('visualSelection').pushObject view.get 'content'
          view.set 'content.isVisualySelected', intersects

    visualSelection: []

    mouseUp: (event)->
      $(document.body).removeClass 'non-selectable'
      $(document.body).unbind 'mousemove.selectable'
      $(document.body).unbind 'mouseup.selectable'
      @get('maskView')?.destroy()

    mouseOut: (event)-> @mouseUp event

    getBoundingRect: (one, another)->
      oneX = one.offset().left
      oneY = one.offset().top
      anotherX = another.offset().left
      anotherY = another.offset().top
      left = Math.min(oneX, anotherX)
      right = Math.max(oneX+one.width(), anotherX+another.width())
      top = Math.min(oneY, anotherY)
      bottom = Math.max(oneY+one.height(), anotherY+another.height())
      {
        width: Math.abs(left - right)
        height: Math.abs(top - bottom)
      }

    intersects: (one, another)->
      bound = @getBoundingRect one, another
      (bound.width < one.width() + another.width()) and
      (bound.height < one.height() + another.height())

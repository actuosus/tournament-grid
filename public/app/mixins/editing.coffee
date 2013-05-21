###
 * editing
 * @author: actuosus
 * Date: 19/05/2013
 * Time: 21:22
###

define ->
  App.Editing = Ember.Mixin.create
    init: ->
      @_super()
      @setupEditing()

    setupEditing: ->
      isEditing = @get '_isEditing'
      @get('editingChildViews').forEach (viewName)=>
        if isEditing
          if typeof viewName is 'string'
            view = @get viewName
            view = @createChildView view
            @set viewName, view
          else
            view = @createChildView viewName
          @addObject view
        else
          view = @get viewName
          @removeObject view

    isEditingChanged: (->
      @setupEditing()
    ).observes '_isEditing'
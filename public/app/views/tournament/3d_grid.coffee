###
 * 3d_grid
 * @author: actuosus
 * Date: 19/03/2013
 * Time: 21:17
###

define ['three'], ->
  App.Tournament3DGridView = Em.View.extend
    classNames: ['3d-canvas']

    didInsertElement: ->
      @scene = new THREE.Scene();

    element: ->
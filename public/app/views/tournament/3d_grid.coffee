###
 * 3d_grid
 * @author: actuosus
 * Date: 19/03/2013
 * Time: 21:17
###

define ['three', 'cs!../../core'], ->
  App.Tournament3DGridView = Em.View.extend
    classNames: ['3d-canvas']

    content: null

    renderer: null
    scene: null
    camera: null

    createObjects: ->
      content = @get 'content'
      stage = content.objectAt(2)

      geometry = new THREE.CubeGeometry( 20, 20, 20 )
      stage.get('rounds').forEach (round, roundIndex)=>
        object = new THREE.Mesh( geometry, new THREE.MeshLambertMaterial( { color: Math.random() * 0xffffff } ) );

        object.position.x = roundIndex * 50;
#        object.position.y = roundIndex * 50;
#        object.position.z = Math.random() * 800 - 400;

#        object.rotation.x = Math.random() * 2 * Math.PI;
#        object.rotation.y = Math.random() * 2 * Math.PI;
#        object.rotation.z = Math.random() * 2 * Math.PI;

#        object.scale.x = Math.random() + 0.5;
#        object.scale.y = Math.random() + 0.5;
#        object.scale.z = Math.random() + 0.5;

        @scene.add object

    roundsLoaded: ->
      console.log 'roundsLoaded'
      @createObjects()

    stagesLoaded: ->
      console.log 'stagesLoaded'
      stages = @get 'report.stages'
      stage = stages.objectAt(2)
#      console.log stage
      if stage
        if stage.get('rounds.isLoaded')
          @roundsLoaded
        else
          stage.get('rounds').addObserver 'isLoaded', @, @roundsLoaded

    willInsertElement: ->
      @scene = new THREE.Scene()

      light = new THREE.DirectionalLight( 0xffffff, 2 )
      light.position.set( 1, 1, 1 ).normalize()
      @scene.add light

      light = new THREE.DirectionalLight( 0xffffff )
      light.position.set( -1, -1, -1 ).normalize()
      @scene.add light

#      geometry = new THREE.CubeGeometry( 20, 20, 20 )
#      for i in [0...2000]
#        object = new THREE.Mesh( geometry, new THREE.MeshLambertMaterial( { color: Math.random() * 0xffffff } ) );
#
#        object.position.x = Math.random() * 800 - 400;
#        object.position.y = Math.random() * 800 - 400;
#        object.position.z = Math.random() * 800 - 400;
#
#        object.rotation.x = Math.random() * 2 * Math.PI;
#        object.rotation.y = Math.random() * 2 * Math.PI;
#        object.rotation.z = Math.random() * 2 * Math.PI;
#
#        object.scale.x = Math.random() + 0.5;
#        object.scale.y = Math.random() + 0.5;
#        object.scale.z = Math.random() + 0.5;
#
#        @scene.add object
#      @createObjects()

      @projector = new THREE.Projector()
      @renderer = new THREE.WebGLRenderer antialias: yes

      content = @get 'content'
      stage = content.objectAt(2)
      if stage
        stage.get('rounds').addObserver '@each', @, @roundsLoaded
        if stage.get('rounds.isLoaded')
          @roundsLoaded
      else
        content.addObserver 'isLoaded', @, @stagesLoaded

    didInsertElement: ->
      @_super()
      height = 400
      width = @$().width()
      @$().height(height)

      @camera = new THREE.PerspectiveCamera( 80, width / height, 1, 3000 )
      @camera.position.set( 0, 300, 500 )

      @renderer.setSize( width, height )
      @$().append @renderer.domElement
      @animate()

    animate: ()->
      requestAnimationFrame(@animate.bind(@))
      @_render()

    mouse: {
      x: 0
      y: 0
    }

    mouseMove: (event)->
      @mouseX = event.clientX
      @mouseY = event.clientY

      @mouse.x = ( event.clientX / window.innerWidth ) * 2 - 1;
      @mouse.y = - ( event.clientY / window.innerHeight ) * 2 + 1;

    theta: 0
    radius: 100

    _render: ()->
      @theta += 0.4

      @camera.position.x = @radius * Math.sin( THREE.Math.degToRad( @theta ) );
      @camera.position.y = @radius * Math.sin( THREE.Math.degToRad( @theta ) );
      @camera.position.z = @radius * Math.cos( THREE.Math.degToRad( @theta ) );
      @camera.position.y += ( - @mouseY + 200 - @camera.position.y ) * .05
      @camera.lookAt @scene.position

      vector = new THREE.Vector3( @mouse.x, @mouse.y, 1 );
      @projector.unprojectVector( vector, @camera )

      raycaster = new THREE.Raycaster( @camera.position, vector.sub( @camera.position ).normalize() );

      intersects = raycaster.intersectObjects( @scene.children );

      if intersects.length > 0
        if INTERSECTED != intersects[ 0 ].object
          INTERSECTED.material.emissive.setHex( INTERSECTED.currentHex ) if INTERSECTED

          INTERSECTED = intersects[ 0 ].object
          INTERSECTED.currentHex = INTERSECTED.material.emissive.getHex()
          INTERSECTED.material.emissive.setHex( 0xff0000 )
      else
        INTERSECTED.material.emissive.setHex( INTERSECTED.currentHex ) if INTERSECTED
        INTERSECTED = null

      @renderer.render @scene, @camera
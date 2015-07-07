###
 * grid
 * @author: actuosus
 * Date: 04/07/2013
 * Time: 16:07
###

define [
  'cs!../../core'
  'cs!../round/tournament_grid_item'
  'cs!../../mixins/map_control'
], ->
  App.TournamentGridView = Em.ContainerView.extend App.MapControl,
    classNames: ['tournament-grid-container']

    childViews: ['toolboxView', 'contentView']

    toolboxView: Em.ContainerView.extend
      classNames: ['toolbox']
      childViews: ['resetButtonView', 'zoomInButtonView', 'zoomOutButtonView']

      mapViewBinding: 'parentView'

      zoomInButtonView: Em.View.extend
        tagName: 'button'
        classNames: ['btn-clean']
        mapViewBinding: 'parentView.mapView'
        render: (_)-> _.push '+'
        click: -> @get('mapView').zoomIn(animated = yes)

      zoomOutButtonView: Em.View.extend
        tagName: 'button'
        classNames: ['btn-clean']
        mapViewBinding: 'parentView.mapView'
        render: (_)-> _.push '-'
        click: -> @get('mapView').zoomOut(animated = yes)

      resetButtonView: Em.View.extend
        tagName: 'button'
        classNames: ['btn-clean']
        mapViewBinding: 'parentView.mapView'
        render: (_)-> _.push '☒'
        click: -> @get('mapView').reset(animated = yes)
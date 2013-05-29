###
 * table_popup
 * @author: actuosus
 * Date: 29/05/2013
 * Time: 18:12
###

define [
  'cs!./table'
  'cs!./popup_table_item'
], ->
  App.MatchTablePopupView = App.PopupView.extend
    classNames: ['small-popup', 'matches-table-popup']

    childViews: ['pastMatchesContainerView', 'futureMatchesContainerView']

    controller: null
    entrant: null

    pastMatches: (->
      @get('controller')?.pastMatchesForEntrant(@get('entrant'))
    ).property()

    futureMatches: (->
      @get('controller')?.futureMatchesForEntrant(@get('entrant'))
    ).property()

    pastMatchesContainerView: Em.ContainerView.extend
      isVisible: (-> !!@get('parentView.pastMatches.length')).property('parentView.pastMatches')
      classNames: ['section']
      controllerBinding: 'parentView.controller'
      entrantBinding: 'parentView.entrant'
      childViews: ['titleView', 'contentView']
      titleView: Em.View.extend
        classNames: ['section-header']
        template: Em.Handlebars.compile '{{loc _past_matches}}'
      contentView: App.MatchesTableView.extend
        controllerBinding: 'parentView.controller'
        entrantBinding: 'parentView.entrant'
        content: (->
          @get('controller')?.pastMatchesForEntrant(@get('entrant'))
        ).property()
        itemViewClass: App.MatchPopupTableItemView
    futureMatchesContainerView: Em.ContainerView.extend
      isVisible: (-> !!@get('parentView.futureMatches.length')).property('parentView.futureMatches')
      classNames: ['section']
      controllerBinding: 'parentView.controller'
      entrantBinding: 'parentView.entrant'
      childViews: ['titleView', 'contentView']
      titleView: Em.View.extend
        classNames: ['section-header']
        template: Em.Handlebars.compile '{{loc _future_matches}}'
      contentView: App.MatchesTableView.extend
        controllerBinding: 'parentView.controller'
        entrantBinding: 'parentView.entrant'
        content: (->
          @get('controller')?.futureMatchesForEntrant(@get('entrant'))
        ).property()
        itemViewClass: App.MatchPopupTableItemView
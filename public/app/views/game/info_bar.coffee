###
 * games_info_bar
 * @author: actuosus
 * @fileOverview
 * Date: 06/02/2013
 * Time: 05:30
###

define [
  'cs!./form'
  'cs!../match/form'
  'cs!../remove_button'
], ->
  App.GamesInfoBarView = Em.View.extend
    tagName: 'ul'
    classNames: ['games-info-bar']
    showInfoLabel: no
    isEditable: no
#    itemViewClass: Em.View.extend
#      tagName: 'li
    template: Em.Handlebars.compile """
      {{#if view.showInfoLabel}}
      <li class="games-info-bar-label">{{loc '_info'}}</li>
      {{/if}}
      {{#each view.content}}
        {{view view.itemViewClass contentBinding=this}}
      {{/each}}
      {{#if App.isEditingMode}}
      <li class="games-create-button" {{bindAttr title="view.addButtonTitle"}}><button class="btn-clean create-btn">+</button></li>
      {{/if}}
      """

    itemViewClass: Em.View.extend
      tagName: 'li'
      classNameBindings: ['isUpdating']
      template: Em.Handlebars.compile '<a target="_blank" {{bindAttr href="link" title="title"}}>{{view.content.contentIndex}}</a>'
      didInsertElement: -> console.log @get 'content'
#      click: ->


    addButtonTitle: (-> '_add_game'.loc()).property()

    click: (event)->
      if $(event.target).hasClass('games-create-button') or $(event.target).hasClass 'create-btn'
        popup = App.PopupView.create target: @
        popup.pushObject(
          App.GameForm.create
            popupView: popup
            match: @get('parentView.content')
            didCreate: => popup.hide()
        )
        popup.append()
      if $(event.target).hasClass('games-info-bar-label')
#        return unless @get 'isEditable'
        popup = App.PopupView.create target: @
        popup.pushObject(
          App.MatchForm.create
            popupView: popup
            match: @get('parentView.content')
            didCreate: => popup.hide()
        )
        popup.append()
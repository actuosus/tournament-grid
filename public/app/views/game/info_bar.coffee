###
 * games_info_bar
 * @author: actuosus
 * @fileOverview
 * Date: 06/02/2013
 * Time: 05:30
###

define ['cs!views/game/form'], ->
  App.GamesInfoBarView = Em.View.extend
    tagName: 'ul'
    classNames: ['games-info-bar']
    showInfoLabel: no
    template: Em.Handlebars.compile """
      {{#if view.showInfoLabel}}
      <li class="games-info-bar-label">{{loc '_info'}}</li>
      {{/if}}
      {{#each view.content}}
      <li {{bindAttr class="isUpdating"}}><a _target="blank" {{bindAttr href="link" title="name"}}>{{view.contentIndex}}</a></li>
      {{/each}}
      {{#if App.isEditingMode}}
      <li class="games-create-button"><button class="btn-clean create-btn">+</button></li>
      {{/if}}
      """
    click: (event)->
      if $(event.target).hasClass('games-create-button') or $(event.target).hasClass 'create-btn'
        popup = App.PopupView.create target: @
        popup.get('childViews').push(
                                      App.GameForm.create
                                        popupView: popup
                                        match: @get('parentView.content')
                                        didCreate: => popup.hide()
                                    )
        popup.append()
###
 * games_info_bar
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 05:30
###

define ->
  App.GamesInfoBarView = Em.View.extend
    tagName: 'ul'
    classNames: ['games-info-bar']
    showInfoLabel: no
    template: Em.Handlebars.compile '{{#if view.showInfoLabel}}<li class="games-info-bar-label">Инфо</li>{{/if}}{{#each view.content}}<li><a {{bindAttr href="link"}}>1</a></li>{{/each}}'
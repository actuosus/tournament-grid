###
 * cell
 * @author: actuosus
 * Date: 16/04/2013
 * Time: 21:27
###

define [
  'ember'
], (Ember)->
  App.TableHeaderCellView = Ember.View.extend
    tagName: 'th'
    classNames: ['table-header-cell']
    defaultTemplate: Ember.Handlebars.compile(
      '<div class="content">{{view.content.headerCellName}}</div>')
    column:         Ember.computed.alias 'content'
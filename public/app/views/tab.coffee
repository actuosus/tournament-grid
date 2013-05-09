###
 * tab
 * @author: actuosus
 * Date: 08/02/2013
 * Time: 01:43
###

define ->
  App.TabView = Em.ContainerView.extend
    classNames: ['tab-view']
    childViews: ['tabBarView', 'contentView']
    tabs: null

    # We already have currentView with Ember.ContainerView

    tabBarView: Em.View.extend
      classNames: ['tab-bar-view', 'i-listsTabs', 'i-listsTabs_bd']
      template: Em.Handlebars.compile '''
                                      <ul class="b-listsTabs">
                                      {{#each view.content}}
                                      {{view view.itemViewClass contentBinding=this}}
                                      {{/each}}
                                      </ul>
                                      '''

    contentView: Em.View.extend
      classNames: ['tab-content-view']
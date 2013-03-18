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
    current: null

    tabBarView: Em.View.extend
      classNames: ['tab-bar-view']

    contentView: Em.View.extend
      classNames: ['tab-content-view']
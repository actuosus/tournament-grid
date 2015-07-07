###
 * tab
 * @author: actuosus
 * Date: 08/02/2013
 * Time: 01:43
###

define ->
  App.TabView = Em.ContainerView.extend
    classNames: ['tab-view']
    childViews: ['tabBarView']

    selection: null

    tabBarView: Em.ContainerView.extend
      classNames: ['tab-bar-view', 'i-listsTabs', 'i-listsTabs_bd']
      childViews: ['tabsView']

      contentBinding: 'parentView.content'
      selectionBinding: 'parentView.selection'

      tabsView: Em.CollectionView.extend
        tagName: 'ul'
        classNames: 'b-listsTabs'
        contentBinding: 'parentView.content'
        selectionBinding: 'parentView.selection'
        itemViewClass: Em.ContainerView.extend
          tagName: 'li'
          classNames: ['item']
          classNameBindings: ['active']
          attributeBindings: ['tabIndex']
          tabIndexBinding: (-> @get('contentIndex')+1).property('contentIndex')
          childViews: ['titleView']
          selectionBinding: 'parentView.selection'

          router: (->
            @get('controller.container')?.lookup('router:main')
          ).property('controller')

          currentWhen: 'stage'

          active: (->
            router = @get 'router'
            content = @get 'content'
            return unless router
            currentWithIndex = @currentWhen + '.index'
            router.isActive.apply(router, [@currentWhen].concat(content)) or
            router.isActive.apply(router, [currentWithIndex].concat(content))
          ).property('namedRoute', 'router.url')

          routeChanged: (->
            @set 'selection', @ if @get 'active'
          ).observes('router.url')

          click: ->
            @set 'selection', @

            router = @get 'router'
            router.transitionTo @currentWhen, @get 'content' if router

          isActive: (->
            Em.isEqual @get('selection'), @
          ).property('selection')

          titleView: Em.View.extend
            idChanged: (-> @rerender() ).observes('parentView.content.id')
            render: (_)-> _.push @get 'parentView.content.id'

    selectionChanged: (->
      if @get 'selection'
        id = @get('selection.content.id')
        Em.View.create render: (_)-> _.push id
      else
        Em.View.create()
    ).observes('selection')
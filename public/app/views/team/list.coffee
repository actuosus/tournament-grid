###
 * list
 * @author: actuosus
 * Date: 24/05/2013
 * Time: 07:14
###

define ->
  App.TeamListView = Em.ContainerView.extend
    childViews: ['searchBarView', 'contentView']
    searchBarView: Em.ContainerView.extend
      classNames: ['search-bar']
      childViews: ['textFieldView', 'clearButtonView']

      clearButtonView: Em.View.extend
        tagName: 'button'
        isVisibleBinding: 'parentView.textFieldView.isNotClearValue'
        classNames: ['btn-clean', 'remove-btn', 'remove']
        attributeBindings: ['title']
        title: '_remove'.loc()
        render: (_)-> _.push '×'

        click: -> @set('parentView.textFieldView.value', '')

      textFieldView: Em.TextField.extend
        classNames: ['search-field']
        placeholder: '_filter'.loc()
        keyUp: (event)->
          switch event.keyCode
            when 27 then @set 'value', ''
        isNotClearValue: (-> !!@get('value')).property('value')
        valueChanged: (->
          if @get 'value'
            @set 'isNotClearValue', yes
          else
            @$().val('')
            @$().focus()
            @set 'isNotClearValue', no
          @set('parentView.parentView.controller.searchQuery', @get 'value')
        ).observes('value')
    contentView: Em.CollectionView.extend
      contentBinding: 'parentView.content'
      itemViewClass: Em.View.extend({
        nameChanged: (-> @rerender() ).observes('content.team.name')
        render: (_)-> _.push @get 'content.team.name'
      })

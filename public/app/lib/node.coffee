###
 * node
 * @author: actuosus
 * Date: 06/04/2013
 * Time: 21:18
###

define ['cs!../core'], ->
  App.Node = Em.Object.extend
    left: null
    right: null
    parent: null

    treeItemChildren: (->
      left = @get('left')
      right = @get('right')
      if left and right
        [left, right]
      else if left and not right
        [left]
      else if right and not left
          [left]
    ).property('left', 'rigth')

    content: null

    name:(->
      @get 'content'
    ).property('content')
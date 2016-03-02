###
 * dump
 * @author: actuosus
 * @fileOverview
 * Date: 13/08/2015
 * Time: 17:56
###

define [], ->
  App.DumpView = Em.View.extend
    classNames: ['dump', 'block-container', 'named-container']
    render: (_)->
      _.push @get 'controller.model'

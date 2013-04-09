###
 * tree_test
 * @author: actuosus
 * Date: 01/04/2013
 * Time: 07:01
###

define [
  'cs!./core'
  'cs!./views/tree'
], ->
    App.Folder = Ember.Object.extend({
      treeItemIsExpanded: yes,  # Default to not expanded
      name: null
    });

    App.File = Ember.Object.extend({
      name: null
    });

    App.someController = Ember.Object.create({
      tree: [
        App.Folder.create({
          name: 'Folder 1',
          treeItemChildren: [
            App.File.create({ name: 'File 1' }),
            App.File.create({ name: 'File 2' }),
            App.File.create({ name: 'File 3' })
          ]
        }),
        App.Folder.create({
          name: 'Folder 2', treeItemChildren: []
        }),
        App.Folder.create({
          name: 'Folder 3',
          treeItemChildren: [
            App.Folder.create({
              name: 'My pictures',
              treeItemChildren: [
                App.File.create({ name: 'File 1' }),
                App.File.create({ name: 'File 2' })
              ]
            }),
            App.File.create({ name: 'File 5' })
          ]
        }),
      ]
    });

    treeView = App.TreeView.create contentBinding: 'App.someController.tree'
    treeView.appendTo '#content'
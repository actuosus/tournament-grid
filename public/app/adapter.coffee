###
 * adapter
 * @author: actuosus
 * Date: 24/04/2013
 * Time: 10:57
###

define [
  'cs!./core'
], ->

  get = Em.get
  set = Em.set

  DS.Store.reopen


  Node = (@reference)->
    @record = reference.record
    @dirtyType = get @record, 'dirtyType'
    @children = Ember.Set.create()
    @parents = Ember.Set.create()

  Node.prototype =
    addChild: (childNode)->
      @children.add childNode
      childNode.parents.add @

    isRoot: -> @parents.every (_)-> not get(_, 'record.isDirty') and _.isRoot()

  App.Adapter = DS.RESTAdapter.extend
    bulkCommit: no

    save: (store, commitDetails)->
      if get(@, 'bulkCommit') isnt false
        return @saveBulk(store, commitDetails)

      adapter = @

      rootNodes = this._createDependencyGraph(store, commitDetails)

      createNestedPromise = (node)->
        if not adapter.shouldSave(node.record) or not node.dirtyType
          promise = Ember.RSVP.resolve()
        else if node.dirtyType is "created"
          promise = adapter.createRecord(store, node.reference.type, node.record)
        else if node.dirtyType is "updated"
          promise = adapter.updateRecord(store, node.reference.type, node.record)
        else if node.dirtyType is "deleted"
          promise = adapter.deleteRecord(store, node.reference.type, node.record)
        if node.children.length > 0
          promise = promise.then(->
            childPromises = node.children.map(createNestedPromise)
            Ember.RSVP.all childPromises
          )
        return promise

      return Ember.RSVP.all(rootNodes.map(createNestedPromise))

    shouldPreserveDirtyRecords: (relationship)-> relationship.kind is 'hasMany'

    _createDependencyGraph: (store, commitDetails)->
      adapter = @
      referenceToNode = Ember.MapWithDefault.create
        defaultValue: (reference)-> new Node reference

      commitDetails.relationships.forEach (r)->
        childNode = referenceToNode.get(r.childReference)
        parentNode = referenceToNode.get(r.parentReference)

        # In the non-embedded case, there is a potential request race
        # condition where the parent returns the id of a deleted child.
        # To solve for this we make the child delete complete first.
        if r.changeType is 'remove' and adapter.shouldSave(childNode.record) and adapter.shouldSave(parentNode.record)
          childNode.addChild(parentNode)
        else
          parentNode.addChild(childNode)

      rootNodes = Ember.Set.create()
      filter = (record)->
        node = referenceToNode.get(get(record, '_reference'))
        rootNodes.add(node) if node.isRoot()

      commitDetails.created.forEach filter
      commitDetails.updated.forEach filter
      commitDetails.deleted.forEach filter

      rootNodes
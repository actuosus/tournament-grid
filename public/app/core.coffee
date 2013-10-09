###
 * core
 * @author: actuosus
 * @fileOverview Application preconfiguration.
 * Date: 21/01/2013
 * Time: 07:32
###

define [
  'jquery.cookie'
  'ember'
  'ember-data'
  'cs!./locales/index'
  'cs!./config'
#  'cs!lib/array'
] , (cookie, ember, emberData, locales, config)->
  window.onerror = (errorMsg, url, lineNumber)->
    data =
      log:
        message: errorMsg
        date: new Date()
        data:
          url: url
          lineNumber: lineNumber
    $.ajax('/api/logs', {
      data: JSON.stringify(data)
      contentType : 'application/json'
      type: 'POST'
    })

  lang = config.currentLanguage or $.cookie 'lang'

  localize = (language)->
    language ?= (window.navigator.userLanguage or window.navigator.language).substring(0, 2)
    Em.STRINGS = locales[language]
    lang = language

  localize lang

  TournamentGrid = Em.Namespace.create

  appConfig =
    VERSION: '0.1'
    autoinit: false
    Store: DS.Store
    customEvents:
      mousewheel: 'mouseWheel'

  appConfig.rootElement = config.rootElement if config.rootElement

  Em.EventDispatcher.reopen(
    events: {
#      touchstart  : 'touchStart',
#      touchmove   : 'touchMove',
#      touchend    : 'touchEnd',
#      touchcancel : 'touchCancel',
      keydown     : 'keyDown',
      keyup       : 'keyUp',
#      keypress    : 'keyPress',
      mousedown   : 'mouseDown',
      mouseup     : 'mouseUp',
      contextmenu : 'contextMenu',
      click       : 'click',
      dblclick    : 'doubleClick',
      mousemove   : 'mouseMove',
      focusin     : 'focusIn',
      focusout    : 'focusOut',
      mouseenter  : 'mouseEnter',
      mouseleave  : 'mouseLeave',
      submit      : 'submit',
      input       : 'input',
      change      : 'change',
      dragstart   : 'dragStart',
      drag        : 'drag',
      dragenter   : 'dragEnter',
      dragleave   : 'dragLeave',
      dragover    : 'dragOver',
      drop        : 'drop',
      dragend     : 'dragEnd'
    }
  )
  App = Em.Application.create appConfig

  if window.DEBUG
    App.LOG_TRANSITIONS = yes
    App.LOG_TRANSITIONS_INTERNAL = yes
    App.LOG_VIEW_LOOKUPS = yes
  App.deferReadiness()

  window.TournamentGrid = TournamentGrid
  window.App = App

  DS.RESTAdapter.configure 'plurals',
    country: 'countries'
    match: 'matches'

  DS.RESTAdapter.map 'App.Report',
    races: embedded: 'always'

  DS.JSONTransforms.object =
    serialize: (deserialized)->
      unless Em.isNone(deserialized)
        if deserialized.keys and deserialized.values
          o = {}
          deserialized.forEach (key, value)->
            o[key] = value
          return o
      if Em.isNone(deserialized) then {} else deserialized

    deserialize: (serialized)->
      if Em.isNone(serialized) then {} else serialized

  DS.JSONTransforms.string =
    deserialize: (serialized)->
      if Em.isNone(serialized) then null else String(serialized)

    serialize: (deserialized)->
      if Em.isNone(deserialized) then null else String(deserialized)

  DS.JSONTransforms.date =
    deserialize: (serialized)->
      type = typeof serialized
      if type is 'string'
        if type is ''
          return null
        else
          return new Date Ember.Date.parse serialized
      else if type is 'number'
        return new Date serialized
      else if serialized is null or serialized is undefined
        return serialized
      else
        return null

    serialize: (date)->
      if date instanceof Date
        days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

        pad = (num)-> if num < 10 then "0"+num else ""+num

        utcYear = date.getUTCFullYear()
        utcMonth = date.getUTCMonth()
        utcDayOfMonth = date.getUTCDate()
        utcDay = date.getUTCDay()
        utcHours = date.getUTCHours()
        utcMinutes = date.getUTCMinutes()
        utcSeconds = date.getUTCSeconds()

        dayOfWeek = days[utcDay]
        dayOfMonth = pad(utcDayOfMonth)
        month = months[utcMonth]

        dayOfWeek + ", " + dayOfMonth + " " + month + " " + utcYear + " " +
          pad(utcHours) + ":" + pad(utcMinutes) + ":" + pad(utcSeconds) + " GMT"
      else
        return null

  App.Adapter = DS.RESTAdapter.extend
    bulkCommit: no

    shouldSave: -> yes

    waitForParents: (record, callback, context, args)->
      observers = new Ember.Set()

      record.eachRelationship (name, meta)->
        relationship = record.cacheFor name

        if meta.kind is 'belongsTo' and relationship and Em.get(relationship, 'isNew')
          observer = ->
            relationship.removeObserver('id', context, observer)
            observers.remove(name)
            finish()

          relationship.addObserver('id', context, observer)
          observers.add name

      finish = -> callback.apply(context, args) if observers.length is 0
      finish()

    createRecord: (store, type, record)->
      sup = @_super
      @waitForParents record, sup, @, arguments

    updateRecord: (store, type, record)->
      sup = @_super
      @waitForParents record, sup, @, arguments

    serializer: DS.JSONSerializer.extend
      keyForAttributeName: (type, name)-> Ember.String.decamelize name
      keyForBelongsTo: (type, name)->
        key = @keyForAttributeName type, name
        if @embeddedType(type, name)
          return key
        key + '_id'

      extractBelongsToPolymorphic: (type, hash, key)->
        keyForId = @keyForPolymorphicId key
        id = hash[keyForId]

        if id
          keyForType = @keyForPolymorphicType key
          hashType = hash[keyForType]
          # Hacky thing to resolve match
          if key is 'entrant1_id' or key is 'entrant2_id' or key is 'entrant_id'
            matchType = App.get('report.match_type')
            if matchType is 'player'
              hashType = 'players'
            else
              if key is 'entrant_id' and App.ResultSet.detect type
                hashType = 'team_refs'
              else
                hashType = 'teams'
          return {id: id, type: hashType}
        return null

    didCreateRecord: (store, type, record, payload)->
      @_super(store, type, record, payload)
      App.get('socketController').socket.emit 'message', JSON.stringify
        action: 'create'
        model: type.toString()
        _id: @serializer.extractId(type, payload[@serializer.rootForType(type)])

    didUpdateRecord: (store, type, record, payload)->
      @_super(store, type, record, payload)
      App.get('socketController').socket.emit 'message', JSON.stringify
        action: 'update'
        model: type.toString()
        _id: @serializer.extractId(type, payload[@serializer.rootForType(type)])

    didDeleteRecord: (store, type, record, payload)->
      @_super(store, type, record, payload)
      App.get('socketController').socket.emit 'message', JSON.stringify
        action: 'remove'
        model: type.toString()
        _id: @serializer.extractId(type, payload[@serializer.rootForType(type)])


  App.store = App.Store.create
#    revision: 12
    adapter: App.Adapter.create()

  App.store.adapter.url = config.api.host
  App.store.adapter.namespace = config.api.namespace
  App.store.adapter.serializer.primaryKey = -> '_id'
  App.store.adapter.serializer.configure {pageCount: 'pageCount'}

  App.store.adapter.dirtyRecordsForHasManyChange = (dirtySet, record, relationship)->
    embeddedType = @get('serializer').embeddedType(record.constructor, relationship.secondRecordName)

    if embeddedType is 'always'
      relationship.childReference.parent = relationship.parentReference
      @_dirtyTree dirtySet, record

#  App.store = App.__container__.lookup('store:main')

  App.store.adapter.url = config.api.host
  App.store.adapter.namespace = config.api.namespace
  App.store.adapter.serializer.primaryKey = -> '_id'
  App.store.adapter.serializer.configure {pageCount: 'pageCount'}

  App.store.adapter.dirtyRecordsForHasManyChange = (dirtySet, record, relationship)->
    embeddedType = @get('serializer').embeddedType(record.constructor, relationship.secondRecordName)

    if embeddedType is 'always'
      relationship.childReference.parent = relationship.parentReference
      @_dirtyTree dirtySet, record

    if relationship.secondRecordName is "matches"
      relationship.childReference.parent = relationship.parentReference;
#      @_dirtyTree(dirtySet, record);
      dirtySet.add record

#
  App.overrideAdapterAjax = (report)->
    App.store.adapter.ajax = (url, type, hash)->
      adapter = @
      new Ember.RSVP.Promise (resolve, reject)->
        hash = hash or {}
        hash.url = url
        hash.type = type
        hash.dataType = 'json'
        hash.contentType = 'application/json; charset=utf-8'
        hash.context = adapter

        if hash.data
          if type isnt 'GET'
            hash.url += "?report_id=#{report.get 'id'}"
#            if App.debug?.wait?
#              hash.url += '&' + jQuery.param({start: App.get('debug.wait.start'), end: App.get('debug.wait.end')})
            hash.data = JSON.stringify hash.data
          else
            hash.data.report_id = report.get 'id'
        else
          hash.url += "?report_id=#{report.get 'id'}"
#          if App.debug?.wait?
#            hash.url += '&' + jQuery.param({start: App.get('debug.wait.start'), end: App.get('debug.wait.end')})

        hash.success = (json)->
          Ember.run(null, resolve, json)

        hash.error = (jqXHR, textStatus, errorThrown)->
          Ember.run(null, reject, jqXHR)

        Ember.$.ajax(hash);

  App.config =
    local:
      api:
        host: ''
        namespace: 'api'
    remote: config

#  if window.grid.
#  $.ajaxSetup
#    username: 'virtus'
#    password: 'snegi'

  App.currentConfig = 'local'

  App.toggleConfig = ->
    if App.currentConfig is 'local'
      App.currentConfig = 'remote'
    else
      App.currentConfig = 'local'
    switch App.currentConfig
      when 'local'
        App.store.adapter.url = App.config.local.api.host
        App.store.adapter.namespace = App.config.local.api.namespace
      when 'remote'
        App.store.adapter.url = App.config.remote.api.host
        App.store.adapter.namespace = App.config.remote.api.namespace


  # Localization configuration
  App.languages = Em.ArrayController.create content: config.languages
  App.set 'currentLanguage', lang

  App.isAuthorized = (options)->
    $.ajax
      url: "/API/reportage/auth.php"
      type: 'GET'
      success: (data)->
        options.success() if data?.authorized
      error: options.failure

  App.LanguageObserver = Em.Object.extend
    currentLanguageChanged: (->
      localize App.get('currentLanguage')
    ).observes('App.currentLanguage')

  App.languageObserver = App.LanguageObserver.create()

  $.datepicker?.setDefaults $.datepicker.regional[App.get('currentLanguage')]
  $.timepicker?.setDefaults $.timepicker.regional[App.get('currentLanguage')]

  App.animation =
    duration: 300

  App.set 'debug', Em.Object.create({
    wait:
      start: 1000
      end: 3000
  })

  App
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

  # Ember.onerror = (error)-> throw error

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
    ApplicationStore: DS.Store
    customEvents:
      mousewheel: 'mouseWheel'

  appConfig.rootElement = config.rootElement if config.rootElement

  Em.EventDispatcher.reopen
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

  App = Em.Application.create appConfig

  if window.DEBUG
    App.LOG_TRANSITIONS = yes
    App.LOG_TRANSITIONS_INTERNAL = yes
    App.LOG_VIEW_LOOKUPS = yes
  App.deferReadiness()

  window.TournamentGrid = TournamentGrid
  window.App = App

  App.ObjectTransform = DS.Transform.extend
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

#  DS.JSONTransforms.string =
#    deserialize: (serialized)->
#      if Em.isNone(serialized) then null else String(serialized)
#
#    serialize: (deserialized)->
#      if Em.isNone(deserialized) then null else String(deserialized)

#  DS.JSONTransforms.date =
#    deserialize: (serialized)->
#      type = typeof serialized
#      if type is 'string'
#        if serialized is ''
#          return null
#        else
#          return new Date Ember.Date.parse serialized
#      else if type is 'number'
#        return new Date serialized
#      else if serialized is null or serialized is undefined
#        return serialized
#      else
#        return null
#
#    serialize: (date)->
#      if date instanceof Date
#        days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
#        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
#
#        pad = (num)-> if num < 10 then "0"+num else ""+num
#
#        utcYear = date.getUTCFullYear()
#        utcMonth = date.getUTCMonth()
#        utcDayOfMonth = date.getUTCDate()
#        utcDay = date.getUTCDay()
#        utcHours = date.getUTCHours()
#        utcMinutes = date.getUTCMinutes()
#        utcSeconds = date.getUTCSeconds()
#
#        dayOfWeek = days[utcDay]
#        dayOfMonth = pad(utcDayOfMonth)
#        month = months[utcMonth]
#
#        dayOfWeek + ", " + dayOfMonth + " " + month + " " + utcYear + " " +
#          pad(utcHours) + ":" + pad(utcMinutes) + ":" + pad(utcSeconds) + " GMT"
#      else
#        return null

  App.ApplicationSerializer = DS.JSONSerializer.extend DS.EmbeddedRecordsMixin,
    primaryKey: '_id'
    attrs:
      matches: { embedded: 'always' }
    keyForAttribute: (key)-> Em.String.decamelize key
    keyForAttributeName: (type, name)-> debugger; Ember.String.decamelize name
    keyForBelongsTo: (type, name)->
      key = @keyForAttributeName type, name
      if @embeddedType(type, name)
        return key
      key + '_id'
    keyForRelationship: (key, type)->
      if type is 'belongsTo'
        key = Em.String.decamelize key + '_id'
      else
        key = Em.String.decamelize key

      return key

    serializeIntoHash: (hash, type, snapshot, options)->
      root = Ember.String.decamelize(type.typeKey)
      hash[root] = this.serialize(snapshot, options)

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

    extractArray: (store, type, arrayPayload, id, requestType)->
      arrayPayload = arrayPayload[Em.String.decamelize(Em.String.pluralize(type.typeKey))]
      return @_super(store, type, arrayPayload, id, requestType)

    extractSingle: (store, type, payload, id, requestType)->
      payload = @normalizePayload(payload)
      payload = payload[Em.String.decamelize(type.typeKey)]
      return @normalize(type, payload)

  App.ReportSerializer = App.ApplicationSerializer.extend
    attrs: teamRefs: embedded: 'always'

  App.TeamSerializer = App.ApplicationSerializer.extend
    attrs:
      players: embedded: 'always', serialize: 'ids'

  App.TeamRefSerializer = App.ApplicationSerializer.extend
    attrs:
      team: embedded: 'always', serialize: 'ids'
      players: embedded: 'always'

  App.RoundSerializer = App.ApplicationSerializer.extend
    attrs:
      matches: embedded: 'always', serialize: 'ids'
      resultSets: embedded: 'always', serialize: 'ids'

  App.MatchSerializer = App.ApplicationSerializer.extend
    attrs:
      games: embedded: 'always', serialize: 'ids'

  App.ApplicationAdapter = DS.RESTAdapter.extend
    namespace: config.api.namespace

    bulkCommit: no
    coalesceFindRequests: yes

    shouldSave: -> yes

#    buildURL: (record, suffix)->
#      url = [this.url]
#
#      Ember.assert("Namespace URL (" + this.namespace + ") must not start with slash", !this.namespace || this.namespace.toString().charAt(0) isnt "/");
#      Ember.assert("Record URL (" + record + ") must not start with slash", !record || record.toString().charAt(0) isnt "/");
#      Ember.assert("URL suffix (" + suffix + ") must not start with slash", !suffix || suffix.toString().charAt(0) isnt "/");
#
#      if !Ember.isNone(this.namespace)
#        url.push(this.namespace)
#
#      url.push(Em.String.decamelize(Em.String.pluralize(record)))
#      if suffix isnt undefined
#        url.push(suffix)
#
##      if record is 'report'
##        console.log url
##        url = [this.url, 'API/reportage/reportage_new.php?ID=' + suffix]
##
##      if record is 'round'
##        console.log url
##        url = [this.url, 'API/reportage/rounds_new.php']
#
#      return url.join("/")

    pathForType: (type)-> Em.String.decamelize(Em.String.pluralize(type))

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

  App.overrideAdapterAjax = (report)->
#    App.store.adapter.ajax = (url, type, hash)->
#      adapter = @
#      new Ember.RSVP.Promise (resolve, reject)->
#        hash = hash or {}
#        hash.url = url
#        hash.type = type
#        hash.dataType = 'json'
#        hash.contentType = 'application/json; charset=utf-8'
#        hash.context = adapter
#
#        if hash.data
#          if type isnt 'GET'
#            hash.url += "?report_id=#{report.get 'id'}"
##            if App.debug?.wait?
##              hash.url += '&' + jQuery.param({start: App.get('debug.wait.start'), end: App.get('debug.wait.end')})
#            hash.data = JSON.stringify hash.data
#          else
#            hash.data.report_id = report.get 'id'
#        else
#          hash.url += "?report_id=#{report.get 'id'}"
##          if App.debug?.wait?
##            hash.url += '&' + jQuery.param({start: App.get('debug.wait.start'), end: App.get('debug.wait.end')})
#
#        hash.success = (json)->
#          Ember.run(null, resolve, json)
#
#        hash.error = (jqXHR, textStatus, errorThrown)->
#          Ember.run(null, reject, jqXHR)
#
#        Ember.$.ajax(hash);

  App.config =
    local:
      api:
        host: ''
        namespace: 'api'
    remote: config

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
      url: App.config.remote.authUrl
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

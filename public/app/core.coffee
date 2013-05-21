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
  'cs!./locales'
  'cs!./config'
#  'cs!lib/array'
] , (cookie, ember, emberData, locales, config)->
#  window.onerror = (errorMsg, url, lineNumber)->
#    data =
#      log:
#        message: errorMsg
#        date: new Date()
#        data:
#          url: url
#          lineNumber: lineNumber
#    $.ajax('/api/logs', {
#      data: JSON.stringify(data)
#      contentType : 'application/json'
#      type: 'POST'
#    })

  lang = $.cookie 'lang'

  localize = (language)->
    language ?= (window.navigator.userLanguage or window.navigator.language).substring(0, 2)
    Em.STRINGS = locales[language]
    lang = language

  localize lang

  ###
   * Localization Handlebars helper.
  ###
  Em.Handlebars.registerHelper 'loc', (property, fn)->
    if fn.contexts and typeof fn.contexts[0] is 'string'
      str = fn.contexts[0]
    else if property[0] is '_'
      str = property
    else if /[A-Z]/.test property[0]
      str = Em.get window, property
    else
      str = this.get property
    new Handlebars.SafeString (str || '').loc('')

  Em.Handlebars.registerBoundHelper '_loc', (value, options)->
#    console.log arguments
    if options.contexts and typeof options.contexts[0] is 'string'
      str = options.contexts[0]
    else if typeof value is 'object'
      str = value[App.currentLanguage]
    else if value is '_'
      str = value
    else if /[A-Z]/.test value
      str = Em.get window, value
    else
      str = this.get "_#{value}.#{App.currentLanguage}"
    new Handlebars.SafeString (str || '').loc('')

  Ember.Handlebars.registerBoundHelper 'moment', (value, options)->
    new Handlebars.SafeString(moment(value).format(options.hash.format))

  Ember.Handlebars.registerBoundHelper 'highlight', (value, options)->
    if options.hash?.partBinding
      part = options.data.view.get options.hash.partBinding
      re = new RegExp(part, 'gi')
      match = value.match(re)

      if part and match
        value = value.replace re, (substring, position, string)->
          "<span class=\"highlight\">#{substring}</span>"
      else
        value = Handlebars.Utils.escapeExpression value
    else
      value = Handlebars.Utils.escapeExpression value
    new Handlebars.SafeString value

  TournamentGrid = Em.Namespace.create

  App = Em.Application.create
    VERSION: '0.1'
    autoinit: false
    LOG_TRANSITIONS: true
#    rootElement: '#content'
    customEvents:
      mousewheel: 'mouseWheel'
  App.deferReadiness()

  window.TournamentGrid = TournamentGrid
  window.App = App

  DS.RecordArray.reopen
    onLoad: (callback)->
      if @get 'isLoaded'
        callback this
      else
        that = @
        isLoadedFn = ->
          if that.get 'isLoaded'
            that.removeObserver 'isLoaded', isLoadedFn
            callback that
      @addObserver 'isLoaded', isLoadedFn
      @

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

#  DS.StateManager.reopen
#    enterState: (transition)->
#      @_super(transition)
#      console.log @, arguments, @get 'currentState'
#
#      record = @record
#      currentState = @get 'currentState'
#
#      switch currentState.name
#        when 'uncommitted'
#          localStorage.setItem 'boo', JSON.stringify record._data

  App.store = DS.Store.create
    revision: 11
    adapter: DS.RESTAdapter.create
      bulkCommit: no

  App.store.adapter.url = config.api.host
  App.store.adapter.namespace = config.api.namespace

  App.store.adapter.serializer.primaryKey = -> '_id'
#  App.store.adapter.serializer.keyForAttributeName = (type, name)->
##    console.log arguments
#    console.log type.metaForProperty name
#    name
#  App.store.adapter.serializer.extractAttribute = (type, hash, attributeName)->
#    console.log arguments
#    key = this._keyForAttributeName(type, attributeName)
#    hash[key]
#  App.store.adapter.materializeAttribute = (record, serialized, attributeName, attributeType)->
#    value = this.extractAttribute(record.constructor, serialized, attributeName);
#    value = this.deserializeValue(value, attributeType);
#
#    record.materializeAttribute(attributeName, value);

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

  App.LanguageObserver = Em.Object.extend
    currentLanguageChanged: (->
      localize App.get('currentLanguage')
    ).observes('App.currentLanguage')

  App.languageObserver = App.LanguageObserver.create()

  $.datepicker?.setDefaults $.datepicker.regional[App.get('currentLanguage')]
  $.timepicker?.setDefaults $.timepicker.regional[App.get('currentLanguage')]

  App.animation =
    duration: 300

  App
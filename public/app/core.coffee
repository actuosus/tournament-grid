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
  'cs!locales'
  'cs!config'
] , (cookie, ember, emberData, locales, config)->
  localize = (lang)->
    lang ?= (window.navigator.userLanguage or window.navigator.language).substring(0, 2)
    Em.STRINGS = locales[lang]

  lang = $.cookie 'lang'
  localize(lang)

  Em.Handlebars.registerHelper 'loc', (property, fn)->
    if fn.contexts and typeof fn.contexts[0] is 'string'
      str = fn.contexts[0]
    else if property[0] is '_'
      str = property
    else if /[A-Z]/.test property[0]
      str = Em.getPath window, property
    else
      str = this.getPath property
    new Handlebars.SafeString (str || '').loc('')

  Ember.Handlebars.registerBoundHelper 'moment', (value, options)->
    new Handlebars.SafeString(moment(value).format(options.hash.format))

  Ember.Handlebars.registerBoundHelper 'highlight', (value, options)->
    if options.hash?.partBinding
      part = options.data.view.get options.hash.partBinding
      re = new RegExp(part, 'i')
      split = value.split(re)

      if part and split.length > 1
#        console.log split[0].length, part.length
        originalPart = value.substring split[0].length, split[0].length + part.length
        value = [
          split[0]
          '<span class="highlight">'
          originalPart
          '</span>'
          split[1]
        ].join('')
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
    customEvents:
      mousewheel: 'mouseWheel'
#  App.deferReadiness()
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

  App.store = DS.Store.create
    revision: 11
    adapter: DS.RESTAdapter.create
      bulkCommit: no
      namespace: config.apiNamespace

  App.store.adapter.serializer.primaryKey = -> '_id'

  # Localization configuration
  App.languages = Em.ArrayController.create content: config.languages
  App.currentLanguage = lang
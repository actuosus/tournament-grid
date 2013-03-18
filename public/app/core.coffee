###
 * core
 * @author: actuosus
 * @fileOverview Application preconfiguration.
 * Date: 21/01/2013
 * Time: 07:32
###

define [
  'ember'
  'ember-data'
] , ()->

  en_US =
    _reset: 'Reset'
    _loading: 'Loading'
    _expand: 'Expand'
    _collapse: 'Collapse'
    _final: 'Final'
    _of_the_final: 'of the final'
    _semifinal: 'Semi-final'
    _third_place_match: 'Third place match'
    _info: 'Info'
    _tournament_results_table: 'Tournament results table'
    _add_entrant: 'Add entrant'

  ru_RU =
    _reset: 'Сброс'
    _loading: 'Загрузка'
    _expand: 'Развернуть'
    _collapse: 'Свернуть'
    _final: 'Финал'
    _of_the_final: 'Финала'
    _semifinal: 'Полуфинал'
    _third_place_match: 'Матч за третье место'
    _info: 'Инфо'
    _tournament_results_table: 'Таблица результатов турнира'
    _add_entrant: 'Добавить участника'

  de_DE =
    _reset: 'Rücksetzen'
    _loading: 'Laden'
    _expand: 'Erweitern'
    _collapse: 'Drehen'
    _final: 'Finale'
    _of_the_final: 'des Final'
    _semifinal: 'Halbfinal'
    _third_place_match: 'Spiel um Platz drei'
    _info: 'Info'
    _tournament_results_table: 'Ergebnisse Table Tournament'
    _add_entrant: 'Fügen Teilnehmer'

  localize = ->
    switch window.navigator.userLanguage or window.navigator.language
      when 'en-US'
        Em.STRINGS = en_US
      when 'ru-RU'
        Em.STRINGS = ru_RU
      when 'de-DE'
        Em.STRINGS = de_DE
      else
        Em.STRINGS = en_US

  localize()

  Ember.Handlebars.registerBoundHelper 'moment', (value, options)->
    new Handlebars.SafeString(moment(value).format(options.hash.format))

  Ember.Handlebars.registerBoundHelper 'highlight', (value, options)->
    if options.hash?.partBinding
      part = options.data.view.get options.hash.partBinding
      re = new RegExp(part, 'i')
      split = value.split(re)

      if part and split.length > 1
        console.log split[0].length, part.length
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
      namespace: 'api'

  App.store.adapter.serializer.primaryKey = -> '_id'
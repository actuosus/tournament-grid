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
    _winners: 'Winners'
    _losers: 'Losers'
    _name: 'Name'
    _title: 'Title'
    _description: 'Description'
    _type: 'Type'
    _entrants_number: 'Entrants number'
    _grid: 'Grid'
    _group: 'Group'
    _matrix: 'Matrix'
    _team: 'Team'
    _team_name: 'Team name'
    _matches: 'Matches'
    _create: 'Create'
    _cancel: 'Cancel'
    _save: 'Save'

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
    _winners: 'Победители'
    _losers: 'Проигравшие'
    _name: 'Имя'
    _title: 'Название'
    _description: 'Описание'
    _type: 'Тип'
    _entrants_number: 'Количество участников'
    _grid: 'Сетка'
    _group: 'Групповой'
    _matrix: 'Матрица'
    _team: 'Команда'
    _team_name: 'Название команды'
    _matches: 'Матчи'
    _create: 'Создать'
    _cancel: 'Отмена'
    _save: 'Сохранить'

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
    _winners: 'Gewinner'
    _losers: 'Verlierer'
    _name: 'Name'
    _title: 'Benennung'
    _description: 'Beschreibung'
    _type: 'Typ'
    _entrants_number: 'Anzahl der Teilnehmer'
    _grid: 'Netz'
    _group: 'Gruppe'
    _matrix: 'Matrix'
    _team: 'Team'
    _team_name: 'Team Name'
    _matches: 'Streichhölzer'
    _create: 'Schaffen'
    _cancel: 'Beenden'
    _save: 'Speichern'

  localize = (lang)->
    if lang
      switch lang
        when 'en'
          Em.STRINGS = en_US
        when 'ru'
          Em.STRINGS = ru_RU
        when 'de'
          Em.STRINGS = de_DE
        else
          Em.STRINGS = en_US
    else
      switch window.navigator.userLanguage or window.navigator.language
        when 'en-US'
          Em.STRINGS = en_US
        when 'ru-RU'
          Em.STRINGS = ru_RU
        when 'de-DE'
          Em.STRINGS = de_DE
        else
          Em.STRINGS = en_US

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
    currentLanguage: lang
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
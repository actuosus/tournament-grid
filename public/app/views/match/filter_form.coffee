###
 * match_filter_form
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 07:45
###

define [
  'ehbs!match/filter_form'
  'cs!../../core'
], (template)->
#  Em.TEMPLATES.matchFilterForm = Em.Handlebars.compile template
  App.MatchFilterFormView = Em.View.extend
    templateName: 'match/filter_form'
    classNames: ['match-filter-form']

    entrant: null
    matchType: null
    periodType: null

    date: null
    startDate: null
    endDate: null

    matchTypeChanged: (->
      @set 'content.matchTypeFilter', @get 'matchType'
    ).observes('matchType')

    entrantChanged: (->
      entrant = @get 'entrant'
      if App.TeamRef.detectInstance entrant
        entrant = entrant.get 'team'
      @set 'content.entrantFilter', entrant
    ).observes('entrant')

    dateChanged: (->
      @set 'content.dateFilter', @get 'date'
    ).observes('date')

    startDateChanged: (->
      @set 'content.startDateFilter', @get 'startDate'
    ).observes('startDate')

    endDateChanged: (->
      @set 'content.endDateFilter', @get 'endDate'
    ).observes('endDate')

    didInsertElement: ->
      self = @
      @$('.date').bind 'change.filter', -> self.set 'date', @valueAsDate
      @$('.start-date').bind 'change.filter', -> self.set 'startDate', @valueAsDate
      @$('.end-date').bind 'change.filter', -> self.set 'endDate', @valueAsDate

    periodTypeChanged: (->
      switch @get 'periodType.id'
        when 'period'
          @set 'isPeriod', yes
          @set 'isDate', no
        when 'date'
          @set 'isPeriod', no
          @set 'isDate', yes
        else
          @set 'isPeriod', no
          @set 'isDate', no
      @set 'content.periodFilter', @get 'periodType'
    ).observes('periodType')
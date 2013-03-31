###
 * report
 * @author: actuosus
 * @fileOverview Report model.
 * Date: 06/02/2013
 * Time: 02:48
###

define ['cs!../core'],->
  App.Report = DS.Model.extend
    primaryKey: '_id'
    title: DS.attr 'string'
    description: DS.attr 'string'
    start_date: DS.attr 'date'
    end_date: DS.attr 'date'
    date: DS.attr 'date'
    place: DS.attr 'string'

    match_type: DS.attr 'string'

    stages: DS.hasMany 'App.Stage'
    entrants: DS.hasMany 'App.Team'

  App.Report.toString = -> 'Report'
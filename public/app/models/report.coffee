###
 * report
 * @author: actuosus
 * @fileOverview Report model.
 * Date: 06/02/2013
 * Time: 02:48
###

define ->
  App.Report = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    description: DS.attr 'string'
    start_date: DS.attr 'date'
    end_date: DS.attr 'date'
    date: DS.attr 'date'
    place: DS.attr 'string'

    match_type: DS.attr 'string'

    stages: DS.hasMany 'App.Stage'

  App.Report.toString = -> 'Report'
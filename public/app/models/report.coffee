###
 * report
 * @author: actuosus
 * @fileOverview 
 * Date: 06/02/2013
 * Time: 02:48
###

define ->
  App.Report = DS.Model.extend
    primaryKey: '_id'
    name: DS.attr 'string'
    stages: DS.hasMany 'App.Stage'

  App.Report.toString = -> 'Report'
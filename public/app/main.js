/**
 * main
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 07:28
 */

require({
//  baseUrl: '/app',
  name: 'app',
  paths: {
    'jquery': '/vendor/scripts/jquery',
    'jquery.mousewheel': '/vendor/scripts/jquery.mousewheel',
    'jquery.isotope': '/vendor/scripts/jquery.isotope',
    'jquery.cookie': '/vendor/scripts/jquery.cookie',
    'jquery.scrollTo': '/vendor/scripts/jquery.scrollTo.min',
    'moment': '/vendor/scripts/moment',
    'Faker': '/vendor/scripts/Faker',
    'raphael': '/vendor/scripts/raphael',
    'spin': '/vendor/scripts/spin',
    'cs': '/vendor/scripts/cs',
    'text': '/vendor/scripts/text',
    'coffee-script': '/vendor/scripts/coffee-script',
    'iced-coffee-script': '/vendor/scripts/coffee-script-iced-large',
    'transit': '/vendor/scripts/jquery.transit.min',
    'handlebars': '/vendor/scripts/handlebars',
    'ember': '/vendor/scripts/ember',
    'ember-data': '/vendor/scripts/ember-data',
    'ember-table': '/vendor/scripts/ember-table',
    'modernizr.columns': '/vendor/scripts/modernizr/columns',
    'bootstrap.tooltip': '/vendor/scripts/bootstrap/bootstrap-tooltip',
    'three': '/vendor/scripts/three',
    'screenfull': '/vendor/scripts/screenfull.min',
    'jquery-ui': '/vendor/scripts/jquery-ui-1.10.1.custom.min'
  },
  shim: {
    'jquery.mousewheel': {
      deps: ['jquery']
    },
    'jquery.isotope': {
      deps: ['jquery']
    },

    'jquery.scrollTo': {
      deps: ['jquery']
    },

    'ember': {
      deps: ['jquery', 'handlebars']
    },
    'ember-data': {
      deps: ['ember']
    },

    'transit': {
      deps: ['jquery']
    },

    'bootstrap.tooltip': {
      deps: ['jquery']
    },
    'ember-table': {
      deps: ['ember', 'jquery-ui']
    }
  }
});

define([
  'jquery',
  'jquery.mousewheel',
  'jquery.scrollTo',
//  'jquery.isotope',
  'jquery.cookie',
  'transit',
//  'raphael',
  'moment',
  'spin',
  'Faker',
  'ember',
  'ember-data',
//  'ember-table',
  'modernizr.columns',
  'cs!./core',
  'cs!./application'
], function(){

})
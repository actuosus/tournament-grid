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
    'jquery': '/vendor/javascripts/jquery',
    'jquery.mousewheel': '/vendor/javascripts/jquery.mousewheel',
    'jquery.isotope': '/vendor/javascripts/jquery.isotope',
    'jquery.cookie': '/vendor/javascripts/jquery.cookie',
    'jquery.scrollTo': '/vendor/javascripts/jquery.scrollTo.min',
    'moment': '/vendor/javascripts/moment',
    'Faker': '/vendor/javascripts/Faker',
    'raphael': '/vendor/javascripts/raphael',
    'spin': '/vendor/javascripts/spin',
    'cs': '/vendor/javascripts/cs',
    'text': '/vendor/javascripts/text',
    'coffee-script': '/vendor/javascripts/coffee-script',
    'iced-coffee-script': '/vendor/javascripts/coffee-script-iced-large',
    'transit': '/vendor/javascripts/jquery.transit.min',
    'handlebars': '/vendor/javascripts/handlebars',
    'ember': '/vendor/javascripts/ember',
    'ember-data': '/vendor/javascripts/ember-data',
    'modernizr.columns': '/vendor/javascripts/modernizr/columns',
    'bootstrap.tooltip': '/vendor/javascripts/bootstrap/bootstrap-tooltip'
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
    }
  }
});

define([
  'jquery',
  'jquery.mousewheel',
  'jquery.scrollTo',
  'jquery.isotope',
  'jquery.cookie',
  'transit',
  'moment',
  'spin',
  'Faker',
  'handlebars',
  'ember',
  'ember-data',
  'modernizr.columns',
  'cs!./core',
  'cs!./application'
], function(){

})
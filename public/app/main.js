/**
 * main
 * @author: actuosus
 * @fileOverview
 * Date: 21/01/2013
 * Time: 07:28
 */

require({
  baseUrl: '/app',
  paths: {
    'jquery': '/vendor/javascripts/jquery',
    'jquery.ui.widget': '/vendor/javascripts/jquery.ui.widget',
    'jquery.fileupload': '/vendor/javascripts/jquery.fileupload',
    'jquery.mousewheel': '/vendor/javascripts/jquery.mousewheel',
    'jquery.isotope': '/vendor/javascripts/jquery.isotope',
    'jquery.cookie': '/vendor/javascripts/jquery.cookie',
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
    'ember-data': '/vendor/javascripts/ember-data'
  },
  shim: {
    'jquery.mousewheel': {
      deps: ['jquery']
    },
    'jquery.isotope': {
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
    }
  }
}, [
  'jquery',
  'jquery.mousewheel',
  'jquery.isotope',
  'jquery.cookie',
  'transit',
  'moment',
  'spin',
  'Faker',
  'handlebars',
  'ember',
  'ember-data',
//  'cs!core',
  'cs!app'
]);
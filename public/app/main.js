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
    'handlebars': '/vendor/scripts/handlebars-1.0.0-rc.3',
    'ember': '/vendor/scripts/ember-1.0.0-rc.3',
    'ember-data': '/vendor/scripts/ember-data',
    'ember-history': '/vendor/scripts/ember-history',
    'ember-table': '/vendor/scripts/ember-table',
    'modernizr.columns': '/vendor/scripts/modernizr/columns',
    'bootstrap.tooltip': '/vendor/scripts/bootstrap/bootstrap-tooltip',
    'three': '/vendor/scripts/three',
    'screenfull': '/vendor/scripts/screenfull.min',
    'jquery-ui': '/vendor/scripts/jquery-ui-1.10.3.custom',
    'jquery.ui.datepicker-ru': '/vendor/scripts/jquery.ui.datepicker-ru',
    'jquery.ui.datepicker-it': '/vendor/scripts/jquery.ui.datepicker-it',
    'jquery.ui.datepicker-de': '/vendor/scripts/jquery.ui.datepicker-de',
    'jquery.ui.timepicker': '/vendor/scripts/jquery-ui-timepicker-addon',
    'jquery.ui.timepicker-ru': '/vendor/scripts/jquery-ui-timepicker-ru',
    'jquery.ui.timepicker-it': '/vendor/scripts/jquery-ui-timepicker-it',
    'jquery.ui.timepicker-de': '/vendor/scripts/jquery-ui-timepicker-de',
    'socket.io': 'http://' + document.location.host + '/socket.io/socket.io.js'
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

    'jquery-ui': {
      deps: ['jquery']
    },

    'jquery.ui.datepicker-ru': {
      deps: ['jquery-ui']
    },

    'jquery.ui.datepicker-it': {
      deps: ['jquery-ui']
    },

    'jquery.ui.datepicker-de': {
      deps: ['jquery-ui']
    },

    'jquery.ui.timepicker': {
      deps: ['jquery-ui']
    },


    'jquery.ui.timepicker-ru': {
      deps: ['jquery.ui.timepicker']
    },

    'jquery.ui.timepicker-it': {
      deps: ['jquery.ui.timepicker']
    },

    'jquery.ui.timepicker-de': {
      deps: ['jquery.ui.timepicker']
    },

    'handlebars': {
      exports: 'Handlebars'
    },

    'ember': {
      deps: ['jquery', 'handlebars'],
      exports: 'Ember',
      init: function(jQuery, Handlebars){
        if ('undefined' === typeof Ember) {
          if ('undefined' !== typeof this.Ember) {
            return this.Ember;
          }
          if ('undefined' !== typeof window) {
            return window.Ember;
          }
        } else {
          return Ember;
        }
      }
    },
    'ember-data': {
      deps: ['ember']
    },
    'ember-history': {
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

require([
  'jquery.mousewheel',
  'jquery.scrollTo',
//  'jquery.isotope',
  'jquery.cookie',
  'jquery-ui',
  'jquery.ui.timepicker',
  'transit',
//  'raphael',
  'moment',
  'spin',
  'Faker',
  'handlebars',
  'ember',
  'ember-data',
  'ember-history',
//  'ember-table',
  'modernizr.columns',
  'cs!./core',
//  'cs!application'
], function(){
//  App.ready();

  require(['cs!application'], function(){
//    App.ready();
    App.advanceReadiness();
  });
});
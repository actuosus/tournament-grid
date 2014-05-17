/**
 * app.build
 * @author actuosus@gmail.com (Arthur Chafonov)
 * @overview
 * Date: 01/07/2013
 * Time: 02:14
 */

/*globals require, requirejs */

requirejs.config({
  baseUrl: '.',
  name: 'app/main',
//  modules: [{name: 'app'}],
  out: 'bundle/app.js',
//  insertRequire: ['app/main'],
//  wrap: true,
  findNestedDependencies: true,
  optimize: 'uglify2',
//  optimize: 'none',
  preserveLicenseComments: false,
  stubModules: ['cs'],
  exclude: ['coffee-script'],
  paths: {
    'jquery': 'empty:',
//    'jquery': 'vendor/scripts/jquery',
    'jquery.mousewheel': 'empty:',
//    'jquery.mousewheel': 'vendor/scripts/jquery.mousewheel',
//    'jquery.isotope': 'vendor/scripts/jquery.isotope',
    'jquery.cookie': 'empty:',
//    'jquery.cookie': 'vendor/scripts/jquery.cookie',
    'jquery.scrollTo': 'vendor/scripts/jquery.scrollTo.min',
    'moment': 'vendor/scripts/moment',
    'Faker': 'vendor/scripts/Faker',
    'raphael': 'vendor/scripts/raphael',
    'spin': 'vendor/scripts/spin',
    'cs': 'vendor/scripts/cs',
    'text': 'vendor/scripts/text',
    'coffee-script': 'vendor/scripts/coffee-script',
    'css': 'vendor/scripts/css',
    'normalize': 'vendor/scripts/normalize',
    'css-builder': 'vendor/scripts/css-builder',
    'iced-coffee-script': 'vendor/scripts/coffee-script-iced-large',
    'transit': 'vendor/scripts/jquery.transit.min',
    'handlebars': 'vendor/scripts/handlebars-1.0.0.min',
    'ember': 'vendor/scripts/ember.prod-1.0.0-rc.6',
    'ember-data': 'vendor/scripts/ember-data.r13',
    'ember-history': 'vendor/scripts/ember-history',
    'ember-table': 'vendor/scripts/ember-table',
    'modernizr.columns': 'vendor/scripts/modernizr/columns',
    'bootstrap.tooltip': 'vendor/scripts/bootstrap/bootstrap-tooltip',
    'three': 'vendor/scripts/three',
    'screenfull': 'vendor/scripts/screenfull.min',
    'jquery-ui': 'empty:',
//    'jquery-ui': 'vendor/scripts/jquery-ui-1.10.3.custom',
    'jquery.ui.datepicker-ru': 'vendor/scripts/jquery.ui.datepicker-ru',
    'jquery.ui.datepicker-it': 'vendor/scripts/jquery.ui.datepicker-it',
    'jquery.ui.datepicker-de': 'vendor/scripts/jquery.ui.datepicker-de',
    'jquery.ui.timepicker': 'vendor/scripts/jquery-ui-timepicker-addon',
    'jquery.ui.timepicker-ru': 'vendor/scripts/jquery-ui-timepicker-ru',
    'jquery.ui.timepicker-it': 'vendor/scripts/jquery-ui-timepicker-it',
    'jquery.ui.timepicker-de': 'vendor/scripts/jquery-ui-timepicker-de',

//    'socket.io': '../../node_modules/socket.io/node_modules/socket.io-client/dist/socket.io'
    'socket.io': 'http://v3.virtuspro.org:33891/socket.io/socket.io'
  },
  shim: {
    'jquery.cookie': {
      deps: ['jquery']
    },
    'jquery.mousewheel': {
      deps: ['jquery']
    },
    'jquery.isotope': {
      deps: ['jquery']
    },

    'jquery.scrollTo': ['jquery'],


    'jquery-ui': {
      deps: ['jquery']
    },

    'jquery.ui.datepicker-ru': {
      deps: ['jquery', 'jquery-ui']
    },

    'jquery.ui.datepicker-it': {
      deps: ['jquery', 'jquery-ui']
    },

    'jquery.ui.datepicker-de': {
      deps: ['jquery', 'jquery-ui']
    },


    'jquery.ui.timepicker': {
      deps: ['jquery', 'jquery-ui']
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
    }
  }
});

require(['app/main']);

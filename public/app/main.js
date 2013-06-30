/**
 * main
 * @author: actuosus
 * @fileOverview Main require file.
 * Date: 21/01/2013
 * Time: 07:28
 */

requirejs.config({
  baseUrl: '/app',
  name: 'app',
  paths: {
    'jquery': [
      'http://yandex.st/jquery/2.0.0/jquery.min',
      '//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min',
      '/vendor/scripts/jquery'
    ],
    'jquery.mousewheel': [
      'http://yandex.st/jquery/mousewheel/3.0.6/jquery.mousewheel.min',
      '/vendor/scripts/jquery.mousewheel'
    ],
    'jquery.cookie': [
      'http://yandex.st/jquery/cookie/1.0/jquery.cookie.min',
      '/vendor/scripts/jquery.cookie'
    ],
    'jquery.scrollTo': '/vendor/scripts/jquery.scrollTo.min',
    'moment': '/vendor/scripts/moment',
//    'Faker': '/vendor/scripts/Faker',
//    'raphael': [
//      'http://yandex.st/raphael/2.1.0/raphael.min',
//      '/vendor/scripts/raphael'
//    ],
    'spin': '/vendor/scripts/spin',
    'cs': '/vendor/scripts/cs',
    'text': '/vendor/scripts/text',
    'normalize': '/vendor/scripts/normalize',
    'css': '/vendor/scripts/css',
    'coffee-script': '/vendor/scripts/coffee-script',
//    'iced-coffee-script': '/vendor/scripts/coffee-script-iced-large',
    'transit': '/vendor/scripts/jquery.transit.min',
    'handlebars': '/vendor/scripts/handlebars',
    'ember': [
      '/vendor/scripts/ember-1.0.0-rc.5',
      '/vendor/scripts/ember.prod'
    ],
    'ember-data': '/vendor/scripts/ember-data.r13',
    'ember-history': '/vendor/scripts/ember-history',
//    'ember-table': '/vendor/scripts/ember-table',
    'modernizr.columns': '/vendor/scripts/modernizr/columns',
//    'three': '/vendor/scripts/three',
    'screenfull': '/vendor/scripts/screenfull.min',
    'jquery-ui': [
      'http://yandex.st/jquery-ui/1.10.3/jquery-ui.min',
      '//ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min',
      '/vendor/scripts/jquery-ui-1.10.3.custom'
    ],
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
    'jquery.cookie': {
      deps: ['jquery']
    },
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
    }
  }
});

if (this.debug) {
  var contentElement = document.querySelector('.b-content');
  var statusElement = document.createElement('div');
  statusElement.id = 'status';
  statusElement.className = 'status';
  contentElement.appendChild(statusElement);

  var errorElement = document.createElement('div');
  errorElement.id = 'error';
  errorElement.className = 'error';

  requirejs.onResourceLoad = function (context, map, depArray) {
    statusElement.innerHTML = 'Loading ' + map.name + '…';
  }

  requirejs.onCompile = function() {
    console.log('some');
  }

  requirejs.onError = function(err) {
    contentElement.appendChild(errorElement);
    errorElement.innerHTML = err;
    throw err;
  }

}

require([
//  'css!./stylesheets/main',
  'jquery',
  'jquery.mousewheel',
  'jquery.scrollTo',
  'jquery.cookie',
  'jquery-ui',
  'jquery.ui.timepicker',
  'transit',
//  'raphael',
  'moment',
  'spin',
  'ember-data',
//  'ember-history',
  'modernizr.columns',
  'cs!./core',
  'cs!./application'
], function(){
  if (window.debug) {
    var statusElement = document.getElementById('status');
    statusElement.parentNode.removeChild(statusElement);
  }
  require(['cs!application'], function(){
    console.time('Loading');
    if (window.hooks) { window.hooks() }
    App.advanceReadiness();
  });
});
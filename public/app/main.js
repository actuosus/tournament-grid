/**
 * main
 * @author actuosus@gmail.com (Arthur Chafonov)
 * @overview Main require file.
 * Date: 21/01/2013
 * Time: 07:28
 */

/*globals require, console*/

if (window.DEBUG) {
  console.time('Compiling');
}

if ('requirejs' in window) {
  var statusElement = document.getElementById('loader-status');
  var errorElement = document.getElementById('loader-error');
  requirejs.onResourceLoad = function (context, map, depArray) {
    'use strict';
    if (statusElement) {
      statusElement.innerHTML = map.name;
    }
  };
  requirejs.onError = function(err) {
    'use strict';
    if (errorElement) {
      errorElement.innerHTML = err.message;
    }
    throw err;
  };
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
  //  'fabric',
  'moment',
  'spin',
  //'ember-template-compiler',
  'ember',
  'ember-data',
  //  'ember-history',
  'modernizr.columns',
  'cs!app/core'
], function() {
  'use strict';
  require(['cs!app/application'], function() {
    if (window.DEBUG) {
      console.timeEnd('Compiling');
      console.time('Loading');
    }
    if (window.hooks) {
      window.hooks();
    }
    App.advanceReadiness();
  });
});
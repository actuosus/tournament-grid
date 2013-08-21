/**
 * main
 * @author: actuosus
 * @fileOverview Main require file.
 * Date: 21/01/2013
 * Time: 07:28
 */

//requirejs.config({
//  paths: {
//    'jquery': [
//      'https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min',
//      'http://yandex.st/jquery/2.0.2/jquery.min',
//      '//ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min'
//    ],
//    'jquery.cookie': 'http://yandex.st/jquery/cookie/1.0/jquery.cookie.min',
//    'jquery-ui': [
//      'http://yandex.st/jquery-ui/1.10.3/jquery-ui.min',
//      '//ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min'
//    ],
//    'jquery.mousewheel': 'http://yandex.st/jquery/mousewheel/3.0.6/jquery.mousewheel.min',
//    'socket.io': 'http://v3.virtuspro.org:33891/socket.io/socket.io',
//  },
//  shim: {
//    'jquery-ui': ['jquery'],
//    'jquery.cookie': ['jquery'],
//    'jquery.mousewheel': ['jquery'],
//    'ember': ['jquery', 'handlebars']
//  }
//});

require([
//  'css!./stylesheets/main',
//  'jquery',
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
  'ember-data',
//  'ember-history',
  'modernizr.columns',
  'cs!app/core'
], function(){
  if (window.DEBUG) {
    var statusElement = document.getElementById('status');
    if (statusElement && statusElement.parentNode) {
      statusElement.parentNode.removeChild(statusElement);
    }
  }
  require(['cs!app/application'], function(){
    if (window.DEBUG) { console.time('Loading'); }
    if (window.hooks) { window.hooks(); }
    App.advanceReadiness();
  });
});
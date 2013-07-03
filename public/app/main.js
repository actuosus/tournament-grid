/**
 * main
 * @author: actuosus
 * @fileOverview Main require file.
 * Date: 21/01/2013
 * Time: 07:28
 */

requirejs.config({
  paths: {
    'jquery': 'http://yandex.st/jquery/2.0.2/jquery.min.js',
    'socket.io': 'http://v3.virtuspro.org:33891/socket.io/socket.io'
  }
})

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
  'cs!app/core',
  'cs!app/application'
], function(){
  if (window.debug) {
    var statusElement = document.getElementById('status');
    statusElement.parentNode.removeChild(statusElement);
  }
  require(['cs!app/application'], function(){
    console.time('Loading');
    if (window.hooks) { window.hooks() }
    App.advanceReadiness();
  });
});
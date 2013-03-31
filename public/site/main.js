/**
 * main
 * @author: actuosus
 * @fileOverview
 * Date: 29/03/2013
 * Time: 14:10
 */

require({
//  baseUrl: '/site',
  name: 'site',
  paths: {
    'jquery': '/vendor/javascripts/jquery',
    'bootstrap.collapse': '/vendor/javascripts/bootstrap/bootstrap-collapse',
    'bootstrap.transition': '/vendor/javascripts/bootstrap/bootstrap-transition',
    'coffee-script': '/vendor/javascripts/coffee-script',
    'cs': '/vendor/javascripts/cs'
  },
  shim: {
    'bootstrap.collapse': {
      deps: ['jquery', 'bootstrap.transition']
    },
    'bootstrap.transition': {
      deps: ['jquery']
    }
  }
});

define([
  'jquery',
  'cs',
  'bootstrap.collapse',
  'cs!./main'
]);
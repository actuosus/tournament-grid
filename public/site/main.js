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
    'jquery': '/vendor/scripts/jquery',
    'bootstrap.collapse': '/vendor/scripts/bootstrap/bootstrap-collapse',
    'bootstrap.transition': '/vendor/scripts/bootstrap/bootstrap-transition',
    'coffee-script': '/vendor/scripts/coffee-script',
    'cs': '/vendor/scripts/cs'
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
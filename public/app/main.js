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
    jquery: '/vendor/javascripts/jquery-1.8.2.min',
    'jquery.ui.widget': '/vendor/javascripts/jquery.ui.widget',
    'jquery.fileupload': '/vendor/javascripts/jquery.fileupload',
    Faker: '/vendor/javascripts/Faker',
    raphael: '/vendor/javascripts/raphael',
    cs: '/vendor/javascripts/cs',
    text: '/vendor/javascripts/text',
    'coffee-script': '/vendor/javascripts/coffee-script',
    'iced-coffee-script': '/vendor/javascripts/coffee-script-iced-large'
  }
}, [
  'cs!app'
]);
/**
 * main
 * @author: actuosus
 * @fileOverview
 * Date: 29/03/2013
 * Time: 13:01
 */

require.config({
//  baseUrl: '/',
  packages: [
    {name:'app', location: '/app'},
    {name:'site', location: '/site'}
  ]
});

require([
  'site',
  'app'
]);
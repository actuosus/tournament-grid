/**
 * conf
 * @author: actuosus
 * @fileOverview
 * Date: 15/06/2013
 * Time: 21:30
 */

define(function(){
  function getParameterByName(name) {
    var match = RegExp('[?&]' + name + '=([^&]*)').exec(window.location.search);
    return match && decodeURIComponent(match[1].replace(/\+/g, ' '));
  }

  var hostname = getParameterByName('hostname') || 'virtuspro.local';
  var port = getParameterByName('port') || 3000;

  return function() {
    return {
      hostname: hostname,
      port: port
    }
  };
});
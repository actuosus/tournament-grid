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

  var hostname = getParameterByName('hostname') || window.location.hostname;
  var port = getParameterByName('port') || window.location.port;

  return function() {
    return {
      hostname: hostname,
      port: port
    }
  };
});
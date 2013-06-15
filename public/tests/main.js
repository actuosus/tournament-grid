require({
  paths: {
    'jquery': '/vendor/scripts/jquery',
    'cs': '/vendor/scripts/cs',
    'coffee-script': '/vendor/scripts/coffee-script',
    'mocha': '/vendor/scripts/mocha',
    'chai': '/vendor/scripts/chai',
    'superagent': '/vendor/scripts/superagent',
    '../../app': '/tests/app',
    '../../conf': '/tests/conf'
  }
});

require(['chai', 'mocha', 'superagent'], function (chai) {
  mocha.setup('bdd');
  chai.should();

  mocha.timeout(10000);

  window.conf = {
    hostname: 'virtuspro.local',
    port: 3000
  }

  require([

    '../../app',
    '../../conf',

    'cs!/test/api/countries',
    'cs!/test/api/brackets',
    'cs!/test/api/games',
    'cs!/test/api/matches',
    'cs!/test/api/players',
    'cs!/test/api/reports',
    'cs!/test/api/result_sets',
    'cs!/test/api/rounds',
    'cs!/test/api/stages',
    'cs!/test/api/team_refs',
    'cs!/test/api/teams',
    'cs!/test/api/index'
  ], function(){
    mocha.run();
  });
});

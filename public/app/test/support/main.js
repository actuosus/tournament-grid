/**
 * main
 * @author: actuosus
 * @fileOverview
 * Date: 13/05/2013
 * Time: 06:34
 */

require({
  paths: {
    'cs': '/vendor/scripts/cs',
    'coffee-script': '/vendor/scripts/coffee-script',
    'mocha': '/app/test/support/mocha',
    'chai': '/app/test/support/chai',
    'sinon': '/app/test/support/sinon'
  }
});

require(['chai', 'mocha', 'sinon'], function (chai) {
  mocha.setup('bdd');
  chai.should();

  window.grid = {};
  window.grid.config = {
    languages: ['ru', 'en']
  };

  window.TESTING = TESTING = true;

  // Run before each test case.
  beforeEach(function () {
    // Put the application into a known state, and destroy the defaultStore.
    // Be careful about DS.Model instances stored in App; they'll be invalid
    // after this.
    // This is broken in some versions of Ember and Ember Data, see:
    // https://github.com/emberjs/data/issues/847

//    App.reset();

//    App.advanceReadiness();
    // Display an error if asynchronous operations are queued outside of
    // Ember.run.  You need this if you want to stay sane.
    Ember.testing = true;
  });
  // Run after each test case.
  afterEach(function () {
    Ember.testing = false;
  });

  // Optional: Clean up after our last test so you can try out the app
  // in the jsFiddle.  This isn't normally required.
  after(function () {
    App.reset();
  });

  require(['/bundle/app.js'], function () {
    require([
      'cs!/app/test/fixtures',
      'cs!/app/test/system',
      'cs!/app/test/models'
    ], function () {
      App.store = DS.defaultStore = DS.Store.create({
        revision: 11,
        adapter: DS.FixtureAdapter.create({ simulateRemoteResponse: true })
      });
      mocha.run();
    });
  });
});

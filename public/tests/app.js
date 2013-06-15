/**
 * app
 * @author: actuosus
 * @fileOverview
 * Date: 15/06/2013
 * Time: 21:29
 */

define(['superagent', 'conf'], function(request){
  var hiddenAPI = 'http://'+ conf.hostname + ':' + conf.port + '/hidden/';

  function Collection() {

  }

  Collection.prototype.remove = function(cb){
//    console.log('Removing a collection', this);
    cb();
  }

  function Model(conf){
    this.name = conf.name;
    this.plural = conf.plural;
    this.collection = new Collection();
  }

  Model.prototype.create = function(data, cb){
//    console.log('Creating a Model', this, data);
    var err = null;
    dataToSend = {}
    dataToSend[this.name] = data
    self = this;
    request
      .post(hiddenAPI + this.plural)
      .send(dataToSend)
      .end(function(res){
      cb(err, res.body[self.name]);
    });
  }

  Model.prototype.remove = function(data, cb){
//    console.log('Removing a Model', this, data);
    var err = null;
    request.del(hiddenAPI + this.plural).send(data).end(function(){
      cb(err, data);
    });
  }
  return {
    app: {
      set: function(){},
      get: function(){}
    },

    init: function(cb) {
      cb();
    },

    teardown: function(cb) {
      cb();
    },

    models: {
      Country: new Model({name: 'country', plural: 'countries'}),
      Report: new Model({name: 'report', plural: 'reports'}),
      Stage: new Model({name: 'stage', plural: 'stages'}),
      Bracket: new Model({name: 'bracket', plural: 'brackets'}),
      Round: new Model({name: 'round', plural: 'rounds'}),
      Match: new Model({name: 'match', plural: 'matches'}),
      Game: new Model({name: 'game', plural: 'games'}),
      Team: new Model({name: 'team', plural: 'teams'}),
      TeamRef: new Model({name: 'team_ref', plural: 'team_refs'}),
      Player: new Model({name: 'player', plural: 'players'}),
      ResultSet: new Model({name: 'result_set', plural: 'result_sets'})
    }
  }
});
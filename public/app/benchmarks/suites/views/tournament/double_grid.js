var view;

before(function() {
  console.log(window.App);
//  var view;
//  window.App = Ember.Namespace.create();
//
//  App.View = Ember.View.extend({
//    template: Ember.Handlebars.compile("{{view}}")
//  });
//
//  App.View.create().destroy();
});

after(function() {
  view.destroy();
});

bench("Creating a new view", function() {
  Ember.run(function() {
    view = App.View.create().append();
  });
});

/**
 * @author actuosus
 * Date: 09/04/15
 * @file RequireJS build script for production site.
 */

/*globals require, requirejs */

requirejs.config({
    baseUrl: '.',
    name: 'app/main',
    out: 'bundle/app.js',
    uglify2: {
        drop_console: true,
        drop_debugger: true
    },
    findNestedDependencies: true,
    //optimize: 'none',
    optimize: 'uglify2',
    preserveLicenseComments: false,
    stubModules: ['cs'],
    exclude: ['coffee-script'],
    paths: {
        'jquery': 'empty:',
        'jquery.mousewheel': 'empty:',
        'jquery.cookie': 'empty:',
        'jquery.scrollTo': 'vendor/scripts/jquery.scrollTo.min',
        'moment': 'vendor/scripts/moment',
        'Faker': 'vendor/scripts/Faker',
        'raphael': 'vendor/scripts/raphael',
        'spin': 'vendor/scripts/spin',
        'cs': 'vendor/scripts/cs',
        'text': 'vendor/scripts/text',
        'coffee-script': 'vendor/scripts/coffee-script',
        'css': 'vendor/scripts/css',
        'normalize': 'vendor/scripts/normalize',
        'css-builder': 'vendor/scripts/css-builder',
        'iced-coffee-script': 'vendor/scripts/coffee-script-iced-large',
        'transit': 'vendor/scripts/jquery.transit.min',
        'handlebars': 'vendor/scripts/handlebars/handlebars',
        'ember': 'vendor/scripts/ember/ember.prod',
        'ember-template-compiler': 'vendor/scripts/ember/ember-template-compiler',
        'ember-data': 'vendor/scripts/ember-data/ember-data.prod',
        'ember-history': 'vendor/scripts/ember-history',
        'ember-table': 'vendor/scripts/ember-table',
        'modernizr.columns': 'vendor/scripts/modernizr/columns',
        'bootstrap.tooltip': 'vendor/scripts/bootstrap/bootstrap-tooltip',
        'three': 'vendor/scripts/three',
        'screenfull': 'vendor/scripts/screenfull.min',
        'jquery-ui': 'empty:',
        'jquery.ui.datepicker-ru': 'vendor/scripts/jquery.ui.datepicker-ru',
        'jquery.ui.datepicker-it': 'vendor/scripts/jquery.ui.datepicker-it',
        'jquery.ui.datepicker-de': 'vendor/scripts/jquery.ui.datepicker-de',
        'jquery.ui.timepicker': 'vendor/scripts/jquery-ui-timepicker-addon',
        'jquery.ui.timepicker-ru': 'vendor/scripts/jquery-ui-timepicker-ru',
        'jquery.ui.timepicker-it': 'vendor/scripts/jquery-ui-timepicker-it',
        'jquery.ui.timepicker-de': 'vendor/scripts/jquery-ui-timepicker-de',

        'socket.io': 'http://v3.virtuspro.org:33891/socket.io/socket.io',
        "ehbs": "vendor/scripts/requirejs-ember-handlebars/ehbs"
    },
    shim: {
        'jquery.cookie': {
            deps: ['jquery']
        },
        'jquery.mousewheel': {
            deps: ['jquery']
        },
        'jquery.isotope': {
            deps: ['jquery']
        },

        'jquery.scrollTo': ['jquery'],

        'ember-template-compiler': ['ember'],

        'jquery-ui': {
            deps: ['jquery']
        },

        'jquery.ui.datepicker-ru': {
            deps: ['jquery', 'jquery-ui']
        },

        'jquery.ui.datepicker-it': {
            deps: ['jquery', 'jquery-ui']
        },

        'jquery.ui.datepicker-de': {
            deps: ['jquery', 'jquery-ui']
        },

        'jquery.ui.timepicker': {
            deps: ['jquery', 'jquery-ui']
        },

        'jquery.ui.timepicker-ru': {
            deps: ['jquery.ui.timepicker']
        },

        'jquery.ui.timepicker-it': {
            deps: ['jquery.ui.timepicker']
        },

        'jquery.ui.timepicker-de': {
            deps: ['jquery.ui.timepicker']
        },

        'handlebars': {
            exports: 'Handlebars'
        },

        'ember': {
            deps: ['jquery'],
            exports: 'Ember'
        },
        'ember-data': {
            deps: ['ember']
        },
        'ember-history': {
            deps: ['ember']
        },

        'transit': {
            deps: ['jquery']
        }
    },
    ehbs: {
        extension: "hbs",
        templatePath: "app/templates/",
        ember: "ember",
        etcPath: "public/vendor/scripts/ember/ember-template-compiler"
    }
});

require(['app/main']);

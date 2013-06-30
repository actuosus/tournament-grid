module.exports = (grunt)->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    copy:
      app:
        files: [
          {src: ['public/app/main.js'], dest: 'public/dist/app/main.js', filter: 'isFile'}
          {src: ['public/app/r.js'], dest: 'public/dist/app/r.js', filter: 'isFile'}
        ]
    clean:
      app: ['public/dist', 'public/bundle']
    coffee:
      glob_to_multiple:
        expand: yes
        cwd: 'public/app'
        src: ['**/*.coffee']
        dest: 'public/dist/app'
        ext: '.js'
    cssmin:
      compress:
        files:
          'public/bundle/app.css': ['public/app/stylesheets/main.css']
#      with_banner:
#        options:
#          banner: '/* My minified css file */'
#        files:
#          'path/to/output.css': ['path/to/**/*.css']
    recess: {
      dist: {
        options: {
          compile: true
        },
        files: {
          'public/bundle/app.css': [
            'public/app/stylesheets/main.css',
          ]
        }
      }
    }
    requirejs:
      compile:
        options:
#          useSourceUrl: yes
#          optimize: 'uglify2'
          optimize: 'none'
#          generateSourceMaps: yes
#          preserveLicenseComments: no
          locale: "en-us",
          baseUrl: './public/app'
#          mainConfigFile: 'public/app.build.js'
#          skipDirOptimize: yes
#          appDir: 'public/app'
#          dir: 'public/bundle'
          paths: {
#            'jquery': '../vendor/scripts/jquery',
            'jquery': 'empty:',
            'jquery.mousewheel': 'empty:',
            'jquery.isotope': '../vendor/scripts/jquery.isotope',
            'jquery.cookie': 'empty:',
            'jquery.scrollTo': '../vendor/scripts/jquery.scrollTo.min',
            'moment': '../vendor/scripts/moment',
            'Faker': '../vendor/scripts/Faker',
            'raphael': '../vendor/scripts/raphael',
            'spin': '../vendor/scripts/spin',
            'cs': '../vendor/scripts/cs',
            'text': '../vendor/scripts/text',
            'coffee-script': '../vendor/scripts/coffee-script',
            'css': '../vendor/scripts/css',
            'normalize': '../vendor/scripts/normalize',
            'css-builder': '../vendor/scripts/css-builder',
            'iced-coffee-script': '../vendor/scripts/coffee-script-iced-large',
            'transit': '../vendor/scripts/jquery.transit.min',
            'handlebars': '../vendor/scripts/handlebars',
            'ember': '../vendor/scripts/ember-1.0.0-rc.5',
            'ember-data': '../vendor/scripts/ember-data.r13',
            'ember-history': '../vendor/scripts/ember-history',
            'ember-table': '../vendor/scripts/ember-table',
            'modernizr.columns': '../vendor/scripts/modernizr/columns',
            'bootstrap.tooltip': '../vendor/scripts/bootstrap/bootstrap-tooltip',
            'three': '../vendor/scripts/three',
            'screenfull': '../vendor/scripts/screenfull.min',
            'jquery-ui': 'empty:',
            'jquery.ui.datepicker-ru': '../vendor/scripts/jquery.ui.datepicker-ru',
            'jquery.ui.datepicker-it': '../vendor/scripts/jquery.ui.datepicker-it',
            'jquery.ui.datepicker-de': '../vendor/scripts/jquery.ui.datepicker-de',
            'jquery.ui.timepicker': '../vendor/scripts/jquery-ui-timepicker-addon',
            'jquery.ui.timepicker-ru': '../vendor/scripts/jquery-ui-timepicker-ru',
            'jquery.ui.timepicker-it': '../vendor/scripts/jquery-ui-timepicker-it',
            'jquery.ui.timepicker-de': '../vendor/scripts/jquery-ui-timepicker-de',

            'socket.io': '../../node_modules/socket.io/node_modules/socket.io-client/dist/socket.io'
          }
          name: 'main'
          out: 'public/bundle/app.js'
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

            'jquery.scrollTo': {
              deps: ['jquery']
            },

            'jquery-ui': {
              deps: ['jquery']
            },

            'jquery.ui.datepicker-ru': {
              deps: ['jquery-ui']
            },

            'jquery.ui.datepicker-it': {
              deps: ['jquery-ui']
            },

            'jquery.ui.datepicker-de': {
              deps: ['jquery-ui']
            },

            'jquery.ui.timepicker': {
              deps: ['jquery-ui']
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
              deps: ['jquery', 'handlebars']
            },
            'ember-data': {
              deps: ['ember']
            },
            'ember-history': {
              deps: ['ember']
            },

            'transit': {
              deps: ['jquery']
            },

            'bootstrap.tooltip': {
              deps: ['jquery']
            },
            'ember-table': {
              deps: ['ember', 'jquery-ui']
            }
          }
    handlebars:
      options:
        namespace: 'Em.TEMPLATES'
        files:
          'public/bundle/templates.js': 'public/app/templates/**/*.handlebars'
    ember_handlebars:
      options:
        files:
          'public/bundle/templates.js': 'public/app/templates/**/*.handlebars'
    exec:
      minify_css:
        cmd: ->
          'node ./node_modules/grunt-contrib-requirejs/node_modules/requirejs/bin/r.js -o cssIn=./public/app/stylesheets/main.css out=./public/bundle/stylesheets/app.css'
    coffeelint:
      options:
        argv:
          csv: yes
        no_trailing_whitespace: level: 'warn'
        max_line_length: level: 'warn'
      app: ['public/app/**/*.coffee']
    jshint:
      files: ['app/*.js', 'test/*.js'],
      options:
        # options here to override JSHint defaults
        globals:
          jQuery: true
          console: true
          module: true
          document: true

  grunt.registerTask 'bundle', 'Create project bundle', ['clean', 'requirejs', 'exec']


  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-exec'
#  grunt.loadNpmTasks 'grunt-contrib-cssmin'
#  grunt.loadNpmTasks 'grunt-recess'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
#  grunt.loadNpmTasks 'grunt-contrib-handlebars'
  grunt.loadNpmTasks 'grunt-ember-handlebars'

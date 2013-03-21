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
#          generateSourceMaps: yes
#          preserveLicenseComments: no
          locale: "en-us",
          baseUrl: './public/app'
#          mainConfigFile: 'public/app.build.js'
#          skipDirOptimize: yes
#          appDir: 'public/app'
#          dir: 'public/bundle'
          paths: {
          'moment': '../vendor/javascripts/moment',
          'jquery': '../vendor/javascripts/jquery',
          'jquery.mousewheel': '../vendor/javascripts/jquery.mousewheel',
          'jquery.cookie': '../vendor/javascripts/jquery.cookie',
          'jquery.isotope': '../vendor/javascripts/jquery.isotope',
          'Faker': '../vendor/javascripts/Faker',
          'raphael': '../vendor/javascripts/raphael',
          'spin': '../vendor/javascripts/spin',
          'cs': '../vendor/javascripts/cs',
          'text': '../vendor/javascripts/text',
          'coffee-script': '../vendor/javascripts/coffee-script',
#          'iced-coffee-script': '../vendor/javascripts/coffee-script-iced-large',
          'transit': '../vendor/javascripts/jquery.transit.min',
          'handlebars': '../vendor/javascripts/handlebars',
          'ember': '../vendor/javascripts/ember',
          'ember-data': '../vendor/javascripts/ember-data'
          }
          name: 'main'
          out: 'public/bundle/app.js'
#          modules: [
#            {
#              name: 'main'
#              out: 'public/app.js'
#            }
##            {
##              optimizeCss: "standard.keepLines"
##              cssIn: 'stylesheets/main.css'
##              out: 'public/app.css'
##            }
#          ]
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

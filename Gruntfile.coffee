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
        expand: true,
        cwd: 'public/app'
        src: ['**/*.coffee']
        dest: 'public/dist/app'
        ext: '.js'
    requirejs:
      compile:
        options:

#          useSourceUrl: yes
#          optimize: 'uglify2'
#          generateSourceMaps: yes
#          preserveLicenseComments: no
          locale: "en-us",
          baseUrl: 'public/app'
#          mainConfigFile: 'public/r.js'
          name: 'main'
          out: 'public/bundle/app.js'
          paths: {
            'jquery': '../vendor/javascripts/jquery',
            'jquery.ui.widget': '../vendor/javascripts/jquery.ui.widget',
            'jquery.fileupload': '../vendor/javascripts/jquery.fileupload',
            'jquery.mousewheel': '../vendor/javascripts/jquery.mousewheel',
            'jquery.isotope': '../vendor/javascripts/jquery.isotope',
            'Faker': '../vendor/javascripts/Faker',
            'raphael': '../vendor/javascripts/raphael',
            'spin': '../vendor/javascripts/spin',
            'cs': '../vendor/javascripts/cs',
            'text': '../vendor/javascripts/text',
            'coffee-script': '../vendor/javascripts/coffee-script',
            'iced-coffee-script': '../vendor/javascripts/coffee-script-iced-large',
            'transit': '../vendor/javascripts/jquery.transit.min',
            'handlebars': '../vendor/javascripts/handlebars',
            'ember': '../vendor/javascripts/ember',
            'ember-data': '../vendor/javascripts/ember-data'
          }
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

  grunt.registerTask 'bundle', 'Create project bundle', ['clean', 'requirejs']


  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'

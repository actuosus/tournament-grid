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
    requirejs: compile: options: mainConfigFile: 'public/app.build.js'
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
      copy_to_bundle:
        cmd: ->
          'cp ./public/vendor/scripts/require.min.js ./public/bundle/.'
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

  grunt.registerTask 'bundle', 'Create project bundle', ['clean', 'requirejs', 'exec:minify_css', 'exec:copy_to_bundle']


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

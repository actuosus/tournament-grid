module.exports = (grunt)->
  config = grunt.file.readJSON 'config.json'
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
      dev: options: mainConfigFile: 'public/app.build.dev.js' # Will rewrite app.js
      prod: options: mainConfigFile: 'public/app.build.site.js'
      full: options: mainConfigFile: 'public/app.build.js'
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
      copy_to_bundle_extras:
        cmd: ->
          'mkdir -p ./public/bundle/vendor/styles/images && cp -R ./public/vendor/styles/images ./public/bundle/vendor/styles/images/.'
      webserver:
        cmd: -> 'node server'
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

    'sftp-deploy': {
      build: {
        auth: {
          host: 'v3.virtuspro.org',
          port: 2200,
          authKey: 'v3'
        },
        src: config.app.deploy.dev.src,
        dest: config.app.deploy.dev.dest
#        exclusions: ['/path/to/source/folder/**/.DS_Store', '/path/to/source/folder/**/Thumbs.db', 'dist/tmp'],
        server_sep: '/'
      },
      dev: {
        auth: {
          host: 'virtus.pro',
          port: 2200,
          authKey: 'v3'
        },
        src: config.app.deploy.prod.src,
        dest: config.app.deploy.prod.dest
        server_sep: '/'
      }
    }

    watch:
      server:
        files: ['Gruntfile.coffee', 'app.coffee', 'routes/**/*.coffee', 'models/**/*.coffee']
        tasks: ['exec:webserver']
        options: atBegin: yes
      app:
        files: ['./public/app/**/*.coffee']
        options: livereload: yes, spawn: no
        tasks: ['deploy:dev']

    emberTemplates:
      compile:
        options:
          amd: true
          templateBasePath: /public\/app\/templates\//
          templateCompilerPath: 'public/vendor/scripts/ember/ember-template-compiler.js'
          handlebarsPath: 'public/vendor/scripts/handlebars/handlebars.js'
        files:
          'public/bundle/templates.js': ['public/app/templates/**/*.hbs']

  grunt.registerTask 'bundle', 'Create project bundle', ['clean', 'requirejs:prod', 'exec:minify_css', 'exec:copy_to_bundle']
  grunt.registerTask 'bundle:full', 'Create full project bundle', ['clean', 'requirejs:full', 'exec:minify_css', 'exec:copy_to_bundle']
  grunt.registerTask 'deploy', 'Deploys bundled app', ['bundle', 'sftp-deploy']

  grunt.registerTask 'deploy:dev', 'Deploys dev bundled app', ['clean', 'requirejs:dev', 'exec:minify_css', 'exec:copy_to_bundle', 'sftp-deploy:dev']

  grunt.registerTask 'test-precompile', '', ->
    fs = require('fs');
    compiler = require('./public/vendor/scripts/ember/ember-template-compiler');
    input = fs.readFileSync('./public/app/templates/application.hbs', { encoding: 'utf8' });
    template = compiler.precompile(input, false);
    output = '(function (Ember) { Ember.HTMLBars.template(' + template + '); })(Ember)';

    fs.writeFileSync('application.hbs.js', output, { encoding: 'utf8' });


  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'
  grunt.loadNpmTasks 'grunt-exec'
  grunt.loadNpmTasks 'grunt-contrib-watch'
#  grunt.loadNpmTasks 'grunt-contrib-cssmin'
#  grunt.loadNpmTasks 'grunt-recess'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
#  grunt.loadNpmTasks 'grunt-contrib-handlebars'
  grunt.loadNpmTasks 'grunt-ember-handlebars'
  grunt.loadNpmTasks 'grunt-ember-templates'
  grunt.loadNpmTasks 'grunt-sftp-deploy'

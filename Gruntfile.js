'use strict';

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    // Metadata.
    pkg: grunt.file.readJSON('package.json'),
    banner: '/*\n* <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
            '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
            '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
            '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>\n' +
            '* Licensed <%= pkg.license %>\n*/',
    clean: {
      files: ['dist']
    },
    coffee: {
      compile: {
        files: {
          'dist/videojs.ga.js': 'src/videojs.ga.coffee',
        }
      }
    },
    uglify: {
      dist: {
        src: 'dist/videojs.ga.js',
        dest: 'dist/videojs.ga.min.js'
      },
    },
    usebanner: {
      taskName: {
        options: { banner: '<%= banner %>' },
        files: { src: [ 'dist/*' ] }
      }
    }
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-banner');

  // Default task.
  grunt.registerTask('default', ['clean', 'coffee', 'uglify', 'usebanner']);

};

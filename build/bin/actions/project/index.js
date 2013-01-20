// Generated by CoffeeScript 1.4.0
var async, fs, skeleton;

async = require('async');

skeleton = require('./skeleton');

fs = require('fs');

exports["new"] = function() {
  var create;
  create = function(name) {
    var config, gitignore, pckge, procfile;
    pckge = new skeleton.Package({
      name: name,
      author: 'Frontfax developer',
      base: name
    });
    gitignore = new skeleton.GitIgnore({
      base: name
    });
    procfile = new skeleton.Procfile({
      base: name
    });
    config = new skeleton.Config({
      base: name
    });
    return async.series([
      function(callback) {
        return pckge.render(callback);
      }, function(callback) {
        return gitignore.render(callback);
      }, function(callback) {
        return procfile.render(callback);
      }, function(callback) {
        return config.render(callback);
      }, function(callback) {
        console.log("\nNow run:\n	cd " + name + "\n	npm i\n");
        return callback();
      }
    ]);
  };
  return function() {
    var name, program, stat;
    program = arguments[arguments.length - 1];
    if (arguments.length < 2) {
      console.log('A name must be given');
      program.help();
    }
    name = arguments[0];
    if (fs.existsSync(name)) {
      stat = fs.statSync(name);
      if (stat.isDirectory()) {
        return program.confirm("\"" + name + "\" already exists. Do you want to create the project inside of an existing directory?", function(ok) {
          process.stdin.destroy();
          if (ok) {
            return create(name);
          } else {
            return process.exit();
          }
        });
      } else {
        return create(name);
      }
    } else {
      return create(name);
    }
  };
};

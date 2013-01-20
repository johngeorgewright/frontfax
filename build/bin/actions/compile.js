// Generated by CoffeeScript 1.4.0
var bin, fs, mkdirp, path, spawn, stalker, walk,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

fs = require('fs');

stalker = require('stalker');

mkdirp = require('mkdirp');

path = require('path');

walk = require('walk');

spawn = require('child_process').spawn;

bin = path.join(__dirname, '..', '..', '..', 'node_modules', '.bin');

exports.js = function(source, dest) {
  var combiningJs, compile;
  combiningJs = false;
  compile = function(program) {
    var files, walker;
    if (!combiningJs) {
      combiningJs = true;
      walker = walk.walk(source);
      files = [];
      walker.on('file', function(root, stats, next) {
        var ext, file;
        file = "" + root + "/" + stats.name;
        ext = path.extname(stats.name);
        if (!(file === dest || ext !== '.js')) {
          files.push(file);
        }
        return next();
      });
      return walker.on('end', function() {
        var commands, uglify;
        if (files.length > 0) {
          console.log("Combining all files from " + source + " to " + dest);
          commands = files;
          commands.push('-o', dest);
          if (program.beautify) {
            commands.push('-b');
          }
          uglify = spawn("" + bin + "/uglifyjs", commands);
          uglify.stdout.on('data', function(data) {
            return console.log(data.toString());
          });
          uglify.stderr.on('data', function(data) {
            return console.log(data.toString());
          });
          return uglify.on('exit', function() {
            var combiningJS;
            return combiningJS = false;
          });
        } else {
          return fs.unlink(dest, function(err) {
            if (err) {
              return console.log(err);
            } else {
              return console.log("Removed " + dest);
            }
          });
        }
      });
    }
  };
  return function(program) {
    var modify;
    modify = function(err, file) {
      if (err) {
        return console.log(err);
      } else {
        return compile(program);
      }
    };
    return mkdirp(path.dirname(dest), function() {
      if (program.watch) {
        return stalker.watch(source, modify, modify);
      } else {
        return compile(program);
      }
    });
  };
};

exports.less = function(source, dest) {
  var compile, compilingLess, cssName, modify, remove;
  compilingLess = [];
  cssName = function(lessName) {
    var basename, buildDir, name;
    name = lessName.replace(source, dest);
    basename = path.basename(name, path.extname(name));
    basename += '.css';
    buildDir = path.dirname(name);
    return "" + buildDir + "/" + basename;
  };
  compile = function(file) {
    var build;
    if (path.extname(file) === '.less' && __indexOf.call(compilingLess, file) < 0) {
      compilingLess.push(file);
      build = cssName(file);
      console.log("Compiling " + file);
      return mkdirp(path.dirname(build), function(err) {
        var lessc;
        if (err) {
          return console.log(err);
        } else {
          lessc = spawn("" + bin + "/lessc", [file, build]);
          lessc.stdout.on('data', function(data) {
            return console.log(data.toString());
          });
          lessc.stderr.on('data', function(data) {
            return console.log(data.toString());
          });
          return lessc.on('exit', function(code) {
            if (code === 0) {
              console.log("Created " + build);
              return compilingLess.splice(compilingLess.indexOf(file), 1);
            }
          });
        }
      });
    }
  };
  modify = function(err, file) {
    if (err) {
      return console.log(err);
    } else {
      return compile(file);
    }
  };
  remove = function(err, file) {
    if (err) {
      return console.log(err);
    } else {
      file = cssName(file);
      return fs.unlink(file, function(err) {
        if (err) {
          return console.log(err);
        } else {
          return console.log("Removed " + file);
        }
      });
    }
  };
  return function(program) {
    return mkdirp(source, function() {
      var walker;
      if (program.watch) {
        return stalker.watch(source, modify, remove);
      } else {
        walker = walk.walk(source);
        return walker.on('file', function(root, stats, next) {
          compile("" + root + "/" + stats.name);
          return next();
        });
      }
    });
  };
};

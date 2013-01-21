// Generated by CoffeeScript 1.4.0
var bin, exec, fs, mkdirp, path, stalker, walk,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

fs = require('fs');

stalker = require('stalker');

mkdirp = require('mkdirp');

path = require('path');

walk = require('walk');

exec = require('child_process').exec;

bin = path.join(__dirname, '..', '..', '..', 'node_modules', '.bin');

exports.js = function(source, dest) {
  var UglifyJS, combiningJs, compile;
  combiningJs = false;
  UglifyJS = require('uglify-js');
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
        var result, _ref;
        if (files.length > 0) {
          console.log("Combining all files from " + source + " to " + dest);
          result = UglifyJS.minify(files, {
            output: {
              beautify: (_ref = program.beautify) != null ? _ref : false
            }
          });
          return fs.writeFile(dest, result.code, function(err) {
            if (err) {
              console.log(err);
            }
            return combiningJs = false;
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
        if (err) {
          return console.log(err);
        } else {
          return exec("" + bin + "/lessc " + file + " " + build, function(error, stdout, stderr) {
            if (error) {
              console.log(error.message);
            } else if (stderr) {
              console.log(stderr);
            } else {
              console.log(stdout);
              console.log("Created " + build);
            }
            return compilingLess.splice(compilingLess.indexOf(file), 1);
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

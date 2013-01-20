// Generated by CoffeeScript 1.4.0
var mkdirp;

mkdirp = require('mkdirp');

exports.createDirectories = function(dirs, callback) {
  var dir, make, _i, _len, _results;
  make = function(path, done) {
    return mkdirp(path, function(err) {
      if (err) {
        callback(err);
      }
      return callback(null, path);
    });
  };
  _results = [];
  for (_i = 0, _len = dirs.length; _i < _len; _i++) {
    dir = dirs[_i];
    _results.push(make(dir));
  }
  return _results;
};

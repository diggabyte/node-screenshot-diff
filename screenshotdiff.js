#!/usr/bin/node

require('coffee-script');
require('coffee-script/register');

global.appRoot = require('path').resolve(__dirname);

var screenshot = require('./lib/node-screenshot-diff/screenshot.js.coffee');
var cli        = require('./lib/node-screenshot-diff/cli.js.coffee');

screenshot.diff(cli.options);

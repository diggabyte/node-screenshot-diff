_       = require('lodash')
program = require('commander')
fs      = require('fs')

program
  .version(require(fs.realpathSync(appRoot + '/package.json')).version)
  .usage('[options] <domain1> <domain2> [paths...]')
  .option('-x, --width <n>', 'Width in pixels of the screenshots. Default: 1400', parseFloat, 1400)
  .option('-y, --height <n>', 'Height in pixels of the screenshots. Default: all', parseFloat, 'all')
  .option('-s, --selector <string>', 'CSS selector to target for the screenshot', '')
  .option('-c, --css <string>', 'Custom CSS rules to apply before taking screenshot', '')
  .option('-d, --delay <n>', 'Delay, in ms, to wait before taking screenshot. Default: 100', parseFloat, 100)
  .option('-o, --outputDir <path>', 'The output dir for images', './screenshots')
  .option('-k, --keep', 'Keep the A/B screenshots used for the diff')
  .option('-p, --protocol <string>', 'Protocol to use. Default: http', 'http')
  .option('-t, --threshold <n>', '(compare) The maximum distortion for (sub)image match. Default: 0.2)', parseFloat, 0.2)
  .option('-f, --fuzz <n>', '(compare) Colors within this distance, as a percentage, are considered equal (0-100). Default: 5', 5)
  .option('-m, --metric <string>', '(compare) Measure differences between images with this metric. Default: AE', 'AE')
  .option('-r, --color <string>', '(compare) Emphasize pixel differences with this color. Default: blue', 'blue')
  .option('-q, --quality <n>', 'Image quality. Default: 100', parseFloat, 100)
  .option('-i, --ignoreSSLErrors', 'Ignore SSL certificate errors')
  .option('-q, --quiet', 'Supress logging information')
  .option('-P, --phantomConfig <json>', 'JSON string of PhantomJS configuration options', JSON.parse, {})
  .option('-C, --compareOpts <json>', 'JSON string of ImageMagick `compare` options', JSON.parse, {})
  .option('-W, --webshotOpts <json>', 'JSON string of node-webshot options', JSON.parse, {})
  .parse(process.argv);

getWebshotOptions = ->
  opts =
    windowSize:
      width: program.width
    shotSize:
      height: program.height
    customCSS: program.css
    quality: program.quality
    phantomConfig: {}
    renderDelay: program.delay
    captureSelector: program.selector
  if program.ignoreSSLErrors
    opts.phantomConfig["ignore-ssl-errors"] = 'yes'
  _.extend opts.phantomConfig, program.phantomConfig
  _.extend program.webshotOpts, opts

getCompareOptions = ->
  opts =
    'dissimilarity-threshold':  program.threshold
    'highlight-color':          program.color
    'fuzz':                     program.fuzz + '%'
    'quality':                  program.quality
    'metric':                   program.metric
  _.extend opts, program.compareOpts
  _.map(opts, (v, k) -> "-#{k} #{v}").join ' '

program.domain1       = program.args.shift();
program.domain2       = program.args.shift();
program.paths         = program.args.splice(0);
program.paths = ['/'] if program.paths.length == 0

program.webshotOpts   = getWebshotOptions()
program.compareOpts   = getCompareOptions()

exports.options = program

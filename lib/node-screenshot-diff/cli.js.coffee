_       = require('lodash')
program = require('commander')

program
  .version('0.0.1')
  .usage('[options] <domain1> <domain2> <paths...>')
  .option('-x, --width <n>', 'Width in pixels of the screenshots. Default: 1400', 1400)
  .option('-y, --height <n>', 'Height in pixels of the screenshots. Default: all', 'all')
  .option('-c, --css <string>', 'Custom CSS rules to apply before taking screenshot', '')
  .option('-o, --outputDir <path>', 'The output dir for images', './screenshots')
  .option('-k, --keep', 'Keep the A/B screenshots used for the diff')
  .option('-p, --protocol <string>', 'Protocol to use. Default: http', 'http')
  .option('-t, --threshold <n>', 'Compare dissimilarity threshold, in px. Default: 10', 10)
  .option('-f, --fuzz <n>', 'Compare fuzz threshold. Default: 5', 5)
  .option('-q, --quality <n>', 'Compare quality. Default: 100', 100)
  .option('-m, --metric <string>', 'Compare metric. Default: AE', 'AE')
  .option('-C, --color <string>', 'Compare color. Default: blue', 'blue')
  .option('-d, --delay <n>', 'Delay, in ms to wait before taking screenshot. Default: 100', 100)
  .option('-i, --ignoreSSLErrors', 'Ignore SSL certificate errors')
  .option('-q, --quiet', 'Supress logging information')
  .option('-P, --phantomConfig <json>', 'JSON string of PhantomJS configuration options', JSON.parse, {})
  .option('-C, --compareOpts <json>', 'JSON string of ImageMagick `compare` options', JSON.parse, {})
  .option('-W, --webshotOpts <json>', 'JSON string of node-webshot options', JSON.parse, {})
  .parse(process.argv);

getWebshotOptions = ->
  opts =
    screensize:
      width: program.width
    shotSize:
     height: program.height
    customCSS: program.customCSS
    phantomConfig: {}
    renderDelay: program.delay
  if program.ignoreSSLErrors
    opts.phantomConfig["ignore-ssl-errors"] = true
  _.extend opts.phantomConfig, program.phantomConfig
  _.extend program.webshotOpts, opts

getCompareOptions = ->
  opts =
    'dissimilarity-threshold':  program.threshold
    'highlight-color':          program.color
    'fuzz':                     program.fuzz
    'quality':                  program.quality
    'metric':                   program.metric
  _.extend opts, program.compareOpts
  _.map(opts, (v, k) -> "-#{k} #{v}").join ' '

program.domain1       = program.args.shift();
program.domain2       = program.args.shift();
program.paths         = program.args.splice(0);
program.webshotOpts   = getWebshotOptions()
program.compareOpts   = getCompareOptions()

exports.options = program

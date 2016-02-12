_           = require('lodash')
sys         = require('sys')
fs          = require('fs')
exec        = require('child_process').exec
webshot     = require('webshot')
Promise     = require('promise')

diff = (opts) ->
  try fs.mkdirSync opts.outputDir

  _.each opts.paths, (path, index) ->
    name        = path.split('?')[0].split('#')[0].replace(/\W/g, '')
    url1        = "#{opts.protocol}://#{opts.domain1}#{path}"
    url2        = "#{opts.protocol}://#{opts.domain2}#{path}"
    screen1     = "#{opts.outputDir}/#{index}_#{opts.domain1}_#{name}.png"
    screen2     = "#{opts.outputDir}/#{index}_#{opts.domain2}_#{name}.png"
    screenDiff  = "#{opts.outputDir}/#{index}_diff_#{name}.png"

    capture = (url, img) ->
      new Promise (fulfill, reject) ->
        console.log("Capturing: #{url}") unless opts.quiet
        webshot url, img, opts.webshotOpts, (err) ->
          if err then reject(err) else _.delay(fulfill, 500)

    compare = ->
      cmd = "compare #{opts.compareOpts} #{screen1} #{screen2} #{screenDiff}"
      exec cmd, (err) ->
        return console.error(err) if err
        console.log("Created Diff: #{screenDiff}") unless opts.quiet
        unless opts.keep
          fs.unlink(screen1, ->)
          fs.unlink(screen2, ->)

    capture(url1, screen1).then ->
      capture(url2, screen2).then(compare)

exports.diff = diff

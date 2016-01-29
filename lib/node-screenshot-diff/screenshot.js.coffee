_           = require('lodash')
sys         = require('sys')
fs          = require('fs')
exec        = require('child_process').exec
webshot     = require('webshot')

diff = (opts) ->
  try fs.mkdirSync opts.outputDir

  _.each opts.paths, (path, index) ->
    name        = path.split('?')[0].split('#')[0].replace(/\W/g, '')
    url1        = "#{opts.protocol}://#{opts.domain1}#{path}"
    url2        = "#{opts.protocol}://#{opts.domain2}#{path}"
    screen1     = "#{opts.outputDir}/#{index}_#{opts.domain1}_#{name}.png"
    screen2     = "#{opts.outputDir}/#{index}_#{opts.domain2}_#{name}.png"
    screenDiff  = "#{opts.outputDir}/#{index}_diff_#{name}.png"

    console.log("Capturing: #{url1}") unless opts.quiet
    webshot url1, screen1, opts.webshotOpts, (err) ->
      throw err if err

      console.log("Capturing: #{url2}") unless opts.quiet
      webshot url2, screen2, opts.webshotOpts, (err) ->
        throw err if err

        cmd = "compare #{opts.compareOpts} #{screen1} #{screen2} #{screenDiff}"
        console.log(cmd)
        exec cmd, (err) ->
          if err
            console.error err
          else
            console.log("Created Diff: #{screenDiff}") unless opts.quiet
            unless opts.keep
              fs.unlink(screen1, ->)
              fs.unlink(screen2, ->)

exports.diff = diff

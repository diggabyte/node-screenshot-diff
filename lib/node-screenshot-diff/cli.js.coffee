_           = require('lodash')
sys         = require('sys')
fs          = require('fs')
exec        = require('child_process').exec
webshot     = require('webshot')
config      = require('../../config/default.json')
decamelize  = require('decamelize')

run = (options) ->
  config = _.extend(config, options) if _.isObject(options)
  try fs.mkdirSync config.outputDir
  _.each config.paths, (pathOpts, name) -> doDiff(name, pathOpts)

getSites = (pathOpts) ->
  if _.isObject(pathOpts)
    path      = pathOpts.path
    protocol  = pathOpts.protocol
    domains   = pathOpts.domains
  else
    path = pathOpts

  protocol  = protocol || 'http:'
  domains   = domains || config.domains

  if domains.length isnt 2
    throw new Error("Exactly two domains are required")

  _.map domains, (domain) ->
    url: "#{protocol}//#{domain}#{path}"
    domain: domain
    protocol: protocol
    path: path

getCompareArgs = ->
  @args ?= (_.map config.compare, (v, k) -> "-#{ decamelize(k, '-') } #{ v }").join ' '
  @args

doDiff = (name, pathOpts) ->
  sites       = getSites(pathOpts)
  site1       = sites[0]
  site2       = sites[1]
  screen1     = "#{config.outputDir}/#{name}_#{site1.domain}.png"
  screen2     = "#{config.outputDir}/#{name}_#{site2.domain}.png"
  screenDiff  = "#{config.outputDir}/#{name}_diff.png"
  compareArgs = getCompareArgs()

  console.log "Capturing: #{site1.url}"
  webshot site1.url, screen1, config.webshot, (err) ->
    throw err if err

    console.log "Capturing: #{site2.url}"
    webshot site2.url, screen2, config.webshot, (err) ->
      throw err if err

      cmd = "compare #{compareArgs} #{screen1} #{screen2} #{screenDiff}"
      exec cmd, (err) ->
        if err
          console.error err
        else
          console.log "Created Diff: #{screenDiff}"
          unless config.keepSourceScreenshots
            fs.unlink(screen1, ->)
            fs.unlink(screen2, ->)

exports.run = run

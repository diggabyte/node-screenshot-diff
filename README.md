# node-screenshot-diff

Generate screenshot diffs for a pair domains and one or more paths.
Used for regressing visual changes between development/staging and production websites.

Still in an alpha release state, so some things might not work as expected.

## Prerequisites

Requires ImageMagick to be installed. Depending on your system, one of the following should work:

    $ brew install imagemagick

    $ apt-get install imagemagick

    $ yum install imagemagick

## Usage

    $ npm install -g screenshot-diff

    $ screenshotdiff --help

      Usage: screenshotdiff [options] <domain1> <domain2> [paths...]

      Options:

        -h, --help                  output usage information
        -V, --version               output the version number
        -x, --width <n>             Width in pixels of the screenshots. Default: 1400
        -y, --height <n>            Height in pixels of the screenshots. Default: all
        -s, --selector <string>     CSS selector to target for the screenshot
        -c, --css <string>          Custom CSS rules to apply before taking screenshot
        -d, --delay <n>             Delay, in ms, to wait before taking screenshot. Default: 100
        -o, --outputDir <path>      The output dir for images
        -k, --keep                  Keep the A/B screenshots used for the diff
        -p, --protocol <string>     Protocol to use. Default: http
        -t, --threshold <n>         (compare) The maximum distortion for (sub)image match. Default: 0.2)
        -f, --fuzz <n>              (compare) Colors within this distance, as a percentage, are considered equal (0-100). Default: 5
        -m, --metric <string>       (compare) Measure differences between images with this metric. Default: AE
        -r, --color <string>        (compare) Emphasize pixel differences with this color. Default: blue
        -q, --quality <n>           Image quality. Default: 100
        -i, --ignoreSSLErrors       Ignore SSL certificate errors
        -q, --quiet                 Supress logging information
        -P, --phantomConfig <json>  JSON string of PhantomJS configuration options
        -C, --compareOpts <json>    JSON string of ImageMagick `compare` options
        -W, --webshotOpts <json>    JSON string of node-webshot options

## TODO
 * Test coverage
 * Guidelines for contributing
 * Allow paths to have different protocols / options / css / js
 * Injecting custom JS to run before screenshots

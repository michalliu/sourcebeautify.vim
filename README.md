sourcebeautify.vim
==================

Beautify your source code in Vim

It support javascript,css,html currently which is powered by [js-beautify](https://github.com/einars/js-beautify)

More language support is well welcomed, your can develop it by pure javascript, see `Customization` for more info.

Install
-------

copy __plugin/sourcebeautify__ to __vimfiles/plugin__


Usage
-----

    <Leader>sb

Your \<Leader\> key is often `\`


Customization
-------------

1. to add more language support

If you wants this plugin to support cpp file, you should create `beautify-cpp.js` and `beautify-cpp.run.js`.

These two files are pure javascript

2. jsbeautify options

Take a look at `beautify-css.run.js`, this file contains following code

        css_beautify(%s);

`%s` refers to the codes before beautify, the other part is pure javascript.

options about beautify javascript look at [here](https://github.com/einars/js-beautify/blob/master/beautify.js)
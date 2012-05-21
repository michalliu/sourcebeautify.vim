sourcebeautify.vim
==================

Beautify your source code in Vim

It support javascript,css,html currently which is powered by [js-beautify](https://github.com/einars/js-beautify)

More language support is well welcomed, your can develop it by pure javascript, see `Customization` for more info.

Install
-------

This plugin requires [jsruntime.vim](https://github.com/michalliu/jsruntime.vim) and [jsoncodecs.vim](https://github.com/michalliu/jsoncodecs.vim) to be installed first

then copy __plugin/sourcebeautify__ to __vimfiles/plugin__


Usage
-----

    <Leader>sb

Your \<Leader\> key is often `\`


Customization
-------------

1. jsbeautify options

    Take a look at `beautify-css.run.js`, this file contains following code

        css_beautify(%s);

    `%s` refers to the codes before beautify, the other part is pure javascript, for example
    
        css_beautify(%s,{indent_char:'\t'});

    [javascript beautifier options](https://github.com/einars/js-beautify/blob/master/beautify.js), [html beautifier options](https://github.com/einars/js-beautify/blob/master/beautify-html.js), [css beautifier options](https://github.com/einars/js-beautify/blob/master/beautify-css.js)

2. add more language support

    If you wants this plugin to support cpp file, you should create `beautify-cpp.js` and `beautify-cpp.run.js`.

    These two files should be written by pure javascript, then modify `sourcebeautify.vim` add declaration and alias
    
        " sourcetype that support by this plugin
        let s:beautifiers.supportedSourceType={
        \'javascript':1,
        \'css':1,
        \'html':1
        \}
    
        " sourcetype name alias
        let s:beautifiers.supportedSourceTypeAlias={
        \'javascript':['js'],
        \'html':['xhtml','htm']
        \}
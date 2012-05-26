sourcebeautify.vim
==================

Beautify your source code in Vim

It support `javascript,css,html` which is powered by [js-beautify](https://github.com/einars/js-beautify) and `JSON` powered by [jsonlint](https://github.com/zaach/jsonlint)

More language support is well welcomed, your can develop it by pure javascript, see `Customization` for more info.

Install
-------

This plugin requires [jsruntime.vim](https://github.com/michalliu/jsruntime.vim) and [jsoncodecs.vim](https://github.com/michalliu/jsoncodecs.vim) to be installed first

then copy __plugin/sourcebeautify__ to __vimfiles/plugin__

Sourcebeautify support json file, but vim can't detect `json` type automaticly. You can add following code to your `vimrc`. I suggest to install [json.vim](http://www.vim.org/scripts/script.php?script_id=1945)

    au BufRead,BufNewFile *.json setf json

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

    [javascript beautifier options](https://github.com/einars/js-beautify/blob/master/beautify.js), [html beautifier options](https://github.com/einars/js-beautify/blob/master/beautify-html.js), [css beautifier options](https://github.com/einars/js-beautify/blob/master/beautify-css.js), [jsonlint options](https://github.com/zaach/jsonlint)

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

Contributor
-----------

__Einar Lielmanis__ - author of  [js-beautify](https://github.com/einars/js-beautify) provide beautifier of `javascript`,`html`,`css` file

__Zach Carter__ - author of  [jsonlint](https://github.com/zaach/jsonlint) provide error checker and beautifier of `JSON` file

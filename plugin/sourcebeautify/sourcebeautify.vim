" Maintainer: yf liu <sophia.smth@gmail.com>
"
" Requires: jsruntime http://www.vim.org/scripts/script.php?script_id=4050
"           jsoncodecs http://www.vim.org/scripts/script.php?script_id=4056
"
" Description: Web Language Beautifier Powered by js-beautify
"              It support html,css,javascript files currently
"              https://github.com/einars/js-beautify
"
" Version: 1.0
if exists('g:loaded_sourcebeautify') || &cp || version < 700
	finish
endif
let g:loaded_sourcebeautify = 1

let s:install_dir = expand("<sfile>:p:h")

let s:beautifiers = {}
" sourcetype that support by this plugin
let s:beautifiers.supportedSourceType={
\'javascript':1,
\'css':1,
\'html':1,
\'json':1
\}
" sourcetype name alias
let s:beautifiers.supportedSourceTypeAlias={
\'javascript':['js'],
\'html':['xhtml','htm']
\}
" dump context files(beautify-{type}.js) to memory to improve performance
let s:beautifiers.contextCache={}
" check if context is already loaded
let s:beautifiers.loadedContext={}
" dump runner files(beautify-{type}.run.js) to memory to improve performance
let s:beautifiers.runnerCache={}

" init beautifier
" context loader
function! s:beautifiers.prepareContext() dict

    " current working source type
    let self.st=&filetype
    " check if support current file type
    let issupport = get(self.supportedSourceType,self.st)

    " if not check the alias name
    if !issupport
        for alias in keys(self.supportedSourceTypeAlias)
            let aliasmap = self.supportedSourceTypeAlias[alias]
            if index(aliasmap, self.st) >= 0
                let self.st = alias
                break
            endif
        endfor
    endif
    " recheck
    let issupport = get(self.supportedSourceType,self.st)

    " not found beautifier
    if !issupport
        echoerr("sry sourcebeautify doesn't support ".(strlen(&filetype) ? &filetype : "unknown")." file yet")
        return 0
    endif

    " context is ok
    if get(self.loadedContext, self.st)
        return 1
    endif
    " start prepare context
    let context = get(self.contextCache,self.st, "")

    " context not cached, put to cache
    if !len(context)
        let beautifierpath = s:install_dir.'/beautifiers/beautify-'.self.st.'.js'
        " cache executable context
        if !filereadable(beautifierpath)
            echoerr "sourcebeautify.vim can't readfile from path ".beautifierpath
            return 0
        endif
        let context = join(readfile(beautifierpath),"\n")
        let self.contextCache[self.st]=context
    endif

    if javascript#runtime#isSupportLivingContext()
        " exec context
        call javascript#runtime#evalScript(context,0)
        " set & update flag
        let self.loadedContext[self.st] = 1
    else
        " reset flag
        let self.loadedContext = {}
    endif

    return 1

endfunction

function! s:beautifiers.beautify(source) dict

    " read from cache
    let runner = get(self.runnerCache,self.st, "")

    " evalable javascript
    let js = []

    " runner not cached
    if !len(runner)
        let runnerpath = s:install_dir.'/beautifiers/beautify-'.self.st.'.run.js'
        " cache runner
        if !filereadable(runnerpath)
            echoerr "sourcebeautify.vim can't readfile from path ".runnerpath
            return "undefined"
        endif
        let runner = join(readfile(runnerpath),"\n")
        let self.runnerCache[self.st]=runner
    endif

    " context must be prepared, context doesn't exist put to evalute waiting
	" list
    if !javascript#runtime#isSupportLivingContext()
        call add(js,get(self.contextCache,self.st, ""))
    endif

    call add(js,printf(runner,jsoncodecs#dump_string(a:source)))

    return javascript#runtime#evalScript(join(js,"\n"))

endfunction

if !exists("*s:beautify")
    function s:beautify(...)
       echo "beautifying, please wait..."
       let success = s:beautifiers.prepareContext()
       if success
           let @0 = s:beautifiers.beautify(getline(1,'$'))
           if @0 != "undefined"
               :g/.*/d
               put!0
               :normal gg
           else
               echo "done,but beautifier returns nothing"
           endif
       else
           redraw!
       endif
    endfunction
endif

nnoremap <silent> <leader>sb :call <SID>beautify()<cr>

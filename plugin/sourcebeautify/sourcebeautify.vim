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

if exists("b:did_sourcebeautify_plugin")
    finish
else
    let b:did_sourcebeautify_plugin = 1
endif

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
" check if context is already loaded to jsruntime
let s:beautifiers.loadedContext={}
" dump runner files(beautify-{type}.run.js) to memory to improve performance
let s:beautifiers.runnerCache={}

" init beautifier
" context loader
function! s:beautifiers.prepareContext() dict

    " current working source type
    let self.st=&filetype

    let issupport = get(self.supportedSourceType,self.st)

    " check alias name
    if !issupport
        for alias in keys(self.supportedSourceTypeAlias)
            let aliasmap = self.supportedSourceTypeAlias[alias]
            if index(aliasmap, self.st) >= 0
                let self.st = alias
                break
            endif
        endfor
    endif

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

    let context = get(self.contextCache,self.st, "")

    " context not cached
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

    if g:jsruntime_support_living_context
        " exec context in jsruntime
        call b:jsruntimeEvalScript(context,0)
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

    " context must be prepared
    if !g:jsruntime_support_living_context
        call add(js,get(self.contextCache,self.st, ""))
    endif

    call add(js,printf(runner,b:json_dump_string(a:source)))

    return b:jsruntimeEvalScript(join(js,"\n"))

endfunction

" Check if dependency is ok
" if ok this function return 1 
" if not ok this function return 0 and print out errors
" this is to ensure even someone change the name of this file, this plugin
" still works
" more info :help initialization
if !exists("*s:checkDependency")
    function s:checkDependency()
        if !exists("g:loaded_jsruntime")
            echoerr('sourcebeautify requires jsruntime.vim, plz visit http://www.vim.org/scripts/script.php?script_id=4050')
            return 0
        endif

        if !g:loaded_jsruntime
            echoerr('sourcebeautify complains jsruntime is not working properly')

            return 0
        endif

        if !exists("g:loaded_jsoncodecs")
            echoerr('sourcebeautify requires jsoncodecs.vim, plz visit http://www.vim.org/scripts/script.php?script_id=4056')
            return 0
        endif
        return 1
    endfunction
endif

if !exists("*s:beautify")
    function s:beautify(...)
        if s:checkDependency()
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
        endif
    endfunction
endif

nnoremap <silent> <leader>sb :call <SID>beautify()<cr>

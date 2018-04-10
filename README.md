# vim-logger
vim-logger provides easy print statements for some common languages. I get tired of having to type out `console.log('my var', myVar);` so this plugin makes it possible to insert log statements with a few keystrokes

![Example](https://raw.githubusercontent.com/jcharry/vim-logger/master/example.gif)

## Usage
Out of the box this plugin provides 3 mappings:

1. `co` - in normal mode to add a log statement for the last thing you yanked
2. `ci` - starts a print statement for you (and leaves you in insert mode where it counts) 
3. `cl` followed by a text object, like: 
  * `cliw` will log out the word under the cursor
  * `cliW` will log out the Word under the cursor
  * `clib` will log out whatever is in between parens ()
  * etc.
4. `cl` also works in visual mode and will add a log statement with the selected text

## Installation
It's recommneded you use your favorite bundler like [Vundle](https://github.com/VundleVim/Vundle.vim) or [Pathogen](https://github.com/tpope/vim-pathogen)

## Configuration
Templates for log statements are preconfigured by file extension, but can be overridden (or new extensions can be supported) by setting the following in your vimrc
```
let g:vim_logger_templates = {
  \'js': "console.log('$$', $$)"
  \'py': "print('$$', $$)"
\}
```

The special characters `$$` are used as `find and replace` markers, meaning, they will get substituted for the incoming text object.

The default mappings are as follows. You can copy these into your vimrc and change them to your liking.
```
" Add a print statement for whatever is in the Yank register
nmap co <Plug>LogFromLastYank

" Create a new line with a barebones print statment
nmap ci <Plug>LogFromInsertMode

" Log from following text object
nmap cl <Plug>LogFromTextObject
vmap cl <Plug>LogFromTextObject
```

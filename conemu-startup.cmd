:: use this file to run your own startup commands 
:: use @ in front of the command to prevent printing the command
 
:: @call "C:\Program Files\Git/cmd/start-ssh-agent.cmd
:: @set PATH=%CMDER_ROOT%\vendor\whatever;%PATH%

:: for cmder: put this into cmder/config as "user-startup.cmd"

:: setlocal does not affect doskey commands
@echo off
setlocal

:: call local script, if TOOLS_DIR is set there, scripts will be configured 
set localscr=%HOME%\conemu-startup.local.cmd
if exist %localscr% (
	call %localscr%
)

:: Navigation
doskey cd = cd /d $*
doskey cl = cd $* $T ls -l --show-control-chars -F --color
doskey ls = ls --show-control-chars -F --color $*
doskey ll = ls -l --show-control-chars -F --color $*
doskey l  = ls -l --show-control-chars -F -a --color $*
doskey .. = cd ..

:: Git
doskey gc = git commit $*
doskey gp = git push $*

doskey ga  = git add $*
doskey gs  = git status $*
doskey gl  = git log --oneline --graph --decorate $*
doskey gla = git log --oneline --all --graph --decorate $*

doskey gb  = git branch $*
doskey gco = git checkout $*

doskey gita = for /d %%a in (*.*) do @(echo --^^^> %%a - git $* ^& cd %%a ^& git $* ^& echo. ^& cd .. )

:: tool dir setup
if "%___TOOLS_DIR%" NEQ "" (
    doskey pss   = python "%___TOOLS_DIR%\scheduleshutdown.py" $*
    doskey bud   = python "%___TOOLS_DIR%\datefilebackup.py" $*
    doskey pych  = python "%___TOOLS_DIR%\pycharmlauncher.py" $*
    doskey rfile = python "%___TOOLS_DIR%\randfile.py" $*
    doskey editshortcuts = gvim "%___TOOLS_DIR%\shortcuts.ahk"
    doskey cdtooldir = cd /d "%___TOOLS_DIR%"
) else (
    echo No TOOLS_DIR set!
)

:: Folders
doskey pr = cd /d "%___PROJECT_DIR%"
doskey ws = cd /d "%___WORKSPACE_DIR%"

:: Misc
doskey g     = gvim --remote-silent $*
doskey e.    = explorer .
doskey npp   = "%ProgramFiles(x86)%\Notepad++\notepad++.exe" $*
doskey clear = cls
doskey mdshow = markdown_py -x markdown.extensions.nl2br $1 ^> $1.html $T start $1.html $T sleep 1 $T del $1.html

:: General shortcuts
doskey pipupdateall = pip freeze --local ^| grep -v '^\-e' ^| cut -d = -f 1  ^| xargs pip install -U

:: Aliases
doskey aliases     = doskey /MACROS
doskey editaliases = gvim --remote-silent "%~f0"
doskey editlocalaliases = gvim --remote-silent %localscr%

:: call local script
if exist %localscr% (
	call %localscr%
)


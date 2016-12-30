:: use this file to run your own startup commands 
:: use @ in front of the command to prevent printing the command
 
:: @call "C:\Program Files\Git/cmd/start-ssh-agent.cmd
:: @set PATH=%CMDER_ROOT%\vendor\whatever;%PATH%

:: for Cmder: put this into Cmder/config as "user-startup.cmd"

:: setlocal does not affect doskey commands
@echo off
setlocal

:: get the "real" dir of this file, I insert this into Cmder with a symlink
for /f %%i in ('dir "%~dp0" ^| grep "<SYMLINK>" ^| cut -d "[" -f2 ^| cut -d "]" -f1') do set ABS_PATH=%%i
for /f %%i in ('dirname %ABS_PATH%') do set TOOLS_DIR=%%i

:: Navigation
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

doskey gita = FOR /d %%F IN (*) DO  @( cd %%F $T echo %%F: $T git $* $T echo. $T cd .. )

:: Custom Programs
doskey pss   = python "%TOOLS_DIR%\scheduleshutdown.py" $*
doskey bud   = python "%TOOLS_DIR%\datefilebackup.py" $*
doskey pych  = python "%TOOLS_DIR%\pycharmlauncher.py" $*
doskey rfile = python "%TOOLS_DIR%\randfile.py" $*

:: Folders
doskey pr = cd /d "%PROJECT_DIR%"
doskey ws = cd /d "%WORKSPACE_DIR%"

:: Misc
doskey g     = gvim --remote-silent $*
doskey e.    = explorer .
doskey npp   = "%ProgramFiles(x86)%\Notepad++\notepad++.exe" $*
doskey clear = cls

:: Aliases
doskey aliases     = doskey /MACROS
doskey editaliases = gvim "%~f0"

REM echo on

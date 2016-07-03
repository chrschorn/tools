:: use this file to run your own startup commands 
:: use @ in front of the command to prevent printing the command
 
:: @call "C:\Program Files\Git/cmd/start-ssh-agent.cmd
:: @set PATH=%CMDER_ROOT%\vendor\whatever;%PATH%

:: for Cmder: put this into Cmder/config as "user-startup.cmd"

@echo off

doskey cl = cd $* $T ls -l --show-control-chars -F --color
doskey ls = ls --show-control-chars -F --color $*
doskey ll = ls -l --show-control-chars -F --color $*
doskey .. = cd ..

:: Git
doskey gc = git commit -m $*
doskey gp = git push $*

doskey ga = git add $*
doskey gs = git status $*
doskey gl = git log --oneline --all --graph --decorate $*

doskey gita = FOR /d %%F IN (*) DO  @( cd %%F $T echo %%F: $T git $* $T echo. $T cd .. )

:: Custom Programs
doskey pss = python "%WORKSPACE_DIR%\tools\scheduleshutdown.py" $*
doskey bud = python "%WORKSPACE_DIR%\tools\datefilebackup.py" $*

:: Folders
doskey pr = cd /d "%PROJECT_DIR%"
doskey ws = cd /d "%WORKSPACE_DIR%"

:: Misc
doskey e.    = explorer .
doskey npp   = "%ProgramFiles(x86)%\Notepad++\notepad++.exe" $*
doskey clear = cls

:: Aliases
doskey aliases     = doskey /MACROS
doskey editaliases = vim "%~f0"

echo on

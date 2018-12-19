; Keylist: https://autohotkey.com/docs/KeyList.htm


; ------------------------------------------
; Default settings recommended by AutoHotkey
; ------------------------------------------
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; ---------------
; Custom settings
; ---------------
#SingleInstance force  ; Force single instance


; ---------
; Functions
; ---------
StartOrActivate(id, path, maximized:=true) 
{
    IfWinExist, %id% 
    {
        IfWinActive, %id% 
        {
            WinMinimize %id% 
        }
        else 
        {
            WinActivate %id% 
            WinSet, Top
        }
    }
    else
    {
        Run %path%
        WinWait %id%
        if maximized
            WinMaximize %id%
        WinSet, Top
    }
    Return
}

; ---------
; Variables
; ---------
EnvGet, appdata, APPDATA  ; left: env variable, right: script variable name
EnvGet, home, USERPROFILE

cmder_id = ahk_class VirtualConsoleClass
cmder_path = %home%\cmder\Cmder.exe

spotify_id = ahk_class SpotifyMainWindow
spotify_path = %appdata%\Spotify\Spotify.exe

keepass_id = ahk_exe KeePass.exe
keepass_path = %home%\KeePass\KeePass.exe

gvim_id = ahk_class Vim
gvim_path = gvim.exe

calc_id = ahk_class CalcFrame
calc_path = calc.exe


; --------------------------------------------------------------------------------------
; Hotkeys Section
; --------------------------------------------------------------------------------------


; ---------------------
; Spotify Control
; ---------------------
>^End::Media_Play_Pause  ; >^ = Right CTRL
>^Del::Media_Prev
>^PgDn::Media_Next
>^Insert::WinMenuSelectItem, %spotify_id%, , 4&, 8&  ; Spotify Shuffle Mode
>^PgUp::WinMenuSelectItem, %spotify_id%, , 4&, 9& ; Spotify Repeat Mode
>^Home::StartOrActivate(spotify_id, spotify_path)  ; start spotify maximized or activate spotify if already exists
>^Up::Send {Volume_Up}
>^Down::Send {Volume_Down}
#l::Media_Stop  ; stop music when locking windows


; ---------------------
; Get ahk_class name of active window
; ---------------------
>^w::  ; right ctrl + g
WinGetClass, class, A
MsgBox, The active window's class is "%class%".
Return


;----------------------
; Start or activate programs
;----------------------
#If !WinActive(gvim_id)
>^g::StartOrActivate(gvim_id, gvim_path)

#If !WinActive(calc_id)
>^r::StartOrActivate(calc_id, calc_path, false)

; ---------------------
; Run programs if no window of them exists (typically have own activate hotkey)
; ---------------------
#If !WinExist(cmder_id)
^ö::Run %cmder_path%

#If !WinExist(keepass_id)
^!k::Run %keepass_path%


; ---------------------
#include %A_AppData%\..\..\shortcuts.local.ahk


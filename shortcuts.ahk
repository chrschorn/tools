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
; Variables
; ---------
EnvGet, APPDATA, appdata  ; left: env variable, right: script variable name
EnvGet, HOME, home

cmder_id = ahk_class VirtualConsoleClass
cmder_path = %home%\cmder\Cmder.exe

spotify_id = ahk_class SpotifyMainWindow
spotify_path = %appdata%\Spotify\Spotify.exe

keepass_id = ahk_exe KeePass.exe
keepass_path = %home%\KeePass\KeePass.exe


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
>^Home::  ; start spotify maximized or activate spotify if already exists
IfWinExist, %spotify_id%
{
	IfWinActive, %spotify_id%
		WinMinimize %spotify_id%
	else
		WinActivate %spotify_id%
		WinSet, Top
}
else
{
	Run %spotify_path%
	WinWait %spotify_id%
	WinMaximize
}
Return

>^Up::Send {Volume_Up}
>^Down::Send {Volume_Down}


; ---------------------
; Get ahk_class name of active window
; ---------------------
>^g::  ; right ctrl + g
WinGetClass, class, A
MsgBox, The active window's class is "%class%".
Return

; ---------------------
; Run programs if no window of them exists
; ---------------------
#If !WinExist(cmder_id)
^ö::Run %cmder_path%

#If !WinExist(keepass_id)
^!k::Run %keepass_path%


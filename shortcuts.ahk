; Keylist: https://autohotkey.com/docs/KeyList.htm


; ------------------------------------------
; Default settings recommended by AutoHotkey
; ------------------------------------------
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#MaxHotkeysPerInterval 300


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


HARestAPI(path, payload) 
{
    ; Store the auth token as env var "HA_API_TOKEN"
	req := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	req.Open("POST", "https://home.schorn.me:443/api" . path, False)
	EnvGet, HA_API_TOKEN, HA_API_TOKEN
	req.setRequestHeader("Authorization", "Bearer " . HA_API_TOKEN)
	req.setRequestHeader("Content-Type", "application/json")
	req.Send(payload)
	req.WaitForResponse()
    ; For debugging:
	;resp := req.ResponseText
	;MsgBox, Response: %resp%
    Return
}

; ---------
; Variables
; ---------
EnvGet, appdata, APPDATA  ; left: env variable, right: script variable name
EnvGet, home, USERPROFILE
EnvGet, prog86, programfiles(x86)


; --------------------------------------------------------------------------------------
; Hotkeys Section
; --------------------------------------------------------------------------------------

; ---------------------
; Spotify Control
; ---------------------
>^End::Media_Play_Pause  ; >^ = Right CTRL
>^Del::Media_Prev
>^PgDn::Media_Next
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
; Home automation
;----------------------
^F9::HARestAPI("/services/scene/turn_on", "{""entity_id"": ""scene.office_christoph_chill""}")
^F10::HARestAPI("/services/scene/turn_on", "{""entity_id"": ""scene.office_christoph_chill_bright""}")
^F12::HARestAPI("/services/switch/toggle", "{""entity_id"": ""switch.virtual_switch_office_christoph_speakers""}")

;----------------------
; Start or activate programs
;----------------------
#IfWinActive ahk_class CalcFrame 
>^r::StartOrActivate("ahk_class CalcFrame", "calc.exe", false)
#IfWinActive

; ---------------------
; Run programs if no window of them exists (typically have own activate hotkey)
; ---------------------
#IfWinExist ahk_class VirtualConsoleClass
^ö::Run %home%\cmder\Cmder.exe
#IfWinExist


#IfWinExist ahk_exe KeePass.exe
^!k::Run %prog86%\KeePass Password Safe 2\KeePass.exe
#IfWinExist


#IfWinActive ahk_exe cs2.exe
LAlt::F9
#IfWinActive


; ---------------------
#include %A_AppData%\..\..\shortcuts.local.ahk



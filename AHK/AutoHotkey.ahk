#Include C:/Users/Udayraj021/Documents/LidWatcher.ahk
; #SingleInstance Force
; #installKeybdHook
; #Persistent
; Menu, Tray, Icon , Shell32.dll, 25, 1
; TrayTip, AutoHotKey, Started, 1
; ; SoundBeep, 300, 150
; Return

; Ctrl Win R
^#r::Reload

r := Start_LidWatcher()  ;Start waiting for the lid to be opened or closed
OnExit, cleanup
return

cleanup:
  Stop_LidWatcher(r)  ;Stop watching the lid state changes
  ExitApp
return

; This function will be called whenever the lid changes states.
; newstate will be either "opened" or "closed", hopefully self-explanatory.
LidStateChange(newstate)
{
  if(newstate!="opened")
  	DllCall("LockWorkStation") ; Lock your session (Win-L)
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LWin & f1::SoundBeep, 1500, 500


; TODO - if CMD is active, use Ctrl D to type exit enter (or Alt Space C)

^!t:: ; ctrl alt T
	; #ifwinactive, ahk_class CabinetWClass
	SoundBeep, 800, 300
	ifwinactive,ahk_class CabinetWClass
	{
	  ; ControlGetText is for the text of elements in menu bar
	  ; ControlGetText, address , edit1,ahk_class CabinetWClass
	  Send {Alt down}D{Alt up}cmd{enter}
	}
	else{
                Run "D:\DC Downloads\INSTALL_DIR\CMDer\vendor\conemu-maximus5\ConEmu64.exe" -Dir "C:/Users/Udayraj021/Desktop"
		; Run bash.exe -c "cd C:/Users/Udayraj021/Desktop; bash"		
	}
	Return
	; #ifwinactive ; Restores to normal behaviour, if needed


; ^SPACE:: This is now for phpstorm autocomplete!
^+SPACE:: ; Ctrl shift space
	SoundBeep, 1200, 500
	Winset, Alwaysontop, TOGGLE, A
	Return

^Q::
	splashWidth := 400
	splashHeight := 100

	ifwinactive,ahk_exe BatmanAK.exe
	{
	SoundBeep, 700, 500
	}
	else{
	SplashTextOn, splashWidth, splashHeight, Clipboard data, It contains:`n%clipboard%
	WinMove, Clipboard, , A_ScreenWidth-splashWidth*1.2, A_ScreenHeight -splashHeight*2.0  ; Move the splash window to the top left corner.
	SoundBeep, 800, 200
	Run, "C:\Users\Udayraj021\Documents\restartSquid.bat.lnk" ; shortcut to make it run as admin
	Sleep, 3000
	SplashTextOff
	}


	
;^+m:: send {{Control}{Alt}{del}}
/*^b::                                       ; Ctrl & b Hotkey
   send, {ctrl down}c{ctrl up}             ; Copies the selected text. ^c could be used as well, but this method is more secure.
   SendInput, [b]{ctrl down}v{ctrl up}[/b] ; Wraps the selected text in bbcode (forum) Bold tags.
Return
*/

;*LAlt & mou::Send, {Shift}



; #IfWinActive, ahk_exe csgo.exe
; {
; LAlt & Tab:: Send, k{Tab}
; Tab & LAlt:: Send, k{Tab}

; ; Tab & LAlt:: Send,  {LAlt}l
; LWin::
; 	SendInput, {LAlt}
; 	Return
; }
; #IfWinActive

/*^+!s::
	send, {click 30,60}
return
*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
/*
Obsolete? Erraneous?:

; Build the LIDSWITCH_STATE_CHANGE GUID
VarSetCapacity(GUID_LIDSWITCH_STATE_CHANGE, 16)
for each, Number in [0xBA3E0F4D, 0x4094B817, 0x63D5D1A2, 0xF3A0E679]
	NumPut(Number, GUID_LIDSWITCH_STATE_CHANGE, 4*(A_Index-1), "UInt")

; Register the hooks
DllCall("RegisterPowerSettingNotification"
, "Ptr", A_ScriptHwnd
, "Ptr", &GUID_LIDSWITCH_STATE_CHANGE
, "UInt", 0)
OnMessage(0x218, "WM_POWERBROADCAST")

WM_POWERBROADCAST(wParam, lParam, Msg, hWnd)
{
	GUID := NumGet(lParam+0, 0, "UInt")
	if (GUID != 0xBA3E0F4D) ; Does not start with lidswitch GUID
		return
	
	Open := NumGet(lParam+0, 20, "UChar") ; 1 or 0
	if Open
	{
		; Opening the lid
		SoundBeep, 750
	}
	else
	{
		; Closing the lid
		SoundBeep, 500
		DllCall("LockWorkStation") ; Lock your session (Win-L)
	}
}
*/




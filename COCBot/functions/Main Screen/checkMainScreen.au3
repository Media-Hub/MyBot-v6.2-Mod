; #FUNCTION# ====================================================================================================================
; Name ..........: checkMainScreen
; Description ...: Checks whether the pixel, located in the eyes of the builder in mainscreen, is available
;				   If it is not available, it calls checkObstacles and also waitMainScreen.
; Syntax ........: checkMainScreen([$Check = True]), IsWaitingForConnection()
; Parameters ....: $Check               - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........:
; Modified ......: KnowJack (July/Aug 2015) , TheMaster (2015), MR.ViPER (2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkObstacles(), waitMainScreen()
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func checkMainScreen($Check = True, $CheckZoomout = True) ;Checks if in main screen

	Local $iCount, $Result
	If $Check = True Then
		SetLog("Trying to locate Main Screen")
	Else
		;If $debugsetlog = 1 Then SetLog("checkMainScreen start quiet mode", $COLOR_DEBUG) ;Debug
	EndIf
	If CheckAndroidRunning(False) = False Then Return
	getBSPos() ; Update $HWnd and Android Window Positions
	#cs
		If $ichkBackground = 0 And $NoFocusTampering = False And $AndroidEmbedded = False Then
		Local $hTimer = TimerInit(), $hWndActive = -1
		Local $activeHWnD = WinGetHandle("")
		While TimerDiff($hTimer) < 1000 And $hWndActive <> $HWnD And Not _Sleep(100)
		getBSPos() ; update $HWnD
		$hWndActive = WinActivate($HWnD) ; ensure bot has window focus
		WEnd
		If $hWndActive <> $HWnD Then
		; something wrong with window, restart Android
		RebootAndroid()
		Return
		EndIf
		WinActivate($activeHWnD) ; restore current active window
		EndIf
	#ce
	WinGetAndroidHandle()
	If $ichkBackground = 0 And $HWnD <> 0 Then
		; ensure android is top
		BotToFront()
	EndIf
	If $AndroidAdbScreencap = False And _WinAPI_IsIconic($HWnD) Then WinSetState($HWnD, "", @SW_RESTORE)
	$iCount = 0
	While _CheckPixel($aIsMain, $bCapturePixel) = False
		WinGetAndroidHandle()
		If _Sleep($iDelaycheckMainScreen1) Then Return
		$Result = checkObstacles()
		If $debugsetlog = 1 Then Setlog("CheckObstacles Result = " & $Result, $COLOR_DEBUG) ;Debug

		If ($Result = False And $MinorObstacle = True) Then
			$MinorObstacle = False
		ElseIf ($Result = False And $MinorObstacle = False) Then
			RestartAndroidCoC() ; Need to try to restart CoC
		Else
			$Restart = True
		EndIf
		waitMainScreen() ; Due to differeneces in PC speed, let waitMainScreen test for CoC restart
		If Not $RunState Then Return
		If @extended Then Return SetError(1, 1, -1)
		If @error Then $iCount += 1
		If $iCount > 2 Then
			SetLog("Unable to fix the window error", $COLOR_RED)
			CloseCoC(True)
			ExitLoop
		EndIf
	WEnd
	If $CheckZoomout Then ZoomOut()
	If Not $RunState Then Return

	If $Check = True Then
		SetLog("Main Screen Located", $COLOR_GREEN)
	Else
		;If $debugsetlog = 1 Then SetLog("checkMainScreen exit quiet mode", $COLOR_DEBUG) ;Debug
	EndIf

	;After checkscreen dispose windows
	DisposeWindows()
EndFunc   ;==>checkMainScreen

Func IsWaitingForConnection()
	If _ColorCheck(_GetPixelColor(430, 365, True), Hex(0xEF7800, 6), 20) Then
		If _ColorCheck(_GetPixelColor(427, 362, True), Hex(0xFF8800, 6), 20) Then
			If _ColorCheck(_GetPixelColor(432, 369, True), Hex(0xB75C00, 6), 20) Then
				If _ColorCheck(_GetPixelColor(429, 365, True), Hex(0xEF7800, 6), 20) Then
					If _ColorCheck(_GetPixelColor(426, 362, True), Hex(0x7F4000, 6), 20) Then
						If _ColorCheck(_GetPixelColor(433, 369, True), Hex(0x3F2000, 6), 20) Then
							SetLog("CoC is Waiting for Connection...", $COLOR_RED)
							CloseCoC(True)
							Return True
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	Return False
EndFunc   ;==>IsWaitingForConnection


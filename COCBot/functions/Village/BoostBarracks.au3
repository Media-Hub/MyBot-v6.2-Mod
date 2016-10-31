; #FUNCTION# ====================================================================================================================
; Name ..........: BoostBarracks.au3
; Description ...:
; Syntax ........: BoostBarracks(), BoostDarkBarracks(), BoostSpellFactory(), BoostDarkSpellFactory()
; Parameters ....:
; Return values .: None
; Author ........: MR.ViPER
; Modified ......: MR.ViPER (9-9-2016), MR.ViPER (17-10-2016) Oct Update
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $DebugBarrackBoost = 0

Func BoostBarracks()
	If $bTrainEnabled = False Then Return
	If $icmbBoostBarracks = 0 Then Return
	If $icmbBoostBarracks > 1 Then
		Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		If $iPlannedBoostBarracksHours[$hour[0]] = 0 Then
			SetLog("Boost Barracks are not Planned, Skipped..", $COLOR_BLUE)
			Return ; exit func if no planned Boost Barracks checkmarks
		EndIf
	EndIf

	If OpenArmyWindow() = True Then
		Local $CheckArmyWindow = ISArmyWindow()
		OpenTrainTabNumber(1)
		If _Sleep(400) Then Return

		$ClickResult = ClickOnBoostArmyWindow()
		If $ClickResult = True Then
			$GemResult = IsGemWindowOpen("", "", True)
			If $GemResult = True Then
				If $icmbBoostBarracks >= 1 Then $icmbBoostBarracks -= 1
				Setlog(" Total remain cycles to boost Barracks:" & $icmbBoostBarracks, $COLOR_GREEN)
				GUICtrlSetData($cmbBoostBarracks, $icmbBoostBarracks)
			EndIf
		EndIf

		ClickP($aAway, 1, 0, "#0161")
		PureClickP($aAway, 1, 0, "#0140")
	EndIf
	_Sleep($iDelayBoostBarracks5 + 1000)
	checkMainScreen(False) ; Check for errors during function
	Return True
EndFunc   ;==>BoostBarracks

Func BoostSpellFactory()
	If $bTrainEnabled = False Then Return
	If $icmbBoostSpellFactory > 0 And $boostsEnabled = 1 Then
		SetLog("Boosting Spell Factory...", $COLOR_BLUE)

		If OpenArmyWindow() = True Then
			Local $CheckArmyWindow = ISArmyWindow()
			OpenTrainTabNumber(2)
			If _Sleep(400) Then Return

			$ClickResult = ClickOnBoostArmyWindow()
			If $ClickResult = True Then
				$GemResult = IsGemWindowOpen("", "", True)
				If $GemResult = True Then
					If $icmbBoostSpellFactory >= 1 Then $icmbBoostSpellFactory -= 1
					Setlog(" Total remain cycles to boost Spells:" & $icmbBoostSpellFactory, $COLOR_GREEN)
					GUICtrlSetData($cmbBoostSpellFactory, $icmbBoostSpellFactory)
				EndIf
			EndIf

			ClickP($aAway, 1, 0, "#0161")
			PureClickP($aAway, 1, 0, "#0140")
		EndIf
		_Sleep($iDelayBoostBarracks5 + 1000)
		checkMainScreen(False) ; Check for errors during function
		Return True
	EndIf
EndFunc   ;==>BoostSpellFactory

Func ClickOnBoostArmyWindow()
	If $DebugBarrackBoost = 1 Then SetLog("Func ClickOnBoostArmyWindow()", $COLOR_DEBUG) ;Debug
	_Sleep($iDelayBoostBarracks2)
	$ClockColor = _GetPixelColor(780, 312 + $midOffsetY, True)
	$ResColCheck = _ColorCheck($ClockColor, Hex(0x65AF20, 6), 40)
	If $ResColCheck = True Then
		SetLog("Boost Button is Available, Clicking On...", $COLOR_BLUE)
		Click(770, 325)
		_Sleep($iDelayBoostBarracks2)
		Return True
	Else
		If _ColorCheck(_GetPixelColor(718, 285 + $midOffsetY, True), Hex(0xEEF470, 6), 40) Then
			SetLog("Already Boosted! Skipping...", $COLOR_GREEN)
		Else
			SetLog("Cannot Verify Boost Button! Skipping...", $COLOR_ORANGE)
		EndIf
		Return False
	EndIf
EndFunc   ;==>ClickOnBoostArmyWindow

Func IsGemWindowOpen($varToChange1 = "", $varToChange2 = "", $AcceptGem = False, $NeedCapture = True)
	If $DebugBarrackBoost = 1 Then SetLog("Func IsGemWindowOpen(" & $AcceptGem & ", " & $NeedCapture & ")", $COLOR_DEBUG) ;Debug
	_Sleep($iDelayisGemOpen1)
	If _ColorCheck(_GetPixelColor(590, 235 + $midOffsetY, True), Hex(0xD80408, 6), 20) Then
		If _ColorCheck(_GetPixelColor(375, 383 + $midOffsetY, True), Hex(0x222322, 6), 20) Then
			If $debugSetlog = 1 Or $DebugBarrackBoost = 1 Then Setlog("DETECTED, GEM Window Is OPEN", $COLOR_DEBUG) ;Debug
			If $AcceptGem = True Then
				Click(435, 445)
				_Sleep($iDelayBoostBarracks2)
				If $varToChange2 = "" = False Then Assign($varToChange2, Eval($varToChange2) - 1, 4)
				If $varToChange2 = "" = False Then
					SetLog('Boost completed. Remaining : ' & Eval($varToChange2), $COLOR_GREEN)
				Else
					SetLog('Boost was Successful.', $COLOR_GREEN)
				EndIf
			Else
				PureClickP($aAway, 1, 0, "#0140") ; click away to close gem window
			EndIf
			_Sleep($iDelayBoostSpellFactory3)
			ClickP($aAway, 1, 0, "#0161")
			If $DebugBarrackBoost = 1 Then SetLog("Func IsGemWindowOpen(" & $AcceptGem & ") = TRUE", $COLOR_GREEN)
			Return True
		EndIf
	EndIf
	If $DebugBarrackBoost = 1 Then SetLog("Func IsGemWindowOpen(" & $AcceptGem & ", " & $NeedCapture & ") = FALSE", $COLOR_GREEN)
	Return False
EndFunc   ;==>IsGemWindowOpen

Func SelectBarrack($BRNum) ; 3
	If $DebugBarrackBoost = 1 Then SetLog("Func SelectBarrack(" & $BRNum & ")", $COLOR_DEBUG) ;Debug
	If $BRNum = 0 Or $BRNum > 4 Then CheckForBarrackNoPos()
	Local $CorrectBRNum

	; $Trainavailable = [1, 0, 1, 1, 1, 1, 0, 0, 0]
	$x = 0
	For $i = 1 To 4 ; from $Trainavailable[1] to $Trainavailable[4]
		If $Trainavailable[$i] = 1 Then
			$x += 1
			If $x = $BRNum Then
				$CorrectBRNum = $i ; this is the correct $barrackPos = $numBarrackAvailables
				ExitLoop
			EndIf
		EndIf
	Next

	If $barrackPos[0][0] = -1 Or $barrackPos[0][0] = 0 Or $barrackPos[0][0] = "" Then LocateBarrack2()
	If $barrackPos[3][0] = -1 Or $barrackPos[3][0] = 0 Or $barrackPos[3][0] = "" Then LocateBarrack2()

	Select
		Case $CorrectBRNum = -1
			If $DebugBarrackBoost = 1 Then SetLog("No Need To Select Barrack", $COLOR_GREEN)
		Case $CorrectBRNum = 1
			ClickP($aAway, 1, 0)
			_Sleep($iDelayBoostBarracks1)
			Click($barrackPos[0][0], $barrackPos[0][1], 1, 0)
		Case $CorrectBRNum = 2
			ClickP($aAway, 1, 0)
			_Sleep($iDelayBoostBarracks1)
			Click($barrackPos[1][0], $barrackPos[1][1], 1, 0)
		Case $CorrectBRNum = 3
			ClickP($aAway, 1, 0)
			_Sleep($iDelayBoostBarracks1)
			Click($barrackPos[2][0], $barrackPos[2][1], 1, 0)
		Case $CorrectBRNum = 4
			ClickP($aAway, 1, 0)
			_Sleep($iDelayBoostBarracks1)
			Click($barrackPos[3][0], $barrackPos[3][1], 1, 0)
		Case Else
			If $DebugBarrackBoost = 1 Then SetLog("Func SelectBarrack(" & $CorrectBRNum & ") = FALSE", $COLOR_RED)
			Return False
	EndSelect


	If $DebugBarrackBoost = 1 Then SetLog("Func SelectBarrack(" & $CorrectBRNum & ") = TRUE", $COLOR_GREEN)
	_Sleep($iDelayBoostBarracks1)
	Return True
EndFunc   ;==>SelectBarrack

Func SelectDarkBarrack($BRNum)
	If $DebugBarrackBoost = 1 Then SetLog("Func SelectBarrack(" & $BRNum & ")", $COLOR_DEBUG) ;Debug
	; If $BRNum = -1 = False Then CheckForBarrackNoPos()
	Local $CorrectBRNum

	; $Trainavailable = [1, 0, 1, 1, 1, 1, 0, 0, 0]
	$x = 0
	For $i = 5 To 6 ; from $Trainavailable[1] to $Trainavailable[4]
		If $Trainavailable[$i] = 1 Then
			$x += 1
			If $x = $BRNum Then
				$CorrectBRNum = $i ; this is the correct $barrackPos = $numBarrackAvailables
				ExitLoop
			EndIf
		EndIf
	Next
	If $DebugBarrackBoost = 1 Then SetLog("$CorrentBRNum = " & $CorrectBRNum, $COLOR_BLUE)

	If $DarkbarrackPos[0][0] = -1 Or $DarkbarrackPos[0][0] = 0 Or $DarkbarrackPos[0][0] = "" Then LocateDarkBarrack()
	If $DarkbarrackPos[1][0] = -1 Or $DarkbarrackPos[1][0] = 0 Or $DarkbarrackPos[1][0] = "" Then LocateDarkBarrack()

	Select
		Case $CorrectBRNum = -1
			If $DebugBarrackBoost = 1 Then SetLog("No Need To Select Barrack", $COLOR_GREEN)
		Case $CorrectBRNum = 5
			ClickP($aAway, 1, 0)
			_Sleep($iDelayBoostBarracks1)
			Click($DarkbarrackPos[0][0], $DarkbarrackPos[0][1], 1, 0)
		Case $CorrectBRNum = 6
			ClickP($aAway, 1, 0)
			_Sleep($iDelayBoostBarracks1)
			Click($DarkbarrackPos[1][0], $DarkbarrackPos[1][1], 1, 0)
		Case Else
			If $DebugBarrackBoost = 1 Then SetLog("Func SelectDarkBarrack(" & $CorrectBRNum & ") = FALSE", $COLOR_RED)
			Return False
	EndSelect


	If $DebugBarrackBoost = 1 Then SetLog("Func SelectBarrack(" & $CorrectBRNum & ") = TRUE", $COLOR_GREEN)
	_Sleep($iDelayBoostBarracks1)
	Return True

EndFunc   ;==>SelectDarkBarrack

Func CheckForBarrackNoPos()
	If $DebugBarrackBoost = 1 Then SetLog("Func CheckForBarrackNoPos()", $COLOR_DEBUG) ;Debug
	If $numBarracksAvaiables = 0 Then
		If $DebugBarrackBoost = 1 Then
			openArmyOverview()
		EndIf
	EndIf
	For $i = 0 To ($numBarracksAvaiables - 1)
		If $barrackPos[$i][0] = "" Or $barrackPos[$i][1] = "" Then
			SetLog("Barrack n� " & $i + 1 & " Not Located", $COLOR_ORANGE)
			SetLog("Locate It By It's Index In Army Overview Tab Index", $COLOR_ORANGE)
			LocateBarrack()
			SaveConfig()
			If $DebugBarrackBoost = 1 Then SetLog("ReCalling Func CheckForBarrackNoPos() Due To Barrack n� " & $i + 1 & " ReLocated", $COLOR_DEBUG) ;Debug
			CheckForBarrackNoPos() ; *****ing AutoIt Doesn't have GoTo Statement
		Else
			If $DebugBarrackBoost = 1 Then SetLog("Barrack n� " & $i + 1 & " Is Located: (" & $barrackPos[$i][0] & ", " & $barrackPos[$i][0] & ")", $COLOR_GREEN)
		EndIf
	Next
	Return True
EndFunc   ;==>CheckForBarrackNoPos

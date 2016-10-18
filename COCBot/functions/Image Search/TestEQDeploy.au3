; #FUNCTION# ====================================================================================================================
; Name ..........: Test Code
; Description ...:
; Author ........:
; Modified ......: ProMac (OCT 2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global Enum $ArmyTAB, $TrainTroopsTAB, $BrewSpellsTAB, $QuickTrainTAB

Func TestTrainRevamp()

	Setlog(" »» Army Window!", $COLOR_BLUE)

	OpenArmyWindow()

	If ISArmyWindow(True, $ArmyTAB) = False Then Return

	Local $timer = TimerInit()

	If _Sleep(250) Then Return

	$canRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])

	Local $sArmyCamp = getArmyCampCap(110, 166) ; OCR read army trained and total
	Local $aGetArmySize = StringSplit($sArmyCamp, "#", $STR_NOCOUNT)

	Local $sSpells = getArmyCampCap(99, 313) ; OCR read Spells trained and total
	Local $aGetSpellsSize = StringSplit($sSpells, "#", $STR_NOCOUNT)

	Local $scastle = getArmyCampCap(300, 468) ; OCR read Castle Received and total
	Local $aGetCastleSize = StringSplit($scastle, "#", $STR_NOCOUNT)

	;Test for Full Army
	$fullarmy = False
	If UBound($aGetArmySize) = 2 Then
		If $aGetArmySize[0] = $aGetArmySize[1] Then
			$fullarmy = True
		EndIf
	Else
		SetLog("Error reading Camp size")
		Return
	EndIf

	$bFullArmySpells = False
	If UBound($aGetSpellsSize) = 2 Then
		If $aGetSpellsSize[0] = $aGetSpellsSize[1] Then
			$bFullArmySpells = True
		EndIf
	Else
		SetLog("Error reading Spells size")
		Return
	EndIf

	Local $checkSpells = False
	If ($bFullArmySpells And ($iEnableSpellsWait[$DB] = 1 Or $iEnableSpellsWait[$LB] = 1)) Or ($iEnableSpellsWait[$DB] = 0 And $iEnableSpellsWait[$LB] = 0) Then
		$checkSpells = True
	EndIf

	$bFullCastle = False
	If UBound($aGetCastleSize) = 2 Then
		If $aGetCastleSize[0] = $aGetCastleSize[1] Then
			$bFullCastle = True
		EndIf
	Else
		SetLog("Error reading Castle size")
		Return
	EndIf

	;Test for Train/Donate Only and Fullarmy
	If ($CommandStop = 3 Or $CommandStop = 0) And $fullarmy Then
		SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_PURPLE)
		If $FirstStart Then $FirstStart = False
		Return
	EndIf

	If IsWaitforHeroesActive() Then
		;CheckExistentArmy("Heroes")
		getArmyHeroCount()
	else
		$bFullArmyHero = True
	EndIf

	$IsFullArmywithHeroesAndSpells = BitAND($fullarmy, $checkSpells, $bFullArmyHero)
	Setlog("Is Full Army with Heroes And Spells: " & $IsFullArmywithHeroesAndSpells)

	If UBound($aGetArmySize) > 1 Then
		If ($IsFullArmywithHeroesAndSpells = True) Or ($aGetArmySize[0] = 0 And $FirstStart) Then
			Setlog("Army Camp: " & $aGetArmySize[0] & "/" & $aGetArmySize[1], $COLOR_GREEN) ; coc-ms
			If $aGetSpellsSize[0] And $aGetSpellsSize[1] <> "" Then Setlog("Spells :" & $aGetSpellsSize[0] & "/" & $aGetSpellsSize[1], $COLOR_GREEN) ; coc-ms
			If $aGetCastleSize[0] And $aGetCastleSize[1] <> "" Then Setlog("Castle : " & $aGetCastleSize[0] & "/" & $aGetCastleSize[1], $COLOR_GREEN) ; coc-ms

			If $IsFullArmywithHeroesAndSpells Then Setlog(" » Your Army is Full, let's make troops before Attack!")
			If ($aGetArmySize[0] = 0 And $FirstStart) Then
				Setlog(" » Your Army is Empty, let's make troops before Attack!")
				Setlog(" » Go to TrainRevamp Tab and select your Quick Army position!", $COLOR_GREEN)
			EndIf

			DeleteTroopsQueued()
			If _Sleep(500) Then Return
			DeleteSpellsQueued()
			If _Sleep(250) Then Return
			OpenTrainTabNumber($QuickTrainTAB)
			If _Sleep(1000) Then Return

			Local $Num = 0
			If GUICtrlRead($hRadio_Army1) = $GUI_CHECKED Then $Num = 1
			If GUICtrlRead($hRadio_Army2) = $GUI_CHECKED Then $Num = 2
			If GUICtrlRead($hRadio_Army3) = $GUI_CHECKED Then $Num = 3

			TrainArmyNumber($Num)

			If _Sleep(700) Then Return
			$FirstStart = False
		Else
			If $aGetArmySize[0] > 0 And $FirstStart Then SetLog("Please Start with army camp Empty or Full!", $COLOR_ORANGE)

			Setlog("Army Camp: " & $aGetArmySize[0] & "/" & $aGetArmySize[1], $COLOR_GREEN) ; coc-ms
			If $aGetSpellsSize[0] And $aGetSpellsSize[1] <> "" Then Setlog("Spells :" & $aGetSpellsSize[0] & "/" & $aGetSpellsSize[1], $COLOR_GREEN) ; coc-ms
			If $aGetCastleSize[0] And $aGetCastleSize[1] <> "" Then Setlog("Castle : " & $aGetCastleSize[0] & "/" & $aGetCastleSize[1], $COLOR_GREEN) ; coc-ms

			$timer = TimerInit()

			Local $TimeRemainTroops = getRemainTrainTimer(756, 169)
			Local $ResultTroopsHour, $ResultTroopsMinutes
			Local $aRemainTrainTroopTimer
			$aTimeTrain[0] = 0

			If $TimeRemainTroops <> "" Then
				;SetLog("Debug Remain Troops | " & $TimeRemainTroops, $COLOR_GREEN)
				If StringInStr($TimeRemainTroops, "h") > 1 Then
					$ResultTroopsHour = StringSplit($TimeRemainTroops, "h", $STR_NOCOUNT)
					; $ResultTroopsHour[0] will be the Hour and the $ResultTroopsHour[1] will be the Minutes with the "m" at end
					$ResultTroopsMinutes = StringTrimRight($ResultTroopsHour[1], 1) ; removing the "m"
					$aRemainTrainTroopTimer = (Number($ResultTroopsHour[0]) * 60) + Number($ResultTroopsMinutes)
				Else
					$aRemainTrainTroopTimer = Number(StringTrimRight($TimeRemainTroops, 1)) ; removing the "m"
				EndIf
				$aTimeTrain[0] = $aRemainTrainTroopTimer
				Setlog("Remain Troops Time: " & $aRemainTrainTroopTimer & " min", $COLOR_GREEN)
			EndIf
			CheckExistentArmy("Troops")

			If IsWaitforSpellsActive() Then
				Local $TimeRemainSpells = getRemainTrainTimer(495, 315)
				$ResultTroopsHour = 0
				$ResultTroopsMinutes = 0
				$aTimeTrain[1] = 0
				Local $iRemainTrainSpellsTimer

				If $TimeRemainSpells <> "" Then
					;SetLog("Debug Remain Spells | " & $TimeRemainSpells, $COLOR_GREEN)
					If StringInStr($TimeRemainSpells, "h") > 1 Then
						$ResultTroopsHour = StringSplit($TimeRemainSpells, "h", $STR_NOCOUNT)
						; $ResultTroopsHour[0] will be the Hour and the $ResultTroopsHour[1] will be the Minutes with the "m" at end
						$ResultTroopsMinutes = StringTrimRight($ResultTroopsHour[1], 1) ; removing the "m"
						$iRemainTrainSpellsTimer = (Number($ResultTroopsHour[0]) * 60) + Number($ResultTroopsMinutes)
					Else
						$iRemainTrainSpellsTimer = Number(StringTrimRight($TimeRemainSpells, 1)) ; removing the "m"
					EndIf
					$aTimeTrain[1] = $iRemainTrainSpellsTimer
					Setlog("Remain Spells Time: " & $iRemainTrainSpellsTimer & " min", $COLOR_GREEN)
				EndIf
				CheckExistentArmy("Spells")
			EndIf

			;Setlog("Debug | Imgloc Troops Time: " & Round(TimerDiff($timer) / 1000, 2) & "'s", $COLOR_GREEN)
			If _Sleep(700) Then Return
			CheckIsFullQueuedAndNotFullArmy()
			$FirstStart = False
		EndIf
	Else
		SetLog("Error! OCR read army trained and total ", $COLOR_RED)
	EndIf

	If $bDonationEnabled = True Then MakingDonatedTroops()

	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(750) Then Return

	SetLog(" »» Army Window Closed!", $COLOR_BLUE)

	SmartWait4Train()
	If _Sleep(250) Then Return

EndFunc   ;==>TestTrainRevamp

Func OpenArmyWindow()

	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep($iDelayRunBot6) Then Return ; wait for window to open
	If IsMainPage() = False Then ; check for main page, avoid random troop drop
		SetLog("Can not open Army Overview window", $COLOR_RED)
		SetError(1)
		Return False
	EndIf

	If WaitforPixel(28, 505 + $bottomOffsetY, 30, 507 + $bottomOffsetY, Hex(0xE4A438, 6), 5, 10) Then
		If $debugsetlogTrain = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_GREEN)
		If $iUseRandomClick = 0 Then
			Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0293") ; Button Army Overview
		Else
			ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
		EndIf
	EndIf

	If _Sleep($iDelayRunBot6) Then Return ; wait for window to open
	If ISArmyWindow(True, $ArmyTAB) = False Then
		SetError(1)
		Return False ; exit if I'm not in train page
	EndIf
	Return True

EndFunc   ;==>OpenArmyWindow

Func ISArmyWindow($writelogs = False, $TabNumber = 0)

	Local $i = 0
	Local $_aIsTrainPgChk1[4] = [816, 136, 0xc40608, 15]
	Local $_aIsTrainPgChk2[4] = [843, 183, 0xe8e8e0, 15]
	Local $_TabNumber[4][4] = [[147, 128, 0Xf8f8f7, 15], [366, 128, 0Xf8f8f7, 15], [555, 128, 0Xf8f8f7, 15], [758, 128, 0Xf8f8f7, 15]] ; Grey pixel on the tab name when is selected

	Local $CheckIT[4] = [$_TabNumber[$TabNumber][0], $_TabNumber[$TabNumber][1], $_TabNumber[$TabNumber][2], $_TabNumber[$TabNumber][3]]

	While $i < 30
		If _CheckPixel($_aIsTrainPgChk1, True) And _CheckPixel($_aIsTrainPgChk2, True) And _CheckPixel($CheckIT, True) Then ExitLoop
		If _Sleep($iDelayIsTrainPage1) Then ExitLoop
		$i += 1
	WEnd

	If $i <= 28 Then
		If ($DebugSetlog = 1 Or $DebugClick = 1) And $writelogs = True Then Setlog("**Train Window OK**", $COLOR_ORANGE)
		Return True
	Else
		If $writelogs = True Then SetLog("Cannot find train Window | TAB " & $TabNumber, $COLOR_RED) ; in case of $i = 29 in while loop
		If $debugImageSave = 1 Then DebugImageSave("IsTrainPage_")
		Return False
	EndIf

EndFunc   ;==>ISArmyWindow

Func CheckExistentArmy($txt = "")

	If ISArmyWindow(True, $ArmyTAB) = False Then
		OpenArmyWindow()
		If _Sleep(1500) Then Return
	EndIf

	$iHeroAvailable = $HERO_NOHERO ; Reset hero available data

	If $txt = "Troops" Then
		ResetVariables("Troops")
		Local $directory = @ScriptDir & "\images\Resources\ArmyTroops"
		Local $x = 23, $y = 215, $x1 = 840, $y1 = 255
	EndIf
	If $txt = "Spells" Then
		ResetVariables("Spells")
		Local $directory = @ScriptDir & "\images\Resources\ArmySpells"
		Local $x = 23, $y = 366, $x1 = 585, $y1 = 400
	EndIf
	If $txt = "Heroes" Then
		Local $directory = @ScriptDir & "\images\Resources\ArmyHeroes"
		Local $x = 610, $y = 366, $x1 = 830, $y1 = 400
	EndIf

	Local $result = SearchArmy($directory, $x, $y, $x1, $y1, $txt)

	If UBound($result) > 0 Then
		For $i = 0 To UBound($result) - 1
			Local $Plural = 0
			If $result[$i][3] > 1 Then $Plural = 1
			If StringInStr($result[$i][0], "queued") Then
				$result[$i][0] = StringTrimRight($result[$i][0], 6)
				;[&i][0] = Troops name | [&i][1] = X coordinate | [&i][2] = Y coordinate | [&i][3] = Quantities
				If $txt = "Troops" Then
					Setlog(" » " & $result[$i][3] & " " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Queued", $COLOR_BLUE)
					Assign("Cur" & $result[$i][0], Eval("Cur" & $result[$i][0]) + $result[$i][3])
				EndIf
				If $txt = "Spells" Then
					Setlog(" » " & $result[$i][3] & " " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Brewed", $COLOR_BLUE)
					Assign("Cur" & $result[$i][0], Eval("Cur" & $result[$i][0]) + $result[$i][3])
				EndIf
				If $txt = "Heroes" Then
					If ArmyHeroStatus(Eval("e" & $result[$i][0])) = "heal" Then Setlog(" » " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Recovering, Remain of " & $result[$i][3], $COLOR_BLUE)
				EndIf
			Else
				If $txt = "Heroes" Then
					Setlog(" » " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Recovered", $COLOR_GREEN)
				Else
					Setlog(" » " & $result[$i][3] & " " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Trained", $COLOR_GREEN)
					Assign("Cur" & $result[$i][0], Eval("Cur" & $result[$i][0]) + $result[$i][3])
				EndIf
			EndIf
		Next
	EndIf
EndFunc   ;==>CheckExistentArmy

Func SearchArmy($directory = "", $x = 0, $y = 0, $x1 = 0, $y1 = 0, $txt = "")
	; Setup arrays, including default return values for $return
	Local $aResult[1][4], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue
	Local $Redlines = "FV"
	; Capture the screen for comparison
	_CaptureRegion2($x, $y, $x1, $y1)

	; Perform the search
	$res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", $Redlines, "Int", 0, "Int", 1000)

	If $res[0] <> "" Then
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

		; Redimension the result array to allow for the new entries
		ReDim $aResult[UBound($aKeys)][4]

		; Loop through the array
		For $i = 0 To UBound($aKeys) - 1
			; Get the property values
			$aResult[$i][0] = returnPropertyValue($aKeys[$i], "objectname")
			; Get the coords property
			$aValue = returnPropertyValue($aKeys[$i], "objectpoints")
			$aCoords = StringSplit($aValue, "|", $STR_NOCOUNT)
			$aCoordsSplit = StringSplit($aCoords[0], ",", $STR_NOCOUNT)
			If UBound($aCoordsSplit) = 2 Then
				; Store the coords into a two dimensional array
				$aCoordArray[0][0] = $aCoordsSplit[0] ; X coord.
				$aCoordArray[0][1] = $aCoordsSplit[1] ; Y coord.
			Else
				$aCoordArray[0][0] = -1
				$aCoordArray[0][1] = -1
			EndIf
			; Store the coords array as a sub-array
			$aResult[$i][1] = Number($aCoordArray[0][0])
			$aResult[$i][2] = Number($aCoordArray[0][1])
		Next
	EndIf

	_ArraySort($aResult, 0, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i

	If $txt = "Troops" Then
		For $i = 0 To UBound($aResult) - 1
			$aResult[$i][3] = Number(getBarracksNewTroopQuantity(Slot($aResult[$i][1]), 196)) ; coc-newarmy
		Next
	EndIf
	If $txt = "Spells" Then
		For $i = 0 To UBound($aResult) - 1
			$aResult[$i][3] = Number(getBarracksNewTroopQuantity(Slot($aResult[$i][1]), 341)) ; coc-newarmy
		Next
	EndIf
	If $txt = "Heroes" Then
		For $i = 0 To UBound($aResult) - 1
			If StringInStr($aResult[$i][0], "Kingqueued") Then
				$aResult[$i][3] = getRemainTHero(620, 414)
			ElseIf StringInStr($aResult[$i][0], "Queenqueued") Then
				$aResult[$i][3] = getRemainTHero(695, 414)
			ElseIf StringInStr($aResult[$i][0], "Wardenqueued") Then
				$aResult[$i][3] = getRemainTHero(775, 414)
			Else
				$aResult[$i][3] = 0
			EndIf
		Next
	EndIf

	Return $aResult
EndFunc   ;==>SearchArmy

Func ResetVariables($txt = "")

	If $txt = "troops" Or $txt = "all" Then
		For $i = 0 To UBound($TroopName) - 1
			Assign("Cur" & $TroopName[$i], 0)
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
		Next
		For $i = 0 To UBound($TroopDarkName) - 1
			Assign("Cur" & $TroopDarkName[$i], 0)
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
		Next
	EndIf
	If $txt = "Spells" Or $txt = "all" Then
		For $i = 0 To UBound($SpellName) - 1
			Assign("Cur" & $SpellName[$i], 0)
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
		Next
	EndIf

EndFunc   ;==>ResetVariables

Func OpenTrainTabNumber($Num)

	Local $Message[4] = ["Army Camp", _
			"Train Troops", _
			"Brew Spells", _
			"Quick Train"]
	Local $TabNumber[4][2] = [[90, 128], [245, 128], [440, 128], [650, 128]]

	If IsTrainPage() Then
		Click($TabNumber[$Num][0], $TabNumber[$Num][1], 2, 200)
		If _Sleep(1500) Then Return
		If ISArmyWindow(False, $Num) Then Setlog("Opened the " & $Message[$Num])
	Else
		Setlog(" » Error Clicking On " & ($Num >= 0 And $Num < UBound($Message)) ? ($Message[$Num]) : ("Not selectable") & " Tab!!!", $COLOR_RED)
	EndIf
EndFunc   ;==>OpenTrainTabNumber

Func TrainArmyNumber($Num)

	$Num = $Num - 1
	Local $a_TrainArmy[3][4] = [[817, 366, 0x6bb720, 10], [817, 484, 0x6bb720, 10], [817, 601, 0x6bb720, 10]]
	Setlog(" » TrainArmyNumber: " & $Num + 1)

	If ISArmyWindow(True, $QuickTrainTAB) Then
		; _ColorCheck($nColor1, $nColor2, $sVari = 5, $Ignore = "")
		If _ColorCheck(_GetPixelColor($a_TrainArmy[$Num][0], $a_TrainArmy[$Num][1], True), Hex($a_TrainArmy[$Num][2], 6), $a_TrainArmy[$Num][3]) Then
			Click($a_TrainArmy[$Num][0], $a_TrainArmy[$Num][1])
			SetLog("Making the Army " & $Num + 1)
			If _Sleep(1000) Then Return
		Else
			Setlog(" » Error Clicking On Army: " & $Num + 1 & "| Pixel was :" & _GetPixelColor($a_TrainArmy[$Num][0], $a_TrainArmy[$Num][1], True), $COLOR_ORANGE)
			Setlog(" » Please 'edit' the Army " & $Num + 1 & " before start the BOT!!!", $COLOR_RED)
			BotStop()
		EndIf
	Else
		Setlog(" » Error Clicking On Army! You are not on Quick Train Window", $COLOR_RED)
	EndIf

EndFunc   ;==>TrainArmyNumber

Func DeleteTroopsQueued()

	OpenTrainTabNumber($TrainTroopsTAB)
	If _Sleep(1500) Then Return
	If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return

	SetLog("Delete Troops Queued ")
	If _Sleep(500) Then Return
	Local $x = 0
	While _ColorCheck(_GetPixelColor(802, 220, True), Hex(0Xbac8a5, 6), 10) = False
		If _Sleep(20) Then Return
		Click(826, 202, 2, 100)
		$x += 1
		If $x = 250 Then ExitLoop
	WEnd

EndFunc   ;==>DeleteTroopsQueued
;IF your current spells don't match with the spells to train will delete them
Func DeleteSpellsQueued()

	OpenTrainTabNumber($BrewSpellsTAB)
	If _Sleep(1500) Then Return
	If ISArmyWindow(True, $BrewSpellsTAB) = False Then Return

	SetLog("Delete Spells Queued ")
	If _Sleep(500) Then Return
	Local $x = 0
	While _ColorCheck(_GetPixelColor(802, 220, True), Hex(0Xbac8a5, 6), 10) = False
		If _Sleep(20) Then Return
		Click(826, 202, 2, 100)
		$x += 1
		If $x = 250 Then ExitLoop
	WEnd

EndFunc   ;==>DeleteSpellsQueued

Func Slot($x)

	Switch $x
		Case $x < 98
			Return 35
		Case $x > 98 And $x < 171
			Return 111
		Case $x > 171 And $x < 244
			Return 184
		Case $x > 244 And $x < 308
			Return 255
		Case $x > 308 And $x < 393
			Return 330
		Case $x > 393 And $x < 465
			Return 403
		Case $x > 465 And $x < 538
			Return 477
		Case $x > 538 And $x < 611
			Return 551
		Case $x > 611 And $x < 683
			Return 625
		Case $x > 683 And $x < 753
			Return 694
		Case $x > 753 And $x < 825
			Return 764
	EndSwitch


EndFunc   ;==>Slot

Func MakingTroops()

	If IsTrainPage() And ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB)
	If _Sleep(1500) Then Return
	If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return

	For $i = 0 To UBound($TroopName) - 1
		If Eval($TroopName[$i] & "Comp") > 0 Then
			If Eval($TroopName[$i] & "Comp") - Eval("Cur" & $TroopName[$i]) > 0 Then
				TrainIt(Eval("e" & $TroopName[$i]), Eval($TroopName[$i] & "Comp") - Eval("Cur" & $TroopName[$i]), $isldTrainITDelay)
				$fullarmy = False
			ElseIf Eval($TroopName[$i] & "Comp") - Eval("Cur" & $TroopName[$i]) < 0 Then
				Setlog("You have " & Abs(Eval($TroopName[$i] & "Comp") - Eval("Cur" & $TroopName[$i])) & " " & NameOfTroop(Eval("e" & $TroopName[$i]), 1) & " more than necessary!", $COLOR_RED)
			ElseIf Eval($TroopName[$i] & "Comp") - Eval("Cur" & $TroopName[$i]) = 0 Then
				Setlog(" » " & NameOfTroop(Eval("e" & $TroopName[$i]), 1) & " are all done!", $COLOR_GREEN)
			EndIf
		EndIf
	Next

	Local $z = 0

	For $i = 0 To UBound($TroopDarkName) - 1
		If Eval($TroopDarkName[$i] & "Comp") > 0 Then
			If $z = 0 Then
				ClickDrag(616, 445 + $midOffsetY, 400, 445 + $midOffsetY, 2000)
				If _Sleep(1500) Then Return
				$z = 1
			EndIf
			If Eval($TroopDarkName[$i] & "Comp") - Eval("Cur" & $TroopDarkName[$i]) > 0 Then
				TrainIt(Eval("e" & $TroopDarkName[$i]), Eval($TroopDarkName[$i] & "Comp") - Eval("Cur" & $TroopDarkName[$i]), $isldTrainITDelay)
				$fullarmy = False
			ElseIf Eval($TroopDarkName[$i] & "Comp") - Eval("Cur" & $TroopDarkName[$i]) < 0 Then
				Setlog("You have " & Abs(Eval($TroopDarkName[$i] & "Comp") - Eval("Cur" & $TroopDarkName[$i])) & " " & NameOfTroop(Eval("e" & $TroopDarkName[$i]), 1) & " more than necessary!", $COLOR_RED)
			ElseIf Eval($TroopDarkName[$i] & "Comp") - Eval("Cur" & $TroopDarkName[$i]) = 0 Then
				Setlog(" » " & NameOfTroop(Eval("e" & $TroopDarkName[$i]), 1) & " are all done!", $COLOR_GREEN)
			EndIf
		EndIf
	Next

EndFunc   ;==>MakingTroops

Func MakingDonatedTroops()

	; [0] = Current Army  | [1] = Total Army Capacity  | [2] = Remain Space for the current Army
	Local $RemainTrainSpace
	Local $Plural = 0

	If IsTrainPage() And ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB)
	If _Sleep(1500) Then Return
	If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return

	For $i = 0 To UBound($TroopName) - 1
		$Plural = 0
		If Eval("Don" & $TroopName[$i]) > 0 Then
			$RemainTrainSpace = GetOCRCurrent(48, 161)
			If $RemainTrainSpace[0] = $RemainTrainSpace[1] Then ExitLoop
			If $TroopHeight[$i] * Eval("Don" & $TroopName[$i]) <= $RemainTrainSpace[2] Then
				;TrainIt(Eval("e" & $TroopName[$i]), Eval("Don" & $TroopName[$i]), $isldTrainITDelay)
				Local $pos = GetTrainPos(Eval("e" & $TroopName[$i]))
				Local $howMuch = Eval("Don" & $TroopName[$i])
				PureClick($pos[0], $pos[1], $howMuch, 500)
				If Eval("Don" & $TroopName[$i]) > 1 Then $Plural = 1
				Setlog(" » Trained " & Eval("Don" & $TroopName[$i]) & " " & NameOfTroop(Eval("e" & $TroopName[$i]), $Plural))
				Assign("Don" & $TroopName[$i], 0)
			Else
				For $z = 0 To $RemainTrainSpace[2] - 1
					$RemainTrainSpace = GetOCRCurrent(48, 161)
					If $RemainTrainSpace[0] = $RemainTrainSpace[1] Then ExitLoop (2)
					If $TroopHeight[$i] <= $RemainTrainSpace[2] Then
						;TrainIt(Eval("e" & $TroopName[$i]), 1, $isldTrainITDelay)
						Local $pos = GetTrainPos(Eval("e" & $TroopName[$i]))
						Local $howMuch = 1
						PureClick($pos[0], $pos[1], $howMuch, 500)
						If Eval("Don" & $TroopName[$i]) > 1 Then $Plural = 1
						Setlog(" » Trained " & Eval("Don" & $TroopName[$i]) & " " & NameOfTroop(Eval("e" & $TroopName[$i]), $Plural))
						Assign("Don" & $TroopName[$i], Eval("Don" & $TroopName[$i]) - 1)
					Else
						Local $pos = GetTrainPos("eArch")
						Local $howMuch = $RemainTrainSpace[3]
						PureClick($pos[0], $pos[1], $howMuch, 500)
						If $RemainTrainSpace[2] > 0 Then $Plural = 1
						Setlog(" » Trained " & $RemainTrainSpace[2] & " " & NameOfTroop(Eval("eArch"), $Plural))
						Assign("Don" & $TroopName[$i], 0)
						ExitLoop (2)
					EndIf
				Next
			EndIf
		EndIf
	Next

	Local $z = 0
	For $i = 0 To UBound($TroopDarkName) - 1
		$Plural = 0
		If Eval("Don" & $TroopDarkName[$i]) > 0 Then
			If $z = 0 Then
				ClickDrag(616, 445 + $midOffsetY, 400, 445 + $midOffsetY, 2000)
				If _Sleep(1500) Then Return
				$z = 1
			EndIf
			$RemainTrainSpace = GetOCRCurrent(48, 161)
			If $RemainTrainSpace[0] = $RemainTrainSpace[1] Then ExitLoop
			If $TroopDarkHeight[$i] * Eval("Don" & $TroopDarkName[$i]) <= $RemainTrainSpace[2] Then
				;TrainIt(Eval("e" & $TroopDarkName[$i]), Eval("Don" & $TroopDarkName[$i]), $isldTrainITDelay)
				Local $pos = GetTrainPos(Eval("e" & $TroopName[$i]))
				Local $howMuch = Eval("Don" & $TroopDarkName[$i])
				PureClick($pos[0], $pos[1], $howMuch, 500)
				If Eval("Don" & $TroopDarkName[$i]) > 1 Then $Plural = 1
				Setlog(" » Trained " & Eval("Don" & $TroopDarkName[$i]) & " " & NameOfTroop(Eval("e" & $TroopDarkName[$i]), $Plural))
				Assign("Don" & $TroopDarkName[$i], 0)
			Else
				For $z = 0 To $RemainTrainSpace[2] - 1
					$RemainTrainSpace = GetOCRCurrent(48, 161)
					$Plural = 0
					If $RemainTrainSpace[0] = $RemainTrainSpace[1] Then ExitLoop (2)
					If $TroopDarkHeight[$i] <= $RemainTrainSpace[3] Then
						;TrainIt(Eval("e" & $TroopDarkName[$i]), 1, $isldTrainITDelay)
						Local $pos = GetTrainPos(Eval("e" & $TroopName[$i]))
						Local $howMuch = 1
						PureClick($pos[0], $pos[1], $howMuch, 500)
						If Eval("Don" & $TroopDarkName[$i]) > 1 Then $Plural = 1
						Setlog(" » Trained " & Eval("Don" & $TroopDarkName[$i]) & " " & NameOfTroop(Eval("e" & $TroopDarkName[$i]), $Plural))
						Assign("Don" & $TroopDarkName[$i], Eval("Don" & $TroopDarkName[$i]) - 1)
					Else
						;TrainIt(Eval("eMini"), $RemainTrainSpace[3], $isldTrainITDelay)
						Local $pos = GetTrainPos("eMini")
						Local $howMuch = $RemainTrainSpace[3]
						PureClick($pos[0], $pos[1], $howMuch, 500)
						If $RemainTrainSpace[3] > 1 Then $Plural = 1
						Setlog(" » Trained " & $RemainTrainSpace[3] & " " & NameOfTroop(Eval("eMini"), $Plural))
						Assign("Don" & $TroopDarkName[$i], 0)
						ExitLoop (2)
					EndIf
				Next
			EndIf
		EndIf
	Next

	$RemainTrainSpace = GetOCRCurrent(48, 161)
	Setlog(" »» Current Capacity: " & $RemainTrainSpace[0] & "/" & ($RemainTrainSpace[1] * 2))

EndFunc   ;==>MakingDonatedTroops

Func GetOCRCurrent($x_start, $y_start)

	Local $FinalResult[3] = [0, 0, 0]

	; [0] = Current Army  | [1] = Total Army Capacity  | [2] = Remain Space for the current Army
	Local $result = getArmyCapacityOnTrainTroops($x_start, $y_start)

	If StringInStr($result, "#") Then
		Local $resultSplit = StringSplit($result, "#", $STR_NOCOUNT)
		$FinalResult[0] = Number($resultSplit[0])
		$FinalResult[1] = Number($resultSplit[1] / 2)
		$FinalResult[2] = $FinalResult[1] - $FinalResult[0]
	Else
		Setlog("DEBUG | ERROR on GetOCRCurrent", $COLOR_RED)
	EndIf

	Return $FinalResult

EndFunc   ;==>GetOCRCurrent

Func CheckIsFullQueuedAndNotFullArmy()

	Local $CheckTroop[4] = [824, 243, 0x949522, 15] ; the green check symbol [bottom right] at slot 0 troop

	If IsTrainPage() And ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB)
	If _Sleep(1500) Then Return
	If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return

	Local $ArmyCamp = GetOCRCurrent(48, 161)

	If UBound($ArmyCamp) = 3 And $ArmyCamp[2] < 0 Then
		If _ColorCheck(_GetPixelColor($CheckTroop[0], $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) Then
			DeleteTroopsQueued()
			If _Sleep(500) Then Return
			$ArmyCamp = GetOCRCurrent(48, 161)
			Local $ArchToMake = $ArmyCamp[2]
			If ISArmyWindow(False, $TrainTroopsTAB) Then PureClick($TrainArch[0], $TrainArch[1], $ArchToMake, 500)
			Setlog("Trained " & $ArchToMake & " archer(s)!")
		Else
			Setlog("CheckIsFullQueuedAndNotFullArmy :" & _GetPixelColor($CheckTroop[0], $CheckTroop[1], True))
		EndIf
	EndIf

EndFunc   ;==>CheckIsFullQueuedAndNotFullArmy


; #########################################################################################
; ####################################### test Buttom #####################################
; #########################################################################################

Func TestEQDeploy()

	$RunState = True
	Setlog(" »»» Initial TestEQDeploy ««« ")
	Local $subDirectory = @ScriptDir & "\TestsImages"
	DirCreate($subDirectory)

	Local $TestEQDeployTimer = TimerInit()
	Local $TestEQDeployFinalTimer = TimerInit()

	; Earthquake Spell 4 tile radius , and so the diameter length would be 8
	; Tile x = 16px and y = 12px
	; Earthquake Spell diameter length | x= 128px and y = 96px
	Local $TileX = 128
	Local $TileY = 96

	; Capture the screen for comparison
	_CaptureRegion()

	; Store a copy of the image handle
	Local $editedImage = $hBitmap

	; Create the timestamp and filename
	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $fileName = String($Date & "_" & $Time & ".png")

	; Needed for editing the picture
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
	Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED
	Local $hPenWHITE = _GDIPlus_PenCreate(0xFFFFFFFF, 2) ; Create a pencil Color FFFFF/WHITE
	Local $hPenGREEN = _GDIPlus_PenCreate(0xFF00FF00, 2) ; Create a pencil Color 00FF00/LIME
	Local $hPenBLUE = _GDIPlus_PenCreate(0xFF2D49FF, 2) ; Create a pencil Color 2D49FF/BLUE
	Local $hPenYELLOW = _GDIPlus_PenCreate(0xFFffff00, 2) ; Create a pencil Color ffff00/YELLOW

	; Let's detect the TH
	Local $result, $listPixelByLevel, $pixelWithLevel, $level, $pixelStr, $TH[2]
	Local $aTownHallLocal[3] = [-1, -1, -1]
	Local $center = [430, 338]
	Local $MixX = 76, $MinY = 70, $MaxX = 790, $MaxY = 603
	Local $aTownHall

	Setlog(" »»» Initial detection TH and Red Lines ««« ")
	; detection TH and Red Lines with Imgloc
	Local $directory = @ScriptDir & "\images\Resources\TH"
	$aTownHall = returnHighestLevelSingleMatch($directory)
	Setlog(" »»» Ends detection TH and Red Lines ««« ")

	If Number($aTownHall[4]) > 0 Then
		; SetLog Debug
		Setlog(" »»» $aTownHall Rows: " & UBound($aTownHall))
		Setlog("filename: " & $aTownHall[0])
		Setlog("objectname: " & $aTownHall[1])
		Setlog("objectlevel: " & $aTownHall[2])
		Setlog("totalobjects: " & $aTownHall[4])
		Setlog(" »»» $aTownHall[5] Rows: " & UBound($aTownHall[5]))
		Setlog("$aTownHall[5]: " & $aTownHall[5])
		$pixelStr = $aTownHall[5]
		Setlog(" »»» X coord: " & $pixelStr[0][0])
		Setlog(" »»» Y coord: " & $pixelStr[0][1])

		; Fill the variables with values
		$TH[0] = $pixelStr[0][0]
		$TH[1] = $pixelStr[0][1]
		$level = $aTownHall[2]
		Setlog("RedLine String: " & $aTownHall[6])
	Else
		SetLog("ImgLoc TownHall Error..!!", $COLOR_RED)
	EndIf

	Setlog("Time Taken|$aTownHall: " & Round(TimerDiff($TestEQDeployTimer) / 1000, 2) & "'s") ; Time taken
	$TestEQDeployTimer = TimerInit()

	If isInsideDiamond($TH) Then
		Setlog("TownHall level: " & $level & "|" & $TH[0] & "-" & $TH[1])
	Else
		SetLog("Found TownHall with Invalid Location?", $COLOR_RED)
	EndIf

	; Let's Draw a Rectangulo on TH detection
	_GDIPlus_GraphicsDrawRect($hGraphic, $TH[0] - 5, $TH[1] - 5, 10, 10, $hPenRED)
	_GDIPlus_GraphicsDrawString($hGraphic, "TH" & $level, $TH[0] + 10, $TH[1], "Verdana", 15)

	; Red Lines

	Local $Redlines = Imgloc2MBR($aTownHall[6])
	Setlog("Time Taken|$Redlines|Imgloc2MBR: " & Round(TimerDiff($TestEQDeployTimer) / 1000, 2) & "'s") ; Time taken
	$TestEQDeployTimer = TimerInit()

	Setlog(" » RedLine string: " & $Redlines)

	Local $listPixelBySide = StringSplit($Redlines, "#")
	$PixelTopLeft = GetPixelSide($listPixelBySide, 1)
	$PixelBottomLeft = GetPixelSide($listPixelBySide, 2)
	$PixelBottomRight = GetPixelSide($listPixelBySide, 3)
	$PixelTopRight = GetPixelSide($listPixelBySide, 4)

	Setlog(" »» " & UBound($PixelTopLeft) + UBound($PixelBottomLeft) + UBound($PixelBottomRight) + UBound($PixelTopRight) & " points detected!")

	; Let's Detect the Most $RedLinepixel near the TH
	Local $tempFinalPixelTopLef[1][3]
	Local $tempFinalPixelBottomLeft[1][3]
	Local $tempFinalPixelBottomRight[1][3]
	Local $tempFinalPixelTopRight[1][3]

	For $i = 0 To UBound($PixelTopLeft) - 1
		Local $PixelTemp = $PixelTopLeft[$i]
		Local $Pixel = Pixel_Distance($PixelTemp[0], $PixelTemp[1], $TH[0], $TH[1])
		ReDim $tempFinalPixelTopLef[$i + 1][3]
		$tempFinalPixelTopLef[$i][0] = $PixelTemp[0]
		$tempFinalPixelTopLef[$i][1] = $PixelTemp[1]
		$tempFinalPixelTopLef[$i][2] = $Pixel
	Next

	For $i = 0 To UBound($PixelBottomLeft) - 1
		Local $PixelTemp = $PixelBottomLeft[$i]
		Local $Pixel = Pixel_Distance($PixelTemp[0], $PixelTemp[1], $TH[0], $TH[1])
		ReDim $tempFinalPixelBottomLeft[$i + 1][3]
		$tempFinalPixelBottomLeft[$i][0] = $PixelTemp[0]
		$tempFinalPixelBottomLeft[$i][1] = $PixelTemp[1]
		$tempFinalPixelBottomLeft[$i][2] = $Pixel
	Next
	For $i = 0 To UBound($PixelBottomRight) - 1
		Local $PixelTemp = $PixelBottomRight[$i]
		Local $Pixel = Pixel_Distance($PixelTemp[0], $PixelTemp[1], $TH[0], $TH[1])
		ReDim $tempFinalPixelBottomRight[$i + 1][3]
		$tempFinalPixelBottomRight[$i][0] = $PixelTemp[0]
		$tempFinalPixelBottomRight[$i][1] = $PixelTemp[1]
		$tempFinalPixelBottomRight[$i][2] = $Pixel
	Next
	For $i = 0 To UBound($PixelTopRight) - 1
		Local $PixelTemp = $PixelTopRight[$i]
		Local $Pixel = Pixel_Distance($PixelTemp[0], $PixelTemp[1], $TH[0], $TH[1])
		ReDim $tempFinalPixelTopRight[$i + 1][3]
		$tempFinalPixelTopRight[$i][0] = $PixelTemp[0]
		$tempFinalPixelTopRight[$i][1] = $PixelTemp[1]
		$tempFinalPixelTopRight[$i][2] = $Pixel
	Next

	Setlog("Time Taken|$Pixel_Distance Loop: " & Round(TimerDiff($TestEQDeployTimer) / 1000, 2) & "'s") ; Time taken
	$TestEQDeployTimer = TimerInit()

	_ArraySort($tempFinalPixelTopLef, 0, -1, -1, 2)
	_ArraySort($tempFinalPixelBottomLeft, 0, -1, -1, 2)
	_ArraySort($tempFinalPixelBottomRight, 0, -1, -1, 2)
	_ArraySort($tempFinalPixelTopRight, 0, -1, -1, 2)

	Local $MostNearTH[4][3]

	$MostNearTH[0][0] = $tempFinalPixelTopLef[0][0]
	$MostNearTH[0][1] = $tempFinalPixelTopLef[0][1]
	$MostNearTH[0][2] = $tempFinalPixelTopLef[0][2]

	$MostNearTH[1][0] = $tempFinalPixelBottomLeft[0][0]
	$MostNearTH[1][1] = $tempFinalPixelBottomLeft[0][1]
	$MostNearTH[1][2] = $tempFinalPixelBottomLeft[0][2]

	$MostNearTH[2][0] = $tempFinalPixelBottomRight[0][0]
	$MostNearTH[2][1] = $tempFinalPixelBottomRight[0][1]
	$MostNearTH[2][2] = $tempFinalPixelBottomRight[0][2]

	$MostNearTH[3][0] = $tempFinalPixelTopRight[0][0]
	$MostNearTH[3][1] = $tempFinalPixelTopRight[0][1]
	$MostNearTH[3][2] = $tempFinalPixelTopRight[0][2]

	_ArraySort($MostNearTH, 0, -1, -1, 2)

	Local $MasterPixel[2]
	$MasterPixel[0] = $MostNearTH[0][0]
	$MasterPixel[1] = $MostNearTH[0][1]

	Local $RedLinepixelCloserTH[2]

	Switch StringLeft(Slice8($MasterPixel), 1)
		Case 1, 2
			$MAINSIDE = "BOTTOM-RIGHT"
			$MixX = 430
			$MaxX = 790
			$MinY = 338
			$MaxY = 603
			Local $PixelRedLine = $PixelBottomRight
			$RedLinepixelCloserTH[0] = $tempFinalPixelBottomRight[0][0]
			$RedLinepixelCloserTH[1] = $tempFinalPixelBottomRight[0][1]
		Case 3, 4
			$MAINSIDE = "TOP-RIGHT"
			$MixX = 430
			$MaxX = 790
			$MinY = 70
			$MaxY = 338
			Local $PixelRedLine = $PixelTopRight
			$RedLinepixelCloserTH[0] = $tempFinalPixelTopRight[0][0]
			$RedLinepixelCloserTH[1] = $tempFinalPixelTopRight[0][1]
		Case 5, 6
			$MAINSIDE = "TOP-LEFT"
			$MixX = 76
			$MaxX = 430
			$MinY = 70
			$MaxY = 338
			Local $PixelRedLine = $PixelTopLeft
			$RedLinepixelCloserTH[0] = $tempFinalPixelTopLef[0][0]
			$RedLinepixelCloserTH[1] = $tempFinalPixelTopLef[0][1]
		Case 7, 8
			$MAINSIDE = "BOTTOM-LEFT"
			$MixX = 76
			$MaxX = 430
			$MinY = 338
			$MaxY = 603
			Local $PixelRedLine = $PixelBottomLeft
			$RedLinepixelCloserTH[0] = $tempFinalPixelBottomLeft[0][0]
			$RedLinepixelCloserTH[1] = $tempFinalPixelBottomLeft[0][1]
	EndSwitch
	Setlog("Forced side: " & $MAINSIDE)

	; Let's Draw a Rectangule of the MainSide
	_GDIPlus_GraphicsDrawRect($hGraphic, $MixX, $MinY, $MaxX - $MixX, $MaxY - $MinY, $hPenGREEN)
	_GDIPlus_GraphicsDrawString($hGraphic, "SIDE: " & $MAINSIDE, $MixX + 50, $MinY, "Verdana", 15)


	; Let's Draw the Red Line
	For $i = 0 To UBound($PixelRedLine) - 1
		Local $RedLinepixel = $PixelRedLine[$i]
		_GDIPlus_GraphicsDrawRect($hGraphic, $RedLinepixel[0] - 1, $RedLinepixel[1] - 1, 2, 2, $hPenRED)
	Next

	; Let's Draw a Line between $RedLinepixelCloserTH and TH
	_GDIPlus_GraphicsDrawLine($hGraphic, $RedLinepixelCloserTH[0], $RedLinepixelCloserTH[1], $TH[0], $TH[1], $hPenWHITE)

	Local $MiddleDistance[2] = [Floor(Abs($RedLinepixelCloserTH[0] - $TH[0]) / 2), Floor(Abs($RedLinepixelCloserTH[1] - $TH[1]) / 2)]

	If $RedLinepixelCloserTH[0] < $TH[0] And $RedLinepixelCloserTH[1] < $TH[1] Then ; Top Left Of The TH
		$MiddleDistance[0] = Abs($MiddleDistance[0] + $RedLinepixelCloserTH[0])
		$MiddleDistance[1] = Abs($MiddleDistance[1] + $RedLinepixelCloserTH[1])
		;_GDIPlus_GraphicsDrawRect($hGraphic, $MiddleDistance[0], $MiddleDistance[1], Abs($MiddleDistance[0] - $Th[0]), Abs($MiddleDistance[1] - $Th[1]), $hPenWHITE)
	EndIf
	If $RedLinepixelCloserTH[0] < $TH[0] And $RedLinepixelCloserTH[1] > $TH[1] Then ; Bottom Left Of The TH
		$MiddleDistance[0] = Abs($MiddleDistance[0] + $RedLinepixelCloserTH[0])
		$MiddleDistance[1] = Abs($MiddleDistance[1] - $RedLinepixelCloserTH[1])
		;_GDIPlus_GraphicsDrawRect($hGraphic, $MiddleDistance[0], $TH[1], Abs($MiddleDistance[0] - $Th[0]), Abs($MiddleDistance[1] - $Th[1]), $hPenWHITE)
	EndIf
	If $RedLinepixelCloserTH[0] > $TH[0] And $RedLinepixelCloserTH[1] > $TH[1] Then ; Bottom Right Of The TH
		$MiddleDistance[0] = Abs($MiddleDistance[0] - $RedLinepixelCloserTH[0])
		$MiddleDistance[1] = Abs($MiddleDistance[1] - $RedLinepixelCloserTH[1])
		;_GDIPlus_GraphicsDrawRect($hGraphic, $Th[0], $TH[1], Abs($MiddleDistance[0] - $Th[0]), Abs($MiddleDistance[1] - $Th[1]), $hPenWHITE)
	EndIf
	If $RedLinepixelCloserTH[0] > $TH[0] And $RedLinepixelCloserTH[1] < $TH[1] Then ; Top right Of The TH
		$MiddleDistance[0] = Abs($MiddleDistance[0] - $RedLinepixelCloserTH[0])
		$MiddleDistance[1] = Abs($MiddleDistance[1] + $RedLinepixelCloserTH[1])
		;_GDIPlus_GraphicsDrawRect($hGraphic, $Th[0], $MiddleDistance[1], Abs($MiddleDistance[0] - $Th[0]), Abs($MiddleDistance[1] - $Th[1]), $hPenWHITE)
	EndIf

	Setlog(" »» Middle Distance is: " & $MiddleDistance[0] & "-" & $MiddleDistance[1])

	; Let's Draw the Middle distance
	_GDIPlus_GraphicsDrawRect($hGraphic, $MiddleDistance[0] - 3, $MiddleDistance[1] - 3, 6, 6, $hPenWHITE)

	; Let´s make the Square to detect the walls
	Local $x = $MiddleDistance[0] - ($TileX / 2)
	Local $y = $MiddleDistance[1] - ($TileY / 2)
	Local $x1 = Floor(Abs($MiddleDistance[0] - $TH[0]) / 2)
	Local $y1 = Floor(Abs($MiddleDistance[1] - $TH[1]) / 2)

	If $MiddleDistance[0] < $TH[0] And $MiddleDistance[1] < $TH[1] Then ; Top Left Of The TH
		$x1 = Abs($x1 + $MiddleDistance[0])
		$y1 = Abs($y1 + $MiddleDistance[1])
	EndIf
	If $MiddleDistance[0] < $TH[0] And $MiddleDistance[1] > $TH[1] Then ; Bottom Left Of The TH
		$x1 = Abs($x1 + $MiddleDistance[0])
		$y1 = Abs($y1 - $MiddleDistance[1])
	EndIf
	If $MiddleDistance[0] > $TH[0] And $MiddleDistance[1] > $TH[1] Then ; Bottom Right Of The TH
		$x1 = Abs($x1 - $MiddleDistance[0])
		$y1 = Abs($y1 - $MiddleDistance[1])
	EndIf
	If $MiddleDistance[0] > $TH[0] And $MiddleDistance[1] < $TH[1] Then ; Top right Of The TH
		$x1 = Abs($x1 - $MiddleDistance[0])
		$y1 = Abs($y1 + $MiddleDistance[1])
	EndIf

	;_GDIPlus_GraphicsDrawEllipse($hGraphic, $x1 - 30, $y1 - 30, 60, 60, $hPenGREEN)
	_GDIPlus_GraphicsDrawRect($hGraphic, $x, $y, $TileX, $TileY, $hPenRED)
	_GDIPlus_GraphicsDrawString($hGraphic, "|Walls|", $x + 10, $y + 10, "Verdana", 15)

	If Pixel_Distance($x, $y, $x1, $y1) > 60 Then
		$TestEQDeployTimer = TimerInit()

		Local $THlevel = $level

		Local $FinalWallsPixelWithDistance
		$FinalWallsPixelWithDistance = GetWalls($x, $y, $x + $TileX, $y + $TileY, $THlevel)
		Setlog(" $FinalWallsPixelWithDistance | Rows; " & UBound($FinalWallsPixelWithDistance, $UBOUND_ROWS))
		Setlog("Time Taken|Walls detection: " & Round(TimerDiff($TestEQDeployTimer) / 1000, 2) & "'s") ; Time taken

		For $i = 0 To UBound($FinalWallsPixelWithDistance) - 1
			_GDIPlus_GraphicsDrawRect($hGraphic, $FinalWallsPixelWithDistance[$i][0] - 2, $FinalWallsPixelWithDistance[$i][1] - 2, 4, 4, $hPenWHITE)
		Next

		Local $PixelNearBuild = PixelNearest($FinalWallsPixelWithDistance, $TH)
		_GDIPlus_GraphicsDrawRect($hGraphic, $PixelNearBuild[0] - 3, $PixelNearBuild[1] - 3, 6, 6, $hPenBLUE)

		Local $radius = 60 ; 60px are the EQ radius
		Local $PixelToDeploy = PixelToDeployEQ($FinalWallsPixelWithDistance, $PixelNearBuild, $radius)
		Setlog("$PixelToDeploy: " & $PixelToDeploy[0] & "-" & $PixelToDeploy[1])
		_GDIPlus_GraphicsDrawRect($hGraphic, $PixelToDeploy[0] - 3, $PixelToDeploy[1] - 3, 6, 6, $hPenYELLOW)
	EndIf

	Setlog("Time Taken|ALL FUNCTION: " & Round(TimerDiff($TestEQDeployFinalTimer) / 1000, 2) & "'s") ; Time taken

	; Clean up resources
	_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $fileName)
	_GDIPlus_PenDispose($hPenRED)
	_GDIPlus_PenDispose($hPenWHITE)
	_GDIPlus_PenDispose($hPenGREEN)
	_GDIPlus_PenDispose($hPenBLUE)
	_GDIPlus_PenDispose($hPenYELLOW)
	_GDIPlus_GraphicsDispose($hGraphic)

	; Lets Open the folder

	Run("Explorer.exe " & $subDirectory)
	$RunState = False

EndFunc   ;==>TestEQDeploy

Func Pixel_Distance($x1, $y1, $x2, $y2) ;Pythagoras theorem for 2D
	Local $a, $b, $c
	If $x2 = $x1 And $y2 = $y1 Then
		Return 0
	Else
		$a = $y2 - $y1
		$b = $x2 - $x1
		$c = Sqrt($a * $a + $b * $b)
		Return $c
	EndIf
EndFunc   ;==>Pixel_Distance

Func Imgloc2MBR($string)

	Local $AllPoints = StringSplit($string, "|", $STR_NOCOUNT)
	Local $EachPoint[UBound($AllPoints)][2]
	Local $_PixelTopLeft, $_PixelBottomLeft, $_PixelBottomRight, $_PixelTopRight

	For $i = 0 To UBound($AllPoints) - 1
		Local $temp = StringSplit($AllPoints[$i], ",", $STR_NOCOUNT)
		$EachPoint[$i][0] = Number($temp[0])
		$EachPoint[$i][1] = Number($temp[1])
		; Setlog(" $EachPoint[0]: " & $EachPoint[$i][0] & " | $EachPoint[1]: " & $EachPoint[$i][1])
	Next

	_ArraySort($EachPoint, 0, 0, 0, 0)

	For $i = 0 To UBound($EachPoint) - 1
		If $EachPoint[$i][0] > 60 And $EachPoint[$i][0] < 430 And $EachPoint[$i][1] > 35 And $EachPoint[$i][1] < 336 Then
			$_PixelTopLeft &= String("|" & $EachPoint[$i][0] & "-" & $EachPoint[$i][1])

		ElseIf $EachPoint[$i][0] > 60 And $EachPoint[$i][0] < 430 And $EachPoint[$i][1] > 336 And $EachPoint[$i][1] < 630 Then
			$_PixelBottomLeft &= String("|" & $EachPoint[$i][0] & "-" & $EachPoint[$i][1])

		ElseIf $EachPoint[$i][0] > 430 And $EachPoint[$i][0] < 805 And $EachPoint[$i][1] > 336 And $EachPoint[$i][1] < 630 Then
			$_PixelBottomRight &= String("|" & $EachPoint[$i][0] & "-" & $EachPoint[$i][1])

		ElseIf $EachPoint[$i][0] > 430 And $EachPoint[$i][0] < 805 And $EachPoint[$i][1] > 35 And $EachPoint[$i][1] < 336 Then
			$_PixelTopRight &= String("|" & $EachPoint[$i][0] & "-" & $EachPoint[$i][1])

		EndIf
	Next

	If Not StringIsSpace($_PixelTopLeft) Then $_PixelTopLeft = StringTrimLeft($_PixelTopLeft, 1)
	If Not StringIsSpace($_PixelBottomLeft) Then $_PixelBottomLeft = StringTrimLeft($_PixelBottomLeft, 1)
	If Not StringIsSpace($_PixelBottomRight) Then $_PixelBottomRight = StringTrimLeft($_PixelBottomRight, 1)
	If Not StringIsSpace($_PixelTopRight) Then $_PixelTopRight = StringTrimLeft($_PixelTopRight, 1)

	Local $NewRedLineString = $_PixelTopLeft & "#" & $_PixelBottomLeft & "#" & $_PixelBottomRight & "#" & $_PixelTopRight

	Return $NewRedLineString

EndFunc   ;==>Imgloc2MBR

Func GetWalls($x, $y, $x1, $y2, $THlevel)

	Local $IniX = $x
	Local $IniY = $y
	Local $aResult[1][6], $aCoordArray[0][0], $aCoords, $aCoordsSplit, $aValue
	Local $directory = @ScriptDir & "\images\Resources\Walls"
	Local $Redlines = "FV"

	Local $minLevel = 0
	Local $maxLevel = 0

	Switch $THlevel
		Case 0 To 6
			$minLevel = 3
			$maxLevel = 6
		Case 7
			$minLevel = 4
			$maxLevel = 7
		Case 8
			$minLevel = 5
			$maxLevel = 8
		Case 9
			$minLevel = 6
			$maxLevel = 10
		Case 10
			$minLevel = 6
			$maxLevel = 10
		Case 11
			$minLevel = 7
			$maxLevel = 11
		Case Else
			$minLevel = 0
			$maxLevel = 11
	EndSwitch

	; Capture the screen for comparison
	_CaptureRegion2($x, $y, $x1, $y2)

	$res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", $Redlines, "Int", $minLevel, "Int", $maxLevel)

	If $res[0] <> "" Then
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

		; Redimension the result array to allow for the new entries
		ReDim $aResult[UBound($aKeys)][6]

		; Loop through the array
		For $i = 0 To UBound($aKeys) - 1
			; Get the property values
			$aResult[$i][0] = returnPropertyValue($aKeys[$i], "filename")
			$aResult[$i][1] = returnPropertyValue($aKeys[$i], "objectname")
			$aResult[$i][2] = returnPropertyValue($aKeys[$i], "objectlevel")
			$aResult[$i][3] = returnPropertyValue($aKeys[$i], "fillLevel")
			$aResult[$i][4] = returnPropertyValue($aKeys[$i], "totalobjects")

			; Get the coords property
			$aValue = returnPropertyValue($aKeys[$i], "objectpoints")
			$aCoords = StringSplit($aValue, "|", $STR_NOCOUNT)
			ReDim $aCoordArray[UBound($aCoords)][2]
			SetLog("$aResult[$i][0]|filename : " & $aResult[$i][0])
			; Loop through the found coords
			For $j = 0 To UBound($aCoords) - 1
				; Split the coords into an array
				$aCoordsSplit = StringSplit($aCoords[$j], ",", $STR_NOCOUNT)
				If UBound($aCoordsSplit) = 2 Then
					; Store the coords into a two dimensional array
					$aCoordArray[$j][0] = $aCoordsSplit[0] + $IniX ; X coord.
					$aCoordArray[$j][1] = $aCoordsSplit[1] + $IniY ; Y coord.
				EndIf
			Next

			; Store the coords array as a sub-array
			$aResult[$i][5] = $aCoordArray
		Next
	EndIf

	Local $temp
	Local $FinalResult[1][2]
	Local $z = 0

	For $i = 0 To UBound($aResult) - 1
		$temp = $aResult[$i][5]
		For $x = 0 To UBound($temp) - 1
			$FinalResult[$z][0] = $temp[$x][0]
			$FinalResult[$z][1] = $temp[$x][1]
			$z += 1
			If $i = (UBound($aResult) - 1) And $x = (UBound($temp) - 1) Then ExitLoop (2)
			ReDim $FinalResult[$z + 1][2]
		Next
	Next

	_ArraySort($FinalResult, 1, 0, 0, 0)

	Setlog(" »" & UBound($FinalResult) & " Walls Detected!")

	Return $FinalResult ; will be a 2D array $FinalPixelWithDistance[$i][2] with X = $FinalPixelWithDistance[$i][0] and Y = $FinalPixelWithDistance[$i][1]
EndFunc   ;==>GetWalls

Func PixelNearest($aArrayPoints, $center) ; $aArrayPoints 2D  ,  $Center 1D

	Setlog("Initial PixelNearest")

	Local $mindist = 860 ; Highest Value on Emulator
	Local $MinPixel[3]
	Local $Distance = 860 ; Highest Value on Emulator

	For $i = 0 To UBound($aArrayPoints) - 1
		If $aArrayPoints[$i][0] = $center[0] And $aArrayPoints[$i][1] = $center[1] Then
			$Distance = 0
		Else
			$Distance = Ceiling(Sqrt(($aArrayPoints[$i][0] - $center[0]) ^ 2 + ($aArrayPoints[$i][1] - $center[1]) ^ 2))
		EndIf
		If $Distance < $mindist Then
			$mindist = $Distance
			$MinPixel[0] = $aArrayPoints[$i][0]
			$MinPixel[1] = $aArrayPoints[$i][1]
			$MinPixel[2] = $mindist
		EndIf
	Next

	; Will Return an Array 3D with Coordinates and Distance
	Setlog("End PixelNearest")
	If $mindist <> 860 Then Return $MinPixel
	If $mindist = 860 Then Return -1

EndFunc   ;==>PixelNearest

Func PixelToDeployEQ($aArrayPoints, $WallNearBuilding, $radius) ; $aArrayPoints 2D  ,  $radius = 60px , $WallNearBuilding  1D

	Setlog("Initial PixelToDeployEQ")
	Local $MinPixel[1][3]
	Local $Distance = 860 ; Highest Value on Emulator
	Local $z = 0

	Local $PixelNearest[2] = [0, 0]
	Local $Pixelfarest[2] = [0, 0]
	Local $Pixelfarest2[2] = [0, 0]
	Local $PixelToDeploy[2] = [0, 0]

	Setlog("Initial PixelToDeployEQ 2")
	If UBound($aArrayPoints) < 2 Then Return $PixelToDeploy

	Setlog("Initial PixelToDeployEQ 3")
	For $i = 0 To UBound($aArrayPoints) - 1
		If $aArrayPoints[$i][0] = $WallNearBuilding[0] And $aArrayPoints[$i][1] = $WallNearBuilding[1] Then
			$Distance = 0
		Else
			$Distance = Ceiling(Sqrt(($aArrayPoints[$i][0] - $WallNearBuilding[0]) ^ 2 + ($aArrayPoints[$i][1] - $WallNearBuilding[1]) ^ 2))
		EndIf
		If $Distance < $radius Then
			$MinPixel[$z][0] = $aArrayPoints[$i][0]
			$MinPixel[$z][1] = $aArrayPoints[$i][1]
			$MinPixel[$z][2] = $Distance
			$z += 1
			If $i = UBound($aArrayPoints) - 1 Then ExitLoop
			ReDim $MinPixel[$z + 1][3]
		EndIf
	Next

	Setlog("Initial PixelToDeployEQ 4")
	Local $MAX = _ArrayMaxIndex($MinPixel, 1, 0, 0, 2)
	Local $MIN = _ArrayMinIndex($MinPixel, 1, 0, 0, 2)

	Setlog("Initial PixelToDeployEQ 5")
	If UBound($MinPixel) > 1 Then

		Setlog("Initial PixelToDeployEQ 6")
		$PixelNearest[0] = $MinPixel[$MIN][0]
		$PixelNearest[1] = $MinPixel[$MIN][1]
		Setlog("$PixelNearest: " & $PixelNearest[0] & "-" & $PixelNearest[1])
		$Pixelfarest[0] = $MinPixel[$MAX][0]
		$Pixelfarest[1] = $MinPixel[$MAX][1]
		Setlog("$Pixelfarest: " & $Pixelfarest[0] & "-" & $Pixelfarest[1])
		$PixelToDeploy[0] = Ceiling(Abs($PixelNearest[0] - $Pixelfarest[0]) / 2)
		$PixelToDeploy[1] = Ceiling(Abs($PixelNearest[1] - $Pixelfarest[1]) / 2)
		Setlog("$PixelToDeploy: " & $PixelToDeploy[0] & "-" & $PixelToDeploy[1])

		Setlog("Initial PixelToDeployEQ 7")
		If $PixelNearest[0] > $Pixelfarest[0] And $PixelNearest[1] < $Pixelfarest[1] Then ; Top Rifht Of The Near Pixel
			$x = $PixelNearest[0] - $PixelToDeploy[0]
			$y = $PixelNearest[1] + $PixelToDeploy[1]
		ElseIf $PixelNearest[0] < $Pixelfarest[0] And $PixelNearest[1] < $Pixelfarest[1] Then ; Top Left Of The Near Pixel
			$x = $PixelNearest[0] + $PixelToDeploy[0]
			$y = $PixelNearest[1] + $PixelToDeploy[1]
		ElseIf $PixelNearest[0] > $Pixelfarest[0] And $PixelNearest[1] > $Pixelfarest[1] Then ; Bottom Right The Near Pixel
			$x = $PixelNearest[0] - $PixelToDeploy[0]
			$y = $PixelNearest[1] - $PixelToDeploy[1]
		ElseIf $PixelNearest[0] < $Pixelfarest[0] And $PixelNearest[1] > $Pixelfarest[1] Then ; Bottom Left Of The Near Pixel
			$x = $PixelNearest[0] + $PixelToDeploy[0]
			$y = $PixelNearest[1] - $PixelToDeploy[1]
		Else
			$x = $PixelNearest[0]
			$y = $PixelNearest[1]
		EndIf

		$Pixelfarest2[0] = $x
		$Pixelfarest2[1] = $y

		Setlog("$Pixelfarest2: " & $Pixelfarest2[0] & "-" & $Pixelfarest2[1])
		Return $Pixelfarest2
	Else
		$Pixelfarest2[0] = $MinPixel[0][0]
		$Pixelfarest2[1] = $MinPixel[0][1]
		Setlog("$Pixelfarest2   : " & $Pixelfarest2[0] & "-" & $Pixelfarest2[1])
		Return $Pixelfarest2
	EndIf


EndFunc   ;==>PixelToDeployEQ

Func TestTrainRevamp2()
	$RunState = True

	$debugOcr = 1
	Setlog("Start......OpenArmy Window.....")

	Local $timer = TimerInit()

	CheckExistentArmy("Troops")

	Setlog("Imgloc Troops Time: " & Round(TimerDiff($timer) / 1000, 2) & "'s")

	Setlog("End......OpenArmy Window.....")
	$debugOcr = 0
	$RunState = False
EndFunc   ;==>TestTrainRevamp2

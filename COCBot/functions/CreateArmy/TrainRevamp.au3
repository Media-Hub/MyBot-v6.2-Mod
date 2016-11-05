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

	If $ichkUseQTrain = 0 Then
		TestTrainRevampOldStyle()
		Return
	EndIf

	Local $timer
	Local $tempElixir = ""
	Local $tempDElixir = ""
	Local $tempElixirSpent = 0
	Local $tempDElixirSpent = 0

	; Read Resource Values For army cost Stats
	VillageReport(True, True)
	$tempCounter = 0
	While ($iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 5
		$tempCounter += 1
		If _Sleep(100) Then Return
		VillageReport(True, True)
	WEnd
	$tempElixir = $iElixirCurrent
	$tempDElixir = $iDarkCurrent

	OpenArmyWindow()

	If ISArmyWindow(True, $ArmyTAB) = False Then Return

	SetLog(" »» Army Window Opened!", $COLOR_ACTION1)

	If _Sleep(250) Then Return
	If $Runstate = False Then Return

	$canRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])

	Local $sArmyCamp = getArmyCampCap(110, 166) ; OCR read army trained and total
	Local $aGetArmySize = StringSplit($sArmyCamp, "#", $STR_NOCOUNT)

	Local $sSpells = getArmyCampCap(99, 313) ; OCR read Spells trained and total
	Local $aGetSpellsSize = StringSplit($sSpells, "#", $STR_NOCOUNT)

	Local $scastle = getArmyCampCap(300, 468) ; OCR read Castle Received and total
	Local $aGetCastleSize = StringSplit($scastle, "#", $STR_NOCOUNT)

	;Test for Full Army
	$fullarmy = False
	$CurCamp = 0
	If UBound($aGetArmySize) = 2 Then
		If $ichkTotalCampForced = 0 Then
			$CurCamp = $aGetArmySize[0]
			$TotalCamp = $aGetArmySize[1]
		Else
			$CurCamp = $aGetArmySize[0]
			$TotalCamp = Number($iValueTotalCampForced)
		EndIf
		If ($CurCamp >= ($TotalCamp * $fulltroop / 100)) And $CommandStop = -1 Then
			$fullarmy = True
		EndIf
	Else
		SetLog("Error reading Camp size")
		Return
	EndIf

	$bFullArmySpells = False
	$iTotalSpellSpace = 0
	If UBound($aGetSpellsSize) = 2 Then
		If $aGetSpellsSize[0] = $aGetSpellsSize[1] Or $aGetSpellsSize[0] >= $iTotalCountSpell Then
			$iTotalSpellSpace = $aGetSpellsSize[0]
			$bFullArmySpells = True
		EndIf
	Else
		SetLog("Error reading Spells size")
		Return
	EndIf

	Local $checkSpells = checkspells()
	If $Runstate = False Then Return
	Local $fullcastlespells = IsFullCastleSpells()
	If $Runstate = False Then Return
	Local $fullcastletroops = IsFullCastleTroops()

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
		SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_DEBUG) ;Debug
		If $FirstStart Then
			$FirstStart = False
			;Load Troop and Spell counts in "Cur"
			CheckExistentArmy("Troops")
			CheckExistentArmy("Spells")
			CountNumberDarkSpells() ; needed value for spell donate
		EndIf

		Return
	EndIf

	If $Runstate = False Then Return
	Setlog("Army Camp: " & $aGetArmySize[0] & "/" & $aGetArmySize[1], $COLOR_GREEN) ; coc-ms
	If $aGetSpellsSize[0] <> "" And $aGetSpellsSize[1] <> "" Then Setlog("Spells :" & $aGetSpellsSize[0] & "/" & $aGetSpellsSize[1], $COLOR_GREEN) ; coc-ms
	If $aGetCastleSize[0] <> "" And $aGetCastleSize[1] <> "" Then Setlog("Clan Castle : " & $aGetCastleSize[0] & "/" & $aGetCastleSize[1], $COLOR_GREEN) ; coc-ms

	If IsWaitforHeroesActive() Or $iChkTrophyRange = 1 Then
		;CheckExistentArmy("Heroes")
		getArmyHeroCount()
	Else
		$bFullArmyHero = True
	EndIf

	If $fullarmy And $checkSpells And $bFullArmyHero And $fullcastlespells And $fullcastletroops Then
		$IsFullArmywithHeroesAndSpells = True
	Else
		$IsFullArmywithHeroesAndSpells = False
	EndIf

	Local $txtFull = "Sorry, Not yet!"
	If $IsFullArmywithHeroesAndSpells = True Then $txtFull = "Yes, they are!"

	Setlog("Chief, are your troops ready for battle? " & $txtFull, $COLOR_ACTION)

	If UBound($aGetArmySize) > 1 Then
		If $Runstate = False Then Return
		If ($IsFullArmywithHeroesAndSpells = True) Or ($aGetArmySize[0] = 0 And $FirstStart) Then

			If $IsFullArmywithHeroesAndSpells Then Setlog(" » Your Army is Full, let's make troops before Attack!", $COLOR_BLUE)
			If ($aGetArmySize[0] = 0 And $FirstStart) Then
				Setlog(" » Your Army is Empty, let's make troops before Attack!", $COLOR_ACTION1)
				Setlog(" » Go to TrainRevamp Tab and select your Quick Army position!", $COLOR_ACTION1)
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

			ResetVariables("donated")

			If _Sleep(700) Then Return
			$FirstStart = False
		Else
			If $Runstate = False Then Return
			If $aGetArmySize[0] > 0 And $FirstStart Then SetLog("Please Start with army camp Empty or Full!", $COLOR_RED)

			$timer = TimerInit()

			Local $TimeRemainTroops = getRemainTrainTimer(756, 169)
			Local $ResultTroopsHour, $ResultTroopsMinutes, $ResultTroopsSeconds
			Local $aRemainTrainTroopTimer = 0
			$aTimeTrain[0] = 0

			If $TimeRemainTroops <> "" Then
				;SetLog("Debug Remain Troops | " & $TimeRemainTroops, $COLOR_GREEN)
				If StringInStr($TimeRemainTroops, "h") > 1 Then
					$ResultTroopsHour = StringSplit($TimeRemainTroops, "h", $STR_NOCOUNT)
					; $ResultTroopsHour[0] will be the Hour and the $ResultTroopsHour[1] will be the Minutes with the "m" at end
					$ResultTroopsMinutes = StringTrimRight($ResultTroopsHour[1], 1) ; removing the "m"
					$aRemainTrainTroopTimer = (Number($ResultTroopsHour[0]) * 60) + Number($ResultTroopsMinutes)
				ElseIf StringInStr($TimeRemainTroops, "m") > 1 Then
					$ResultTroopsMinutes = StringSplit($TimeRemainTroops, "m", $STR_NOCOUNT)
					$aRemainTrainTroopTimer = $ResultTroopsMinutes[0] + Ceiling($ResultTroopsMinutes[1] / 60)
				Else
					$ResultTroopsSeconds = StringTrimRight($TimeRemainTroops, 1) ; removing the "s"
					$aRemainTrainTroopTimer = Ceiling($ResultTroopsSeconds / 60)
				EndIf

				$aTimeTrain[0] = $aRemainTrainTroopTimer
				Setlog("Remain Troops Time: " & $aRemainTrainTroopTimer & " min", $COLOR_GREEN)
			EndIf
			CheckExistentArmy("Troops")
			CheckExistentArmy("Spells")
			CountNumberDarkSpells() ; needed value for spell donates
			If IsWaitforSpellsActive() Then
				Local $TimeRemainSpells = getRemainTrainTimer(495, 315)
				$ResultTroopsHour = 0
				$ResultTroopsMinutes = 0
				$ResultTroopsSeconds = 0
				$aTimeTrain[1] = 0
				Local $iRemainTrainSpellsTimer = 0

				If $TimeRemainSpells <> "" Then
					;SetLog("Debug Remain Spells | " & $TimeRemainSpells, $COLOR_GREEN)
					If StringInStr($TimeRemainSpells, "h") > 1 Then
						$ResultTroopsHour = StringSplit($TimeRemainSpells, "h", $STR_NOCOUNT)
						; $ResultTroopsHour[0] will be the Hour and the $ResultTroopsHour[1] will be the Minutes with the "m" at end
						$ResultTroopsMinutes = StringTrimRight($ResultTroopsHour[1], 1) ; removing the "m"
						$iRemainTrainSpellsTimer = (Number($ResultTroopsHour[0]) * 60) + Number($ResultTroopsMinutes)
					ElseIf StringInStr($TimeRemainSpells, "m") > 1 Then
						$ResultTroopsMinutes = StringSplit($TimeRemainSpells, "m", $STR_NOCOUNT)
						$iRemainTrainSpellsTimer = $ResultTroopsMinutes[0] + Ceiling($ResultTroopsMinutes[1] / 60)
					Else
						$ResultTroopsSeconds = StringTrimRight($TimeRemainSpells, 1) ; removing the "s"
						$iRemainTrainSpellsTimer = Ceiling($ResultTroopsSeconds / 60)
					EndIf
					$aTimeTrain[1] = $iRemainTrainSpellsTimer
					Setlog("Remain Spells Time: " & $iRemainTrainSpellsTimer & " min", $COLOR_GREEN)
				EndIf
			EndIf

			If _Sleep(100) Then Return

			If $bDonationEnabled = True Then MakingDonatedTroops()

			CheckIsFullQueuedAndNotFullArmy()
			If $Runstate = False Then Return
			CheckIsEmptyQueuedAndNotFullArmy()
			If $Runstate = False Then Return
			$FirstStart = False
		EndIf
	Else
		SetLog("Error! OCR read army trained and total ", $COLOR_RED)
	EndIf

	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(1000) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts
	SetLog(" »» Army Window Closed!", $COLOR_ACTION1)

	;;;;;; Protect Army cost stats from being missed up by DC and other errors ;;;;;;;
	VillageReport(True, True)

	$tempCounter = 0
	While ($iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 30
		$tempCounter += 1
		If _Sleep($iDelayTrain1) Then Return
		VillageReport(True, True)
	WEnd

	If $tempElixir <> "" And $iElixirCurrent <> "" Then
		$tempElixirSpent = ($tempElixir - $iElixirCurrent)
		$iTrainCostElixir += $tempElixirSpent
		$iElixirTotal -= $tempElixirSpent
		If $ichkSwitchAcc = 1 Then $aElixirTotalAcc[$nCurProfile-1] -= $tempElixirSpent 	; Separate stats per account - SwitchAcc - DEMEN
	EndIf

	If $tempDElixir <> "" And $iDarkCurrent <> "" Then
		$tempDElixirSpent = ($tempDElixir - $iDarkCurrent)
		$iTrainCostDElixir += $tempDElixirSpent
		$iDarkTotal -= $tempDElixirSpent
		If $ichkSwitchAcc = 1 Then $aDarkTotalAcc[$nCurProfile - 1] -= $tempDElixirSpent 	; Separate stats per account - SwitchAcc -  DEMEN
	EndIf

	If $Runstate = False Then Return
	UpdateStats()

	checkAttackDisable($iTaBChkIdle) ; Check for Take-A-Break after opening train page

EndFunc   ;==>TestTrainRevamp

Func TestTrainRevampOldStyle()

	Local $tempElixir = ""
	Local $tempDElixir = ""
	Local $tempElixirSpent = 0
	Local $tempDElixirSpent = 0

	; Read Resource Values For army cost Stats
	VillageReport(True, True)
	$tempCounter = 0
	While ($iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 5
		$tempCounter += 1
		If _Sleep(100) Then Return
		VillageReport(True, True)
	WEnd
	$tempElixir = $iElixirCurrent
	$tempDElixir = $iDarkCurrent


	Setlog(" »» Army Window!", $COLOR_BLUE)

	OpenArmyWindow()
	If $Runstate = False Then Return

	$fullarmy = False
	$bFullArmySpells = False

	$canRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])

	IsFullArmy(True)
	If $Runstate = False Then Return
	IsFullSpells(True)

	Local $fullcastlespells = IsFullCastleSpells()
	If $Runstate = False Then Return
	Local $fullcastletroops = IsFullCastleTroops()

	Local $checkSpells = checkspells()

	;Test for Train/Donate Only and Fullarmy
	If ($CommandStop = 3 Or $CommandStop = 0) And $fullarmy Then
		SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_DEBUG) ;Debug
		If $FirstStart Then $FirstStart = False
		Return
	EndIf

	If IsWaitforHeroesActive() Or $iChkTrophyRange = 1 Then
		;CheckExistentArmy("Heroes")
		getArmyHeroCount()
	Else
		$bFullArmyHero = True
	EndIf

	If $Runstate = False Then Return

	If $fullarmy And $checkSpells And $bFullArmyHero And $fullcastlespells And $fullcastletroops Then
		$IsFullArmywithHeroesAndSpells = True
		$FirstStart = False
	Else
		$IsFullArmywithHeroesAndSpells = False
	EndIf

	Local $rWhatToTrain = WhatToTrain(True) ; r in First means Result! Result of What To Train Function
	Local $rRemoveExtraTroops = RemoveExtraTroops($rWhatToTrain)

	If $rRemoveExtraTroops = 1 Or $rRemoveExtraTroops = 2 Then
		$fullarmy = False
		$bFullArmySpells = False

		IsFullArmy()
		IsFullSpells()

		$fullcastlespells = IsFullCastleSpells()
		$fullcastletroops = IsFullCastleTroops()

		$checkSpells = checkspells()

		;Test for Train/Donate Only and Fullarmy
		If ($CommandStop = 3 Or $CommandStop = 0) And $fullarmy Then
			SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_DEBUG) ;Debug
			If $FirstStart Then $FirstStart = False
			Return
		EndIf

		If IsWaitforHeroesActive() Then
			;CheckExistentArmy("Heroes")
			getArmyHeroCount()
		Else
			$bFullArmyHero = True
		EndIf

		If $fullarmy And $checkSpells And $bFullArmyHero And $fullcastlespells And $fullcastletroops Then
			$IsFullArmywithHeroesAndSpells = True
		Else
			$IsFullArmywithHeroesAndSpells = False
		EndIf

	EndIf

	If $Runstate = False Then Return

	If $rRemoveExtraTroops = 2 Then
		$rWhatToTrain = WhatToTrain(False, False)
		OpenTrainTabNumber($TrainTroopsTAB)
		TrainUsingWhatToTrain($rWhatToTrain)
	EndIf

	;If Not $rRemoveExtraTroops = 2 Then OpenTrainTabNumber($TrainTroopsTAB)

	If IsQueueEmpty($TrainTroopsTAB) = True Then
		If $Runstate = False Then Return
		OpenTrainTabNumber($ArmyTAB)
		$rWhatToTrain = WhatToTrain(False, False)
		OpenTrainTabNumber($TrainTroopsTAB)
		TrainUsingWhatToTrain($rWhatToTrain)
	Else
		If $Runstate = False Then Return
		OpenTrainTabNumber($ArmyTAB)
		Local $TimeRemainTroops = getRemainTrainTimer(756, 169)
		Local $ResultTroopsHour, $ResultTroopsMinutes, $ResultTroopsSeconds
		Local $aRemainTrainTroopTimer = 0
		$aTimeTrain[0] = 0

		If $TimeRemainTroops <> "" Then
			;SetLog("Debug Remain Troops | " & $TimeRemainTroops, $COLOR_GREEN)
			If StringInStr($TimeRemainTroops, "h") > 1 Then
				$ResultTroopsHour = StringSplit($TimeRemainTroops, "h", $STR_NOCOUNT)
				; $ResultTroopsHour[0] will be the Hour and the $ResultTroopsHour[1] will be the Minutes with the "m" at end
				$ResultTroopsMinutes = StringTrimRight($ResultTroopsHour[1], 1) ; removing the "m"
				$aRemainTrainTroopTimer = (Number($ResultTroopsHour[0]) * 60) + Number($ResultTroopsMinutes)
			ElseIf StringInStr($TimeRemainTroops, "m") > 1 Then
				$ResultTroopsMinutes = StringSplit($TimeRemainTroops, "m", $STR_NOCOUNT)
				$aRemainTrainTroopTimer = $ResultTroopsMinutes[0] + Ceiling($ResultTroopsMinutes[1] / 60)
			Else
				$ResultTroopsSeconds = StringTrimRight($TimeRemainTroops, 1) ; removing the "s"
				$aRemainTrainTroopTimer = Ceiling($ResultTroopsSeconds / 60)
			EndIf

			$aTimeTrain[0] = $aRemainTrainTroopTimer
			Setlog("Remaining Troops Train Time: " & $aRemainTrainTroopTimer & " min", $COLOR_GREEN)
		EndIf
	EndIf
	$rWhatToTrain = WhatToTrain(False, False)
	If DoWhatToTrainContainSpell($rWhatToTrain) Then

		If IsQueueEmpty($BrewSpellsTAB) = True Then
			TrainUsingWhatToTrain($rWhatToTrain, True)
		Else
			OpenTrainTabNumber($ArmyTAB)
			Local $TimeRemainTroops = getRemainTrainTimer(500, 315)
			Local $ResultTroopsHour, $ResultTroopsMinutes, $ResultTroopsSeconds
			Local $aRemainTrainTroopTimer = 0
			$aTimeTrain[0] = 0

			If $TimeRemainTroops <> "" Then
				;SetLog("Debug Remain Troops | " & $TimeRemainTroops, $COLOR_GREEN)
				If StringInStr($TimeRemainTroops, "h") > 1 Then
					$ResultTroopsHour = StringSplit($TimeRemainTroops, "h", $STR_NOCOUNT)
					; $ResultTroopsHour[0] will be the Hour and the $ResultTroopsHour[1] will be the Minutes with the "m" at end
					$ResultTroopsMinutes = StringTrimRight($ResultTroopsHour[1], 1) ; removing the "m"
					$aRemainTrainTroopTimer = (Number($ResultTroopsHour[0]) * 60) + Number($ResultTroopsMinutes)
				ElseIf StringInStr($TimeRemainTroops, "m") > 1 Then
					$ResultTroopsMinutes = StringSplit($TimeRemainTroops, "m", $STR_NOCOUNT)
					$aRemainTrainTroopTimer = $ResultTroopsMinutes[0] + Ceiling($ResultTroopsMinutes[1] / 60)
				Else
					$ResultTroopsSeconds = StringTrimRight($TimeRemainTroops, 1) ; removing the "s"
					$aRemainTrainTroopTimer = Ceiling($ResultTroopsSeconds / 60)
				EndIf

				$aTimeTrain[0] = $aRemainTrainTroopTimer
				Setlog("Remaining Spells Brew Time: " & $aRemainTrainTroopTimer & " min", $COLOR_GREEN)
			EndIf
		EndIf
	EndIf


	If _Sleep(250) Then Return
	If $Runstate = False Then Return
	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If _Sleep(250) Then Return

	;;;;;; Protect Army cost stats from being missed up by DC and other errors ;;;;;;;
	VillageReport(True, True)

	$tempCounter = 0
	While ($iElixirCurrent = "" Or ($iDarkCurrent = "" And $iDarkStart <> "")) And $tempCounter < 30
		$tempCounter += 1
		If _Sleep($iDelayTrain1) Then Return
		VillageReport(True, True)
	WEnd

	If $tempElixir <> "" And $iElixirCurrent <> "" Then
		$tempElixirSpent = ($tempElixir - $iElixirCurrent)
		$iTrainCostElixir += $tempElixirSpent
		$iElixirTotal -= $tempElixirSpent
		If $ichkSwitchAcc = 1 Then $aElixirTotalAcc[$nCurProfile-1] -= $tempElixirSpent 	; Separate stats per account - SwitchAcc - DEMEN
	EndIf

	If $tempDElixir <> "" And $iDarkCurrent <> "" Then
		$tempDElixirSpent = ($tempDElixir - $iDarkCurrent)
		$iTrainCostDElixir += $tempDElixirSpent
		$iDarkTotal -= $tempDElixirSpent
		If $ichkSwitchAcc = 1 Then $aDarkTotalAcc[$nCurProfile - 1] -= $tempDElixirSpent 	; Separate stats per account - SwitchAcc -  DEMEN
	EndIf

	If $Runstate = False Then Return
	UpdateStats()

	checkAttackDisable($iTaBChkIdle) ; Check for Take-A-Break after opening train page


EndFunc   ;==>TestTrainRevampOldStyle

Func IsFullArmy($log = False)
	If ISArmyWindow(False, $ArmyTAB) = False Then OpenTrainTabNumber($ArmyTAB)
	If $Runstate = False Then Return

	Local Const $rColorCheck = _ColorCheck(_GetPixelColor(28, 176, True), Hex(0xFFFFFF, 6), 20) And _ColorCheck(_GetPixelColor(24, 168, True), Hex(0x92C232, 6), 20)

	If $rColorCheck = True Then $fullarmy = True

	Local $sArmyCamp = getArmyCampCap(110, 166) ; OCR read army trained and total
	Local $aGetArmySize = StringSplit($sArmyCamp, "#", $STR_NOCOUNT)
	If UBound($aGetArmySize) >= 2 Then
		If $log Then SetLog("Troops: " & $aGetArmySize[0] & "/" & $aGetArmySize[1], $COLOR_GREEN)
		;Test for Full Army
		$fullarmy = False
		$CurCamp = 0
		If $ichkTotalCampForced = 0 Then
			$CurCamp = $aGetArmySize[0]
			$TotalCamp = $aGetArmySize[1]
		Else
			$CurCamp = $aGetArmySize[0]
			$TotalCamp = Number($iValueTotalCampForced)
		EndIf
		Local $thePercent = Number(($CurCamp / $TotalCamp) * 100, 1)
		If $thePercent >= $fulltroop Then $fullarmy = True
	EndIf
	Return $fullarmy
EndFunc   ;==>IsFullArmy

Func IsFullSpells($log = False)
	If ISArmyWindow(False, $ArmyTAB) = False Then OpenTrainTabNumber($ArmyTAB)
	If $Runstate = False Then Return

	Local $sSpells = getArmyCampCap(99, 313) ; OCR read Spells trained and total
	Local $aGetSpellsSize = StringSplit($sSpells, "#", $STR_NOCOUNT)

	$bFullArmySpells = False
	If UBound($aGetSpellsSize) = 2 Then
		If $log Then SetLog("Spells: " & $aGetSpellsSize[0] & "/" & $aGetSpellsSize[1], $COLOR_GREEN)
		If $aGetSpellsSize[0] = $aGetSpellsSize[1] Or $aGetSpellsSize[0] >= $iTotalCountSpell Or $aGetSpellsSize[0] >= TotalSpellsToBrewInGUI() Then
			$bFullArmySpells = True
			Return True
		EndIf
	Else
		SetLog("Error reading Spells size")
		Return
	EndIf

	If $aGetSpellsSize[0] = $iTotalCountSpell Then
		$bFullArmySpells = True
		Return True
	EndIf

	Return $bFullArmySpells
EndFunc   ;==>IsFullSpells

Func checkspells()
	Local $ToReturn = False
	If $Runstate = False Then Return

	If ($iEnableSpellsWait[$DB] = 0 And $iEnableSpellsWait[$LB] = 0) Or ($bFullArmySpells And ($iEnableSpellsWait[$DB] = 1 Or $iEnableSpellsWait[$LB] = 1)) Then
		$ToReturn = True
		Return $ToReturn
	EndIf

	$ToReturn = (IIf($iDBcheck = 1, IIf($iEnableSpellsWait[$DB] = 1, $bFullArmySpells, True), 1) And IIf($iABcheck = 1, IIf($iEnableSpellsWait[$LB] = 1, $bFullArmySpells, True), 1))

	Return $ToReturn
EndFunc   ;==>checkspells

Func IsFullCastleSpells($returnOnly = False)
	Local $ToReturn = False
	If $Runstate = False Then Return
	If $iChkWaitForCastleSpell[$DB] = 0 And $iChkWaitForCastleSpell[$LB] = 0 Then
		$ToReturn = True
		If $returnOnly = False Then
			Return $ToReturn
		Else
			Return ""
		EndIf
	EndIf

	Local Const $rColCheck = _ColorCheck(_GetPixelColor(512, 470, True), Hex(0x93C230, 6), 30)
	Local $rColCheckFullCCTroops = False
	$ToReturn = (IIf($iDBcheck = 1, IIf($iChkWaitForCastleSpell[$DB] = 1, $rColCheck, True), 1) And IIf($iABcheck = 1, IIf($iChkWaitForCastleSpell[$LB] = 1, $rColCheck, True), 1))


	If $ToReturn = True Then
		$CurCCSpell = GetCurCCSpell()
		If $CurCCSpell = "" Then
			If $returnOnly = False Then SetLog("Failed to get current available spell in clan castle", $COLOR_RED)
			$ToReturn = False
			If $returnOnly = False Then
				Return $ToReturn
			Else
				Return ""
			EndIf
		EndIf
		Local $bShouldRemove
		$bShouldRemove = Not CompareCCSpellWithGUI($CurCCSpell)

		If $bShouldRemove = True Then
			SetLog("Removing Useless Spell from Clan Castle", $COLOR_BLUE)
			RemoveCastleSpell()
			If _Sleep(1000) Then Return
			$canRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])
			If $canRequestCC = True Then
				$rColCheckFullCCTroops = _ColorCheck(_GetPixelColor(24, 470, True), Hex(0x93C230, 6), 30)
				If $rColCheckFullCCTroops = True Then SetLog("Castle spell is empty, Requesting for...")
				If $returnOnly = False Then
					RequestCC(False, IIf($rColCheckFullCCTroops = True Or ($iChkWaitForCastleTroops[$DB] = 0 And $iChkWaitForCastleTroops[$LB] = 0), IIf($iChkWaitForCastleSpell[$LB] = 1, IIf(String(GUICtrlRead($cmbABWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbABWaitForCastleSpell) & " Spell")), IIf($iChkWaitForCastleSpell[$DB] = 1, IIf(String(GUICtrlRead($cmbDBWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbDBWaitForCastleSpell) & " Spell")), "")), ""))
				Else
					$ToReturn = IIf($rColCheckFullCCTroops = True Or ($iChkWaitForCastleTroops[$DB] = 0 And $iChkWaitForCastleTroops[$LB] = 0), IIf($iChkWaitForCastleSpell[$LB] = 1, IIf(String(GUICtrlRead($cmbABWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbABWaitForCastleSpell) & " Spell")), IIf($iChkWaitForCastleSpell[$DB] = 1, IIf(String(GUICtrlRead($cmbDBWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbDBWaitForCastleSpell) & " Spell")), "")), "")
					Return $ToReturn
				EndIf
			EndIf
			$ToReturn = False
		EndIf
	Else
		$canRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])
		If $canRequestCC = True Then
			$rColCheckFullCCTroops = _ColorCheck(_GetPixelColor(24, 470, True), Hex(0x93C230, 6), 30)
			If $rColCheckFullCCTroops = True Then SetLog("Castle spell is empty, Requesting for...")
			If $returnOnly = False Then
				RequestCC(False, IIf($rColCheckFullCCTroops = True Or ($iChkWaitForCastleTroops[$DB] = 0 And $iChkWaitForCastleTroops[$LB] = 0), IIf($iChkWaitForCastleSpell[$LB] = 1, IIf(String(GUICtrlRead($cmbABWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbABWaitForCastleSpell) & " Spell")), IIf($iChkWaitForCastleSpell[$DB] = 1, IIf(String(GUICtrlRead($cmbDBWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbDBWaitForCastleSpell) & " Spell")), "")), ""))
			Else
				$ToReturn = IIf($rColCheckFullCCTroops = True Or ($iChkWaitForCastleTroops[$DB] = 0 And $iChkWaitForCastleTroops[$LB] = 0), IIf($iChkWaitForCastleSpell[$LB] = 1, IIf(String(GUICtrlRead($cmbABWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbABWaitForCastleSpell) & " Spell")), IIf($iChkWaitForCastleSpell[$DB] = 1, IIf(String(GUICtrlRead($cmbDBWaitForCastleSpell)) = "Any", "", String(GUICtrlRead($cmbDBWaitForCastleSpell) & " Spell")), "")), "")
				Return $ToReturn
			EndIf
		EndIf
	EndIf
	If $returnOnly = False Then
		Return $ToReturn
	Else
		Return ""
	EndIf
EndFunc   ;==>IsFullCastleSpells

Func RemoveCastleSpell()
	If _ColorCheck(_GetPixelColor(675, 482, True), Hex(0xFFFFFF, 6), 30) = False Then ; If no 'Edit Army' Button found in army tab to edit troops
		SetLog("Cannot find/verify 'Edit Army' Button in Army tab", $COLOR_ORANGE)
		Return False ; Exit function
	EndIf

	Click(Random(680, 775, 1), Random(470, 515, 1)) ; Click on Edit Army Button
	If $Runstate = False Then Return

	If _Sleep(500) Then Return

	Local $pos[2] = [575, 575]
	ClickRemoveTroop($pos, 1, $isldTrainITDelay) ; Click on Remove button as much as needed

	If _Sleep(400) Then Return

	If _ColorCheck(_GetPixelColor(815, 520, True), Hex(0x68B020, 6), 30) = False Then ; If no 'Okay' button found in army tab to save changes
		SetLog("Cannot find/verify 'Okay' Button in Army tab", $COLOR_ORANGE)
		ClickP($aAway, 2, 0, "#0346") ; Click Away, Necessary! due to possible errors/changes
		If _Sleep(400) Then OpenArmyWindow() ; Open Army Window AGAIN
		Return False ; Exit Function
	EndIf

	If _Sleep(700) Then Return

	Click(Random(730, 830, 1), Random(495, 525, 1)) ; Click on 'Okay' button to save changes

	If _Sleep(700) Then Return

	If _ColorCheck(_GetPixelColor(508, 428, True), Hex(0xFFFFFF, 6), 30) = False Then ; If no 'Okay' button found to verify that we accept the changes
		SetLog("Cannot find/verify 'Okay #2' Button in Army tab", $COLOR_ORANGE)
		ClickP($aAway, 2, 0, "#0346") ;Click Away
		Return False ; Exit function
	EndIf

	Click(Random(445, 585, 1), Random(400, 455, 1)) ; Click on 'Okay' button to Save changes... Last button

	SetLog("Castle Sell Removed", $COLOR_GREEN)
	If _Sleep(200) Then Return
	Return True
EndFunc   ;==>RemoveCastleSpell

Func CompareCCSpellWithGUI($CS)
	Local $SpellsInGUI[2] = [GUICtrlRead($cmbDBWaitForCastleSpell), GUICtrlRead($cmbABWaitForCastleSpell)]
	$dbCSPellWait = IIf($iDBcheck = 1, IIf($iChkWaitForCastleSpell[$DB] = 1, $SpellsInGUI[0] = "Any", True), True)
	$lbCSPellWait = IIf($iABcheck = 1, IIf($iChkWaitForCastleSpell[$LB] = 1, $SpellsInGUI[1] = "Any", True), True)
	If $dbCSPellWait = True And $lbCSPellWait = True Then Return True
	If $Runstate = False Then Return
	Switch $SpellsInGUI[0]
		Case "Poison"
			$SpellsInGUI[0] = "PSpell"
		Case "EarthQuake"
			$SpellsInGUI[0] = "ESpell"
		Case "Haste"
			$SpellsInGUI[0] = "HaSpell"
		Case "Skeleton"
			$SpellsInGUI[0] = "SkSpell"
	EndSwitch
	Switch $SpellsInGUI[1]
		Case "Poison"
			$SpellsInGUI[1] = "PSpell"
		Case "EarthQuake"
			$SpellsInGUI[1] = "ESpell"
		Case "Haste"
			$SpellsInGUI[1] = "HaSpell"
		Case "Skeleton"
			$SpellsInGUI[1] = "SkSpell"
	EndSwitch

	Return ((IIf($iDBcheck = 1, IIf($iChkWaitForCastleSpell[$DB] = 1, $CS = $SpellsInGUI[0], False), False)) Or (IIf($iABcheck = 1, IIf($iChkWaitForCastleSpell[$LB] = 1, $CS = $SpellsInGUI[1], False), False)))
EndFunc   ;==>CompareCCSpellWithGUI

Func GetCurCCSpell()
	If $Runstate = False Then Return
	Local $directory = @ScriptDir & "\images\Resources\ArmyDarkSpells"
	Local $res = SearchArmy($directory, 508, 493, 587, 592, "", True)
	If ValidateSearchArmyResult($res) Then
		Return $res[0][0]
	EndIf
	Return ""
EndFunc   ;==>GetCurCCSpell

Func IsFullCastleTroops()
	Local $ToReturn = False
	If $Runstate = False Then Return
	If $iChkWaitForCastleTroops[$DB] = 0 And $iChkWaitForCastleTroops[$LB] = 0 Then
		$ToReturn = True
		Return $ToReturn
	EndIf

	Local Const $rColCheck = _ColorCheck(_GetPixelColor(24, 470, True), Hex(0x93C230, 6), 30)

	$ToReturn = (IIf($iDBcheck = 1, IIf($iChkWaitForCastleTroops[$DB] = 1, $rColCheck, True), 1) And IIf($iABcheck = 1, IIf($iChkWaitForCastleTroops[$LB] = 1, $rColCheck, True), 1))

	Return $ToReturn
EndFunc   ;==>IsFullCastleTroops

Func TrainUsingWhatToTrain($rWTT, $SpellsOnly = False)
	If $Runstate = False Then Return
	If $SpellsOnly = False Then
		If ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB)
	Else
		If ISArmyWindow(False, $BrewSpellsTAB) = False Then OpenTrainTabNumber($BrewSpellsTAB)
	EndIf
	; Loop through needed troops to Train
	Select
		Case $IsFullArmywithHeroesAndSpells = False
			For $i = 0 To (UBound($rWTT) - 1)
				If $Runstate = False Then Return
				If $rWTT[$i][1] > 0 Then ; If Count to Train Was Higher Than ZERO
					If IsSpellToBrew($rWTT[$i][0]) Then
						BrewUsingWhatToTrain($rWTT[$i][0], $rWTT[$i][1])
						ContinueLoop
					Else
						If $SpellsOnly = True Then ContinueLoop
					EndIf
					$NeededSpace = CalcNeededSpace($rWTT[$i][0], $rWTT[$i][1])
					$LeftSpace = LeftSpace()
					If $NeededSpace <= $LeftSpace Then ; If Needed Space was Equal Or Lower Than Left Space
						If DragIfNeeded($rWTT[$i][0]) = False Then
							Return False
						EndIf
						SetLog("Training " & $rWTT[$i][1] & "x " & NameOfTroop(Eval("e" & $rWTT[$i][0]), IIf($rWTT[$i][1] > 1, 1, 0)), $COLOR_GREEN)
						TrainIt(Eval("e" & $rWTT[$i][0]), $rWTT[$i][1], $isldTrainITDelay)
					Else ; If Needed Space was Higher Than Left Space
						$CountToTrain = 0
						$CanAdd = True
						Do
							$NeededSpace = CalcNeededSpace($rWTT[$i][0], $CountToTrain)
							If $NeededSpace <= $LeftSpace Then
								$CountToTrain += 1
							Else
								$CanAdd = False
							EndIf
						Until $CanAdd = False
						If $CountToTrain > 0 Then
							If DragIfNeeded($rWTT[$i][0]) = False Then
								Return False
							EndIf
						EndIf
						SetLog("Training " & $CountToTrain & "x " & NameOfTroop(Eval("e" & $rWTT[$i][0]), IIf($CountToTrain > 1, 1, 0)), $COLOR_GREEN)
						TrainIt(Eval("e" & $rWTT[$i][0]), $CountToTrain, $isldTrainITDelay)
					EndIf
				EndIf
			Next
		Case $IsFullArmywithHeroesAndSpells = True
			For $i = 0 To (UBound($rWTT) - 1)
				If $Runstate = False Then Return
				If $rWTT[$i][1] > 0 Then ; If Count to Train Was Higher Than ZERO
					If IsSpellToBrew($rWTT[$i][0]) Then
						BrewUsingWhatToTrain($rWTT[$i][0], $rWTT[$i][1])
						ContinueLoop
					Else
						If $SpellsOnly = True Then ContinueLoop
					EndIf
					$NeededSpace = CalcNeededSpace($rWTT[$i][0], $rWTT[$i][1])
					$LeftSpace = LeftSpace(True)
					$LeftSpace = ($LeftSpace[1] * 2) - $LeftSpace[0]
					If $NeededSpace <= $LeftSpace Then ; If Needed Space was Equal Or Lower Than Left Space
						If DragIfNeeded($rWTT[$i][0]) = False Then
							Return False
						EndIf
						SetLog("Training " & $rWTT[$i][1] & "x " & NameOfTroop(Eval("e" & $rWTT[$i][0]), IIf($rWTT[$i][1] > 1, 1, 0)), $COLOR_GREEN)
						TrainIt(Eval("e" & $rWTT[$i][0]), $rWTT[$i][1], $isldTrainITDelay)
					Else ; If Needed Space was Higher Than Left Space
						$CountToTrain = 0
						$CanAdd = True
						Do
							$NeededSpace = CalcNeededSpace($rWTT[$i][0], $CountToTrain)
							If $NeededSpace <= $LeftSpace Then
								$CountToTrain += 1
							Else
								$CanAdd = False
							EndIf
						Until $CanAdd = False
						If $CountToTrain > 0 Then
							If DragIfNeeded($rWTT[$i][0]) = False Then
								Return False
							EndIf
						EndIf
						SetLog("Training " & $CountToTrain & "x " & NameOfTroop(Eval("e" & $rWTT[$i][0]), IIf($CountToTrain > 1, 1, 0)), $COLOR_GREEN)
						TrainIt(Eval("e" & $rWTT[$i][0]), $CountToTrain, $isldTrainITDelay)
					EndIf
				EndIf
			Next
	EndSelect

	Return True
EndFunc   ;==>TrainUsingWhatToTrain

Func BrewUsingWhatToTrain($Spell, $Quantity) ; it's job is a bit different with 'TrainUsingWhatToTrain' Function, It's being called by TrainusingWhatToTrain Func
	If $Quantity <= 0 Then Return False
	If $Quantity = 9999 Then
		SetLog("Brewing " & NameOfTroop(Eval("e" & $Spell)) & " Cancelled, " & @CRLF & _
				"Because you have enough as you set In GUI And This Spell will not be used in Attack")
		Return True
	EndIf
	If $Runstate = False Then Return
	If ISArmyWindow(False, $BrewSpellsTAB) = False Then OpenTrainTabNumber($BrewSpellsTAB)
	;If IsQueueEmpty(-1, True) = False Then Return True
	Select
		Case $IsFullArmywithHeroesAndSpells = False
			If _ColorCheck(_GetPixelColor(230, 208, True), Hex(0x677CB5, 6), 30) = False Then RemoveExtraTroopsQueue()
			$NeededSpace = CalcNeededSpace($Spell, $Quantity)
			$LeftSpace = LeftSpace()
			If $NeededSpace <= $LeftSpace Then ; If Needed Space was Equal Or Lower Than Left Space
				SetLog("Brewing " & $Quantity & "x " & NameOfTroop(Eval("e" & $Spell), IIf($Quantity > 1, 1, 0)), $COLOR_GREEN)
				TrainIt(Eval("e" & $Spell), $Quantity, $isldTrainITDelay)
				#CS Else ; If Needed Space was Higher Than Left Space
					$CountToBrew = 0
					$CanAdd = True
					Do
					$NeededSpace = CalcNeededSpace($Spell, $CountToBrew)
					If $NeededSpace <= $LeftSpace Then
					$CountToBrew += 1
					Else
					$CanAdd = False
					EndIf
					Until $CanAdd = False
					If $CountToBrew > 0 Then
					SetLog("Brewing " & $CountToBrew & "x " & NameOfTroop(Eval("e" & $Spell), IIf($CountToBrew > 1, 1, 0)), $COLOR_GREEN)
					TrainIt(Eval("e" & $Spell), $CountToBrew, $isldTrainITDelay)
					EndIf
				#CE
			EndIf
		Case $IsFullArmywithHeroesAndSpells = True
			$NeededSpace = CalcNeededSpace($Spell, $Quantity)
			$LeftSpace = LeftSpace(True)
			$LeftSpace = ($LeftSpace[1] * 2) - $LeftSpace[0]
			If $NeededSpace <= $LeftSpace Then ; If Needed Space was Equal Or Lower Than Left Space
				SetLog("Brewing " & $Quantity & "x " & NameOfTroop(Eval("e" & $Spell), IIf($Quantity > 1, 1, 0)), $COLOR_GREEN)
				TrainIt(Eval("e" & $Spell), $Quantity, $isldTrainITDelay)
				#CS Else ; If Needed Space was Higher Than Left Space
					$CountToBrew = 0
					$CanAdd = True
					Do
					$NeededSpace = CalcNeededSpace($Spell, $CountToBrew)
					If $NeededSpace <= $LeftSpace Then
					$CountToBrew += 1
					Else
					$CanAdd = False
					EndIf
					Until $CanAdd = False
					If $CountToBrew > 0 Then
					SetLog("Brewing " & $CountToBrew & "x " & NameOfTroop(Eval("e" & $Spell), IIf($CountToBrew > 1, 1, 0)), $COLOR_GREEN)
					TrainIt(Eval("e" & $Spell), $CountToBrew, $isldTrainITDelay)
					EndIf
				#CE
			EndIf
	EndSelect
EndFunc   ;==>BrewUsingWhatToTrain

Func TotalSpellsToBrewInGUI()
	Local $ToReturn = 0
	If $iTotalCountSpell = 0 Then Return $ToReturn
	If $Runstate = False Then Return
	For $i = 0 To (UBound($SpellName) - 1)
		$ToReturn += Number(Number(Eval($SpellName[$i] & "Comp") * $SpellHeight[$i]))
	Next
	Return $ToReturn
EndFunc   ;==>TotalSpellsToBrewInGUI

Func HowManyTimesWillBeUsed($Spell) ;ONLY ONLY ONLY FOR SPELLS
	Local $ToReturn = -1
	If $Runstate = False Then Return
	; Code For DeadBase
	If $iDBcheck = 1 Then
		If $iAtkAlgorithm[$DB] = 1 Then ; Scripted Attack is Selected
			If IsGUICheckedForSpell($Spell, $DB) Then
				$ToReturn = CountCommandsForSpell($Spell, $DB)
				If $ToReturn = 0 Then $ToReturn = -1
			Else ; Spell not selected to be used in GUI so bot will not use Spell
				$ToReturn = -1
			EndIf
		Else ; Scripted Attack is NOT selected, And Starndard attacks not using Spells YET So The spell will not be used in attack
			$ToReturn = -1
		EndIf
	EndIf

	; Code For LiveBase
	If $iABcheck = 1 Then
		If $iAtkAlgorithm[$LB] = 1 Then ; Scripted Attack is Selected
			If IsGUICheckedForSpell($Spell, $LB) Then
				$ToReturn = CountCommandsForSpell($Spell, $LB)
				If $ToReturn = 0 Then $ToReturn = -1
			EndIf
		EndIf
	EndIf

	Return $ToReturn
EndFunc   ;==>HowManyTimesWillBeUsed

Func CountCommandsForSpell($Spell, $Mode)
	Local $ToReturn = 0
	Local $filename = ""
	If $Runstate = False Then Return
	If $Mode = $DB Then
		$filename = $scmbDBScriptName
	Else
		$filename = $scmbABScriptName
	EndIf

	Local $rownum = 0
	If FileExists($dirAttacksCSV & "\" & $filename & ".csv") Then
		Local $f, $line, $acommand, $command
		Local $value1, $Troop
		$f = FileOpen($dirAttacksCSV & "\" & $filename & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			$rownum += 1
			If @error = -1 Then ExitLoop
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), 2)
				$Troop = StringStripWS(StringUpper($acommand[5]), 2)
				If $Troop = $Spell Then $ToReturn += 1
			EndIf
		WEnd
	Else
		$ToReturn = 0
	EndIf
	Return $ToReturn
EndFunc   ;==>CountCommandsForSpell

Func IsGUICheckedForSpell($Spell, $Mode)
	Local $sSpell = ""
	If $Runstate = False Then Return
	Switch Eval("e" & $Spell)
		Case $eLSpell
			$sSpell = "Light"
		Case $eHSpell
			$sSpell = "Heal"
		Case $eRSpell
			$sSpell = "Rage"
		Case $eJSpell
			$sSpell = "Jump"
		Case $eFSpell
			$sSpell = "Freeze"
		Case $ePSpell
			$sSpell = "Poison"
		Case $eESpell
			$sSpell = "Earthquake"
		Case $eHaSpell
			$sSpell = "Haste"
	EndSwitch

	$iVal = Execute("$ichk" & $sSpell & "Spell")

	Return (($iVal[$Mode] = 1) ? True : False)
EndFunc   ;==>IsGUICheckedForSpell

Func DragIfNeeded($Troop)
	Local Const $pos = GetTrainPos(Eval("e" & $Troop))
	If $Runstate = False Then Return

	If IsDarkTroop($Troop) Then
		Local $rCheckPixel = _CheckPixel($pos, $bCapturePixel)
		For $i = 1 To 4
			If $rCheckPixel = False Then
				ClickDrag(616, 445 + $midOffsetY, 400, 445 + $midOffsetY, 2000)
				If _Sleep(1500) Then Return
				$rCheckPixel = _CheckPixel($pos, $bCapturePixel)
			Else
				Return True
			EndIf
		Next
		SetLog("Failed to Verify Troop " & NameOfTroop(Eval("e" & $Troop)) & " Position or Failed to Drag Successfully", $COLOR_RED)
		Return False
	Else
		Local $rCheckPixel = _CheckPixel($pos, $bCapturePixel)
		For $i = 1 To 4
			If $rCheckPixel = False Then
				ClickDrag(400, 445 + $midOffsetY, 616, 445 + $midOffsetY, 2000)
				If _Sleep(1500) Then Return
				$rCheckPixel = _CheckPixel($pos, $bCapturePixel)
			Else
				Return True
			EndIf
		Next
		SetLog("Failed to Verify Troop " & NameOfTroop(Eval("e" & $Troop)) & " Position or Failed to Drag Successfully", $COLOR_RED)
		Return False
	EndIf
EndFunc   ;==>DragIfNeeded

Func DoWhatToTrainContainSpell($rWTT)
	For $i = 0 To (UBound($rWTT) - 1)
		If $Runstate = False Then Return
		If IsSpellToBrew($rWTT[$i][0]) Then
			If $rWTT[$i][1] > 0 Then Return True
		EndIf
	Next
	Return False
EndFunc   ;==>DoWhatToTrainContainSpell

Func IsElixirTroop($Troop)
	For $i = 0 To (UBound($TroopName) - 1)
		If $Runstate = False Then Return
		If $Troop = $TroopName[$i] Then Return True
	Next
	Return False
EndFunc   ;==>IsElixirTroop

Func IsDarkTroop($Troop)
	For $i = 0 To (UBound($TroopDarkName) - 1)
		If $Runstate = False Then Return
		If $Troop = $TroopDarkName[$i] Then Return True
	Next
	Return False
EndFunc   ;==>IsDarkTroop

Func IsSpellToBrew($Spell)
	For $i = 0 To (UBound($SpellName) - 1)
		If $Runstate = False Then Return
		If $Spell = $SpellName[$i] Then Return True
	Next
	Return False
EndFunc   ;==>IsSpellToBrew

Func CalcNeededSpace($Troop, $Quantity)
	For $i = 0 To (UBound($MergedTroopGroup) - 1)
		If $Runstate = False Then Return
		If $Troop = $MergedTroopGroup[$i][0] Then
			$THeight = $MergedTroopGroup[$i][2]
			Return Number($THeight * $Quantity)
		EndIf
	Next
	; For Spells Only, If didn't found as a troop
	For $i = 0 To (UBound($SpellGroup) - 1)
		If $Runstate = False Then Return
		If $Troop = $SpellGroup[$i][0] Then
			$THeight = $SpellGroup[$i][2]
			Return Number($THeight * $Quantity)
		EndIf
	Next
	Return -1
EndFunc   ;==>CalcNeededSpace

Func RemoveExtraTroops($toRemove)
	; Army Window should be open and should be in Tab 'Army tab'

	; 1 Means Removed Troops without Deleting Troops Queued
	; 2 Means Removed Troops And Also Deleted Troops Queued
	; 3 Means Didn't removed troop... Everything was well
	Local $ToReturn = 0

	If $IsFullArmywithHeroesAndSpells = True Or $fullarmy = True Or ($CommandStop = 3 Or $CommandStop = 0) = True Then
		$ToReturn = 3
		Return $ToReturn
	EndIf

	If UBound($toRemove) > 0 Then ; If needed to remove troops
		Local $rGetSlotNumber = GetSlotNumber() ; Get all available Slot numbers with troops assigned on them
		Local $rGetSlotNumberSpells = GetSlotNumber(True) ; Get all available Slot numbers with Spells assigned on them

		; Check if Troops to remove are already in Train Tab Queue!! If was, Will Delete All Troops Queued Then Check Everything Again...
		OpenTrainTabNumber($TrainTroopsTAB)
		$CounterToRemove = 0
		For $i = 0 To (UBound($toRemove) - 1)
			If $Runstate = False Then Return
			If IsSpellToBrew($toRemove[$i][0]) Then ExitLoop
			$CounterToRemove += 1
			If IsAlreadyTraining($toRemove[$i][0]) Then
				SetLog(NameOfTroop(Eval("e" & $toRemove[$i][0])) & " Is in Train Tab Queue By Mistake!", $COLOR_BLUE)
				DeleteTroopsQueued()
				$ToReturn = 2
			EndIf
		Next

		If TotalSpellsToBrewInGUI() > 0 Then
			OpenTrainTabNumber($BrewSpellsTAB)
			For $i = $CounterToRemove To (UBound($toRemove) - 1)
				If $Runstate = False Then Return
				If IsAlreadyTraining($toRemove[$i][0], True) Then
					SetLog(NameOfTroop(Eval("e" & $toRemove[$i][0])) & " Is in Spells Tab Queue By Mistake!", $COLOR_BLUE)
					DeleteSpellsQueued()
					$ToReturn = 2
				EndIf
			Next
		EndIf

		OpenTrainTabNumber($ArmyTAB)
		$toRemove = WhatToTrain(True, False)

		$rGetSlotNumber = GetSlotNumber() ; Get all available Slot numbers with troops assigned on them
		$rGetSlotNumberSpells = GetSlotNumber(True)

		SetLog("Troops To Remove: ", $COLOR_GREEN)
		$CounterToRemove = 0
		; Loop through Troops needed to get removed Just to write some Logs
		For $i = 0 To (UBound($toRemove) - 1)
			If IsSpellToBrew($toRemove[$i][0]) Then ExitLoop
			$CounterToRemove += 1
			SetLog("  " & NameOfTroop(Eval("e" & $toRemove[$i][0])) & ": " & $toRemove[$i][1] & "x", $COLOR_GREEN)
		Next

		If TotalSpellsToBrewInGUI() > 0 Then
			If $CounterToRemove <= UBound($toRemove) Then
				SetLog("Spells To Remove: ", $COLOR_GREEN)
				For $i = $CounterToRemove To (UBound($toRemove) - 1)
					SetLog("  " & NameOfTroop(Eval("e" & $toRemove[$i][0])) & ": " & $toRemove[$i][1] & "x", $COLOR_GREEN)
				Next
			EndIf
		EndIf

		If _ColorCheck(_GetPixelColor(675, 482, True), Hex(0xFFFFFF, 6), 30) = False Then ; If no 'Edit Army' Button found in army tab to edit troops
			SetLog("Cannot find/verify 'Edit Army' Button in Army tab", $COLOR_ORANGE)
			Return False ; Exit function
		EndIf

		Click(Random(680, 775, 1), Random(470, 515, 1)) ; Click on Edit Army Button

		; Loop through troops needed to get removed
		$CounterToRemove = 0
		For $j = 0 To (UBound($toRemove) - 1)
			If IsSpellToBrew($toRemove[$j][0]) Then ExitLoop
			$CounterToRemove += 1
			For $i = 0 To (UBound($rGetSlotNumber) - 1) ; Loop through All available slots
				; $toRemove[$j][0] = Troop name, E.g: Barb, $toRemove[$j][1] = Quantity to remove
				If $toRemove[$j][0] = $rGetSlotNumber[$i] Then ; If $toRemove Troop Was the same as The Slot Troop
					$pos = GetSlotRemoveBtnPosition($i + 1) ; Get positions of - Button to remove troop
					ClickRemoveTroop($pos, $toRemove[$j][1], $isldTrainITDelay) ; Click on Remove button as much as needed
				EndIf
			Next
		Next

		If TotalSpellsToBrewInGUI() > 0 Then
			For $j = $CounterToRemove To (UBound($toRemove) - 1)
				For $i = 0 To (UBound($rGetSlotNumberSpells) - 1) ; Loop through All available slots
					; $toRemove[$j][0] = Troop name, E.g: Barb, $toRemove[$j][1] = Quantity to remove
					If $toRemove[$j][0] = $rGetSlotNumberSpells[$i] Then ; If $toRemove Troop Was the same as The Slot Troop
						$pos = GetSlotRemoveBtnPosition($i + 1, True) ; Get positions of - Button to remove troop
						ClickRemoveTroop($pos, $toRemove[$j][1], $isldTrainITDelay) ; Click on Remove button as much as needed
					EndIf
				Next
			Next
		EndIf

		If _ColorCheck(_GetPixelColor(772, 510, True), Hex(0xFFFFFF, 6), 30) = False Then ; If no 'Okay' button found in army tab to save changes
			SetLog("Cannot find/verify 'Okay' Button in Army tab", $COLOR_ORANGE)
			ClickP($aAway, 2, 0, "#0346") ; Click Away, Necessary! due to possible errors/changes
			If _Sleep(400) Then OpenArmyWindow() ; Open Army Window AGAIN
			Return False ; Exit Function
		EndIf

		If _Sleep(700) Then Return
		If $Runstate = False Then Return
		Click(Random(730, 830, 1), Random(495, 525, 1)) ; Click on 'Okay' button to save changes

		If _Sleep(700) Then Return

		If _ColorCheck(_GetPixelColor(508, 428, True), Hex(0xFFFFFF, 6), 30) = False Then ; If no 'Okay' button found to verify that we accept the changes
			SetLog("Cannot find/verify 'Okay #2' Button in Army tab", $COLOR_ORANGE)
			ClickP($aAway, 2, 0, "#0346") ;Click Away
			Return False ; Exit function
		EndIf

		Click(Random(445, 585, 1), Random(400, 455, 1)) ; Click on 'Okay' button to Save changes... Last button

		SetLog("All Extra troops removed", $COLOR_GREEN)
		If _Sleep(200) Then Return
		If $ToReturn = 0 Then $ToReturn = 1
	Else ; If No extra troop found
		SetLog("No extra troop to remove, Great", $COLOR_GREEN)
		$ToReturn = 3
	EndIf
	Return $ToReturn
EndFunc   ;==>RemoveExtraTroops

Func RemoveExtraTroopsQueue() ; Will remove All Extra troops in queue If there's a Low Opacity red color on them
	;Local Const $DecreaseBy = 70
	;Local $x = 834
	If $IsFullArmywithHeroesAndSpells = True Then Return True

	Local Const $y = 187, $yRemoveBtn = 200, $xDecreaseRemoveBtn = 10
	Local $rColCheck = ""
	Local $Removed = False
	For $x = 834 To 58 Step -70
		If $Runstate = False Then Return
		$rColCheck = _ColorCheck(_GetPixelColor($x, $y, True), Hex(0xD7AFA9, 6), 20)
		If $rColCheck = True Then
			Do
				If _Sleep(20) Then Return
				Click($x - $xDecreaseRemoveBtn, $yRemoveBtn, 2, $isldTrainITDelay)
				$Removed = True
				$rColCheck = _ColorCheck(_GetPixelColor($x, $y, True), Hex(0xD7AFA9, 6), 20)
			Until $rColCheck = False
		ElseIf $rColCheck = False And $Removed Then
			ExitLoop
		EndIf
	Next
	Return True
EndFunc   ;==>RemoveExtraTroopsQueue

Func IsAlreadyTraining($Troop, $Spells = False)
	If $Runstate = False Then Return
	Select
		Case $Spells = False
			If IsQueueEmpty($TrainTroopsTAB) Then Return False ; If No troops were in Queue

			Local $QueueTroops = CheckQueueTroops(False, False) ; Get Troops that they're currently training...
			For $i = 0 To (UBound($QueueTroops) - 1)
				If $QueueTroops[$i] = $Troop Then Return True
			Next

			Return False
		Case $Spells = True
			If IsQueueEmpty($BrewSpellsTAB) Then Return False ; If No Spells were in Queue

			Local $QueueSpells = CheckQueueSpells(False, False) ; Get Troops that they're currently training...
			For $i = 0 To (UBound($QueueSpells) - 1)
				If $QueueSpells[$i] = $Troop Then Return True
			Next

			Return False
	EndSelect

EndFunc   ;==>IsAlreadyTraining

Func IsQueueEmpty($Tab = -1, $bSkipTabCheck = False)
	If $Runstate = False Then Return
	If $bSkipTabCheck = False Then
		If $Tab = -1 Then $Tab = $TrainTroopsTAB
		If ISArmyWindow(False, $Tab) = False Then OpenTrainTabNumber($Tab)
	EndIf

	If $IsFullArmywithHeroesAndSpells = False Then
		If _ColorCheck(_GetPixelColor(230, 208, True), Hex(0x677CB5, 6), 30) = False Then RemoveExtraTroopsQueue()
	EndIf

	If _ColorCheck(_GetPixelColor(230, 208, True), Hex(0x677CB5, 6), 30) Then Return True ; If No troops were in Queue Return True
	Return False
EndFunc   ;==>IsQueueEmpty

Func ClickRemoveTroop($pos, $iTimes, $iSpeed)
	$pos[0] = Random($pos[0] - 3, $pos[0] + 10, 1)
	$pos[1] = Random($pos[1] - 5, $pos[1] + 5, 1)
	If $Runstate = False Then Return
	If _Sleep(400) Then Return
	If $iTimes <> 1 Then
		If FastCaptureRegion() = True Then
			For $i = 0 To ($iTimes - 1)
				PureClick($pos[0], $pos[1], 1, $iSpeed) ;Click once.
				If _Sleep($iSpeed, False) Then ExitLoop
			Next
		Else
			PureClick($pos[0], $pos[1], $iTimes, $iSpeed) ;Click $iTimes.
			If _Sleep($iSpeed, False) Then Return
		EndIf
	Else
		PureClick($pos[0], $pos[1], 1, $iSpeed)

		If _Sleep($iSpeed, False) Then Return
	EndIf
EndFunc   ;==>ClickRemoveTroop

Func GetSlotRemoveBtnPosition($iSlot, $Spells = False)
	Local Const $aResult[2] = [Number((74 * $iSlot) - 4), IIf($Spells = False, 270, 417)]
	Return $aResult
EndFunc   ;==>GetSlotRemoveBtnPosition

Func GetSlotNumber($Spells = False)
	Select
		Case $Spells = False
			Local Const $Orders[19] = [$eBarb, $eArch, $eGiant, $eGobl, $eWall, $eBall, $eWiza, $eHeal, $eDrag, $ePekk, $eBabyD, $eMine, _
					$eMini, $eHogs, $eValk, $eGole, $eWitc, $eLava, $eBowl] ; Set Order of troop display in Army Tab

			Local $allCurTroops[UBound($Orders)]

			; Code for Elixir Troops to Put Current Troops into an array by Order
			For $i = 0 To (UBound($TroopName) - 1)
				If $Runstate = False Then Return
				If Number(Eval("Cur" & $TroopName[$i])) > 0 Then
					For $j = 0 To (UBound($Orders) - 1)
						If Eval("e" & $TroopName[$i]) = $Orders[$j] Then
							$allCurTroops[$j] = $TroopName[$i]
						EndIf
					Next
				EndIf
			Next

			#CS		This Codes Not Needed With New 'True' Train Order and new Training System ;)
			; Code for DARK Elixir Troops to Put Current Troops into an array by Order
			For $i = 0 To (UBound($TroopDarkName) - 1)
				If $Runstate = False Then Return
				If Number(Eval("Cur" & $TroopDarkName[$i])) > 0 Then
					For $j = 0 To (UBound($Orders) - 1)
						If Eval("e" & $TroopDarkName[$i]) = $Orders[$j] Then
							$allCurTroops[$j] = $TroopDarkName[$i]
						EndIf
					Next
				EndIf
			Next
			#CE

			_ArryRemoveBlanks($allCurTroops)

			Return $allCurTroops
		Case $Spells = True

			; Set Order of Spells display in Army Tab
			Local Const $SpellsOrders[10] = [$eLSpell, $eHSpell, $eRSpell, $eJSpell, $eFSpell, $eCSpell, $ePSpell, $eESpell, $eHaSpell, $eSkSpell]

			Local $allCurSpells[UBound($SpellsOrders)]

			; Code for Spells to Put Current Spells into an array by Order
			For $i = 0 To (UBound($SpellName) - 1)
				If $Runstate = False Then Return
				If Number(Eval("Cur" & $SpellName[$i])) > 0 Then
					For $j = 0 To (UBound($SpellsOrders) - 1)
						If Eval("e" & $SpellName[$i]) = $SpellsOrders[$j] Then
							$allCurSpells[$j] = $SpellName[$i]
						EndIf
					Next
				EndIf
			Next

			_ArryRemoveBlanks($allCurSpells)

			Return $allCurSpells
	EndSelect
EndFunc   ;==>GetSlotNumber

Func WhatToTrain($ReturnExtraTroopsOnly = False, $showlog = True)
	If ISArmyWindow(False, $ArmyTAB) = False Then OpenTrainTabNumber($ArmyTAB)
	Local $ToReturn[1][2] = [["Arch", 0]]

	If $IsFullArmywithHeroesAndSpells Then
		If $CommandStop = 3 Or $CommandStop = 0 Then
			If $FirstStart Then $FirstStart = False
			Return $ToReturn
		EndIf
		Setlog(" » Your Army is Full, let's make troops before Attack!")
		; Elixir Troops
		For $i = 0 To (UBound($TroopName) - 1)
			If Number(Eval($TroopName[$i] & "Comp")) > 0 Then
				$ToReturn[UBound($ToReturn) - 1][0] = $TroopName[$i]
				$ToReturn[UBound($ToReturn) - 1][1] = Number(Eval($TroopName[$i] & "Comp"))
				ReDim $ToReturn[UBound($ToReturn) + 1][2]
			EndIf
		Next
		#CS		This Codes Not Needed With New 'True' Train Order and new Training System ;)
		; Dark Troops
		For $i = 0 To (UBound($TroopDarkName) - 1)
			If Number(Eval($TroopDarkName[$i] & "Comp")) > 0 Then
				$ToReturn[UBound($ToReturn) - 1][0] = $TroopDarkName[$i]
				$ToReturn[UBound($ToReturn) - 1][1] = Number(Eval($TroopDarkName[$i] & "Comp"))
				ReDim $ToReturn[UBound($ToReturn) + 1][2]
			EndIf
		Next
		#CE
		; Spells
		For $i = 0 To (UBound($SpellName) - 1)
			If $Runstate = False Then Return
			If TotalSpellsToBrewInGUI() = 0 Then ExitLoop
			If Number(Eval($SpellName[$i] & "Comp")) > 0 Then
				If HowManyTimesWillBeUsed($SpellName[$i]) > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $SpellName[$i]
					$ToReturn[UBound($ToReturn) - 1][1] = Number(Eval($SpellName[$i] & "Comp"))
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				Else
					CheckExistentArmy("Spells", False)
					If Number(Number(Eval($SpellName[$i] & "Comp")) - Number(Eval("Cur" & $SpellName[$i]))) > 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $SpellName[$i]
						$ToReturn[UBound($ToReturn) - 1][1] = Number(Number(Eval($SpellName[$i] & "Comp")) - Number(Eval("Cur" & $SpellName[$i])))
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					Else
						$ToReturn[UBound($ToReturn) - 1][0] = $SpellName[$i]
						$ToReturn[UBound($ToReturn) - 1][1] = 9999
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					EndIf
				EndIf
			EndIf
		Next
		Return $ToReturn
	EndIf

	; Get Current available troops
	CheckExistentArmy("Troops", $showlog)
	CheckExistentArmy("Spells", $showlog)

	Switch $ReturnExtraTroopsOnly
		Case False
			; Check Elixir Troops needed quantity to Train
			For $i = 0 To (UBound($TroopName) - 1)
				If $Runstate = False Then Return
				If Number(Eval($TroopName[$i] & "Comp")) > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $TroopName[$i]
					$ToReturn[UBound($ToReturn) - 1][1] = Number(Number(Eval($TroopName[$i] & "Comp")) - Number(Eval("Cur" & $TroopName[$i])))
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			Next

			#CS		This Codes Not Needed With New 'True' Train Order and new Training System ;)
			; Check DARK Elixir Troops needed quantity to Train
			For $i = 0 To (UBound($TroopDarkName) - 1)
				If $Runstate = False Then Return
				If Number(Eval($TroopDarkName[$i] & "Comp")) > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $TroopDarkName[$i]
					$ToReturn[UBound($ToReturn) - 1][1] = Number(Number(Eval($TroopDarkName[$i] & "Comp")) - Number(Eval("Cur" & $TroopDarkName[$i])))
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			Next
			#CE

			; Check Spells needed quantity to Brew
			For $i = 0 To (UBound($SpellName) - 1)
				If $Runstate = False Then Return
				If TotalSpellsToBrewInGUI() = 0 Then ExitLoop
				If Number(Eval($SpellName[$i] & "Comp")) > 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $SpellName[$i]
					$ToReturn[UBound($ToReturn) - 1][1] = Number(Number(Eval($SpellName[$i] & "Comp")) - Number(Eval("Cur" & $SpellName[$i])))
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			Next
		Case Else
			; Check Elixir Troops Extra Quantity
			For $i = 0 To (UBound($TroopName) - 1)
				If $Runstate = False Then Return
				If Number(Eval("Cur" & $TroopName[$i])) > 0 Then
					If StringInStr(Number(Number(Eval($TroopName[$i] & "Comp")) - Number(Eval("Cur" & $TroopName[$i]))), "-") > 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $TroopName[$i]
						$ToReturn[UBound($ToReturn) - 1][1] = StringReplace(Number(Number(Eval($TroopName[$i] & "Comp")) - Number(Eval("Cur" & $TroopName[$i]))), "-", "")
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					EndIf
				EndIf
			Next

			#CS		This Codes Not Needed With New 'True' Train Order and new Training System ;)
			; Check DARK Elixir Troops Extra Quantity
			For $i = 0 To (UBound($TroopDarkName) - 1)
				If $Runstate = False Then Return
				If Number(Eval("Cur" & $TroopDarkName[$i])) > 0 Then
					If StringInStr(Number(Number(Eval($TroopDarkName[$i] & "Comp")) - Number(Eval("Cur" & $TroopDarkName[$i]))), "-") > 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $TroopDarkName[$i]
						$ToReturn[UBound($ToReturn) - 1][1] = StringReplace(Number(Number(Eval($TroopDarkName[$i] & "Comp")) - Number(Eval("Cur" & $TroopDarkName[$i]))), "-", "")
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					EndIf
				EndIf
			Next
			#CE

			; Check Spells Extra Quantity
			For $i = 0 To (UBound($SpellName) - 1)
				If $Runstate = False Then Return
				If TotalSpellsToBrewInGUI() = 0 Then ExitLoop
				If Number(Eval("Cur" & $SpellName[$i])) > 0 Then
					If StringInStr(Number(Number(Eval($SpellName[$i] & "Comp")) - Number(Eval("Cur" & $SpellName[$i]))), "-") > 0 Then
						$ToReturn[UBound($ToReturn) - 1][0] = $SpellName[$i]
						$ToReturn[UBound($ToReturn) - 1][1] = StringReplace(Number(Number(Eval($SpellName[$i] & "Comp")) - Number(Eval("Cur" & $SpellName[$i]))), "-", "")
						ReDim $ToReturn[UBound($ToReturn) + 1][2]
					EndIf
				EndIf
			Next
	EndSwitch
	_ArrayDelete($ToReturn, UBound($ToReturn) - 1)
	Return $ToReturn
EndFunc   ;==>WhatToTrain

Func TestTroopsCoords()
	#CS
		For $i = 0 To UBound($TroopName) - 1
		TrainIt(Eval("e" & $TroopName[$i]), 1, $isldTrainITDelay)
		Next
		ClickDrag(616, 445 + $midOffsetY, 400, 445 + $midOffsetY, 2000)
		If _Sleep(1500) Then Return
		For $i = 0 To UBound($TroopDarkName) - 1
		TrainIt(Eval("e" & $TroopDarkName[$i]), 1, $isldTrainITDelay)
		Next
	#CE
	TrainIt($eDrag, 1, 300)
	TrainIt($eBarb, 1, 300)
	TrainIt($eArch, 1, 300)
	TrainIt($eGiant, 1, 300)
	TrainIt($eGobl, 1, 300)
	TrainIt($eWall, 1, 300)
	TrainIt($eBall, 1, 300)
	TrainIt($eWiza, 1, 300)
	TrainIt($eHeal, 1, 300)
	TrainIt($eDrag, 1, 300)
	TrainIt($ePekk, 1, 300)
	TrainIt($eBabyD, 1, 300)
	TrainIt($eMine, 1, 300)
	If _Sleep(1000) Then Return
	ClickDrag(616, 445 + $midOffsetY, 400, 445 + $midOffsetY, 2000)
	If _Sleep(1500) Then Return
	TrainIt($eMini, 1, 300)
	TrainIt($eHogs, 1, 300)
	TrainIt($eValk, 1, 300)
	TrainIt($eGole, 1, 300)
	TrainIt($eWitc, 1, 300)
	TrainIt($eLava, 1, 300)
	TrainIt($eBowl, 1, 300)
EndFunc   ;==>TestTroopsCoords

Func LeftSpace($ReturnAll = False)
	; Need to be in 'Train Tab'
	$RemainTrainSpace = GetOCRCurrent(45, 159)
	If $Runstate = False Then Return
	;_ArrayDisplay($RemainTrainSpace, "$RemainTrainSpace")
	If $ReturnAll = False Then
		Return Number($RemainTrainSpace[2])
	Else
		Return $RemainTrainSpace
	EndIf
EndFunc   ;==>LeftSpace

Func OpenArmyWindow()

	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If $Runstate = False Then Return
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
		If $Runstate = False Then Return
		If _CheckPixel($_aIsTrainPgChk1, True) And _CheckPixel($_aIsTrainPgChk2, True) And _CheckPixel($CheckIT, True) Then ExitLoop
		If _Sleep($iDelayIsTrainPage1) Then ExitLoop
		$i += 1
	WEnd

	If $i <= 28 Then
		If ($DebugSetlog = 1 Or $DebugClick = 1) And $writelogs = True Then Setlog("**Train Window OK**", $COLOR_DEBUG) ;Debug
		Return True
	Else
		If $writelogs = True Then SetLog("Cannot find train Window | TAB " & $TabNumber, $COLOR_RED) ; in case of $i = 29 in while loop
		If $debugImageSave = 1 Then DebugImageSave("IsTrainPage_")
		Return False
	EndIf

EndFunc   ;==>ISArmyWindow

Func CheckExistentArmy($txt = "", $showlog = True)

	If ISArmyWindow(True, $ArmyTAB) = False Then
		OpenArmyWindow()
		If _Sleep(1500) Then Return
	EndIf

	;$iHeroAvailable = $HERO_NOHERO ; Reset hero available data

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
			If $Runstate = False Then Return
			Local $Plural = 0
			If $result[$i][0] <> "" Then
				If $result[$i][3] > 1 Then $Plural = 1
				If StringInStr($result[$i][0], "queued") Then
					$result[$i][0] = StringTrimRight($result[$i][0], 6)
					;[&i][0] = Troops name | [&i][1] = X coordinate | [&i][2] = Y coordinate | [&i][3] = Quantities
					If $txt = "Troops" Then
						If $showlog = True Then Setlog(" - " & $result[$i][3] & " " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Queued", $COLOR_BLUE)
						Assign("Cur" & $result[$i][0], Eval("Cur" & $result[$i][0]) + $result[$i][3])
					EndIf
					If $txt = "Spells" Then
						If $result[$i][3] = 0 Then
							If $showlog = True Then SetLog(" - No Spells are Brewed", $COLOR_BLUE)
						Else
							If $showlog = True Then Setlog(" - " & $result[$i][3] & " " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Brewed", $COLOR_BLUE)
							Assign("Cur" & $result[$i][0], Eval("Cur" & $result[$i][0]) + $result[$i][3])
						EndIf
					EndIf
					If $txt = "Heroes" Then
						If ArmyHeroStatus(Eval("e" & $result[$i][0])) = "heal" Then Setlog(" » " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Recovering, Remain of " & $result[$i][3], $COLOR_BLUE)
					EndIf
				Else
					If $txt = "Heroes" Then
						If $showlog = True Then Setlog(" - " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Recovered", $COLOR_GREEN)
					ElseIf $txt = "Troops" Then
						ResetDropTrophiesVariable()
						If $showlog = True Then Setlog(" - " & $result[$i][3] & " " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Available", $COLOR_GREEN)
						Assign("Cur" & $result[$i][0], Eval("Cur" & $result[$i][0]) + $result[$i][3])
						CanBeUsedToDropTrophies(Eval("e" & $result[$i][0]), Eval("Cur" & $result[$i][0]))
					Else
						If $result[$i][3] = 0 Then
							If $showlog = True Then SetLog(" - No Spells are Brewed", $COLOR_GREEN)
						Else
							If $showlog = True Then Setlog(" - " & $result[$i][3] & " " & NameOfTroop(Eval("e" & $result[$i][0]), $Plural) & " Brewed", $COLOR_GREEN)
							Assign("Cur" & $result[$i][0], Eval("Cur" & $result[$i][0]) + $result[$i][3])
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	EndIf

	If $txt = "Spells" Then
		CountNumberDarkSpells()
	EndIf

EndFunc   ;==>CheckExistentArmy

Func CanBeUsedToDropTrophies($eTroop, $Quantity)
	;SetLog("CanBeUsedToDrop|$eTroop = " & $eTroop & @CRLF & "Quantity = " & $Quantity)
	If $eTroop = $eBarb Then
		$aDTtroopsToBeUsed[0][1] = $Quantity

	ElseIf $eTroop = $eArch Then
		$aDTtroopsToBeUsed[1][1] = $Quantity

	ElseIf $eTroop = $eGiant Then
		$aDTtroopsToBeUsed[2][1] = $Quantity

	ElseIf $eTroop = $eGobl Then
		$aDTtroopsToBeUsed[4][1] = $Quantity

	ElseIf $eTroop = $eWall Then
		$aDTtroopsToBeUsed[3][1] = $Quantity

	ElseIf $eTroop = $eMini Then
		$aDTtroopsToBeUsed[5][1] = $Quantity
	EndIf

EndFunc   ;==>CanBeUsedToDropTrophies

Func ResetDropTrophiesVariable()
	For $i = 0 To (UBound($aDTtroopsToBeUsed, 1) - 1) ; Reset the variables
		$aDTtroopsToBeUsed[$i][1] = 0
	Next
EndFunc   ;==>ResetDropTrophiesVariable

Func CheckQueueTroops($getQuantity = True, $showlog = True)
	Local $res[1] = [""]
	;$hTimer = TimerInit()
	If $showlog Then SetLog("Checking Troops Queue...", $COLOR_BLUE)
	Local $directory = @ScriptDir & "\images\Resources\TrainTroops"
	Local $result = SearchArmy($directory, 18, 182, 839, 261)
	ReDim $res[UBound($result)]
	;SetLog("btnGrayCheckc Done Within " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds.", $COLOR_BLUE)
	For $i = 0 To (UBound($result) - 1)
		If $Runstate = False Then Return
		$res[$i] = $result[$i][0]
	Next
	_ArrayReverse($res)
	If $getQuantity Then
		Local $Quantities = GetQueueQuantity($res)
		If $showlog Then
			For $i = 0 To (UBound($Quantities) - 1)
				SetLog("  - " & NameOfTroop(Eval("e" & $Quantities[$i][0])) & ": " & $Quantities[$i][1] & "x", $COLOR_GREEN)
			Next
		EndIf
	EndIf
	;_ArrayDisplay($Quantities)
	Return $res
EndFunc   ;==>CheckQueueTroops

Func CheckQueueSpells($getQuantity = True, $showlog = True)
	Local $res[1] = [""]
	;$hTimer = TimerInit()
	If $showlog Then SetLog("Checking Spells Queue...", $COLOR_BLUE)
	Local $directory = @ScriptDir & "\images\Resources\SpellsInQueue"
	Local $result = SearchArmy($directory, 18, 182, 839, 261)
	ReDim $res[UBound($result)]
	;SetLog("btnGrayCheckc Done Within " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds.", $COLOR_BLUE)
	For $i = 0 To (UBound($result) - 1)
		If $Runstate = False Then Return
		$res[$i] = $result[$i][0]
	Next
	_ArrayReverse($res)
	If $getQuantity Then
		Local $Quantities = GetQueueQuantity($res)
		If $showlog Then
			For $i = 0 To (UBound($Quantities) - 1)
				If $Runstate = False Then Return
				SetLog("  - " & NameOfTroop(Eval("e" & $Quantities[$i][0])) & ": " & $Quantities[$i][1] & "x", $COLOR_GREEN)
			Next
		EndIf
	EndIf
	;_ArrayDisplay($Quantities)
	Return $res
EndFunc   ;==>CheckQueueSpells

Func GetQueueQuantity($AvailableTroops)
	If IsArray($AvailableTroops) Then
		If $AvailableTroops[0] = "" Or StringLen($AvailableTroops[0]) = 0 Then _ArrayDelete($AvailableTroops, 0)
		If $AvailableTroops[UBound($AvailableTroops) - 1] = "" Or StringLen($AvailableTroops[UBound($AvailableTroops) - 1]) = 0 Then _ArrayDelete($AvailableTroops, Number(UBound($AvailableTroops) - 1))
		;$hTimer = TimerInit()
		Local $result[UBound($AvailableTroops)][2] = [["", 0]]
		Local $x = 770, $y = 189
		_CaptureRegion2()
		For $i = 0 To (UBound($AvailableTroops) - 1)
			If $Runstate = False Then Return
			$OCRResult = getQueueTroopsQuantity($x, $y)
			$result[$i][0] = $AvailableTroops[$i]
			$result[$i][1] = $OCRResult
			; At end, update Coords to next troop
			$x -= 70
		Next
		;SetLog("GetQueueQuantity Done Within " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds at #" & $i & " Loop.", $COLOR_BLUE)
		Return $result
	EndIf
	Return False
EndFunc   ;==>GetQueueQuantity

Func SearchArmy($directory = "", $x = 0, $y = 0, $x1 = 0, $y1 = 0, $txt = "", $skipReceivedTroopsCheck = False)
	; Setup arrays, including default return values for $return
	Local $aResult[1][4], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue
	Local $Redlines = "FV"
	; Capture the screen for comparison

	For $waiting = 0 To 10
		If $Runstate = False Then Return
		If getReceivedTroops(162, 200, $skipReceivedTroopsCheck) = False Then
			; Perform the search
			_CaptureRegion2($x, $y, $x1, $y1)
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
						$aCoordArray[0][0] = $aCoordsSplit[0] + $x ; X coord.
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
			ExitLoop
		Else
			If $waiting = 1 Then Setlog("You have received castle troops! Wait 5's...")
			If _Sleep($iDelayTrain8) Then Return
		EndIf
	Next

	_ArraySort($aResult, 0, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i

	If $txt = "Troops" Then
		For $i = 0 To UBound($aResult) - 1
			$aResult[$i][3] = Number(getBarracksNewTroopQuantity(Slot($aResult[$i][1], "troop"), 196)) ; coc-newarmy
		Next
	EndIf
	If $txt = "Spells" Then
		For $i = 0 To UBound($aResult) - 1
			$aResult[$i][3] = Number(getBarracksNewTroopQuantity(Slot($aResult[$i][1], "spells"), 341)) ; coc-newarmy
			;Setlog("$aResult: " & $aResult[$i][0] & "|" & $aResult[$i][1] & "|" & $aResult[$i][2] & "|" & $aResult[$i][3])
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
			If $Runstate = False Then Return
			Assign("Cur" & $TroopName[$i], 0)
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
		Next
		For $i = 0 To UBound($TroopDarkName) - 1
			If $Runstate = False Then Return
			Assign("Cur" & $TroopDarkName[$i], 0)
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
		Next
	EndIf
	If $txt = "Spells" Or $txt = "all" Then
		For $i = 0 To UBound($SpellName) - 1
			If $Runstate = False Then Return
			Assign("Cur" & $SpellName[$i], 0)
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
		Next
	EndIf
	If $txt = "donated" Or $txt = "all" Then
		For $i = 0 To UBound($TroopName) - 1
			If $Runstate = False Then Return
			Assign("Don" & $TroopName[$i], 0)
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
		Next
		For $i = 0 To UBound($TroopDarkName) - 1
			Assign("Don" & $TroopDarkName[$i], 0)
			If $Runstate = False Then Return
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
	If $Runstate = False Then Return

	If IsTrainPage() Then
		Click($TabNumber[$Num][0], $TabNumber[$Num][1], 2, 200)
		If _Sleep(1500) Then Return
		If ISArmyWindow(False, $Num) Then Setlog(" » Opened the " & $Message[$Num], $COLOR_ACTION1)
	Else
		Setlog(" » Error Clicking On " & ($Num >= 0 And $Num < UBound($Message)) ? ($Message[$Num]) : ("Not selectable") & " Tab!!!", $COLOR_RED)
	EndIf
EndFunc   ;==>OpenTrainTabNumber

Func TrainArmyNumber($Num)

	$Num = $Num - 1
	Local $a_TrainArmy[3][4] = [[817, 366, 0x6bb720, 10], [817, 484, 0x6bb720, 10], [817, 601, 0x6bb720, 10]]
	Setlog(" » TrainArmyNumber: " & $Num + 1)
	If $Runstate = False Then Return

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

	If ISArmyWindow(True, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB)
	If _Sleep(1500) Then Return
	If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return

	SetLog(" »» Delete Troops Queued ", $COLOR_ACTION)
	If _Sleep(500) Then Return
	Local $x = 0
	While _ColorCheck(_GetPixelColor(802, 220, True), Hex(0Xbac8a5, 6), 10) = False
		If _Sleep(20) Then Return
		If $Runstate = False Then Return
		Click(826, 202, 2, 50)
		$x += 1
		If $x = 250 Then ExitLoop
	WEnd

EndFunc   ;==>DeleteTroopsQueued
;IF your current spells don't match with the spells to train will delete them
Func DeleteSpellsQueued()

	OpenTrainTabNumber($BrewSpellsTAB)
	If _Sleep(1500) Then Return
	If ISArmyWindow(True, $BrewSpellsTAB) = False Then Return

	SetLog(" »» Delete Spells Queued ", $COLOR_ACTION)
	If _Sleep(500) Then Return
	Local $x = 0
	While _ColorCheck(_GetPixelColor(802, 220, True), Hex(0Xbac8a5, 6), 10) = False
		If _Sleep(20) Then Return
		If $Runstate = False Then Return
		Click(826, 202, 2, 100)
		$x += 1
		If $x = 250 Then ExitLoop
	WEnd

EndFunc   ;==>DeleteSpellsQueued

Func Slot($x = 0, $txt = "")

	If $Runstate = False Then Return
	Switch $x
		Case $x < 94
			If $txt = "troop" Then Return 35
			If $txt = "spells" Then Return 40
		Case $x > 94 And $x < 171
			If $txt = "troop" Then Return 111
			If $txt = "spells" Then Return 120
		Case $x > 171 And $x < 244
			If $txt = "troop" Then Return 184
			If $txt = "spells" Then Return 195
		Case $x > 244 And $x < 308
			If $txt = "troop" Then Return 255
			If $txt = "spells" Then Return 272
		Case $x > 308 And $x < 393
			If $txt = "troop" Then Return 330
			If $txt = "spells" Then Return 341
		Case $x > 393 And $x < 465
			If $txt = "troop" Then Return 403
			If $txt = "spells" Then Return 415
		Case $x > 465 And $x < 538
			If $txt = "troop" Then Return 477
			If $txt = "spells" Then Return 485
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
		If $Runstate = False Then Return
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
		If $Runstate = False Then Return
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
	; notes $MergedTroopGroup[19][5]
	; notes $MergedTroopGroup[19][0] = $TroopName | [1] = $TroopNamePosition | [2] = $TroopHeight | [3] = qty | [4] = marker for DarkTroop or ElixerTroop]
	; notes ClickDrag(616, 445 + $midOffsetY, 400, 445 + $midOffsetY, 2000) ; Click drag for dark Troops
	; notes	ClickDrag(400, 445 + $midOffsetY, 616, 445 + $midOffsetY, 2000) ; Click drag for Elixer Troops
	; notes $RemainTrainSpace[0] = Current Army  | [1] = Total Army Capacity  | [2] = Remain Space for the current Army



	Local $RemainTrainSpace
	Local $Plural = 0
	Local $areThereDonTroop = 0
	Local $areThereDonSpell = 0

	For $j = 0 To UBound($TroopName) - 1
		If $Runstate = False Then Return
		$areThereDonTroop += Eval("Don" & $TroopName[$j])
	Next
	For $j = 0 To UBound($TroopDarkName) - 1
		If $Runstate = False Then Return
		$areThereDonTroop += Eval("Don" & $TroopDarkName[$j])
	Next

	For $j = 0 To UBound($SpellName) - 1
		If $Runstate = False Then Return
		$areThereDonSpell += Eval("Don" & $SpellName[$j])
	Next
	If $areThereDonSpell = 0 And $areThereDonTroop = 0 Then Return

	SetLog(" » making donated troops", $COLOR_ACTION1)
	If $areThereDonTroop > 0 Then
		; Load Eval("Don" & $TroopName[$i]) Values into $MergedTroopGroup[19][5]
		For $i = 0 To UBound($MergedTroopGroup, 1) - 1
			For $j = 0 To UBound($TroopName) - 1
				If $TroopName[$j] = $MergedTroopGroup[$i][0] Then
					$MergedTroopGroup[$i][3] = Eval("Don" & $TroopName[$j])
				EndIf
			Next
			For $j = 0 To UBound($TroopDarkName) - 1
				If $TroopDarkName[$j] = $MergedTroopGroup[$i][0] Then
					$MergedTroopGroup[$i][3] = Eval("Don" & $TroopDarkName[$j])
				EndIf
			Next
		Next

		; Zero Eval("Don" & $Troop/Dark/Name[$i]) Values
		For $j = 0 To UBound($TroopName) - 1
			Assign("Don" & $TroopName[$j], 0)
		Next
		For $j = 0 To UBound($TroopDarkName) - 1
			Assign("Don" & $TroopDarkName[$j], 0)
		Next

		If IsTrainPage() And ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB)
		If _Sleep(1500) Then Return
		If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return

		For $i = 0 To UBound($MergedTroopGroup, 1) - 1
			If $Runstate = False Then Return
			$Plural = 0
			If $MergedTroopGroup[$i][3] > 0 Then
				$RemainTrainSpace = GetOCRCurrent(48, 161)
				If $RemainTrainSpace[0] = $RemainTrainSpace[1] Then ; army camps full
					;Camps Full All Donate Counters should be zero!!!!
					For $j = 0 To UBound($MergedTroopGroup, 1) - 1
						$MergedTroopGroup[$j][3] = 0
					Next
					ExitLoop
				EndIf

				If $MergedTroopGroup[$i][2] * $MergedTroopGroup[$i][3] <= $RemainTrainSpace[2] Then ; Troopheight x donate troop qty <= avaible train space
					Local $pos = GetTrainPos(Eval("e" & $MergedTroopGroup[$i][0]))
					Local $howMuch = $MergedTroopGroup[$i][3]
					If $MergedTroopGroup[$i][4] = "e" Then
						;TrainIt(Eval("e" & $MergedTroopGroup[$i][0]), $howMuch, $isldTrainITDelay)
						PureClick($pos[0], $pos[1], $howMuch, 500)

					Else
						ClickDrag(616, 445 + $midOffsetY, 400, 445 + $midOffsetY, 2000) ; Click drag for dark Troops
						;TrainIt(Eval("e" & $MergedTroopGroup[$i][0]), $howMuch, $isldTrainITDelay)
						PureClick($pos[0], $pos[1], $howMuch, 500)
						ClickDrag(400, 445 + $midOffsetY, 616, 445 + $midOffsetY, 2000) ; Click drag for Elixer Troops
					EndIf
					If $MergedTroopGroup[$i][3] > 1 Then $Plural = 1
					Setlog(" » Trained " & $MergedTroopGroup[$i][3] & " " & NameOfTroop(Eval("e" & $MergedTroopGroup[$i][0]), $Plural), $COLOR_ACTION)
					$MergedTroopGroup[$i][3] = 0
					If _Sleep(1000) Then Return ; Needed Delay, OCR was not picking up Troop Changes
				Else
					For $z = 0 To $RemainTrainSpace[2] - 1
						$RemainTrainSpace = GetOCRCurrent(48, 161)
						If $RemainTrainSpace[0] = $RemainTrainSpace[1] Then ; army camps full
							;Camps Full All Donate Counters should be zero!!!!
							For $j = 0 To UBound($MergedTroopGroup, 1) - 1
								$MergedTroopGroup[$j][3] = 0
							Next
							ExitLoop (2) ;
						EndIf
						If $MergedTroopGroup[$i][2] <= $RemainTrainSpace[2] And $MergedTroopGroup[$i][3] > 0 Then
							;TrainIt(Eval("e" & $TroopName[$i]), 1, $isldTrainITDelay)
							Local $pos = GetTrainPos(Eval("e" & $MergedTroopGroup[$i][0]))
							Local $howMuch = 1
							If $MergedTroopGroup[$i][4] = "e" Then
								;TrainIt(Eval("e" & $MergedTroopGroup[$i][0]), 1, $isldTrainITDelay)
								PureClick($pos[0], $pos[1], $howMuch, 500)
							Else
								ClickDrag(616, 445 + $midOffsetY, 400, 445 + $midOffsetY, 2000) ; Click drag for dark Troops
								;TrainIt(Eval("e" & $MergedTroopGroup[$i][0]), 1, $isldTrainITDelay)
								PureClick($pos[0], $pos[1], $howMuch, 500)
								ClickDrag(400, 445 + $midOffsetY, 616, 445 + $midOffsetY, 2000) ; Click drag for Elixer Troops
							EndIf
							If $MergedTroopGroup[$i][3] > 1 Then $Plural = 1
							Setlog(" » Trained " & $MergedTroopGroup[$i][3] & " " & NameOfTroop(Eval("e" & $MergedTroopGroup[$i][0]), $Plural), $COLOR_ACTION)
							$MergedTroopGroup[$i][3] -= 1
							If _Sleep(1000) Then Return ; Needed Delay, OCR was not picking up Troop Changes
						Else
							ExitLoop
						EndIf
					Next
				EndIf
			EndIf
		Next
		;Top Off any remianing space with archers
		$RemainTrainSpace = GetOCRCurrent(48, 161)
		If $RemainTrainSpace[0] < $RemainTrainSpace[1] Then ; army camps full
			Local $howMuch = $RemainTrainSpace[2]
			;TrainIt(Eval($eArch), 1, $isldTrainITDelay)
			PureClick($TrainArch[0], $TrainArch[1], $howMuch, 500)
			If $RemainTrainSpace[2] > 0 Then $Plural = 1
			Setlog("Trained " & $howMuch & " archer(s)!", $COLOR_ACTION)
			If _Sleep(1000) Then Return ; Needed Delay, OCR was not picking up Troop Changes
		EndIf
		; Ensure all donate values are reset to zero
		For $j = 0 To UBound($MergedTroopGroup, 1) - 1
			$MergedTroopGroup[$j][3] = 0
		Next
	EndIf

	If $areThereDonSpell > 0 Then
		;Train Donated Spells
		If IsTrainPage() And ISArmyWindow(False, 2) = False Then OpenTrainTabNumber(2)
		If _Sleep(1500) Then Return
		If ISArmyWindow(True, 2) = False Then Return

		For $i = 0 To UBound($SpellName) - 1
			If $Runstate = False Then Return
			If Eval("Don" & $SpellName[$i]) > 0 Then
				$Plural = 0
				Local $pos = GetTrainPos(Eval("e" & $SpellName[$i]))
				Local $howMuch = Eval("Don" & $SpellName[$i])
				If $howMuch > 1 Then $Plural = 1
				PureClick($pos[0], $pos[1], $howMuch, 500)
				Setlog(" » Brewed " & $howMuch & " " & NameOfTroop(Eval("e" & $SpellName[$i]), $Plural), $COLOR_ACTION)
				Assign("Don" & $SpellName[$i], Eval("Don" & $SpellName[$i]) - $howMuch)
			EndIf
		Next
	EndIf
	If _Sleep(1000) Then Return
	$RemainTrainSpace = GetOCRCurrent(48, 161)
	Setlog(" » Current Capacity: " & $RemainTrainSpace[0] & "/" & ($RemainTrainSpace[1]))
EndFunc   ;==>MakingDonatedTroops

Func GetOCRCurrent($x_start, $y_start)

	Local $FinalResult[3] = [0, 0, 0]
	If $Runstate = False Then Return $FinalResult

	; [0] = Current Army  | [1] = Total Army Capacity  | [2] = Remain Space for the current Army
	Local $result = getArmyCapacityOnTrainTroops($x_start, $y_start)

	If StringInStr($result, "#") Then
		Local $resultSplit = StringSplit($result, "#", $STR_NOCOUNT)
		$FinalResult[0] = Number($resultSplit[0])
		$FinalResult[1] = Number($resultSplit[1])
		$FinalResult[2] = $FinalResult[1] - $FinalResult[0]
	Else
		Setlog("DEBUG | ERROR on GetOCRCurrent", $COLOR_RED)
	EndIf

	Return $FinalResult

EndFunc   ;==>GetOCRCurrent

Func CheckIsFullQueuedAndNotFullArmy()

	SetLog(" » Checking: FULL Queue and Not Full Army", $COLOR_ACTION1)
	Local $CheckTroop[4] = [824, 243, 0x949522, 20] ; the green check symbol [bottom right] at slot 0 troop
	If $Runstate = False Then Return

	If IsTrainPage() And ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB)
	If _Sleep(1500) Then Return
	If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return

	Local $ArmyCamp = GetOCRCurrent(48, 161)

	If UBound($ArmyCamp) = 3 And $ArmyCamp[2] < 0 Then
		If _ColorCheck(_GetPixelColor($CheckTroop[0], $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) Then
			SetLog(" » Conditions met: FULL Queue and Not Full Army")
			DeleteTroopsQueued()
			If _Sleep(500) Then Return
			$ArmyCamp = GetOCRCurrent(48, 161)
			Local $ArchToMake = $ArmyCamp[2]
			If ISArmyWindow(False, $TrainTroopsTAB) Then PureClick($TrainArch[0], $TrainArch[1], $ArchToMake, 500)
			Setlog("Trained " & $ArchToMake & " archer(s)!")
		Else
			SetLog(" » Conditions NOT met: FULL queue and Not Full Army")
		EndIf
	EndIf

EndFunc   ;==>CheckIsFullQueuedAndNotFullArmy

Func CheckIsEmptyQueuedAndNotFullArmy()

	SetLog(" » Checking: Empty Queue and Not Full Army", $COLOR_ACTION1)
	Local $CheckTroop[4] = [820, 220, 0xCFCFC8, 15] ; the gray background at slot 0 troop
	Local $CheckTroop1[4] = [390, 130, 0x78BE2B, 15] ; the Green Arrow on Troop Training tab
	If $Runstate = False Then Return

	If IsTrainPage() And ISArmyWindow(False, $TrainTroopsTAB) = False Then OpenTrainTabNumber($TrainTroopsTAB)
	If _Sleep(1500) Then Return
	If ISArmyWindow(True, $TrainTroopsTAB) = False Then Return

	Local $ArmyCamp = GetOCRCurrent(48, 161)

	If UBound($ArmyCamp) = 3 And $ArmyCamp[2] > 0 Then
		If _ColorCheck(_GetPixelColor($CheckTroop[0], $CheckTroop[1], True), Hex($CheckTroop[2], 6), $CheckTroop[3]) Then
			If Not _ColorCheck(_GetPixelColor($CheckTroop1[0], $CheckTroop1[1], True), Hex($CheckTroop1[2], 6), $CheckTroop1[3]) Then
				SetLog(" » Conditions met: Empty Queue and Not Full Army")
				If _Sleep(500) Then Return
				$ArmyCamp = GetOCRCurrent(48, 161)
				Local $ArchToMake = $ArmyCamp[2]
				If ISArmyWindow(False, $TrainTroopsTAB) Then PureClick($TrainArch[0], $TrainArch[1], $ArchToMake, 500)
				SetLog(" » Trained " & $ArchToMake & " archer(s)!")
			Else
				SetLog(" » Conditions NOT met: Empty queue and Not Full Army")
			EndIf
		EndIf
	EndIf
EndFunc   ;==>CheckIsEmptyQueuedAndNotFullArmy

Func AttackBarCheck()

	Local $x = 0, $y = 659, $x1 = 853, $y1 = 698
	; Setup arrays, including default return values for $return
	Local $aResult[1][5], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue
	Local $Redlines = "FV"
	Local $directory = @ScriptDir & "\images\Resources\AttackBar"
	If $Runstate = False Then Return
	; Capture the screen for comparison
	_CaptureRegion2($x, $y, $x1, $y1)

	Local $strinToReturn = ""
	; Perform the search
	$res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", $Redlines, "Int", 0, "Int", 1000)

	If IsArray($res) Then
		If $res[0] = "0" Or $res[0] = "" Then
			SetLog("Imgloc|AttackBarCheck not found!", $COLOR_RED)
		ElseIf StringLeft($res[0], 2) = "-1" Then
			SetLog("DLL Error: " & $res[0] & ", AttackBarCheck", $COLOR_RED)
		Else
			; Get the keys for the dictionary item.
			Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

			; Redimension the result array to allow for the new entries
			ReDim $aResult[UBound($aKeys)][5]

			; Loop through the array
			For $i = 0 To UBound($aKeys) - 1
				If $Runstate = False Then Return
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
				If $DebugSetlog = 1 Then Setlog($aResult[$i][0] & " | $aCoordArray: " & $aCoordArray[0][0] & "-" & $aCoordArray[0][1])
				;;;;;;;; Is exist Castle Spell ;;;;;;;
				If UBound($aCoords) > 1 And StringInStr($aResult[$i][0], "Spell") <> 0 Then
					If $DebugSetlog = 1 Then Setlog($aResult[$i][0] & " detected twice!")
					Local $aCoordsSplit2 = StringSplit($aCoords[1], ",", $STR_NOCOUNT)
					If UBound($aCoordsSplit2) = 2 Then
						; Store the coords into a two dimensional array
						If $aCoordsSplit2[0] < $aCoordsSplit[0] then
							$aCoordArray[0][0] = $aCoordsSplit2[0] ; X coord.
							$aCoordArray[0][1] = $aCoordsSplit2[1] ; Y coord.
						If $DebugSetlog = 1 Then Setlog($aResult[$i][0] & " | $aCoordArray: " & $aCoordArray[0][0] & "-" & $aCoordArray[0][1])
						EndIf
					Else
						$aCoordArray[0][0] = -1
						$aCoordArray[0][1] = -1
					EndIf
				EndIf
				; Store the coords array as a sub-array
				$aResult[$i][1] = Number($aCoordArray[0][0])
				$aResult[$i][2] = Number($aCoordArray[0][1])
			Next

			_ArraySort($aResult, 0, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i

			For $i = 0 To UBound($aResult) - 1
				Local $Slottemp
				If $aResult[$i][1] > 0 Then
					If $DebugSetlog = 1 Then SetLog("$aResult : " & $i, $COLOR_DEBUG) ;Debug
					If $DebugSetlog = 1 Then SetLog("UBound($aResult) : " & $aResult[$i][0] & "|" & $aResult[$i][1] & "|" & $aResult[$i][2], $COLOR_DEBUG) ;Debug
					$Slottemp = SlotAttack($aResult[$i][1])
					If $DebugSetlog = 1 Then SetLog("$Slottemp : " & $Slottemp[0] & "|" & $Slottemp[1], $COLOR_DEBUG) ;Debug
					If $aResult[$i][0] = "Castle" Or $aResult[$i][0] = "King" Or $aResult[$i][0] = "Queen" Or $aResult[$i][0] = "Warden" Then
						$aResult[$i][3] = 1
						$aResult[$i][4] = $Slottemp[1]
					Else
						$aResult[$i][3] = Number(getTroopCountBig($Slottemp[0], 636)) ; For Bigg Numbers , when the troops is slelected
						$aResult[$i][4] = $Slottemp[1]
						If $aResult[$i][3] = "" Or $aResult[$i][3] = 0 Then
							$aResult[$i][3] = Number(getTroopCountSmall($Slottemp[0], 641)) ; For small Numbers
							$aResult[$i][4] = $Slottemp[1]
						EndIf
					EndIf
					$strinToReturn &= "|" & Eval("e" & $aResult[$i][0]) & "#" & $aResult[$i][4] & "#" & $aResult[$i][3]
				EndIf
			Next
		EndIf
	EndIf

	If $debugImageSave = 1 Then
		Local $x = 0, $y = 659, $x1 = 853, $y1 = 698
		_CaptureRegion($x, $y, $x1, $y1)
		Local $subDirectory = @ScriptDir & "\AttackBarCheck"
		DirCreate($subDirectory)
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $filename = String($Date & "_" & $Time & "_.png")
		Local $editedImage = $hBitmap
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED

		For $i = 0 To UBound($aResult) - 1
			_GDIPlus_GraphicsDrawRect($hGraphic, $aResult[$i][1] - 5, $aResult[$i][2] - 5, 10, 10, $hPenRED)
		Next

		_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $filename)
		_GDIPlus_PenDispose($hPenRED)
		_GDIPlus_GraphicsDispose($hGraphic)
	EndIf

	$strinToReturn = StringTrimLeft($strinToReturn, 1)

	; Setlog("String: " & $strinToReturn)
	; Will return [0] = Name , [1] = X , [2] = Y , [3] = Quantities , [4] = Slot Number
	; Old style is: "|" & Troopa Number & "#" & Slot Number & "#" & Quantities
	Return $strinToReturn

EndFunc   ;==>AttackBarCheck

Func SlotAttack($x)

	Local $CheckSlot11 = _ColorCheck(_GetPixelColor(834, 588 + $bottomOffsetY, True), Hex(0x040c0a, 6), 15)
	Local $Slottemp[2] = [0, 0]
	If $Runstate = False Then Return

	Switch $x
		Case $x < 98
			$Slottemp[0] = 35
			$Slottemp[1] = 0
			If $CheckSlot11 = False Then $Slottemp[0] -= 13
			Return $Slottemp
		Case $x > 98 And $x < 171
			$Slottemp[0] = 111
			$Slottemp[1] = 1
			If $CheckSlot11 = False Then $Slottemp[0] -= 13
			Return $Slottemp
		Case $x > 171 And $x < 244
			$Slottemp[0] = 184
			$Slottemp[1] = 2
			If $CheckSlot11 = False Then $Slottemp[0] -= 13
			Return $Slottemp
		Case $x > 244 And $x < 308
			$Slottemp[0] = 255
			$Slottemp[1] = 3
			If $CheckSlot11 = False Then $Slottemp[0] -= 13
			Return $Slottemp
		Case $x > 308 And $x < 393
			$Slottemp[0] = 330
			$Slottemp[1] = 4
			If $CheckSlot11 = False Then $Slottemp[0] -= 13
			Return $Slottemp
		Case $x > 393 And $x < 465
			$Slottemp[0] = 403
			$Slottemp[1] = 5
			If $CheckSlot11 = False Then $Slottemp[0] -= 13
			Return $Slottemp
		Case $x > 465 And $x < 538
			$Slottemp[0] = 477
			$Slottemp[1] = 6
			If $CheckSlot11 = False Then $Slottemp[0] -= 13
			Return $Slottemp
		Case $x > 538 And $x < 611
			$Slottemp[0] = 551
			$Slottemp[1] = 7
			If $CheckSlot11 = False Then $Slottemp[0] -= 13
			Return $Slottemp
		Case $x > 611 And $x < 683
			$Slottemp[0] = 625
			$Slottemp[1] = 8
			If $CheckSlot11 = False Then $Slottemp[0] -= 13
			Return $Slottemp
		Case $x > 683 And $x < 753
			$Slottemp[0] = 694
			$Slottemp[1] = 9
			If $CheckSlot11 = False Then $Slottemp[0] -= 13
			Return $Slottemp
		Case $x > 753 And $x < 823
			$Slottemp[0] = 764
			$Slottemp[1] = 10
			If $CheckSlot11 = False Then $Slottemp[0] -= 13
			Return $Slottemp
		Case $x > 823 And $x < 860
			$Slottemp[0] = 830
			$Slottemp[1] = 11
			Return $Slottemp
		Case Else
			Return $Slottemp
	EndSwitch

EndFunc   ;==>SlotAttack

;New Function to count number of dark troops - value needed for existing donate()
Func CountNumberDarkSpells()

	$CurTotalDarkSpell = $CurPSpell + $CurESpell + $CurHaSpell + $CurSkSpell

	Return $CurTotalDarkSpell
EndFunc   ;==>CountNumberDarkSpells

Func getReceivedTroops($x_start, $y_start, $skip = False) ; Check if 'you received Castle Troops from' , will proceed with a Sleep until the message disappear
	If $skip = True Then Return False
	Local $result = ""
	If $Runstate = False Then Return

	$result = getOcrAndCapture("coc-DonTroops", $x_start, $y_start, 120, 27, True) ; X = 162  Y = 200

	If IsString($result) <> "" Or IsString($result) <> " " Then
		If StringInStr($result, "you") Then ; If exist Minutes or only Seconds
			Return True
		Else
			Return False
		EndIf
	Else
		Return False
	EndIf

EndFunc   ;==>getReceivedTroops


; #########################################################################################
; ####################################### test Buttom #####################################
; #########################################################################################

Func TestEQDeploy()

	$Runstate = True
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
	Local $filename = String($Date & "_" & $Time & ".png")

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
	_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $filename)
	_GDIPlus_PenDispose($hPenRED)
	_GDIPlus_PenDispose($hPenWHITE)
	_GDIPlus_PenDispose($hPenGREEN)
	_GDIPlus_PenDispose($hPenBLUE)
	_GDIPlus_PenDispose($hPenYELLOW)
	_GDIPlus_GraphicsDispose($hGraphic)

	; Lets Open the folder

	Run("Explorer.exe " & $subDirectory)
	$Runstate = False

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
	$Runstate = True

	$debugOcr = 1
	Setlog("Start......OpenArmy Window.....")

	Local $timer = TimerInit()

	CheckExistentArmy("Troops")

	Setlog("Imgloc Troops Time: " & Round(TimerDiff($timer) / 1000, 2) & "'s")

	Setlog("End......OpenArmy Window.....")
	$debugOcr = 0
	$Runstate = False
EndFunc   ;==>TestTrainRevamp2

Func IIf($Condition, $IfTrue, $IfFalse)
	If $Condition = True Then
		Return $IfTrue
	Else
		Return $IfFalse
	EndIf
EndFunc   ;==>IIf

Func _ArryRemoveBlanks(ByRef $Array)
	$Counter = 0
	For $i = 0 To UBound($Array) - 1
		If $Array[$i] <> "" Then
			$Array[$Counter] = $Array[$i]
			$Counter += 1
		EndIf
	Next
	ReDim $Array[$Counter]
EndFunc   ;==>_ArryRemoveBlanks

Func ValidateSearchArmyResult($result, $index = 0)
	If IsArray($result) Then
		If UBound($result) > 0 Then
			If StringLen($result[$index][0]) > 0 Then Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>ValidateSearchArmyResult

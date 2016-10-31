
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyTroopTime
; Description ...: Obtains time reamining in mimutes for Troops Training - Army Overview window
; Syntax ........: getArmyTroopTime($bOpenArmyWindow = False, $bCloseArmyWindow = False)
; Parameters ....:
; Return values .:
; Author ........: Promac(04-2016)
; Modified ......: MonkeyHunter (04-2016), MR.ViPER (16-10-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getArmyTroopTime($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SETLOG("Begin getArmyTroopTime:", $COLOR_DEBUG) ;Debug

	Local $ResultTroopsHour, $ResultTroopsMinutes, $ResultTroopsSeconds
	Local $aRemainTrainTroopTimer = 0 , $iRemainTrainTroopTimer = 0
	$aTimeTrain[0] = 0

	If $bOpenArmyWindow = False And ISArmyWindow() = False Then ; check for train page
		SetError(1)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow = True Then
		If OpenArmyWindow() = False Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($iDelaycheckArmyCamp5) Then Return
	EndIf

	Local $TimeRemainTroops = getRemainTrainTimer(756, 169) ;Get Troop training time via OCR.

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
	Else
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("Can not read remaining Troop train time!", $COLOR_DEBUG) ;Debug
	EndIf

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

	$aTimeTrain[0] = $aRemainTrainTroopTimer ; Update global array

EndFunc   ;==>getArmyTroopTime

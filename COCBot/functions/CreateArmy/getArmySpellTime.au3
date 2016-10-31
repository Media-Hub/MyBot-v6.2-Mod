
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmySpellTime
; Description ...: Obtains time reamining in mimutes for spells Training - Army Overview window
; Syntax ........: getArmySpellTime($bOpenArmyWindow = False, $bCloseArmyWindow = False)
; Parameters ....:
; Return values .: Promac (04-2016)
; Author ........: MonkeyHunter (04-2016)
; Modified ......: MR.ViPER (16-10-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getArmySpellTime($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("Begin getArmySpellTime:", $COLOR_DEBUG) ;Debug

	Local $ResultTroopsHour = 0
	Local $ResultTroopsMinutes = 0
	Local $ResultTroopsSeconds = 0
	$aTimeTrain[1] = 0
	Local $iRemainTrainSpellsTimer = 0

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

	Local $TimeRemainSpells = getRemainTrainTimer(495, 315) ;Get spell training time via OCR.

	If $TimeRemainSpells <> "" Then

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
	Else
		If Not $bFullArmySpells Then
			If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("Can not read remaining Spell train time!", $COLOR_DEBUG) ;Debug
		EndIf
	EndIf

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

	$aTimeTrain[1] = $iRemainTrainSpellsTimer ; update global array

EndFunc   ;==>getArmySpellTime

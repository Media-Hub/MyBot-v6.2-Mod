
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

	If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SETLOG("Begin getArmyTroopTime:", $COLOR_PURPLE)

	$aTimeTrain[0] = 0  ; reset time

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

	Local $iRemainTrainTroopTimer = 0, $sResultTroopMinutes = "", $aResult

	Local $sResultTroops = getRemainTrainTimer(745, 165) ;Get Troop training time via OCR.

	If $sResultTroops <> "" Then
		If StringInStr($sResultTroops, "m") > 1 Then
			$iRemainTrainTroopTimer = Number(StringTrimRight($sResultTroops, 1)) ; removing the "m"
		ElseIf StringInStr($sResultTroops, "s") > 1 Then
			$iRemainTrainTroopTimer = Number(StringTrimRight($sResultTroops, 1)) / 60  ; removing the "s" and convert to minutes
		Else
			If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("getArmyTroopTime: Bad OCR string", $COLOR_RED)
		EndIf
		SetLog("Troop train time: " & StringFormat("%.2f", $iRemainTrainTroopTimer), $COLOR_BLUE)
	Else
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("Can not read remaining Troop train time!", $COLOR_RED)
	EndIf

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

	$aTimeTrain[0] = $iRemainTrainTroopTimer ; Update global array

EndFunc   ;==>getArmyTroopTime

; #FUNCTION# ====================================================================================================================
; Name ..........: GetListPixel($listPixel), GetLocationItem($functionName)
; Description ...: Pixel and Locate Image functions
; Author ........: HungLe (april-2015)
; Modified ......: MR.ViPER (October-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetListPixel($listPixel)
	Local $listPixelSideStr = StringSplit($listPixel, "|")
	If ($listPixelSideStr[0] > 1) Then
		Local $listPixelSide[UBound($listPixelSideStr) - 1]
		For $i = 0 To UBound($listPixelSide) - 1
			Local $Delimiter = StringRegExp($listPixelSideStr[$i + 1], "(?iU)\b[,-]\b", 1)
			If UBound($Delimiter) >= 1 Then $Delimiter = $Delimiter[0]
			Local $pixelStr = StringSplit($listPixelSideStr[$i + 1], $Delimiter)
			If ($pixelStr[0] > 1) Then
				Local $pixel[2] = [$pixelStr[1], $pixelStr[2]]
				$listPixelSide[$i] = $pixel
			EndIf
		Next
		Return $listPixelSide
	Else
		Local $Delimiter = StringRegExp($listPixel, "(?iU)\b[,-]\b", 1)
		If UBound($Delimiter) >= 1 Then $Delimiter = $Delimiter[0]
		If StringInStr($listPixel, $Delimiter) > 0 Then
			Local $pixelStrHere = StringSplit($listPixel, $Delimiter)
			Local $pixelHere[2] = [$pixelStrHere[1], $pixelStrHere[2]]
			Local $listPixelHere[1]
			$listPixelHere[0] = $pixelHere
			Return $listPixelHere
		EndIf
		Return -1 ;
	EndIf
EndFunc   ;==>GetListPixel


Func GetLocationItem($functionName, $useImgLoc = False)
	If $debugSetLog = 1 Or $debugBuildingPos = 1 Then
		Local $hTimer = TimerInit()
		Setlog("GetLocationItem(" & $functionName & ")", $COLOR_PURPLE)
	EndIf
	Local $resultHere
	If $useImgLoc = False Then
		$resultHere = DllCall($hFuncLib, "str", $functionName, "ptr", $hHBitmap2)
	Else
		$resultHere = GetLocationItemImgLoc($functionName)
	EndIf
	If UBound($resultHere) > 0 Then
		If $debugBuildingPos = 1 Then Setlog("#*# " & $functionName & ": " & $resultHere[0] & "calc in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
		Return GetListPixel($resultHere[0])
	Else
		If $debugBuildingPos = 1 Then Setlog("#*# " & $functionName & ": NONE calc in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
	EndIf
EndFunc   ;==>GetLocationItem

Func GetLocationItemImgLoc($functionName)
	Local $DebugIt = False
	If $debugSetLog = 1 Or $debugBuildingPos = 1 Then
		Local $hTimer = TimerInit()
		Setlog("GetLocationItemImgLoc(" & $functionName & ")", $COLOR_PURPLE)
	EndIf

	Switch $functionName
		Case "getLocationTownHall"
			Local $directory = @ScriptDir & "\images\Resources\TH"
			Local $resultHere = multiMatchesPixelOnly($directory, 0, "ECD", "ECD")
			If $DebugIt Then SetLog("$resultHere = " & $resultHere, $COLOR_BLUE)
			If Not $resultHere = "" Then
				If $debugSetLog = 1 Or $debugBuildingPos = 1 Then Setlog("Found TH Within " & Round(TimerDiff($hTimer) / 1000, 2) & " second(s)", $COLOR_PURPLE)
				Return StringSplit($resultHere, "|", 2)
			EndIf
	EndSwitch
EndFunc   ;==>GetLocationItemImgLoc

Func GetLocationCC()
	If $debugSetLog = 1 Or $debugBuildingPos = 1 Then
		Local $hTimer = TimerInit()
		Setlog("GetLocationCC()", $COLOR_PURPLE)
	EndIf
	Local $directory = @ScriptDir & "\images\ClanCastle"
	Local $Result = multiMatchesPixelOnly($directory, 0, "ECD", "ECD")
	If $debugSetLog = 1 Or $debugBuildingPos = 1 Then SetLog("GetLocationCC() Time Taken: " & Round(Number(TimerDiff($hTimer) / 1000), 2) & " Second(s)!")
	Return GetListPixel($Result)
EndFunc   ;==>GetLocationCC

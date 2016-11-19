; #FUNCTION# ====================================================================================================================
; Name ..........: SideP
; Description ...: Determine Side Multiple times More fast, All This File Only For 'SideP' Command in Attack CSV
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: MR.ViPER (12-11-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $DebugSideP = 0
Global Const $dGoldMines = @ScriptDir & "\images\Resources\SideP\GoldMines", $dDarkDrills = @ScriptDir & "\images\Resources\SideP\Drills", $dElixirCollectors = @ScriptDir & "\images\Resources\SideP\Collectors"

Func TestSideP()
	Local $oRunState = $RunState
	$RunState = True

	GetRedLines()
	Local $rGetCountEachSide = GetCountEachSide("Collector")
	If Not @error Then
		GetPercentageEachSide($rGetCountEachSide)
	EndIf
	ResetRedLines()

	$RunState = $oRunState
EndFunc   ;==>TestSideP

Func GetPercentageEachSide($rGetCountEachSide)
	Local $ToReturn[4] = [0, 0, 0, 0]
	Local $TotalFound = $rGetCountEachSide[0] + $rGetCountEachSide[1] + $rGetCountEachSide[2] + $rGetCountEachSide[3]
	If $DebugSideP Then SetLog("Total Objects Found: " & $TotalFound)
	If $TotalFound = 0 Then Return SetError(1)

	$ToReturn[0] = Round(($rGetCountEachSide[0] / $TotalFound) * 100)
	$ToReturn[1] = Round(($rGetCountEachSide[1] / $TotalFound) * 100)
	$ToReturn[2] = Round(($rGetCountEachSide[2] / $TotalFound) * 100)
	$ToReturn[3] = Round(($rGetCountEachSide[3] / $TotalFound) * 100)

	If $DebugSideP Then
		SetLog("==============Percentage===============")
		SetLog("BOTTOM-RIGHT Percentage: " & $ToReturn[0] & "%", $COLOR_BLUE)
		SetLog("TOP-RIGHT Percentage: " & $ToReturn[1] & "%", $COLOR_BLUE)
		SetLog("TOP-LEFT Percentage: " & $ToReturn[2] & "%", $COLOR_BLUE)
		SetLog("BOTTOM-LEFT Percentage: " & $ToReturn[3] & "%", $COLOR_BLUE)
	EndIf
	Return $ToReturn
EndFunc   ;==>GetPercentageEachSide

Func GetCountEachSide($sToSearch)
	Local $ToReturn[4] = [0, 0, 0, 0]
	Local $iSearchResult = ""
	Local $bSomethingFound = False
	Local $splitedPositions
	Switch $sToSearch
		Case "Mine"
			$iSearchResult = multiMatchesPixelOnly($dGoldMines, 7, $DCD, $CurBaseRedLine)
		Case "Drill"
			$iSearchResult = multiMatchesPixelOnly($dDarkDrills, 3, $DCD, $CurBaseRedLine)
		Case "Collector"
			$iSearchResult = multiMatchesPixelOnly($dElixirCollectors, 7, $DCD, $CurBaseRedLine)
		Case Else
			Return SetError(1)
	EndSwitch

	If $iSearchResult <> "" And StringLen($iSearchResult) > 3 Then $bSomethingFound = True
	If $bSomethingFound Then
		If StringInStr($iSearchResult, "|") > 0 Then
			$splitedPositions = StringSplit($iSearchResult, "|", 2)
		Else
			$splitedPositions = _StringEqualSplit($iSearchResult, StringLen($iSearchResult))
		EndIf
	EndIf

	If $bSomethingFound = False Then
		If $DebugSideP Then
			SetLog("SomethingFound is false and" & @CRLF & "$iSearchResult = " & $iSearchResult, $COLOR_RED)
			DebugImageSave("SideP_BuildingNotFound_", False)
		EndIf
		Return SetError(2)
	EndIf

	For $Pos In $splitedPositions
		Switch StringLeft(Slice8(StringSplit($Pos, ",", 2)), 1)
			Case 1, 2 ; BOTTOM-RIGHT
				$ToReturn[0] += 1
			Case 3, 4 ; TOP-RIGHT
				$ToReturn[1] += 1
			Case 5, 6 ; TOP-LEFT
				$ToReturn[2] += 1
			Case 7, 8 ; BOTTOM-LEFT
				$ToReturn[3] += 1
		EndSwitch
	Next
	If $DebugSideP Then
		SetLog("==============Objects Count===============")
		SetLog("BOTTOM-RIGHT Objects Count: x" & $ToReturn[0], $COLOR_BLUE)
		SetLog("TOP-RIGHT Objects Count: x" & $ToReturn[1], $COLOR_BLUE)
		SetLog("TOP-LEFT Objects Count: x" & $ToReturn[2], $COLOR_BLUE)
		SetLog("BOTTOM-LEFT Objects Count: x" & $ToReturn[3], $COLOR_BLUE)
	EndIf

	Return $ToReturn
EndFunc   ;==>GetCountEachSide

Func GetRedLines()
	If StringLen($CurBaseRedLine[0]) > 30 Then Return $CurBaseRedLine
	If $DebugSideP Then $hTimer = TimerInit()
	_CaptureRegion2()
	Local $SingleCocDiamond = "ECD"
	Local $result = DllCall($pImgLib2, "str", "SearchRedLines", "handle", $hHBitmap2, "str", $SingleCocDiamond)
	If IsArray($result) Then
		If $DebugSideP Then SetLog("Redline grabbed within " & Round(TimerDiff($hTimer) / 1000, 2) & " second(s)", $COLOR_GREEN)
		$CurBaseRedLine[0] = $result[0]
	EndIf
	Return $CurBaseRedLine
EndFunc   ;==>GetRedLines

Func _StringEqualSplit($sString, $iNumChars)
	If Not IsString($sString) Or $sString = "" Then Return SetError(1, 0, 0)
	If Not IsInt($iNumChars) Or $iNumChars < 1 Then Return SetError(2, 0, 0)
	Return StringRegExp($sString, "(?s).{1," & $iNumChars & "}", 3)
EndFunc   ;==>_StringEqualSplit

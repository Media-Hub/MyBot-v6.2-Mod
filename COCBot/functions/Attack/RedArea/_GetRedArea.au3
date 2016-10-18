; #FUNCTION# ====================================================================================================================
; Name ..........: _GetRedArea
; Description ...:  See strategy below
; Syntax ........: _GetRedArea()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; Strategy :
; 			Search red area
;			Split the result in 4 sides (global var) : Top Left / Bottom Left / Top Right / Bottom Right
;			Remove bad pixel (Suppose that pixel to deploy are in the green area)
;			Get pixel next the "out zone" , indeed the red color is very different and more uncertain
;			Sort each sides
;			Add each sides in one array (not use, but it can help to get closer pixel of all the red area)

Func _GetRedArea()
	$nameFunc = "[_GetRedArea] "
	debugRedArea($nameFunc & " IN")

	Local $colorVariation = 40
	Local $xSkip = 1
	Local $ySkip = 5

	If $iMatchMode = $LB And $iChkDeploySettings[$LB] = 4 Then ; Used for DES Side Attack (need to know the side the DES is on)
		Local $result = DllCall($hFuncLib, "str", "getRedAreaSideBuilding", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation, "int", $eSideBuildingDES)
		If $debugSetlog Then Setlog("Debug: Redline with DES Side chosen")
	ElseIf $iMatchMode = $LB And $iChkDeploySettings[$LB] = 5 Then ; Used for TH Side Attack (need to know the side the TH is on)
		Local $result = DllCall($hFuncLib, "str", "getRedAreaSideBuilding", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation, "int", $eSideBuildingTH)
		If $debugSetlog Then Setlog("Debug: Redline with TH Side chosen")
	Else ; Normal getRedArea
		;Local $result = DllCall($hFuncLib, "str", "getRedArea", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation)
		Local $result[1]
		$result[0] = GetImgLoc2MBR()
		If $debugSetlog Then Setlog("Debug: Redline chosen")
	EndIf

	Local $listPixelBySide = StringSplit($result[0], "#")

	$listPixelBySide[2] &= "|213-512|218-516|222-520|227-524|231-528|236-532|240-536|245-540|249-544|254-548|258-552|263-556|267-560|272-564|276-568|281-572|285-576|290-580|294-584|299-588|303-592|308-596|312-600|317-604|321-608|326-612|330-616|335-620|339-624|344-628"
	$listPixelBySide[3] &= "|496-629|501-625|506-621|511-617|516-613|521-609|526-605|531-601|536-597|541-593|546-589|551-585|556-581|561-577|566-573|571-569|576-565|581-561|586-557|591-553|596-549|601-545|606-541|611-537|616-533|621-529|626-525|631-521|636-517|641-513"

	$PixelTopLeft = GetPixelSide($listPixelBySide, 1)
	$PixelBottomLeft = GetPixelSide($listPixelBySide, 2)
	$PixelBottomRight = GetPixelSide($listPixelBySide, 3)
	$PixelTopRight = GetPixelSide($listPixelBySide, 4)

	Local $offsetArcher = 15

	ReDim $PixelRedArea[UBound($PixelTopLeft) + UBound($PixelBottomLeft) + UBound($PixelTopRight) + UBound($PixelBottomRight)]
	ReDim $PixelRedAreaFurther[UBound($PixelTopLeft) + UBound($PixelBottomLeft) + UBound($PixelTopRight) + UBound($PixelBottomRight)]

	;If Milking Attack ($iAtkAlgorithm[$DB] = 2) or AttackCSV skip calc of troops further offset (archers drop points for standard attack)
	; but need complete calc if use standard attack after milking attack ($MilkAttackAfterStandardAtk =1) and use redarea ($iChkRedArea[$MA] = 1)
	;If $debugsetlog = 1 Then Setlog("REDAREA matchmode " & $iMatchMode & " atkalgorithm[0] = " & $iAtkAlgorithm[$DB] & " $MilkAttackAfterScriptedAtk = " & $MilkAttackAfterScriptedAtk , $color_aqua)
	If ($iMatchMode = $DB And $iAtkAlgorithm[$DB] = 2) Or ($iMatchMode = $DB And $ichkUseAttackDBCSV = 1) Or ($iMatchMode = $LB And $ichkUseAttackABCSV = 1) Then
		If $debugsetlog = 1 Then setlog("redarea no calc pixel further (quick)", $color_purple)
		$count = 0
		ReDim $PixelTopLeftFurther[UBound($PixelTopLeft)]
		For $i = 0 To UBound($PixelTopLeft) - 1
			$PixelTopLeftFurther[$i] = $PixelTopLeft[$i]
			$PixelRedArea[$count] = $PixelTopLeft[$i]
			$PixelRedAreaFurther[$count] = $PixelTopLeftFurther[$i]
			$count += 1
		Next
		ReDim $PixelBottomLeftFurther[UBound($PixelBottomLeft)]
		For $i = 0 To UBound($PixelBottomLeft) - 1
			$PixelBottomLeftFurther[$i] = $PixelBottomLeft[$i]
			$PixelRedArea[$count] = $PixelBottomLeft[$i]
			$PixelRedAreaFurther[$count] = $PixelBottomLeftFurther[$i]
			$count += 1
		Next
		ReDim $PixelTopRightFurther[UBound($PixelTopRight)]
		For $i = 0 To UBound($PixelTopRight) - 1
			$PixelTopRightFurther[$i] = $PixelTopRight[$i]
			$PixelRedArea[$count] = $PixelTopRight[$i]
			$PixelRedAreaFurther[$count] = $PixelTopRightFurther[$i]
			$count += 1
		Next
		ReDim $PixelBottomRightFurther[UBound($PixelBottomRight)]
		For $i = 0 To UBound($PixelBottomRight) - 1
			$PixelBottomRightFurther[$i] = $PixelBottomRight[$i]
			$PixelRedArea[$count] = $PixelBottomRight[$i]
			$PixelRedAreaFurther[$count] = $PixelBottomRightFurther[$i]
			$count += 1
		Next
		debugRedArea("PixelTopLeftFurther* " & UBound($PixelTopLeftFurther))
	Else
		If $debugsetlog = 1 Then setlog("redarea calc pixel further", $color_purple)
		$count = 0
		ReDim $PixelTopLeftFurther[UBound($PixelTopLeft)]
		For $i = 0 To UBound($PixelTopLeft) - 1
			$PixelTopLeftFurther[$i] = _GetOffsetTroopFurther($PixelTopLeft[$i], $eVectorLeftTop, $offsetArcher)
			$PixelRedArea[$count] = $PixelTopLeft[$i]
			$PixelRedAreaFurther[$count] = $PixelTopLeftFurther[$i]
			$count += 1
		Next
		ReDim $PixelBottomLeftFurther[UBound($PixelBottomLeft)]
		For $i = 0 To UBound($PixelBottomLeft) - 1
			$PixelBottomLeftFurther[$i] = _GetOffsetTroopFurther($PixelBottomLeft[$i], $eVectorLeftBottom, $offsetArcher)
			$PixelRedArea[$count] = $PixelBottomLeft[$i]
			$PixelRedAreaFurther[$count] = $PixelBottomLeftFurther[$i]
			$count += 1
		Next
		ReDim $PixelTopRightFurther[UBound($PixelTopRight)]
		For $i = 0 To UBound($PixelTopRight) - 1
			$PixelTopRightFurther[$i] = _GetOffsetTroopFurther($PixelTopRight[$i], $eVectorRightTop, $offsetArcher)
			$PixelRedArea[$count] = $PixelTopRight[$i]
			$PixelRedAreaFurther[$count] = $PixelTopRightFurther[$i]
			$count += 1
		Next
		ReDim $PixelBottomRightFurther[UBound($PixelBottomRight)]
		For $i = 0 To UBound($PixelBottomRight) - 1
			$PixelBottomRightFurther[$i] = _GetOffsetTroopFurther($PixelBottomRight[$i], $eVectorRightBottom, $offsetArcher)
			$PixelRedArea[$count] = $PixelBottomRight[$i]
			$PixelRedAreaFurther[$count] = $PixelBottomRightFurther[$i]
			$count += 1
		Next
		debugRedArea("PixelTopLeftFurther " & UBound($PixelTopLeftFurther))
	EndIf

	If UBound($PixelTopLeft) < 30 Then
		$PixelTopLeft = _GetVectorOutZone($eVectorLeftTop)
		$PixelTopLeftFurther = $PixelTopLeft
	EndIf
	If UBound($PixelBottomLeft) < 30 Then
		$PixelBottomLeft = _GetVectorOutZone($eVectorLeftBottom)
		$PixelBottomLeftFurther = $PixelBottomLeft
	EndIf
	If UBound($PixelTopRight) < 30 Then
		$PixelTopRight = _GetVectorOutZone($eVectorRightTop)
		$PixelTopRightFurther = $PixelTopRight
	EndIf
	If UBound($PixelBottomRight) < 30 Then
		$PixelBottomRight = _GetVectorOutZone($eVectorRightBottom)
		$PixelBottomRightFurther = $PixelBottomRight
	EndIf

	debugRedArea($nameFunc & "  Size of arr pixel for TopLeft [" & UBound($PixelTopLeft) & "] /  BottomLeft [" & UBound($PixelBottomLeft) & "] /  TopRight [" & UBound($PixelTopRight) & "] /  BottomRight [" & UBound($PixelBottomRight) & "] ")

	debugRedArea($nameFunc & " OUT ")
EndFunc   ;==>_GetRedArea

Func GetImgLoc2MBR()

	Local $directory = @ScriptDir & "\images\WeakBase\Eagle"
	Local $return = returnHighestLevelSingleMatch($directory)
	If IsRedLineOld() = True Then
		If $debugDropSCommand = 1 Then SetLog("RedLine For Defense Being Updated...", $color_purple)
		$redLinesDefense[0] = DllCall($hImgLib, "str", "GetProperty", "str", "redline", "str", "")[0]
		$redLinesDefense[1] = TimerInit()
	EndIf

	Local $AllPoints = StringSplit($return[6], "|", $STR_NOCOUNT)
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

	;Setlog(" »» NEW REDlines Imgloc: " & $NewRedLineString)

	Return $NewRedLineString

EndFunc   ;==>GetImgLoc2MBR

Func IsRedLineOld()
	If $redLinesDefense[0] <= 0 Or $redLinesDefense[1] = 0 Then Return True
	Local $tDiff = TimerDiff($redLinesDefense[1])
	If Int($tDiff, 1) <= 240000 Then Return False
	Return True
EndFunc   ;==>IsRedLineOld

Func ResetRedLine()
	$redLinesDefense[0] = -1
	$redLinesDefense[1] = 0
EndFunc   ;==>ResetRedLine

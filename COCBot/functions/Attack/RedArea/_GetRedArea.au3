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

	Local $colorVariation = 60
	Local $xSkip = 1
	Local $ySkip = 5

	_CaptureRegion2()
	If $iMatchMode = $LB And $iChkDeploySettings[$LB] = 4 Then ; Used for DES Side Attack (need to know the side the DES is on)
		Local $result = DllCall($hFuncLib, "str", "getRedAreaSideBuilding", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation, "int", $eSideBuildingDES)
		If $debugSetlog Then Setlog("Debug: Redline with DES Side chosen")
	ElseIf $iMatchMode = $LB And $iChkDeploySettings[$LB] = 5 Then ; Used for TH Side Attack (need to know the side the TH is on)
		Local $result = DllCall($hFuncLib, "str", "getRedAreaSideBuilding", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation, "int", $eSideBuildingTH)
		If $debugSetlog Then Setlog("Debug: Redline with TH Side chosen")
	Else ; Normal getRedArea
		Local $result = GetImgLoc2MBR()
		If $debugSetlog Then Setlog("Debug: Redline chosen")
	EndIf

	Local $listPixelBySide = StringSplit($result, "#")

	If $debugRedArea =  1 then
		Local $1 = StringSplit($listPixelBySide[1], "|", 2)
		Local $2 = StringSplit($listPixelBySide[2], "|", 2)
		Local $3 = StringSplit($listPixelBySide[3], "|", 2)
		Local $4 = StringSplit($listPixelBySide[4], "|", 2)


		_CaptureRegion()

		; Store a copy of the image handle
		Local $editedImage = $hBitmap
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED
		Local $subDirectory = @ScriptDir & "\RedLineDebug"
		DirCreate($subDirectory)
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $fileName = String($Date & "_" & $Time & "_variation_" & $colorVariation & "_.png")

		For $i = 0 To UBound($1) - 1
			Local $temp = StringSplit($1[$i], "-", 2)
			If UBound($temp) > 1 Then
				_GDIPlus_GraphicsDrawRect($hGraphic, $temp[0] - 2, $temp[1] - 2, 4, 4, $hPenRED)
			EndIf
		Next
		For $i = 0 To UBound($2) - 1
			Local $temp = StringSplit($2[$i], "-", 2)
			If UBound($temp) > 1 Then
				_GDIPlus_GraphicsDrawRect($hGraphic, $temp[0] - 2, $temp[1] - 2, 4, 4, $hPenRED)
			EndIf
		Next
		For $i = 0 To UBound($3) - 1
			Local $temp = StringSplit($3[$i], "-", 2)
			If UBound($temp) > 1 Then
				_GDIPlus_GraphicsDrawRect($hGraphic, $temp[0] - 2, $temp[1] - 2, 4, 4, $hPenRED)
			EndIf
		Next
		For $i = 0 To UBound($4) - 1
			Local $temp = StringSplit($4[$i], "-", 2)
			If UBound($temp) > 1 Then
				_GDIPlus_GraphicsDrawRect($hGraphic, $temp[0] - 2, $temp[1] - 2, 4, 4, $hPenRED)
			EndIf
		Next


		_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $fileName)
		_GDIPlus_PenDispose($hPenRED)
		_GDIPlus_GraphicsDispose($hGraphic)

	EndIf

	$PixelTopLeft = GetPixelSide($listPixelBySide, 1)
	$PixelBottomLeft = GetPixelSide($listPixelBySide, 2)
	$PixelBottomRight = GetPixelSide($listPixelBySide, 3)
	$PixelTopRight = GetPixelSide($listPixelBySide, 4)

	Local $offsetTroops = 12 ;;;;;; This can be selectable on GUI ... from 5 to 20 --- future release

	ReDim $PixelRedArea[UBound($PixelTopLeft) + UBound($PixelBottomLeft) + UBound($PixelTopRight) + UBound($PixelBottomRight)]
	ReDim $PixelRedAreaFurther[UBound($PixelTopLeft) + UBound($PixelBottomLeft) + UBound($PixelTopRight) + UBound($PixelBottomRight)]

	;If Milking Attack ($iAtkAlgorithm[$DB] = 2) or AttackCSV skip calc of troops further offset (archers drop points for standard attack)
	; but need complete calc if use standard attack after milking attack ($MilkAttackAfterStandardAtk =1) and use redarea ($iChkRedArea[$MA] = 1)
	;If $debugsetlog = 1 Then Setlog("REDAREA matchmode " & $iMatchMode & " atkalgorithm[0] = " & $iAtkAlgorithm[$DB] & " $MilkAttackAfterScriptedAtk = " & $MilkAttackAfterScriptedAtk , $COLOR_DEBUG) ;Debug
	If ($iMatchMode = $DB And $iAtkAlgorithm[$DB] = 2) Or ($iMatchMode = $DB And $ichkUseAttackDBCSV = 1) Or ($iMatchMode = $LB And $ichkUseAttackABCSV = 1) Then
		If $debugsetlog = 1 Then setlog("redarea no calc pixel further (quick)", $COLOR_DEBUG) ;Debug
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
		If $debugsetlog = 1 Then setlog("redarea calc pixel further", $COLOR_DEBUG) ;Debug
		$count = 0
		ReDim $PixelTopLeftFurther[UBound($PixelTopLeft)]
		For $i = 0 To UBound($PixelTopLeft) - 1
			$PixelTopLeftFurther[$i] = _GetOffsetTroopFurther($PixelTopLeft[$i], $eVectorLeftTop, $offsetTroops)
			$PixelRedArea[$count] = $PixelTopLeft[$i]
			$PixelRedAreaFurther[$count] = $PixelTopLeftFurther[$i]
			$count += 1
		Next
		ReDim $PixelBottomLeftFurther[UBound($PixelBottomLeft)]
		For $i = 0 To UBound($PixelBottomLeft) - 1
			$PixelBottomLeftFurther[$i] = _GetOffsetTroopFurther($PixelBottomLeft[$i], $eVectorLeftBottom, $offsetTroops)
			$PixelRedArea[$count] = $PixelBottomLeft[$i]
			$PixelRedAreaFurther[$count] = $PixelBottomLeftFurther[$i]
			$count += 1
		Next
		ReDim $PixelTopRightFurther[UBound($PixelTopRight)]
		For $i = 0 To UBound($PixelTopRight) - 1
			$PixelTopRightFurther[$i] = _GetOffsetTroopFurther($PixelTopRight[$i], $eVectorRightTop, $offsetTroops)
			$PixelRedArea[$count] = $PixelTopRight[$i]
			$PixelRedAreaFurther[$count] = $PixelTopRightFurther[$i]
			$count += 1
		Next
		ReDim $PixelBottomRightFurther[UBound($PixelBottomRight)]
		For $i = 0 To UBound($PixelBottomRight) - 1
			$PixelBottomRightFurther[$i] = _GetOffsetTroopFurther($PixelBottomRight[$i], $eVectorRightBottom, $offsetTroops)
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

	_CaptureRegion2()
	Local $_PixelTopLeft, $_PixelBottomLeft, $_PixelBottomRight, $_PixelTopRight , $AllPoints , $EachPoint[1][2]
	Local $SingleCocDiamond = "ECD"
	Local $res = DllCall($pImgLib2, "str", "SearchRedLines", "handle", $hHBitmap2, "str", $SingleCocDiamond)

	If @error Then _logErrorDLLCall($pImgLib2 & ", SearchRedLines: ", @error)

	If IsArray($res) Then
		If $res[0] = "0" Or $res[0] = "" Then
			SetLog("Imgloc|SearchRedLines not found!", $COLOR_RED)
		ElseIf StringLeft($res[0], 2) = "-1" Then
			SetLog("DLL Error: " & $res[0] & ", SearchRedLines", $COLOR_RED)
		Else
			$AllPoints = StringSplit($res[0], "|", $STR_NOCOUNT)

			ReDim $EachPoint[UBound($AllPoints)][2]

			For $i = 0 To UBound($AllPoints) - 1
				Local $temp = StringSplit($AllPoints[$i], ",", $STR_NOCOUNT)
				$EachPoint[$i][0] = Number($temp[0])
				$EachPoint[$i][1] = Number($temp[1])
				; Setlog(" $EachPoint[0]: " & $EachPoint[$i][0] & " | $EachPoint[1]: " & $EachPoint[$i][1])
			Next

			_ArraySort($EachPoint, 0, 0, 0, 0)

			For $i = 0 To UBound($EachPoint) - 1
				If $EachPoint[$i][0] > 20 And $EachPoint[$i][0] < 440 And $EachPoint[$i][1] > 20 And $EachPoint[$i][1] < 349 Then
					$_PixelTopLeft &= String("|" & $EachPoint[$i][0] & "-" & $EachPoint[$i][1])

				ElseIf $EachPoint[$i][0] > 20 And $EachPoint[$i][0] < 440 And $EachPoint[$i][1] > 349 And $EachPoint[$i][1] < 630 Then
					$_PixelBottomLeft &= String("|" & $EachPoint[$i][0] & "-" & $EachPoint[$i][1])

				ElseIf $EachPoint[$i][0] > 440 And $EachPoint[$i][0] < 850 And $EachPoint[$i][1] > 349 And $EachPoint[$i][1] < 630 Then
					$_PixelBottomRight &= String("|" & $EachPoint[$i][0] & "-" & $EachPoint[$i][1])

				ElseIf $EachPoint[$i][0] > 440 And $EachPoint[$i][0] < 850 And $EachPoint[$i][1] > 20 And $EachPoint[$i][1] < 349 Then
					$_PixelTopRight &= String("|" & $EachPoint[$i][0] & "-" & $EachPoint[$i][1])

				EndIf
			Next

			If Not StringIsSpace($_PixelTopLeft) Then $_PixelTopLeft = StringTrimLeft($_PixelTopLeft, 1)
			If Not StringIsSpace($_PixelBottomLeft) Then $_PixelBottomLeft = StringTrimLeft($_PixelBottomLeft, 1)
			If Not StringIsSpace($_PixelBottomRight) Then $_PixelBottomRight = StringTrimLeft($_PixelBottomRight, 1)
			If Not StringIsSpace($_PixelTopRight) Then $_PixelTopRight = StringTrimLeft($_PixelTopRight, 1)
		EndIf
	EndIf

;~ 	_CaptureRegion2()
;~ 	Local $result = DllCall($hFuncRedLib, "str", "getRedArea", "ptr", $hHBitmap2, "int", 1, "int", 5, "int", 60)
;~ 	If @error Then _logErrorDLLCall($hFuncRedLib & ", getRedArea: ", @error)

;~ 	Local $AllPoints2 = StringSplit($result[0], "#", $STR_NOCOUNT)

;~ 	$_PixelTopLeft &= "|" & $AllPoints2[0]
;~ 	$_PixelBottomLeft &= "|" & $AllPoints2[1]
;~ 	$_PixelBottomRight &= "|" & $AllPoints2[2]
;~ 	$_PixelTopRight &= "|" & $AllPoints2[3]

	Local $__PixelTopLeft = ReturnString($_PixelTopLeft)
	Local $__PixelBottomLeft = ReturnString($_PixelBottomLeft)
	Local $__PixelBottomRight = ReturnString($_PixelBottomRight)
	Local $__PixelTopRight = ReturnString($_PixelTopRight)

	If Not StringIsSpace($__PixelTopLeft) Then $__PixelTopLeft = StringTrimLeft($__PixelTopLeft, 1)
	If Not StringIsSpace($__PixelBottomLeft) Then $__PixelBottomLeft = StringTrimLeft($__PixelBottomLeft, 1)
	If Not StringIsSpace($__PixelBottomRight) Then $__PixelBottomRight = StringTrimLeft($__PixelBottomRight, 1)
	If Not StringIsSpace($__PixelTopRight) Then $__PixelTopRight = StringTrimLeft($__PixelTopRight, 1)

	Local $NewRedLineString = $__PixelTopLeft & "#" & $__PixelBottomLeft & "#" & $__PixelBottomRight & "#" & $__PixelTopRight

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

Func ReturnString($string = "")

	Local $OldPixel = StringSplit($string, "|", $STR_NOCOUNT)
	Local $EachPointOld[1][2]
	Local $__Pixel = ""

	Local $z = 0
	For $i = 0 To UBound($OldPixel) - 1
		Local $temp = StringSplit($OldPixel[$i], "-", $STR_NOCOUNT)
		If UBound($temp) > 1 Then
			Local $aResult = _ArraySearch($EachPointOld, $temp[0], 0, 0, 0, 0, 1, 0, False)
			If not @error And $temp[1] = $EachPointOld[$aResult][1] Then
				ContinueLoop
			Else
				$EachPointOld[$z][0] = Number($temp[0])
				$EachPointOld[$z][1] = Number($temp[1])
				$z += 1
				ReDim $EachPointOld[$z + 1][2]
			EndIf
		EndIf
	Next

	_ArraySort($EachPointOld, 0, 0, 0, 0)

	For $i = 0 To UBound($EachPointOld) - 1
		If $EachPointOld[$i][0] > 1 And $EachPointOld[$i][1] > 1 Then
			$__Pixel &= String("|" & $EachPointOld[$i][0] & "-" & $EachPointOld[$i][1])
		EndIf
	Next

	Return $__Pixel

EndFunc   ;==>ReturnString

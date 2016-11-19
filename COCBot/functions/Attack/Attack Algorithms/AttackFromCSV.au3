; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...: This file contens the attack algorithm SCRIPTED
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $MAINSIDE = "TOP-RIGHT"
Global $FRONT_LEFT = "TOP-RIGHT-DOWN"
Global $FRONT_RIGHT = "TOP-RIGHT-UP"
Global $RIGHT_FRONT = "TOP-LEFT-UP"
Global $RIGHT_BACK = "TOP-LEFT-DOWN"
Global $LEFT_FRONT = "BOTTOM-RIGHT-UP"
Global $LEFT_BACK = "BOTTOM-RIGHT-DOWN"
Global $BACK_LEFT = "BOTTOM-LEFT-DOWN"
Global $BACK_RIGHT = "BOTTOM-LEFT-UP"


Global $PixelTopLeftDropLine
Global $PixelTopRightDropLine
Global $PixelBottomLeftDropLine
Global $PixelBottomRightDropLine
Global $PixelTopLeftUPDropLine
Global $PixelTopLeftDOWNDropLine
Global $PixelTopRightUPDropLine
Global $PixelTopRightDOWNDropLine
Global $PixelBottomLeftUPDropLine
Global $PixelBottomLeftDOWNDropLine
Global $PixelBottomRightUPDropLine
Global $PixelBottomRightDOWNDropLine

Global Const $TopExt[2] = [444, 22]
Global Const $LeftExt[2] = [2, 344]
Global Const $RightExt[2] = [860, 344]
Global Const $BottomExt[2] = [444, 670]
Global Const $Middle = [444, 344]

Global $ExternalArea[8][3] = [ _
		[$LeftExt[0], $LeftExt[1], "LEFT"], _
		[$RightExt[0], $RightExt[1], "RIGHT"], _
		[$TopExt[0], $TopExt[1], "TOP"], _
		[$BottomExt[0], $BottomExt[1], "BOTTOM"], _
		[($TopExt[0] + $LeftExt[0]) / 2, ($TopExt[1] + $LeftExt[1]) / 2, "TOP-LEFT"], _
		[($TopExt[0] + $RightExt[0]) / 2, ($TopExt[1] + $RightExt[1]) / 2, "TOP-RIGHT"], _
		[($BottomExt[0] + $LeftExt[0]) / 2, ($BottomExt[1] + $LeftExt[1]) / 2, "BOTTOM-LEFT"], _
		[($BottomExt[0] + $RightExt[0]) / 2, ($BottomExt[1] + $RightExt[1]) / 2, "BOTTOM-RIGHT"] _
		]

Global Const $TopInt[2] = [444, 70]
Global Const $LeftInt[2] = [55, 344]
Global Const $RightInt[2] = [825, 344]
Global Const $BottomInt[2] = [444, 640]

Global $InternalArea[8][3] = [ _
		[$LeftInt[0], $LeftInt[1], "LEFT"], _
		[$RightInt[0], $RightInt[1], "RIGHT"], _
		[$TopInt[0], $TopInt[1], "TOP"], _
		[$BottomInt[0], $BottomInt[1], "BOTTOM"], _
		[($TopInt[0] + $LeftInt[0]) / 2, ($TopInt[1] + $LeftInt[1]) / 2, "TOP-LEFT"], _
		[($TopInt[0] + $RightInt[0]) / 2, ($TopInt[1] + $RightInt[1]) / 2, "TOP-RIGHT"], _
		[($BottomInt[0] + $LeftInt[0]) / 2, ($BottomInt[1] + $LeftInt[1]) / 2, "BOTTOM-LEFT"], _
		[($BottomInt[0] + $RightInt[0]) / 2, ($BottomInt[1] + $RightInt[1]) / 2, "BOTTOM-RIGHT"] _
		]

; #FUNCTION# ====================================================================================================================
; Name ..........: Algorithm_AttackCSV
; Description ...:
; Syntax ........: Algorithm_AttackCSV([$testattack = False])
; Parameters ....: $testattack          - [optional]
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: MR.ViPER (5-10-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func Algorithm_AttackCSV($testattack = False, $captureredarea = True)

	;	00 read attack file SIDE row and valorize variables
	ParseAttackCSV_Read_SIDE_variables()
	If _Sleep($iDelayRespond) Then Return

	Local $hTimerTOTAL = TimerInit()

	;	01 - TROOPS ------------------------------------------------------------------------------------------------------------------------------------------
	debugAttackCSV("Troops to be used (purged from troops) ")
	For $i = 0 To UBound($atkTroops) - 1 ; identify the position of this kind of troop
		debugAttackCSV("SLOT n.: " & $i & " - Troop: " & NameOfTroop($atkTroops[$i][0]) & " (" & $atkTroops[$i][0] & ") - Quantity: " & $atkTroops[$i][1])
	Next

;~ 	;	02 - REDAREA -----------------------------------------------------------------------------------------------------------------------------------------
	Local $hTimer = TimerInit()

	If $captureredarea Or $makeIMGCSV = 1 Then

		ParseAndMakeDropLines("")

		Setlog("> Get all Red Area in  " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_BLUE)

		Local $hTimer = TimerInit()

		Local $htimerREDAREA = Round(TimerDiff($hTimer) / 1000, 2)
		debugAttackCSV("Calculated  (in " & $htimerREDAREA & " seconds) :")
		debugAttackCSV("	[" & UBound($PixelTopLeft) & "] pixels TopLeft")
		debugAttackCSV("	[" & UBound($PixelTopRight) & "] pixels TopRight")
		debugAttackCSV("	[" & UBound($PixelBottomLeft) & "] pixels BottomLeft")
		debugAttackCSV("	[" & UBound($PixelBottomRight) & "] pixels BottomRight")


		Setlog(">> Total time: " & Round(TimerDiff($hTimerTOTAL) / 1000, 2) & " seconds", $COLOR_BLUE)

		; 06 - DEBUGIMAGE ------------------------------------------------------------------------
		If $makeIMGCSV = 1 Then AttackCSVDEBUGIMAGE() ;make IMG debug
	EndIf

	; 07 - START TH SNIPE BEFORE ATTACK CSV IF NEED ------------------------------------------
	If $THSnipeBeforeDBEnable = 1 And $searchTH = "-" Then townHallCheck(True) ;search townhall if no previous detect
	If $THSnipeBeforeDBEnable = 1 Then
		If $searchTH <> "-" Then
			If SearchTownHallLoc() Then
				Setlog(_PadStringCenter(" TH snipe Before Scripted Attack ", 54, "="), $color_blue)
				$THusedKing = 0
				$THusedQueen = 0
				AttackTHParseCSV()
			Else
				If $debugsetlog = 1 Then Setlog("TH snipe before scripted attack skip, th internal village", $COLOR_DEBUG) ;Debug
			EndIf
		Else
			If $debugsetlog = 1 Then Setlog("TH snipe before scripted attack skip, no th found", $COLOR_DEBUG) ;Debug
		EndIf
	EndIf

	; 08 - LAUNCH PARSE FUNCTION -------------------------------------------------------------
	SetSlotSpecialTroops()
	If _Sleep($iDelayRespond) Then Return
	ParseAttackCSV($testattack)

EndFunc   ;==>Algorithm_AttackCSV

; #FUNCTION# ====================================================================================================================
; Name ..........: UpdateResourcesLocations
; Description ...: Recalculate and Get New Positions For Gold Mines/Elixir Collectors/Drills/Dark Elixir Storage
; Syntax ........: UpdateResourcesLocations([$lineContent])
; Parameters ....: $lineContent          - The Line That's Currently Processing In Attack CSV File
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: MR.ViPER (Just moved Sardo Codes in Separate Function, 5-10-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func UpdateResourcesLocations($lineContent)
	;$debugBuildingPos = 1
	;$debugGetLocation = 1
	Local $hTimerTOTAL = TimerInit()
	ParseAttackCSV_Read_SIDE_variables($lineContent)
	;	03 - TOWNHALL ------------------------------------------------------------------------
	If $searchTH = "-" Then
		Local $THString = ""

		If $attackcsv_locate_townhall = 1 Then
			SuspendAndroid()
			$hTimer = TimerInit()

;~ 			Local $searchTH = checkTownHallADV2(0, 0, False)
;~ 			If $searchTH = "-" Then ; retry with autoit search after $iDelayVillageSearch5 seconds
;~ 				If _Sleep($iDelayAttackCSV1) Then Return
;~ 				If $debugsetlog = 1 Then SetLog("2nd attempt to detect the TownHall!", $COLOR_DEBUG) ;Debug
;~ 				$searchTH = checkTownhallADV2()
;~ 			EndIf
;~ 			If $searchTH = "-" Then ; retry with c# search, matching could not have been caused by heroes that partially hid the townhall
;~ 				If _Sleep($iDelayAttackCSV2) Then Return
;~ 				If $debugImageSave = 1 Then DebugImageSave("VillageSearch_NoTHFound2try_", False)
;~ 				THSearch()
;~ 			EndIf

			Local $aResult = townHallCheck(True)
			$THString = convertToOldTHData($aResult)

			Setlog("> Townhall located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_BLUE)
			ResumeAndroid()
		Else
			Setlog("> Townhall search not needed, skip")
		EndIf
	Else
		Setlog("> Townhall has already been located in while searching for an image", $COLOR_BLUE)
	EndIf
	If _Sleep($iDelayRespond) Then Return

	_CaptureRegion2()

	;	04 - MINES, COLLECTORS, DRILLS -----------------------------------------------------------------------------------------------------------------------
	;reset variables
	Global $PixelMine[0]
	Global $PixelElixir[0]
	Global $PixelDarkElixir[0]
	Local $PixelNearCollectorTopLeftSTR = ""
	Local $PixelNearCollectorBottomLeftSTR = ""
	Local $PixelNearCollectorTopRightSTR = ""
	Local $PixelNearCollectorBottomRightSTR = ""


	;	04.01 If drop troop near gold mine
	If $attackcsv_locate_mine = 1 Then
		;SetLog("Locating mines")
		$hTimer = TimerInit()
		SuspendAndroid()
		$PixelMine = GetLocationMine()
		ResumeAndroid()
		If _Sleep($iDelayRespond) Then Return
		CleanRedArea($PixelMine)
		Local $htimerMine = Round(TimerDiff($hTimer) / 1000, 2)
		If (IsArray($PixelMine)) Then
			For $i = 0 To UBound($PixelMine) - 1
				$pixel = $PixelMine[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "MINE"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP LEFT SIDE")
							$PixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM LEFT SIDE")
							$PixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP RIGHT SIDE")
							$PixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM RIGHT SIDE")
							$PixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		Setlog("> Mines located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_BLUE)
	Else
		Setlog("> Mines detection not needed, skip", $COLOR_BLUE)
	EndIf
	If _Sleep($iDelayRespond) Then Return

	;	04.02  If drop troop near elisir
	If $attackcsv_locate_elixir = 1 Then
		;SetLog("Locating elixir")
		$hTimer = TimerInit()
		SuspendAndroid()
		$PixelElixir = GetLocationElixir()
		ResumeAndroid()
		If _Sleep($iDelayRespond) Then Return
		CleanRedArea($PixelElixir)
		Local $htimerMine = Round(TimerDiff($hTimer) / 1000, 2)
		If (IsArray($PixelElixir)) Then
			For $i = 0 To UBound($PixelElixir) - 1
				$pixel = $PixelElixir[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "ELIXIR"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP LEFT SIDE")
							$PixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM LEFT SIDE")
							$PixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP RIGHT SIDE")
							$PixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM RIGHT SIDE")
							$PixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		Setlog("> Elixir collectors located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_BLUE)
	Else
		Setlog("> Elixir collectors detection not needed, skip", $COLOR_BLUE)
	EndIf
	If _Sleep($iDelayRespond) Then Return

	;	04.03 If drop troop near drill
	If $attackcsv_locate_drill = 1 Then
		;SetLog("Locating drills")
		$hTimer = TimerInit()
		SuspendAndroid()
		$PixelDarkElixir = GetLocationDarkElixir()
		ResumeAndroid()
		If _Sleep($iDelayRespond) Then Return
		CleanRedArea($PixelDarkElixir)
		Local $htimerMine = Round(TimerDiff($hTimer) / 1000, 2)
		If (IsArray($PixelDarkElixir)) Then
			For $i = 0 To UBound($PixelDarkElixir) - 1
				$pixel = $PixelDarkElixir[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "DRILL"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP LEFT SIDE")
							$PixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM LEFT SIDE")
							$PixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;Setlog($str & " :  TOP RIGHT SIDE")
							$PixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;Setlog($str & " :  BOTTOM RIGHT SIDE")
							$PixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		Setlog("> Drills located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_BLUE)
	Else
		Setlog("> Drills detection not needed, skip", $COLOR_BLUE)
	EndIf
	If _Sleep($iDelayRespond) Then Return

	If StringLen($PixelNearCollectorTopLeftSTR) > 0 Then $PixelNearCollectorTopLeftSTR = StringLeft($PixelNearCollectorTopLeftSTR, StringLen($PixelNearCollectorTopLeftSTR) - 1)
	If StringLen($PixelNearCollectorTopRightSTR) > 0 Then $PixelNearCollectorTopRightSTR = StringLeft($PixelNearCollectorTopRightSTR, StringLen($PixelNearCollectorTopRightSTR) - 1)
	If StringLen($PixelNearCollectorBottomLeftSTR) > 0 Then $PixelNearCollectorBottomLeftSTR = StringLeft($PixelNearCollectorBottomLeftSTR, StringLen($PixelNearCollectorBottomLeftSTR) - 1)
	If StringLen($PixelNearCollectorBottomRightSTR) > 0 Then $PixelNearCollectorBottomRightSTR = StringLeft($PixelNearCollectorBottomRightSTR, StringLen($PixelNearCollectorBottomRightSTR) - 1)
	$PixelNearCollectorTopLeft = GetListPixel3($PixelNearCollectorTopLeftSTR)
	$PixelNearCollectorTopRight = GetListPixel3($PixelNearCollectorTopRightSTR)
	$PixelNearCollectorBottomLeft = GetListPixel3($PixelNearCollectorBottomLeftSTR)
	$PixelNearCollectorBottomRight = GetListPixel3($PixelNearCollectorBottomRightSTR)

	If $attackcsv_locate_gold_storage = 1 Then
		SuspendAndroid()
		$GoldStoragePos = GetLocationGoldStorage()
		ResumeAndroid()
	EndIf

	If $attackcsv_locate_elixir_storage = 1 Then
		SuspendAndroid()
		$ElixirStoragePos = GetLocationElixirStorage()
		ResumeAndroid()
	EndIf


	; 05 - DARKELIXIRSTORAGE ------------------------------------------------------------------------
	If $attackcsv_locate_dark_storage = 1 Then
		$hTimer = TimerInit()
		SuspendAndroid()
		Local $PixelDarkElixirStorage = GetLocationDarkElixirStorageWithLevel()
		ResumeAndroid()
		If _Sleep($iDelayRespond) Then Return
		CleanRedArea($PixelDarkElixirStorage)
		Local $pixel = StringSplit($PixelDarkElixirStorage, "#", 2)
		If UBound($pixel) >= 2 Then
			Local $pixellevel = $pixel[0]
			Local $pixelpos = StringSplit($pixel[1], "-", 2)
			If UBound($pixelpos) >= 2 Then
				Local $temp = [Int($pixelpos[0]), Int($pixelpos[1])]
				$darkelixirStoragePos = $temp
			EndIf
		EndIf
		Setlog("> Dark Elixir Storage located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_BLUE)
	Else
		Setlog("> Dark Elixir Storage detection not need, skip", $COLOR_BLUE)
	EndIf

	Setlog(">> Total time: " & Round(TimerDiff($hTimerTOTAL) / 1000, 2) & " seconds", $COLOR_BLUE)
	If _Sleep($iDelayRespond) Then Return
	;$debugBuildingPos = 0
	;$debugGetLocation = 0
EndFunc   ;==>UpdateResourcesLocations

Func ParseAndMakeDropLines($MAINSIDE)

	Local $hTimer = TimerInit()

	Local $result

	If IsRedLineAvailable() = True Then
		$result = GetImgLoc2MBR($CurBaseRedLine)
		Setlog("Used last Red Lines!!", $COLOR_RED)
	Else
		$result = GetImgLoc2MBR()
	EndIf

	If $debugsetlog Then Setlog("Debug: Redline chosen")

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
		Local $fileName = String($Date & "_" & $Time & "_.png")

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

	ReDim $PixelRedArea[UBound($PixelTopLeft) + UBound($PixelBottomLeft) + UBound($PixelTopRight) + UBound($PixelBottomRight)]
	ReDim $PixelRedAreaFurther[UBound($PixelTopLeft) + UBound($PixelBottomLeft) + UBound($PixelTopRight) + UBound($PixelBottomRight)]

	Local $hTimer = TimerInit()

	;If $MAINSIDE = "BOTTOM-RIGHT" Then
	CleanRedArea($PixelBottomRight)
	If UBound($PixelBottomRight) < 30 Then
		$PixelBottomRight = _GetVectorOutZone($eVectorRightBottom)
	EndIf
	debugAttackCSV("RedArea cleaned")
	debugAttackCSV("	[" & UBound($PixelBottomRight) & "] pixels BottomRight")
	$PixelBottomRightDropLine = MakeDropLine($PixelBottomRight, StringSplit($InternalArea[3][0] & "-" & $InternalArea[3][1] + 20, "-", $STR_NOCOUNT), StringSplit($InternalArea[1][0] + 30 & "-" & $InternalArea[1][1], "-", $STR_NOCOUNT))
	;-- BOTTOM RIGHT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($PixelBottomRightDropLine) - 1
		$pixel = $PixelBottomRightDropLine[$i]
		Switch StringLeft(Slice8($pixel), 1)
			Case "1"
				$tempvectstr1 &= $pixel[0] & "-" & $pixel[1] & "|"
			Case "2"
				$tempvectstr2 &= $pixel[0] & "-" & $pixel[1] & "|"
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$PixelBottomRightDOWNDropLine = GetListPixel($tempvectstr1)
	$PixelBottomRightUPDropLine = GetListPixel($tempvectstr2)
	Setlog("> BOTTOM-RIGHT DROP LINE EDGE in  " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_BLUE)
	$hTimer = TimerInit()
	;EndIf

	;If $MAINSIDE = "TOP-RIGHT" Then
	CleanRedArea($PixelTopRight)
	If UBound($PixelTopRight) < 30 Then
		$PixelTopRight = _GetVectorOutZone($eVectorRightTop)
	EndIf
	debugAttackCSV("RedArea cleaned")
	debugAttackCSV("	[" & UBound($PixelTopRight) & "] pixels TopRight")
	$PixelTopRightDropLine = MakeDropLine($PixelTopRight, StringSplit($InternalArea[2][0] & "-" & $InternalArea[2][1] - 25, "-", $STR_NOCOUNT), StringSplit($InternalArea[1][0] + 30 & "-" & $InternalArea[1][1], "-", $STR_NOCOUNT))
	;-- TOP RIGHT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($PixelTopRightDropLine) - 1
		$pixel = $PixelTopRightDropLine[$i]
		Switch StringLeft(Slice8($pixel), 1)
			Case "3"
				$tempvectstr1 &= $pixel[0] & "-" & $pixel[1] & "|"
			Case "4"
				$tempvectstr2 &= $pixel[0] & "-" & $pixel[1] & "|"
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$PixelTopRightDOWNDropLine = GetListPixel($tempvectstr1)
	$PixelTopRightUPDropLine = GetListPixel($tempvectstr2)
	Setlog("> TOP-RIGHT DROP LINE EDGE in  " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_BLUE)
	$hTimer = TimerInit()
	;EndIf

	;If $MAINSIDE = "TOP-LEFT" Then
	CleanRedArea($PixelTopLeft)
	If UBound($PixelTopLeft) < 30 Then
		$PixelTopLeft = _GetVectorOutZone($eVectorLeftTop)
	EndIf
	debugAttackCSV("RedArea cleaned")
	debugAttackCSV("	[" & UBound($PixelTopLeft) & "] pixels TopLeft")
	$PixelTopLeftDropLine = MakeDropLine($PixelTopLeft, StringSplit($InternalArea[0][0] - 30 & "-" & $InternalArea[0][1], "-", $STR_NOCOUNT), StringSplit($InternalArea[2][0] & "-" & $InternalArea[2][1] - 25, "-", $STR_NOCOUNT))
	;-- TOP LEFT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($PixelTopLeftDropLine) - 1
		$pixel = $PixelTopLeftDropLine[$i]
		Switch StringLeft(Slice8($pixel), 1)
			Case "6"
				$tempvectstr1 &= $pixel[0] & "-" & $pixel[1] & "|"
			Case "5"
				$tempvectstr2 &= $pixel[0] & "-" & $pixel[1] & "|"
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$PixelTopLeftDOWNDropLine = GetListPixel($tempvectstr1)
	$PixelTopLeftUPDropLine = GetListPixel($tempvectstr2)
	Setlog("> TOP-LEFT DROP LINE EDGE in  " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_BLUE)
	$hTimer = TimerInit()
	;EndIf

	;If $MAINSIDE = "BOTTOM-LEFT" Then
	CleanRedArea($PixelBottomLeft)
	If UBound($PixelBottomLeft) < 30 Then
		$PixelBottomLeft = _GetVectorOutZone($eVectorLeftBottom)
	EndIf
	debugAttackCSV("RedArea cleaned")
	debugAttackCSV("	[" & UBound($PixelBottomLeft) & "] pixels BottomLeft")
	$PixelBottomLeftDropLine = MakeDropLine($PixelBottomLeft, StringSplit($InternalArea[0][0] - 30 & "-" & $InternalArea[0][1], "-", $STR_NOCOUNT), StringSplit($InternalArea[3][0] & "-" & $InternalArea[3][1] + 20, "-", $STR_NOCOUNT))
	;-- BOTTOM LEFT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($PixelBottomLeftDropLine) - 1
		$pixel = $PixelBottomLeftDropLine[$i]
		Switch StringLeft(Slice8($pixel), 1)
			Case "8"
				$tempvectstr1 &= $pixel[0] & "-" & $pixel[1] & "|"
			Case "7"
				$tempvectstr2 &= $pixel[0] & "-" & $pixel[1] & "|"
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$PixelBottomLeftDOWNDropLine = GetListPixel($tempvectstr1)
	$PixelBottomLeftUPDropLine = GetListPixel($tempvectstr2)
	Setlog("> BOTTOM-LEFT DROP LINE EDGE in  " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_BLUE)

	;EndIf

	If _Sleep($iDelayRespond) Then Return

EndFunc   ;==>ParseAndMakeDropLines

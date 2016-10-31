; #FUNCTION# ====================================================================================================================
; Name ..........: CheckWall()
; Description ...: This file Includes the detection of Walls for Upgrade
; Syntax ........:
; Parameters ....: None
; Return values .:
; Author ........: Didipe
; Modified ......: ProMac (oct 2015), MR.ViPER (1-10-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func CheckWall()
	;$icmbWalls = _GUICtrlComboBox_GetCurSel($cmbWalls)

	If _Sleep(500) Then Return
	Local $levelWall = $icmbWalls + 4
	Local $listPixel[0]
	Local $DebugIt = 0		; 2 = Will Call SaveDebugImageWall2 Function, 1 = Will Call SaveDebugImageWall Function

	$hTimer = TimerInit()

	_CaptureRegion2()
	SetLog("Searching for Wall(s) level: " & $levelWall, $COLOR_GREEN)

	Local $directory = @ScriptDir & "\images\Resources\WallUpgrade\" & $levelWall & "\"
	Local $result = SearchWalls($directory, $levelWall, $levelWall)
	If $DebugIt = 2 Then SaveDebugImageWall2($result)
	SetMostPositionsFound($result)
	ClickP($aAway, 1, 0, "#0505") ; to prevent bot 'Anyone there ?'
	If Not $result[0][0] = "" And UBound($result) > 0 Then
		Local $listPixelTemp = GetListPixel($result[0][0])
		_ArrayAdd($listPixel, $listPixelTemp)
	EndIf

	Setlog("Time Taken: " & Round(TimerDiff($hTimer) / 1000, 2) & "'s") ; Time taken

	If (UBound($listPixel) = 0) Then
		SetLog("No wall(s) level: " & $levelWall & " found.", $COLOR_RED)
	Else
		If $DebugIt = 1 Then SaveDebugImageWall($listPixel, $result[0][3])
		SetLog("Found: " & UBound($listPixel) & " possible Wall position(s).", $COLOR_GREEN)
		SetLog("Checking if found positions are a Wall and of desired level.", $COLOR_GREEN)
		For $i = 0 To UBound($listPixel) - 1
			;try click
			Local $pixel = $listPixel[$i]
			Local $xCompensation = 6
			Local $yCompensation = 4
			For $j = 0 To 1 ; try compensation
				GemClick($pixel[0] + $xCompensation, $pixel[1] + $yCompensation)
				If _Sleep(500) Then Return
				$aResult = BuildingInfo(245, 520 + $bottomOffsetY) ; Get Unit name and level with OCR 860x780
				If $aResult[0] = 2 Then ; We found a valid building name
					If StringInStr($aResult[1], "wall") = True And Number($aResult[2]) = ($icmbWalls + 4) Then ; we found a wall
						Setlog("Position No: " & $i + 1 & " is a Wall Level: " & $icmbWalls + 4 & ".")
						Return True
					Else
						If $debugSetlog Then
							ClickP($aAway, 1, 0, "#0931") ;Click Away
							Setlog("Position No: " & $i + 1 & " is not a Wall Level: " & $icmbWalls + 4 & ". It was: " & $aResult[1] & ", " & $aResult[2] & " at: (" & $pixel[0] + $xCompensation & "," & $pixel[1] + $yCompensation & ").", $COLOR_DEBUG) ;Debug
						Else
							ClickP($aAway, 1, 0, "#0932") ;Click Away
							Setlog("Position No: " & $i + 1 & " is not a Wall Level: " & $icmbWalls + 4 & ".", $COLOR_RED)
						EndIf
					EndIf
				Else
					ClickP($aAway, 1, 0, "#0933") ;Click Away
					$xCompensation = 4
					$yCompensation = 7
				EndIf
			Next
		Next
	EndIf
	Return False

EndFunc   ;==>CheckWall

Func SetMostPositionsFound(ByRef $Positions)
	Local $i_ub = UBound($Positions)
	For $i_count = 0 To $i_ub - 2
		Local $i_se = $i_count
		For $x_count = $i_count To $i_ub - 1
			If Number($Positions[$i_se][2]) < Number($Positions[$x_count][2]) Then $i_se = $x_count
		Next
		Local $i_hld = $Positions[$i_count][2]
		$Positions[$i_count][0] = $Positions[$i_se][0]
		$Positions[$i_count][1] = $Positions[$i_se][1]
		$Positions[$i_count][2] = $Positions[$i_se][2]
		$Positions[$i_count][3] = $Positions[$i_se][3]
		$Positions[$i_se][0] = $Positions[$i_count][0]
		$Positions[$i_se][1] = $Positions[$i_count][1]
		$Positions[$i_se][2] = $i_hld
		$Positions[$i_se][3] = $Positions[$i_count][3]
	Next
	For $i = UBound($Positions) - 1 To 1 Step -1
		_ArrayDelete($Positions, $i)
	Next
EndFunc   ;==>SetMostPositionsFound

Func SaveDebugImageWall($listPixel, $TxtName, $SaveLQImageAlso = False)
	#CS
		This Function Will Save an Screen Shot With All Detected Positions By Most Found Image
		Images will be Saved in:
		\Profiles\<PROFILE_NAME>\Temp\Debug\WallUpgrade\
	#CE
	_CaptureRegion2()
	$hImage = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap2)
	$hGraphics = _GDIPlus_ImageGetGraphicsContext($hImage)
	Local $hBrush
	_GDIPlus_GraphicsFillRect($hGraphics, 0, 0, 250, 110) ; HIDE Village Name
	_GDIPlus_GraphicsFillRect($hGraphics, 656, 0, 204, 203) ; HIDE Village Resources
	_GDIPlus_GraphicsFillRect($hGraphics, 260, 0, 335, 55) ; HIDE Buliders And SHIELD
	_GDIPlus_GraphicsFillRect($hGraphics, 0, 485, 120, 247) ; HIDE WAR Button AND Attack Button
	$hBrush = _GDIPlus_BrushCreateSolid(0xFF000029)
	If $aCCPos[0] = -1 Or $aCCPos[1] = -1 Then
		Setlog("Debug Image warning: Locate the Clan Castle to hide the clanname!", $COLOR_RED)
	EndIf
	If $aCCPos[0] <> -1 Then _GDIPlus_GraphicsFillRect($hGraphics, $aCCPos[0] - $IsCCAutoLocated[2], $aCCPos[1] - $IsCCAutoLocated[3], 66, 20, $hBrush) ;draw filled rectangle on the image to hide the user CC if position is known
	Local $hPen = _GDIPlus_PenCreate(0xFFFEDCBA, 2)
	Local $i
	For $i = 0 To UBound($listPixel) - 1
		Local $pixel = $listPixel[$i]
		_GDIPlus_GraphicsDrawRect($hGraphics, $pixel[0], $pixel[1], 5, 5, $hPen)
	Next
	$hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
	$hFormat = _GDIPlus_StringFormatCreate()
	$hFamily = _GDIPlus_FontFamilyCreate("Arial")
	$hFont = _GDIPlus_FontCreate($hFamily, 22, 2)
	$tLayout = _GDIPlus_RectFCreate(295, 670, 550, 30)
	_GDIPlus_GraphicsDrawStringEx($hGraphics, "Found Positions: " & $i, $hFont, $tLayout, $hFormat, $hBrush)
	$i = 0
	$Date = @MDAY & "." & @MON & "." & @YEAR
	$Time = @HOUR & "." & @MIN & "." & @SEC
	$TxtName = "(" & $TxtName & ") "
	Local $savefolder = $dirTempDebug
	$savefolder = $dirTempDebug & "WallUpgrade" & "\"
	DirCreate($savefolder)
	Local $extension = "png"

	Local $exist = True
	Local $i = 1
	Local $first = True
	Local $filename = "", $filenameLQ = ""
	While $exist
		If $first Then
			$first = False
			$filename = $savefolder & $TxtName & $Date & " at " & $Time & "." & $extension
			$filenameLQ = $savefolder & "[LQ]" & $TxtName & $Date & " at " & $Time & "." & $extension
			If FileExists($filename) = 1 Then
				$exist = True
			Else
				$exist = False

			EndIf
		Else
			$filename = $savefolder & $TxtName & $Date & " at " & $Time & " (" & $i & ")." & $extension
			$filenameLQ = $savefolder & "[LQ]" & $TxtName & $Date & " at " & $Time & " (" & $i & ")." & $extension
			If FileExists($filename) = 1 Then
				$i += 1
			Else
				$exist = False
			EndIf
		EndIf
	WEnd

	_GDIPlus_ImageSaveToFile($hImage, $filename)
	If $SaveLQImageAlso = True Then
		Local $sImgCLSID = _GDIPlus_EncodersGetCLSID("jpg")
		Local $tGUID = _WinAPI_GUIDFromString($sImgCLSID)
		Local $tParams = _GDIPlus_ParamInit(1)
		Local $tData = DllStructCreate("int Quality")
		DllStructSetData($tData, "Quality", 50)
		Local $pData = DllStructGetPtr($tData)
		_GDIPlus_ParamAdd($tParams, $GDIP_EPGQUALITY, 1, $GDIP_EPTLONG, $pData)
		_GDIPlus_ImageSaveToFileEx($hImage, $filenameLQ, $sImgCLSID, $tParams)
	EndIf
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_GraphicsDispose($hGraphics)
	Setlog($filename, $COLOR_DEBUG) ;Debug
	If _Sleep($iDelayDebugImageSave1) Then Return
EndFunc   ;==>SaveDebugImageWall

Func SaveDebugImageWall2($result, $SaveLQImageAlso = False)
	#CS
		This Function Will Save an Screen Shot With All Detected Positions By Each Image
		Images will be Saved in:
		\Profiles\<PROFILE_NAME>\Temp\Debug\WallUpgrade\<WALL_LEVEL>\<TIMES>
		<TIMES> Can be a Number From 1 To 9999, Highest Number Will Be The Latest Added Debug Folder/Images
	#CE
	_CaptureRegion2()
	Local $subFolderIndex = 0
	For $ArrCounter = 0 To (UBound($result) - 1)
		If Not $result[$ArrCounter][3] = "" Then
			$hImage = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap2)
			$hGraphics = _GDIPlus_ImageGetGraphicsContext($hImage)
			Local $hBrush
			_GDIPlus_GraphicsFillRect($hGraphics, 0, 0, 250, 110) ; HIDE Village Name
			_GDIPlus_GraphicsFillRect($hGraphics, 656, 0, 204, 203) ; HIDE Village Resources
			_GDIPlus_GraphicsFillRect($hGraphics, 260, 0, 335, 55) ; HIDE Buliders And SHIELD
			_GDIPlus_GraphicsFillRect($hGraphics, 0, 485, 120, 247) ; HIDE WAR Button AND Attack Button
			$hBrush = _GDIPlus_BrushCreateSolid(0xFF000029)
			If $aCCPos[0] = -1 Or $aCCPos[1] = -1 Then
				Setlog("Debug Image warning: Locate the Clan Castle to hide the clanname!", $COLOR_RED)
			EndIf
			;draw filled rectangle on the image to hide the user CC if position is known
			If $aCCPos[0] <> -1 Then _GDIPlus_GraphicsFillRect($hGraphics, $aCCPos[0] - $IsCCAutoLocated[2], $aCCPos[1] - $IsCCAutoLocated[3], 66, 20, $hBrush)
			Local $hPen = _GDIPlus_PenCreate(0xFFFEDCBA, 2)
			Local $i
			If Not $result[$ArrCounter][0] = "" Then
				Local $sPixels = $result[$ArrCounter][0]
				Local $splitedsPixels = StringSplit($sPixels, "|", 2)
				For $j = 0 To (UBound($splitedsPixels) - 1)
					$ThePixel = StringSplit($splitedsPixels[$j], "-", 2)
					_GDIPlus_GraphicsDrawRect($hGraphics, $ThePixel[0], $ThePixel[1], 5, 5, $hPen)
				Next
			EndIf
			$hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
			$hFormat = _GDIPlus_StringFormatCreate()
			$hFamily = _GDIPlus_FontFamilyCreate("Arial")
			$hFont = _GDIPlus_FontCreate($hFamily, 22, 2)
			$tLayout = _GDIPlus_RectFCreate(295, 670, 550, 30)
			_GDIPlus_GraphicsDrawStringEx($hGraphics, "Found Positions: " & $result[$ArrCounter][2], $hFont, $tLayout, $hFormat, $hBrush)
			$i = 0
			$Date = @MDAY & "." & @MON & "." & @YEAR
			$Time = @HOUR & "." & @MIN & "." & @SEC
			Local $TxtName = "(" & $result[$ArrCounter][3] & ") "
			Local $savefolder = $dirTempDebug
			$savefolder = $dirTempDebug & "WallUpgrade" & "\" & $result[$ArrCounter][1] & "\" & IIf($subFolderIndex >= 1, $subFolderIndex & "\", "")
			DirCreate($savefolder)
			If $subFolderIndex <= 0 Then
				For $SubFolderCounter = 1 To 9999
					If FileExists($savefolder & $SubFolderCounter & "\") = False Then
						$savefolder &= $SubFolderCounter & "\"
						DirCreate($savefolder)
						$subFolderIndex = $SubFolderCounter
						ExitLoop
					EndIf
				Next
			EndIf
			Local $extension = "png"

			Local $exist = True
			Local $i = 1
			Local $first = True
			Local $filename = "", $filenameLQ = ""
			While $exist
				If $first Then
					$first = False
					$filename = $savefolder & $TxtName & $Date & " at " & $Time & "." & $extension
					$filenameLQ = $savefolder & "[LQ]" & $TxtName & $Date & " at " & $Time & "." & $extension
					If FileExists($filename) = 1 Then
						$exist = True
					Else
						$exist = False

					EndIf
				Else
					$filename = $savefolder & $TxtName & $Date & " at " & $Time & " (" & $i & ")." & $extension
					$filenameLQ = $savefolder & "[LQ]" & $TxtName & $Date & " at " & $Time & " (" & $i & ")." & $extension
					If FileExists($filename) = 1 Then
						$i += 1
					Else
						$exist = False
					EndIf
				EndIf
			WEnd

			_GDIPlus_ImageSaveToFile($hImage, $filename)
			If $SaveLQImageAlso = True Then
				Local $sImgCLSID = _GDIPlus_EncodersGetCLSID("jpg")
				Local $tGUID = _WinAPI_GUIDFromString($sImgCLSID)
				Local $tParams = _GDIPlus_ParamInit(1)
				Local $tData = DllStructCreate("int Quality")
				DllStructSetData($tData, "Quality", 50)
				Local $pData = DllStructGetPtr($tData)
				_GDIPlus_ParamAdd($tParams, $GDIP_EPGQUALITY, 1, $GDIP_EPTLONG, $pData)
				_GDIPlus_ImageSaveToFileEx($hImage, $filenameLQ, $sImgCLSID, $tParams)
			EndIf
			_GDIPlus_ImageDispose($hImage)
			_GDIPlus_PenDispose($hPen)
			_GDIPlus_GraphicsDispose($hGraphics)
			Setlog($filename, $COLOR_DEBUG) ;Debug
		EndIf
	Next
	If _Sleep($iDelayDebugImageSave1) Then Return
EndFunc   ;==>SaveDebugImageWall2

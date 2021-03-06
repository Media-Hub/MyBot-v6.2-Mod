
; #FUNCTION# ====================================================================================================================
; Name ..........: DebugImageSave
; Description ...: Saves a copy of the current BS image to the Temp Folder for later review
; Syntax ........: DebugImageSave([$TxtName = "Unknown"])
; Parameters ....: $TxtName             - [optional] text string to use as part of saved filename. Default is "Unknown".
; Return values .: None
; Author ........: KnowJack (Aug 2015)
; Modified ......: Sardo (2016-01), MR.ViPER (2016-09)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func DebugImageSave($TxtName = "Unknown", $capturenew = True, $extensionpng = "png", $makesubfolder = True, $sDrawText = "", $iDrawX = 0, $iDrawY = 0, $iDrawSize = 10, $iDrawRX = 0, $iDrawRY = 0, $iDrawRW = 0, $iDrawRH = 0)

	; Debug Code to save images before zapping for later review, time stamped to align with logfile!
	;SetLog("Taking snapshot for later review", $COLOR_GREEN) ;Debug purposes only :)
	$Date = @MDAY & "." & @MON & "." & @YEAR
	$Time = @HOUR & "." & @MIN & "." & @SEC
	Local $savefolder = $dirTempDebug
	If $makesubfolder = True Then
		$savefolder = $dirTempDebug & $TxtName & "\"
		DirCreate($savefolder)
	EndIf

	Local $extension
	If $extensionpng = "png" Then
		$extension = "png"
	Else
		$extension = "jpg"
	EndIf

	Local $exist = True
	Local $i = 1
	Local $first = True
	Local $filename = ""
	While $exist
		If $first Then
			$first = False
			$filename = $savefolder & $TxtName & $Date & " at " & $Time & "." & $extension
			If FileExists($filename) = 1 Then
				$exist = True
			Else
				$exist = False

			EndIf
		Else
			$filename = $savefolder & $TxtName & $Date & " at " & $Time & " (" & $i & ")." & $extension
			If FileExists($filename) = 1 Then
				$i += 1
			Else
				$exist = False
			EndIf
		EndIf
	WEnd

	If $capturenew Then _CaptureRegion()
	If $sDrawText <> "" Or ($iDrawRX <> 0 Or $iDrawRW <> 0 Or $iDrawRH <> 0) Then
		Local $hBmpTemp = $hBitmap
		Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBmpTemp)
		If $sDrawText <> "" Then
			_GDIPlus_GraphicsDrawString($hGraphics, $sDrawText, $iDrawX, $iDrawY, "Arial", $iDrawSize)
		EndIf
		If $iDrawRX <> 0 Or $iDrawRW <> 0 Or $iDrawRH <> 0 Then
			_GDIPlus_GraphicsDrawRect($hGraphics, $iDrawRX, $iDrawRY, $iDrawRW, $iDrawRH)
		EndIf
		_GDIPlus_ImageSaveToFile($hBmpTemp, $filename)
		_GDIPlus_BitmapDispose($hBmpTemp)
	Else
		_GDIPlus_ImageSaveToFile($hBitmap, $filename)
	EndIf
	If $debugsetlog = 1 Then Setlog($filename, $COLOR_DEBUG) ;Debug

	If _Sleep($iDelayDebugImageSave1) Then Return

EndFunc   ;==>DebugImageSave

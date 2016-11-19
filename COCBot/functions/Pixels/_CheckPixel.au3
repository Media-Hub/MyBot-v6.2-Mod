; #FUNCTION# ====================================================================================================================
; Name ..........: _CheckPixel
; Description ...: _CheckPixel : takes an Screencode array[4] as a parameter, [x, y, color, tolerance], $bNeedCapture is used to make a 2x2 capture if needed in the _GetPixelColor function
; Syntax ........: _CheckPixel($tab, $bNeedCapture)
; Parameters ....: $aScreenCode, $bNeedCapture
; Return values .: True when the referenced pixel is found, False if not found
; Author ........: FastFrench (2015)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func _CheckPixel($aScreenCode, $bNeedCapture = False, $Ignore = "")
	If _ColorCheck(_GetPixelColor($aScreenCode[0], $aScreenCode[1], $bNeedCapture), Hex($aScreenCode[2], 6), $aScreenCode[3], $Ignore) Then Return True
	Return False;
EndFunc   ;==>_CheckPixel

Func _CheckPixel2($aScreenCode, $bNeedCapture = Default, $Ignore = Default, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default)
	If $bNeedCapture = Default Then $bNeedCapture = False
	If $debugSetlog = 1 And $sLogText <> Default And IsString($sLogText) Then
		$sLogText &= ", Expected: " & Hex($aScreenCode[2], 6)
	Else
		$sLogText = Default
	EndIf
	If _ColorCheck2( _
			_GetPixelColor2($aScreenCode[0], $aScreenCode[1], $bNeedCapture, $sLogText, $LogTextColor, $bSilentSetLog), _ ; capture color #1
			Hex($aScreenCode[2], 6), _  ; compare to Color #2 from screencode
			$aScreenCode[3], $Ignore) Then ; using tolerance from screencode and color mask name referenced by $Ignore
		Return True
	EndIf
	Return False;
EndFunc   ;==>_CheckPixel2
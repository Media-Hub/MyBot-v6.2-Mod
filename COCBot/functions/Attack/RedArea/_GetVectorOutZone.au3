
; #FUNCTION# ====================================================================================================================
; Name ..........: _GetVectorOutZone
; Description ...:
; Syntax ........: _GetVectorOutZone($eVectorType)
; Parameters ....: $eVectorType         - an unknown value.
; Return values .: None
; Author ........: didipe
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: NoNo
; ===============================================================================================================================
Func _GetVectorOutZone($eVectorType)
	debugRedArea("_GetVectorOutZone IN")
	Local $vectorOutZone[0]

	If ($eVectorType = $eVectorLeftTop) Then
		$xMin = 2
		$yMin = 349
		$xMax = 440
		$yMax = 30
		$xStep = 4
		$yStep = -3
	ElseIf ($eVectorType = $eVectorRightTop) Then
		$xMin = 440
		$yMin = 30
		$xMax = 857
		$yMax = 349
		$xStep = 4
		$yStep = 3
	ElseIf ($eVectorType = $eVectorLeftBottom) Then
		$xMin = 2
		$yMin = 349
		$xMax = 440
		$yMax = 630
		$xStep = 4
		$yStep = 3
	Else
		$xMin = 440
		$yMin = 630
		$xMax = 857
		$yMax = 349
		$xStep = 4
		$yStep = -3
	EndIf

	Local $pixel[2]
	Local $x = $xMin

	For $y = $yMin To $yMax Step $yStep
		$x += $xStep
		$pixel[0] = Floor($x)
		$pixel[1] = Ceiling($y)
		ReDim $vectorOutZone[UBound($vectorOutZone) + 1]
		$vectorOutZone[UBound($vectorOutZone) - 1] = $pixel
	Next
	Return $vectorOutZone

EndFunc   ;==>_GetVectorOutZone

; #FUNCTION# ====================================================================================================================
; Name ..........: getTownHallInfo()
; Description ...: Gets information about the Town Hall
; Syntax ........:
; Parameters ....: None
; Return values .: An array of values for the detected town hall
; Author ........: LunaEclipse(April 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func townHallCheck($check = False)
	; Setup default return coords of 0,0
	Local $defaultCoords[1][2] = [[0, 0]]

	$searchTH = "-"
	$THx=0
	$THy=0 ;if not check, find  TH Snipe and bully mode, always find if deadbase enabled, and TH lvl or Outside checked, find  same with livebase

	; Setup Empty Results in case to avoid errors, levels are set to max level of each type

	; Start the timer for overall weak base search

	If $check = True Or _
		 IsSearchModeActive($TS)  Or _
		($isModeActive[$DB] And (  Number($iChkMeetTH[$DB])>0 Or Number($ichkMeetTHO[$DB])>0)) Or _
		($isModeActive[$LB] And (  Number($iChkMeetTH[$LB])>0 Or Number($ichkMeetTHO[$LB])>0)) Then

		Local $aTownHall = returnHighestLevelSingleMatch(@ScriptDir & "\images\Resources\TH")

		;$aTownHall[0] ; Filename
		;$aTownHall[1] ; Type
		;$aTownHall[2] ; Level
		;$aTownHall[3] ; Fill Percent
		;$aTownHall[4] ; Total Objects
		;$aTownHall[5] ; Coords

		If $debugImageSave = 1 then
		; Capture the screen for comparison
			_CaptureRegion()

			; Store a copy of the image handle
			Local $editedImage = $hBitmap
			Local $subDirectory = @ScriptDir & "\Thdetection\"
			DirCreate($subDirectory)

			; Create the timestamp and filename
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN & "." & @SEC
			Local $fileName = "Thdetection_" & $sBotVersion & "_" & $Date & "_" & $Time & ".png"

			; Needed for editing the picture
			Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
			Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED

				If Number($aTownHall[4]) > 0 Then
					; Retrieve the coords sub-array
					local $coords = $aTownHall[5]

					If IsArray($coords) Then
						; Loop through all found points for the item and add them to the image
						For $j = 0 To UBound($coords) - 1
							addInfoToDebugImage($hGraphic, $hPen, $aTownHall[0], $coords[0][0], $coords[0][1])
						Next
					EndIf
				EndIf

			; Save the image and release any memory
			_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & $fileName)
			_GDIPlus_PenDispose($hPen)
			_GDIPlus_GraphicsDispose($hGraphic)
		EndIf

		; Fill the array that will be returned with the various results, only store the results if a match was found

		If $RunState = false then return
		Return convertToOldTHData($aTownHall)
	Else
		$THLoc = $searchTH
			$THx = 0
			$THy = 0
		Return ""
	EndIf

EndFunc   ;==>townHallCheck


Func convertToOldTHData($aResult)
	$searchTH = "-"
	$THLoc = "-"
	$THx = 0
	$THy = 0

	; Make sure we have received valid data
	If IsArray($aResult) Then
		; Save the town hall level to the old global variable
		If $aResult[1] = "" Then
			$searchTH = "-"
		ElseIf $aResult[2] <= 6 Then
			$searchTH = "4-6"
		ElseIF $aResult[2] >= 7 Then
			$searchTH = String($aResult[2])
		EndIf

		; Save X, Y Coords to the old global variable
		If $aResult[1] = ""  Then
			$THx = 0
			$THy = 0
		Else
			Local $coords = $aResult[5]

			If IsArray($coords) Then
				$THx = $coords[0][0]
				$THy = $coords[0][1]
			Else
				$THx = 0
				$THy = 0
			EndIf
		EndIf

		If SearchTownHallLoc() = False And $searchTH <> "-" Then
			$THLoc = "In"
		ElseIf $searchTH <> "-" Then
			$THLoc = "Out"
		Else
			$THLoc = $searchTH
			$THx = 0
			$THy = 0
		EndIf
	EndIf

	Return " [TH]:" & StringFormat("%2s", $searchTH) & ", " & $THLoc
EndFunc  ;==>convertToOldTHData
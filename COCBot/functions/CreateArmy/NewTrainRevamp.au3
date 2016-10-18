; #FUNCTION# ====================================================================================================================
; Name ..........: Train Revamp System
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: ProMac (2016-10)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


; New Revamp TABS and Positions| [0] = X | [1] = Y
Global $aArmyTrainButton[2] = [40, 525 + $bottomOffsetY] ; Main Screen, Army Train Button
Global Enum $aArmyTab, $aTrainTroopsTab, $aBrewSpellsTab, $aQuickTrainTab
Global $TabNumber[4][2] = [[0, 0], [0, 0], [0, 0], [0, 0]]

; New ReVamp Check Positions and colors | [0] = X | [1] = Y | [2] = Color | [3] = Tolerance
Global Enum $aLastArmy, $aArmy1, $aArmy2, $aArmy3
Global $a_LastArmy[4] = [0, 0, 0xFFFFFF, 10]
Global $a_Army1[4] = [0, 0, 0xFFFFFF, 10]
Global $a_Army2[4] = [0, 0, 0xFFFFFF, 10]
Global $a_Army3[4] = [0, 0, 0xFFFFFF, 10]
Global $a_TrainArmy[4][4] = [$a_LastArmy, $a_Army1, $a_Army2, $a_Army3]

Global $aIsTrainTroopsEmpty[4]
Global $aIsTrainTroopsFull[4] ; If the last Remain Troop Height is larger them remain Army Capacity

Global $aIsBrewSpellsEmpty[4]
Global $aIsBrewSpellsFull[4] ; If the last Remain Spell Space is larger them remain Factory Capacity

Global $TroopsTabEmpty = True
Global $BrewSpellsEmpty = True
Global $TroopstabBoosted = False
Global $BrewSpellsBoosted = False

;########################
; Main Train ReVamp Loop
;########################

Func TrainReVamp()

	If $bTrainEnabled = False Then Return
	SetLog("Training Troops & Spells", $COLOR_BLUE)

	If ($CommandStop = 3 Or $CommandStop = 0) Then
		ClickP($aAway, 1, 0, "#0268") ;Click Away to clear open windows in case user interupted
		If _Sleep($iDelayTrain3) Then Return
		OpenArmyWindow()
		CheckTroops()
		CheckSpells()
		If $fullarmy And $bFullArmySpells Then
			SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_PURPLE)
			If $FirstStart Then $FirstStart = False
			Return
		EndIf
	Else
		ClickP($aAway, 1, 0, "#0268") ;Click Away to clear open windows in case user interupted
		If _Sleep($iDelayTrain3) Then Return
		;OPEN ARMY OVERVIEW WITH NEW BUTTON
		If OpenArmyWindow() = False Then Return ;
	EndIf

	checkAttackDisable($iTaBChkIdle) ; Check for Take-A-Break after opening train page

	If $FirstStart Or ($iTScheck = 1 And $iMatchMode = $TS) Then
		If ISArmyWindow() Then OpenTrainTabNumber($aTrainTroopsTab)
		If $iTScheck = 1 And $iMatchMode = $TS Then SetLog(" » Your Last Attack was a TH snipe, Lets try to balance the army!", $COLOR_GREEN)
		DeleteTroopsTrained()
		If ISArmyWindow() Then OpenTrainTabNumber($aArmyTab)
	EndIf

	CheckTroops()
	CheckSpells()
	CheckClanCastle()
	CheckHeroes()
	CheckWorkingTabs()

	$IsFullArmywithHeroesAndSpells = BitAND($fullarmy, BitOR(IsSearchModeActive($DB), IsSearchModeActive($TS), IsSearchModeActive($LB)))
	If $debugsetlogTrain = 1 Then Setlog("IsSearchModeActive($DB): " & IsSearchModeActive($DB))
	If $debugsetlogTrain = 1 Then Setlog("IsSearchModeActive($LB): " & IsSearchModeActive($LB))
	If $debugsetlogTrain = 1 Then Setlog("IsSearchModeActive($TS): " & IsSearchModeActive($TS))
	If $debugsetlogTrain = 1 Then Setlog("$IsFullArmywithHeroesAndSpells: " & $IsFullArmywithHeroesAndSpells)

	If Not ISArmyWindow() Then Return
	If $RunState = False Then Return


	If ($FirstStart Or ($iTScheck = 1 And $iMatchMode = $TS)) And $IsFullArmywithHeroesAndSpells = False Then

		SetLog(" » Let's check your Army!!", $COLOR_GREEN)
		If ISArmyWindow() Then OpenTrainTabNumber($aTrainTroopsTab)
		checkAttackDisable($iTaBChkIdle) ; Check for Take-A-Break after opening train page
		MakingTroops()
		If ISArmyWindow() Then OpenTrainTabNumber($aBrewSpellsTab)
		MakingSpells()
		Return
	Else

		If $IsFullArmywithHeroesAndSpells = True And $CommandStop <> 0 Then
			SetLog(" » Your Army is full let make a new army before attack!", $COLOR_GREEN)
			checkAttackDisable($iTaBChkIdle) ; Check for Take-A-Break after opening train page
			If ISArmyWindow() Then OpenTrainTabNumber($aQuickTrainTab)
			If ISQuicktrainPage() Then TrainArmyNumber($a_TrainArmy)
			Return
		EndIf

		If ISArmyWindow() Then OpenTrainTabNumber($aTrainTroopsTab)

		If $TroopsTabEmpty = True And $fullarmy = False Then
			If ISArmyWindow() Then OpenTrainTabNumber($aArmyTab)
			CheckTroops()
			If ISArmyWindow() Then OpenTrainTabNumber($aTrainTroopsTab)
			MakingTroops()
		EndIf

		If ISArmyWindow() Then OpenTrainTabNumber($aBrewSpellsTab)

		If $BrewSpellsEmpty = True And $bFullArmySpells = False Then
			If ISArmyWindow() Then OpenTrainTabNumber($aArmyTab)
			CheckSpells()
			If ISArmyWindow() Then OpenTrainTabNumber($aBrewSpellsTab)
			MakingSpells()
			Return
		EndIf

	EndIf

EndFunc   ;==>TrainReVamp

;#############################################
; Sub Functions To the new Train ReVamp System
;#############################################


; Army TAB [ old Army Over View ]
; Open IT

Func OpenArmyWindow()

	ClickP($aAway, 1, 0, "#0346") ;Click Away
	If _Sleep($iDelayRunBot6) Then Return ; wait for window to open
	If IsMainPage() = False Then ; check for main page, avoid random troop drop
		SetLog("Can not open Army Overview window", $COLOR_RED)
		SetError(1)
		Return False
	EndIf

	If WaitforPixel(28, 505 + $bottomOffsetY, 30, 507 + $bottomOffsetY, Hex(0xE4A438, 6), 5, 10) Then
		If $debugsetlogTrain = 1 Then SetLog("Click $aArmyTrainButton", $COLOR_GREEN)
		If $iUseRandomClick = 0 Then
			Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0293") ; Button Army Overview
		Else
			ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
		EndIf
	EndIf

	If _Sleep($iDelayRunBot6) Then Return ; wait for window to open
	If IsTrainPage() = False Then
		SetError(1)
		Return False ; exit if I'm not in train page
	EndIf
	Return True

EndFunc   ;==>OpenArmyWindow

; Check Troops | Trained troops | Queued Troops | Quantities | and if it match with your combo will not delete them
; In Army TAB

Func CheckTroops()

	ResetVariables("Troops")
	$fullarmy = False
	Local $directory = @ScriptDir & "\images\Resources\ArmyTroops\"

	Local $Timer = CheckRemainTrainTimeArmy($X, $Y, "Troops")

	Local $Result = SearchArmy($directory, $X, $Y, $x1, $y1)

	If UBound($Result) > 0 Then
		For $i = 0 To UBound($Result) - 1
			Local $Plural = 0
			If $Result[$i][3] > 1 Then $Plural = 1
			If StringInStr($Result[$i][0], "queued" Then
				$Result[$i][0] = StringTrimRight($Result[$i][0], 6)
				;[&i][0] = Troops name | [&i][1] = X coordinate | [&i][2] = Y coordinate | [&i][3] = Quantities
				Setlog(" » " & $Result[$i][3] & " " & NameOfTroop(Eval("e" & $Result[$i][0], $Plural) & " Queued.", $COLOR_BLUE)
				Assign("Cur" & $Result[$i][0], Eval("Cur" & $Result[$i][0] + $Result[$i][3])
			Else
				Setlog(" » " & $Result[$i][3] & " " & NameOfTroop(Eval("e" & $Result[$i][0], $Plural) & " Trained.", $COLOR_GREEN)
				Assign("Cur" & $Result[$i][0], Eval("Cur" & $Result[$i][0] + $Result[$i][3])
			EndIf
		Next
		SetLog(" »» Remain Train Time: " Sec2Time($Timer))
	EndIf
EndFunc   ;==>CheckTroops

; Check Spells
; In Army TAB

Func CheckSpells()

	ResetVariables("Spells")
	$bFullArmySpells = False
	Local $directory = @ScriptDir & "\images\Resources\ArmySpells\"

	Local $Timer = CheckRemainTrainTimeArmy($X, $Y, "Spells")

	Local $Result = SearchArmy($directory, $X, $Y, $x1, $y1)

	If UBound($Result) > 0 Then
		For $i = 0 To UBound($Result) - 1
			Local $Plural = 0
			If $Result[$i][3] > 1 Then $Plural = 1
			If StringInStr($Result[$i][0], "queued" Then
				$Result[$i][0] = StringTrimRight($Result[$i][0], 6)
				;[&i][0] = Troops name | [&i][1] = X coordinate | [&i][2] = Y coordinate | [&i][3] = Quantities
				Setlog(" » " & $Result[$i][3] & " " & NameOfTroop(Eval("e" & $Result[$i][0], $Plural) & " Brewed.", $COLOR_BLUE)
				Assign("Cur" & $Result[$i][0], Eval("Cur" & $Result[$i][0] + $Result[$i][3])
			Else
				Setlog(" » " & $Result[$i][3] & " " & NameOfTroop(Eval("e" & $Result[$i][0], $Plural) & " Finished.", $COLOR_GREEN)
				Assign("Cur" & $Result[$i][0], Eval("Cur" & $Result[$i][0] + $Result[$i][3])
			EndIf
		Next
		SetLog(" »» Remain Spells Time: " Sec2Time($Timer))
	EndIf

EndFunc   ;==>CheckSpells

; Check Clan Castle
; In Army Tab

Func CheckClanCastle()

	Local $directory = @ScriptDir & "\images\Resources\ArmyTroops\"

	Local $Timer = CheckRemainTrainTimeArmy($X, $Y, "Clan Castle")

	Local $Result = SearchArmy($directory, $X, $Y, $x1, $y1)

	If UBound($Result) > 0 Then
		For $i = 0 To UBound($Result) - 1
			Local $Plural = 0
			If $Result[$i][3] > 1 Then $Plural = 1
			Setlog(" » " & $Result[$i][3] & " " & NameOfTroop(Eval("e" & $Result[$i][0], $Plural) & " in Clan Castle.", $COLOR_GREEN)
		Next
		;SetLog(" »» Remain Spells Time: " Sec2Time($Timer))
	EndIf

EndFunc   ;==>CheckClanCastle

; Check Heroes
; In Army Tab

Func CheckHeroes()

	Local $directory = @ScriptDir & "\images\Resources\ArmyHeroes\"

	Local $Timer = CheckRemainTrainTimeArmy($X, $Y, "Heroes")

	Local $Result = SearchArmy($directory, $X, $Y, $x1, $y1)

	If UBound($Result) > 0 Then
		For $i = 0 To UBound($Result) - 1
			Local $Plural = 0
			If $Result[$i][3] > 1 Then $Plural = 1
			If StringInStr($Result[$i][0], "queued" Then
				$Result[$i][0] = StringTrimRight($Result[$i][0], 6)
				;[&i][0] = Troops name | [&i][1] = X coordinate | [&i][2] = Y coordinate | [&i][3] = Quantities
				Setlog(" » " & $Result[$i][3] & " " & NameOfTroop(Eval("e" & $Result[$i][0], $Plural) & " Recovering.", $COLOR_BLUE)
			Else
				Setlog(" » " & $Result[$i][3] & " " & NameOfTroop(Eval("e" & $Result[$i][0], $Plural) & " Recovered.", $COLOR_GREEN)
			EndIf
		Next
		SetLog(" »» Remain Train Time: " Sec2Time($Timer))
	EndIf

EndFunc   ;==>CheckHeroes

; Check Remain Train Time | Troops | Spells | Heroes
; In Army Tabs

Func CheckRemainTrainTimeArmy($X, $Y, $Log)

	Local $Result = Null
	Local $ResultSplit = ""
	Local $FinalTimeInSeconds = 0

	For $waiting = 0 To 10
		If getReceivedTroops(162, 200) = False Then
			$Result = getRemainTrainTimer($X, $Y)
			If IsTrainPage() Then
				If IsString($Result) <> "" Or IsString($Result) <> " " Then
					If StringInStr($Result, "h") Then
						$ResultSplit = StringSplit($Result, "h")
						If UBound($ResultSplit) > 1 Then
							$FinalTimeInSeconds = (($ResultSplit[0] * 60) + $ResultSplit[1]) * 60
							Return $FinalTimeInSeconds
						Else
							$FinalTimeInSeconds = ($ResultSplit[0] * 60) * 60
							Return $FinalTimeInSeconds
						EndIf
					ElseIf StringInStr($Result, "m") Then
						$ResultSplit = StringSplit($Result, "m")
						If UBound($ResultSplit) > 1 Then
							$FinalTimeInSeconds = (($ResultSplit[0] * 60) + $ResultSplit[1]
							Return $FinalTimeInSeconds
						Else
							$FinalTimeInSeconds = ($ResultSplit[0] * 60)
							Return $FinalTimeInSeconds
						EndIf
					Else
						Return $Result
					EndIf
				Else
					Setlog(" Remain Timer for " & $Log & " error!, $COLOR_RED)
					Return -1
				EndIf
			Else
				Setlog(" Remain Timer for " & $Log & " error|Not is page!, $COLOR_RED)
				Return -1
			EndIf
		Else
			If $waiting = 1 Then Setlog("You have received castle troops! Wait 5's...")
			If _Sleep($iDelayTrain8) Then Return
		EndIf
	Next

EndFunc   ;==>CheckRemainTrainTimeArmy

Func getReceivedTroops($x_start, $y_start) ; Check if 'you received Castle Troops from' , will proceed with a Sleep until the message disappear

	Local $Result = Null
	$Result = getOcrAndCapture("coc-DonTroops", $x_start, $y_start, 120, 27, True) ; X = 162  Y = 200

	If IsString($Result) <> "" Or IsString($Result) <> " " Or $Result <> Null Then
		If StringInStr($Result, "you") Then ; If exist Minutes or only Seconds
			Return True
		Else
			Return False
		EndIf
	Else
		Return False
	EndIf

EndFunc   ;==>getReceivedTroops

; Check Tabs Working , using the green arrow on the tab | Train Troops TAB | Brew Spells TAB
Func CheckWorkingTabs()

	$TroopsTabEmpty = True
	$BrewSpellsEmpty = True
	$TroopstabBoosted = False
	$BrewSpellsBoosted = False

	; [0] = x | [1]= Y | [2] = Working in Progress OR boosted in progress | [3] = Tolerances
	Local $TrainTabColorCheck[2][4]
	Local $BrewSpelssColorCheck[2][4]

	; Check the Train Tab if working
	If _ColorCheck(_GetPixelColor($TrainTabColorCheck[0][0], $TrainTabColorCheck[0][1], True), $TrainTabColorCheck[0][2], 6), $TrainTabColorCheck[0][3]) Then
		$TroopsTabEmpty = False
	Else
		$TroopsTabEmpty = True
	EndIf
	; Check the Train Tab if Boosted
	If _ColorCheck(_GetPixelColor($TrainTabColorCheck[1][0], $TrainTabColorCheck[1][1], True), $TrainTabColorCheck[1][2], 6), $TrainTabColorCheck[1][3]) Then
		$TroopstabBoosted = False
	Else
		$TroopstabBoosted = True
	EndIf

	; Check the Brew Spells Tab if working
	If _ColorCheck(_GetPixelColor($BrewSpelssColorCheck[0][0], $BrewSpelssColorCheck[0][1], True), $BrewSpelssColorCheck[0][2], 6), $BrewSpelssColorCheck[0][3]) Then
		$BrewSpellsEmpty = False
	Else
		$BrewSpellsEmpty = True
	EndIf
	; Check the Brew Spells Tab if Boosted
	If _ColorCheck(_GetPixelColor($BrewSpelssColorCheck[1][0], $BrewSpelssColorCheck[1][1], True), $BrewSpelssColorCheck[1][2], 6), $BrewSpelssColorCheck[1][3]) Then
		$BrewSpellsBoosted = False
	Else
		$BrewSpellsBoosted = True
	EndIf

	For $i = 0 To 1
		For $X = 0 To 1
			If $Results[$i][$X] = Null Then
				Switch $i
					Case 0
						Local Const $txt = "Train Tab"
					Case 1
						Local Const $txt = "Brew Spells Tab"
				EndSwitch
				Switch $X
					Case 0
						Local Const $txt1 = "For Working"
					Case 1
						Local Const $txt1 = "For boosted"
				EndSwitch
				Setlog(" » Error checking the " & $txt & " " & $txt1 & "!", $COLOR_RED)
			EndIf
		Next
	Next

EndFunc   ;==>CheckWorkingTabs

; Open the TAB number

Func OpenTrainTabNumber($Num)
	Local $Message[4] = ["Army Camp", _
			"Train Troops", _
			"Brew Spells", _
			"Quick Train"]

	If ISArmyWindow() Then
		Click($TabNumber[$Num][0], $TabNumber[$Num][1])
		If _Sleep(1000) Then Return
	Else
		Setlog(" » Error Clicking On " & ($Num >= 0 And $Num < UBound($Message)) ? ($Message[$Num]) : ("Not selectable") & " Tab!!!", $COLOR_RED)
	EndIf
EndFunc   ;==>OpenTrainTabNumber

; Click on Army number | On quick train Tab | Previous Army | Army 1 | Army 2 | Army 3
Func TrainArmyNumber($Num)

	If ISQuicktrainPage() Then
		If _ColorCheck(_GetPixelColor($a_TrainArmy[$Num][0], $a_TrainArmy[$Num][1], True), $a_TrainArmy[$Num][2], 6), $a_TrainArmy[$Num][3]) Then
			Click($a_TrainArmy[$Num][0], $a_TrainArmy[$Num][1])
			If _Sleep(1000) Then Return
		Else
			Setlog(" » Error Clicking On Army: " & $Num & "| Pixel was :" & _GetPixelColor($a_TrainArmy[$Num][0], $a_TrainArmy[$Num][1], True), $COLOR_RED)
		EndIf
	Else
		Setlog(" » Error Clicking On Army! You are not on Quick Train Window", $COLOR_RED)
	EndIf

EndFunc   ;==>TrainArmyNumber

; IF you combo is not match with trained troops will delete them.
Func DeleteTroopsTrained()

EndFunc   ;==>DeleteTroopsTrained

;IF your current spells don't match with the spells to train will delete them
Func DeleteSpellsTrained()

EndFunc   ;==>DeleteSpellsTrained

; Check if it is the Army Window
Func ISArmyWindow()

EndFunc   ;==>ISArmyWindow

; Check if it is the Qick Train Window
Func ISQuicktrainPage()

EndFunc   ;==>ISQuicktrainPage

Func MakingTroops()

	For $i = 0 To UBound($TroopName) - 1
		If Eval($TroopName[$i] & "Comp") > 0 Then
			If Eval($TroopName[$i] & "Comp") - Eval("Cur" & $TroopName[$i]) > 0 Then
				TrainIt(Eval("e" & $TroopName[$i]), Eval($TroopName[$i] & "Comp") - Eval("Cur" & $TroopName[$i]), $isldTrainITDelay)
				$fullarmy = False
			ElseIf Eval($TroopName[$i] & "Comp") - Eval("Cur" & $TroopName[$i]) < 0 Then
				Setlog("You have " & Abs(Eval($TroopName[$i] & "Comp") - Eval("Cur" & $TroopName[$i])) & " " & NameOfTroop(Eval("e" & $TroopName[$i]), 1) & " Morre than necessary!", $COLOR_RED)
			ElseIf Eval($TroopName[$i] & "Comp") - Eval("Cur" & $TroopName[$i]) = 0 Then
				Setlog(" » " & NameOfTroop(Eval("e" & $TroopName[$i]), 1) & " are all done!", $COLOR_GREEN)
			EndIf
		EndIf
	Next
	For $i = 0 To UBound($TroopDarkName) - 1
		If Eval($TroopDarkName[$i] & "Comp") > 0 Then
			If Eval($TroopDarkName[$i] & "Comp") - Eval("Cur" & $TroopDarkName[$i]) > 0 Then
				TrainIt(Eval("e" & $TroopDarkName[$i]), Eval($TroopDarkName[$i] & "Comp") - Eval("Cur" & $TroopDarkName[$i]), $isldTrainITDelay)
				$fullarmy = False
			ElseIf Eval($TroopDarkName[$i] & "Comp") - Eval("Cur" & $TroopDarkName[$i]) < 0 Then
				Setlog("You have " & Abs(Eval($TroopDarkName[$i] & "Comp") - Eval("Cur" & $TroopDarkName[$i])) & " " & NameOfTroop(Eval("e" & $TroopDarkName[$i]), 1) & " Morre than necessary!", $COLOR_RED)
			ElseIf Eval($TroopDarkName[$i] & "Comp") - Eval("Cur" & $TroopDarkName[$i]) = 0 Then
				Setlog(" » " & NameOfTroop(Eval("e" & $TroopDarkName[$i], 1) & " are all done!", $COLOR_GREEN)
			EndIf
		EndIf
	Next

EndFunc   ;==>MakingTroops

Func MakingSpells()

	For $i = 0 To UBound($SpellName) - 1
		If Eval($SpellName[$i] & "Comp") > 0 Then
			Switch SpellName[$i]
				Case "LSpell"
					Local Const $Click[2] = [0, 0]
				Case "HSpell"
					Local Const $Click[2] = [0, 0]
				Case "RSpell"
					Local Const $Click[2] = [0, 0]
				Case "JSpell"
					Local Const $Click[2] = [0, 0]
				Case "FSpell"
					Local Const $Click[2] = [0, 0]
				Case "CSpell"
					Local Const $Click[2] = [0, 0]
				Case "PSpell"
					Local Const $Click[2] = [0, 0]
				Case "ESpell"
					Local Const $Click[2] = [0, 0]
				Case "HaSpell"
					Local Const $Click[2] = [0, 0]
				Case "SkSpell"
					Local Const $Click[2] = [0, 0]
			EndSwitch
			If Eval($SpellName[$i] & "Comp") - Eval("Cur" & $SpellName[$i]) > 0 Then
				GemClick($Click[0], $Click[1], Eval($SpellName[$i] & "Comp") - Eval("Cur" & $SpellName[$i]), $isldTrainITDelay)
				$fullarmy = False
			ElseIf Eval($SpellName[$i] & "Comp") - Eval("Cur" & $SpellName[$i]) < 0 Then
				Setlog("You have " & Abs(Eval($SpellName[$i] & "Comp") - Eval("Cur" & $SpellName[$i])) & " " & NameOfTroop(Eval("e" & $SpellName[$i]), 1) & " Morre than necessary!", $COLOR_RED)
			ElseIf Eval($SpellName[$i] & "Comp") - Eval("Cur" & $SpellName[$i]) = 0 Then
				Setlog(" » " & NameOfTroop(Eval("e" & $SpellName[$i]), 1) & " are all done!", $COLOR_GREEN)
			EndIf
		EndIf
	Next

EndFunc   ;==>MakingSpells
Func ResetVariables($txt)

	If $txt = "troops" Or $txt = "all" Then
		For $i = 0 To UBound($TroopName) - 1
			Assign("Cur" & $TroopName[$i], 0)
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
		Next
		For $i = 0 To UBound($TroopDarkName) - 1
			Assign("Cur" & $TroopDarkName[$i], 0)
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
		Next
	EndIf
	If $txt = "spells" Or $txt = "all" Then
		For $i = 0 To UBound($SpellName) - 1
			Assign("Cur" & $SpellName[$i], 0)
			If _Sleep($iDelayTrain6) Then Return ; '20' just to Pause action
		Next
	EndIf

EndFunc   ;==>ResetVariables
; Will Return a Array | [&i][0] = Troops name | [&i][1] = X coordinate | [&i][2] = Y coordinate | [&i][3] = Quantities , sorted by less X position
Func SearchArmy($directory, $X, $Y, $x1, $y1)
	; Setup arrays, including default return values for $return
	Local $aResult[1][4] = ["", "", "", ""], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue

	; Capture the screen for comparison
	_CaptureRegion2($X, $Y, $x1, $y1)

	; Perform the search
	$res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", "FV", "Int", 20, "str", "", "Int", 0, "Int", 1000)

	If $res[0] <> "" Then
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

		; Redimension the result array to allow for the new entries
		ReDim $aResult[UBound($aKeys)][4]

		; Loop through the array
		For $i = 0 To UBound($aKeys) - 1
			; Get the property values
			$aResult[$i][0] = returnPropertyValue($aKeys[$i], "filename")
			; Get the coords property
			$aValue = returnPropertyValue($aKeys[$i], "objectpoints")
			$aCoords = StringSplit($aValue, "|", $STR_NOCOUNT)
			$aCoordsSplit = StringSplit($aCoords[0], ",", $STR_NOCOUNT)
			If UBound($aCoordsSplit) = 2 Then
				; Store the coords into a two dimensional array
				$aCoordArray[0][0] = $aCoordsSplit[0] ; X coord.
				$aCoordArray[0][1] = $aCoordsSplit[1] ; Y coord.
			Else
				$aCoordArray[0][0] = -1
				$aCoordArray[0][1] = -1
			EndIf
			; Store the coords array as a sub-array
			$aResult[$i][1] = Number($aCoordArray[0][0])
			$aResult[$i][2] = Number($aCoordArray[0][1])
			$aResult[$i][3] = Number(getArmyTroopQuantity($aResult[$i][1] - 20, $aResult[$i][2] - 30))
		Next
	EndIf

	_ArraySort($aResult, 1, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i

	Return $aResult
EndFunc   ;==>SearchArmy

Func Sec2Time($nr_sec) ; Convert seconds to Time format HH:MM:SS
	$sec2time_hour = Int($nr_sec / 3600)
	$sec2time_min = Int(($nr_sec - $sec2time_hour * 3600) / 60)
	$sec2time_sec = $nr_sec - $sec2time_hour * 3600 - $sec2time_min * 60
	Return StringFormat("%02d:%02d:%02d", $sec2time_hour, $sec2time_min, $sec2time_sec)
EndFunc   ;==>Sec2Time

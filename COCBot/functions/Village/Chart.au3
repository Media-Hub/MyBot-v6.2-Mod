#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         Ezeck

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

Func ChartAddDataPoint1hr($WhichSet = "Total", $bGreenButton = False)
	SetLog("Adding A Chart Data Point")
	Global $t1HrTimer

	If 	$WhichSet = "Total"  Then
		Local $aChartGold24hr[24]
		Local $aChartElixir24hr[24]
		Local $aChartDarkE24hr[24]
		Local $aChartWasStartClicked[24]
		Local $EmptyString = "0"
		For $i = 0 to 22
			$EmptyString &= "|0"
		Next

		;Set timer for OneHour
		$t1HrTimer = TimerInit()
		;Read the Data from File
		If Not FileExists($ChartPath &"Total.ini") Then
			FileOpen($ChartPath&"Total.ini", $FO_OVERWRITE + $FO_CREATEPATH)
			;IniWrite ( "filename", "section", "key", "value" )
			IniWrite($ChartPath&"Total.ini", "ChartData", "GoldTotal", $EmptyString)
			IniWrite($ChartPath&"Total.ini", "ChartData", "ElixirTotal", $EmptyString)
			IniWrite($ChartPath&"Total.ini", "ChartData", "DarkETotal", $EmptyString)
			IniWrite($ChartPath&"Total.ini", "ChartData", "WasStart", $EmptyString)
			FileClose($ChartPath&"Total.ini")
		Else
			FileOpen($ChartPath)
			;Load the Arrays with Data
			$aChartGold24hr = StringSplit(IniRead($ChartPath&"Total.ini", "ChartData", "GoldTotal",""), "|", $STR_NOCOUNT)
			$aChartElixir24hr = StringSplit(IniRead($ChartPath&"Total.ini", "ChartData", "ElixirTotal",""), "|", $STR_NOCOUNT)
			$aChartDarkE24hr = StringSplit(IniRead($ChartPath&"Total.ini", "ChartData", "DarkETotal",""), "|", $STR_NOCOUNT)
			$aChartWasStartClicked = StringSplit(IniRead($ChartPath&"Total.ini", "ChartData", "WasStart",""), "|", $STR_NOCOUNT)
			FileClose($ChartPath&"Total.ini")
		EndIf

		;Add the new Data
		_ArrayPush($aChartGold24hr, $iGoldCurrent)
		_ArrayPush($aChartElixir24hr, $iElixirCurrent)
		_ArrayPush($aChartDarkE24hr, $iDarkCurrent)
		_ArrayPush($aChartWasStartClicked, $bGreenButton)

		;Save Data Back to file
		FileOpen($ChartPath&"Total.ini", $FO_OVERWRITE + $FO_CREATEPATH)
		;IniWrite ( "filename", "section", "key", "value" )
		IniWrite($ChartPath&"Total.ini", "ChartData", "GoldTotal", _ArrayToString($aChartGold24hr, "|" , -1, -1))
		IniWrite($ChartPath&"Total.ini", "ChartData", "ElixirTotal", _ArrayToString($aChartElixir24hr, "|", -1, -1))
		IniWrite($ChartPath&"Total.ini", "ChartData", "DarkETotal", _ArrayToString($aChartDarkE24hr, "|", -1, -1))
		IniWrite($ChartPath&"Total.ini", "ChartData", "WasStart", _ArrayToString($aChartWasStartClicked, "|", -1, -1))
		FileClose($ChartPath&"Total.ini")
		Return
	EndIf

	If 	$WhichSet = "Rate"  Then ; Recorded from Last 96 Attacks
		Local $aChartGoldRate[96]
		Local $aChartElixirRate[96]
		Local $aChartDarkERate[96]
		Local $aChartWasStartClicked[96]
		Local $EmptyString = "0"
		For $i = 0 to 94
			$EmptyString &= "|0"
		Next
		;Read the Data from File
		If Not FileExists($ChartPath&"Rate.ini") Then
			FileOpen($ChartPath&"Rate.ini", $FO_OVERWRITE + $FO_CREATEPATH)
			;IniWrite ( "filename", "section", "key", "value" )
			IniWrite($ChartPath&"Rate.ini", "ChartData", "GoldRate", $EmptyString)
			IniWrite($ChartPath&"Rate.ini", "ChartData", "ElixirRate", $EmptyString)
			IniWrite($ChartPath&"Rate.ini", "ChartData", "DarkERate", $EmptyString)
			IniWrite($ChartPath&"Rate.ini", "ChartData", "WasFirstRate", $EmptyString)
			FileClose($ChartPath&"Rate.ini")
		Else
			FileOpen($ChartPath&"Rate.ini")
			;Load the Arrays with Data
			$aChartGoldRate = StringSplit(IniRead($ChartPath&"Rate.ini", "ChartData", "GoldRate",""), "|", $STR_NOCOUNT)
			$aChartElixirRate = StringSplit(IniRead($ChartPath&"Rate.ini", "ChartData", "ElixirRate",""), "|", $STR_NOCOUNT)
			$aChartDarkERate = StringSplit(IniRead($ChartPath&"Rate.ini", "ChartData", "DarkERate",""), "|", $STR_NOCOUNT)
			$aChartWasStartClicked = StringSplit(IniRead($ChartPath&"Rate.ini", "ChartData", "WasFirstRate",""), "|", $STR_NOCOUNT)
			FileClose($ChartPath)
		EndIf

		;Add the new Data
		_ArrayPush($aChartGoldRate, Round($iGoldTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600))
		_ArrayPush($aChartElixirRate, Round($iElixirTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600))
		_ArrayPush($aChartDarkERate, Round($iDarkTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600 * 1000))
		_ArrayPush($aChartWasStartClicked, $bGreenButton)

		;Save Data Back to file
		FileOpen($ChartPath&"Rate.ini", $FO_OVERWRITE + $FO_CREATEPATH)
		;IniWrite ( "filename", "section", "key", "value" )
		IniWrite($ChartPath&"Rate.ini", "ChartData", "GoldRate", _ArrayToString($aChartGoldRate, "|" , -1, -1))
		IniWrite($ChartPath&"Rate.ini", "ChartData", "ElixirRate", _ArrayToString($aChartElixirRate, "|", -1, -1))
		IniWrite($ChartPath&"Rate.ini", "ChartData", "DarkERate", _ArrayToString($aChartDarkERate, "|", -1, -1))
		IniWrite($ChartPath&"Rate.ini", "ChartData", "WasFirstRate", _ArrayToString($aChartWasStartClicked, "|", -1, -1))
		FileClose($ChartPath&"Rate.ini")
		Return
	EndIf

	If 	$WhichSet = "Attack"  Then ; Recorded from Last 96 Attacks
		Local $aChartGoldAttack[96]
		Local $aChartElixirAttack[96]
		Local $aChartDarkEAttack[96]

		Local $aChartGoldBonus[96]
		Local $aChartElixirBonus[96]
		Local $aChartDarkEBonus[96]

		Local $aChartWasStartClicked[96]
		Local $EmptyString = "0"
		For $i = 0 to 94
			$EmptyString &= "|0"
		Next
		;Read the Data from File
		If Not FileExists($ChartPath&"Attack.ini") Then
			FileOpen($ChartPath, $FO_OVERWRITE + $FO_CREATEPATH)
			;IniWrite ( "filename", "section", "key", "value" )
			IniWrite($ChartPath&"Attack.ini", "ChartData", "GoldAttack", $EmptyString)
			IniWrite($ChartPath&"Attack.ini", "ChartData", "ElixirAttack", $EmptyString)
			IniWrite($ChartPath&"Attack.ini", "ChartData", "DarkEAttack", $EmptyString)

			IniWrite($ChartPath&"Attack.ini", "ChartData", "GoldBonus", $EmptyString)
			IniWrite($ChartPath&"Attack.ini", "ChartData", "ElixirBonus", $EmptyString)
			IniWrite($ChartPath&"Attack.ini", "ChartData", "DarkEBonus", $EmptyString)

			IniWrite($ChartPath&"Attack.ini", "ChartData", "WasFirstAttack", $EmptyString)
			FileClose($ChartPath&"Attack.ini")
		Else
			FileOpen($ChartPath&"Attack.ini")
			;Load the Arrays with Data
			$aChartGoldAttack = StringSplit(IniRead($ChartPath&"Attack.ini", "ChartData", "GoldAttack",""), "|", $STR_NOCOUNT)
			$aChartElixirAttack = StringSplit(IniRead($ChartPath&"Attack.ini", "ChartData", "ElixirAttack",""), "|", $STR_NOCOUNT)
			$aChartDarkEAttack = StringSplit(IniRead($ChartPath&"Attack.ini", "ChartData", "DarkEAttack",""), "|", $STR_NOCOUNT)

			$aChartGoldBonus = StringSplit(IniRead($ChartPath&"Attack.ini", "ChartData", "GoldBonus",""), "|", $STR_NOCOUNT)
			$aChartElixirBonus = StringSplit(IniRead($ChartPath&"Attack.ini", "ChartData", "ElixirBonus",""), "|", $STR_NOCOUNT)
			$aChartDarkEBonus = StringSplit(IniRead($ChartPath&"Attack.ini", "ChartData", "DarkEBonus",""), "|", $STR_NOCOUNT)

			$aChartWasStartClicked = StringSplit(IniRead($ChartPath&"Attack.ini", "ChartData", "WasFirstAttack",""), "|", $STR_NOCOUNT)
			FileClose($ChartPath&"Attack.ini")
		EndIf

		;Add the new Data
		_ArrayPush($aChartGoldAttack, $iGoldLast)
		_ArrayPush($aChartElixirAttack, $iElixirLast)
		_ArrayPush($aChartDarkEAttack, $iDarkLast)

		_ArrayPush($aChartGoldBonus, $iGoldLastBonus)
		_ArrayPush($aChartElixirBonus, $iElixirLastBonus)
		_ArrayPush($aChartDarkEBonus, $iDarkLastBonus)

		_ArrayPush($aChartWasStartClicked, $bGreenButton)

		;Save Data Back to file
		FileOpen($ChartPath&"Attack.ini", $FO_OVERWRITE + $FO_CREATEPATH)
		;IniWrite ( "filename", "section", "key", "value" )
		IniWrite($ChartPath&"Attack.ini", "ChartData", "GoldAttack", _ArrayToString($aChartGoldAttack, "|" , -1, -1))
		IniWrite($ChartPath&"Attack.ini", "ChartData", "ElixirAttack", _ArrayToString($aChartElixirAttack, "|", -1, -1))
		IniWrite($ChartPath&"Attack.ini", "ChartData", "DarkEAttack", _ArrayToString($aChartDarkEAttack, "|", -1, -1))

		IniWrite($ChartPath&"Attack.ini", "ChartData", "GoldBonus", _ArrayToString($aChartGoldBonus, "|" , -1, -1))
		IniWrite($ChartPath&"Attack.ini", "ChartData", "ElixirBonus", _ArrayToString($aChartElixirBonus, "|", -1, -1))
		IniWrite($ChartPath&"Attack.ini", "ChartData", "DarkEBonus", _ArrayToString($aChartDarkEBonus, "|", -1, -1))

		IniWrite($ChartPath&"Attack.ini", "ChartData", "WasFirstAttack", _ArrayToString($aChartWasStartClicked, "|", -1, -1))
		FileClose($ChartPath&"Attack.ini")
		Return
	EndIf

	Return
EndFunc

Func btn1DisplayChart() ; Totals Bar Graph Version

	Global $Form101 = GUICreate("24 Hr Total Chart", 1050, 550, -1, -1, BitOR($WS_SYSMENU, $WS_POPUP))
    GUISetBkColor(0xffffff)
	GUICtrlSetState($btn1Chart, $GUI_DISABLE)
    _CreateBarChart1("Total Gold, Elixir, Dark Elixer","Last 24Hr's",20,20,1000,500) ; name, description, x,y (chart offsets from boarder size, boarder size 1000 x 500
	$btnValidateLevels = GUICtrlCreateButton("Exit Chart", 946, 4, 100, 18)
	GUICtrlSetOnEvent(-1, "ExitChart1")
	GUISetState(@SW_SHOW) ; <--- displays the created window
EndFunc

Func ExitChart1()
	GUIDelete($Form101)
	GUICtrlSetState($btn1Chart, $GUI_ENABLE)
EndFunc

Func btn2DisplayChart() ; Totals Line

	Global $Form102 = GUICreate("24 Hr Total Chart", 1050, 550, -1, -1, BitOR($WS_SYSMENU, $WS_POPUP))
    GUISetBkColor(0xffffff)
	GUICtrlSetState($btn2Chart, $GUI_DISABLE)
    _CreateBarChart2("Total Gold, Elixir, Dark Elixer","Last 24Hr's",20,20,1000,500) ; name, description, x,y (chart offsets from boarder size, boarder size 1000 x 500
	$btnValidateLevels = GUICtrlCreateButton("Exit Chart", 946, 4, 100, 18)
	GUICtrlSetOnEvent(-1, "ExitChart2")
	GUISetState(@SW_SHOW) ; <--- displays the created window
EndFunc

Func ExitChart2()
	GUIDelete($Form102)
	GUICtrlSetState($btn2Chart, $GUI_ENABLE)
EndFunc

Func btn3DisplayChart() ; Rate Lines

	Global $Form103 = GUICreate("Rates / Hr", 1050, 550, -1, -1, BitOR($WS_SYSMENU, $WS_POPUP))
    GUISetBkColor(0xffffff)
	GUICtrlSetState($btn3Chart, $GUI_DISABLE)
    _CreateBarChart3("RATES / HR,","Last 96 Attacks",20,20,1000,500) ; name, description, x,y (chart offsets from boarder size, boarder size 1000 x 500
	$btnValidateLevels = GUICtrlCreateButton("Exit Chart", 946, 4, 100, 18)
	GUICtrlSetOnEvent(-1, "ExitChart3")
	GUISetState(@SW_SHOW) ; <--- displays the created window
EndFunc

Func ExitChart3()
	GUIDelete($Form103)
	GUICtrlSetState($btn3Chart, $GUI_ENABLE)
EndFunc

Func btn4DisplayChart() ; Attack

	Global $Form104 = GUICreate("24 Hr Total Chart", 1050, 550, -1, -1, BitOR($WS_SYSMENU, $WS_POPUP))
    GUISetBkColor(0xffffff)
	GUICtrlSetState($btn4Chart, $GUI_DISABLE)
    _CreateBarChart4("Attack Data","Last 96 Attacks",20,20,1000,500) ; name, description, x,y (chart offsets from boarder size, boarder size 1000 x 500
	$btnValidateLevels = GUICtrlCreateButton("Exit Chart", 946, 4, 100, 18)
	GUICtrlSetOnEvent(-1, "ExitChart4")
	GUISetState(@SW_SHOW) ; <--- displays the created window
EndFunc

Func ExitChart4()
	GUIDelete($Form104)
	GUICtrlSetState($btn4Chart, $GUI_ENABLE)
EndFunc



Func _CreateBarChart4($sTitle1="",$sTitle2="",$iX=20,$iY=20,$iW=400,$iH=400)
	Local $colorGold = 0xFFD700
	Local $colorElixir =0xDD1AD5
	Local $colorDark = 0x242024
	Local $colorRed = 0xed0404
	;set default values for the frame
    If $iX=-1 Then $iX=20
    If $iY=-1 Then $iY=20
    If $iW=-1 Then $iW=400
    If $iH=-1 Then $iH=400

	;Read File to Array
	Local $aChartGoldAttack[96]
	Local $aChartElixirAttack[96]
	Local $aChartDarkEAttack[96]

	Local $aChartGoldBonus[96]
	Local $aChartElixirBonus[96]
	Local $aChartDarkEBonus[96]

	Local $aChartWasStartClicked[96]

	If FileExists($ChartPath&"Attack.ini") Then
		FileOpen($ChartPath&"Attack.ini")
			$aChartGoldAttack = StringSplit(IniRead($ChartPath&"Attack.ini", "ChartData", "GoldAttack",""), "|", $STR_NOCOUNT)
			$aChartGoldBonus = StringSplit(IniRead($ChartPath&"Attack.ini", "ChartData", "GoldBonus",""), "|", $STR_NOCOUNT)

			$aChartElixirAttack = StringSplit(IniRead($ChartPath&"Attack.ini", "ChartData", "ElixirAttack",""), "|", $STR_NOCOUNT)
			$aChartElixirBonus = StringSplit(IniRead($ChartPath&"Attack.ini", "ChartData", "ElixirBonus",""), "|", $STR_NOCOUNT)

			$aChartDarkEAttack = StringSplit(IniRead($ChartPath&"Attack.ini", "ChartData", "DarkEAttack",""), "|", $STR_NOCOUNT)
			$aChartDarkEBonus = StringSplit(IniRead($ChartPath&"Attack.ini", "ChartData", "DarkEBonus",""), "|", $STR_NOCOUNT)

			$aChartWasStartClicked = StringSplit(IniRead($ChartPath&"Attack.ini", "ChartData", "WasFirstAttack",""), "|", $STR_NOCOUNT)
		FileClose($ChartPath&"Attack.ini")
	Else
		SetLog("No Chart Data Found")
		Return
	EndIf
	Local $max = 0
	Local $maxDark = 0; To Look for Max value on the Neg side
	;_ArrayMax($arValues,1);compare numerically
	If $max < _ArrayMax($aChartGoldAttack, 1) Then $max = _ArrayMax($aChartGoldAttack, 1)
	If $max < _ArrayMax($aChartElixirAttack, 1) Then $max = _ArrayMax($aChartElixirAttack, 1)
	If $max < _ArrayMax($aChartGoldBonus, 1) Then $max = _ArrayMax($aChartGoldBonus, 1)
	If $max < _ArrayMax($aChartElixirBonus, 1) Then $max = _ArrayMax($aChartElixirBonus, 1)

	If $maxDark < _ArrayMax($aChartDarkEAttack, 1) Then $maxDark = _ArrayMax($aChartDarkEAttack, 1)
	If $maxDark < _ArrayMax($aChartDarkEBonus, 1) Then $maxDark = _ArrayMax($aChartDarkEBonus, 1)
	$max = $max / 1000

    ;create frame for the chart
    $grp = GUICtrlCreateGroup("", $iX, $iY, $iW, $iH)

    ;title
    GUICtrlCreateLabel($sTitle1,$iX+15, $iY+10,$iW-30,-1,$SS_CENTER)
    GUICtrlSetColor(-1,0x002244)
    GUICtrlSetFont(-1, 9, 800, 0, "Arial")
    GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
    GUICtrlCreateLabel($sTitle2,$iX+15, $iY+25,$iW-30,-1,$SS_CENTER)
    GUICtrlSetColor(-1,0x002244)
    GUICtrlSetFont(-1, 8, 800, 0, "Arial")
    GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
    Local $Canvas

	; X axis Lables
	$Canvas = _CreateBarCanvas($iX+15, $iY+15, $iW-50, $iH-60)
		GUICtrlCreateLabel( "Oldest           ------------->           Newest",$iX+52+(($Canvas[2]/96))*35,$iY+$iH-18)
			GUICtrlSetColor(-1,0x990000)
			GUICtrlSetFont(-1, 8, 800, 0, "Arial")
			GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)

    ;draw the Lines
    GUICtrlCreateGraphic($Canvas[0]-0.5*$Canvas[4], $Canvas[1]+0.5*$Canvas[4], $Canvas[2], $Canvas[3],0)
		;Dark Attack
		Local $icount = -1
		;Find First Non Zero Number
		For $i = 0 to UBound($aChartDarkEAttack) -1
			If $aChartDarkEAttack[$i] <> 0 or $aChartDarkEAttack[$i] <> "" Then
				$icount = $i -1
				ExitLoop
			EndIf
		Next
		If $icount = -1 Then $icount = 0
		For $i = 0 to UBound($aChartDarkEAttack) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorDark)

			If $i = $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 5 + ($Canvas[2] / UBound($aChartDarkEAttack)) * $i, -2 + $Canvas[3] - ($Canvas[3] / _RoundUp($maxDark)) * $aChartDarkEAttack[$i])
			EndIf
			If $i > $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_LINE, 5 + ($Canvas[2] / UBound($aChartDarkEAttack)) * $i, -2 + $Canvas[3] - ($Canvas[3] / _RoundUp($maxDark)) * $aChartDarkEAttack[$i])
			EndIf
		Next
		;Dark Bonus
		Local $icount = -1
		;Find First Non Zero Number
		For $i = 0 to UBound($aChartDarkEBonus) -1
			If $aChartDarkEBonus[$i] <> 0 or $aChartDarkEBonus[$i] <> "" Then
				$icount = $i -1
				ExitLoop
			EndIf
		Next
		If $icount = -1 Then $icount = 0
		For $i = 0 to UBound($aChartDarkEBonus) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorDark) ;<-Need a new Color

			If $i = $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 5 + ($Canvas[2] / UBound($aChartDarkEBonus)) * $i, -2 + $Canvas[3] - ($Canvas[3] / _RoundUp($maxDark)) * $aChartDarkEBonus[$i])
			EndIf
			If $i > $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_LINE, 5 + ($Canvas[2] / UBound($aChartDarkEBonus)) * $i, -2 + $Canvas[3] - ($Canvas[3] / _RoundUp($maxDark)) * $aChartDarkEBonus[$i])
			EndIf
		Next

		;Elixir Attack
		Local $icount = -1
		;Find First Non Zero Number
		For $i = 0 to UBound($aChartElixirAttack) -1
			If $aChartElixirAttack[$i] <> 0 or $aChartElixirAttack[$i] <> "" Then
				$icount = $i -1
				ExitLoop
			EndIf
		Next
		If $icount = -1 Then $icount = 0
		For $i = 0 to UBound($aChartElixirAttack) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorElixir)

			If $i = $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 5 + ($Canvas[2] / UBound($aChartElixirAttack)) * $i, -2 + $Canvas[3] - ($Canvas[3] / _RoundUp($max)) * $aChartElixirAttack[$i] / 1000)
			EndIf
			If $i > $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_LINE, 5 + ($Canvas[2] / UBound($aChartElixirAttack)) * $i, -2 + $Canvas[3] - ($Canvas[3] / _RoundUp($max)) * $aChartElixirAttack[$i] / 1000)
			EndIf
		Next
		;Elixir Bonus
		Local $icount = -1
		;Find First Non Zero Number
		For $i = 0 to UBound($aChartElixirBonus) -1
			If $aChartElixirBonus[$i] <> 0 or $aChartElixirBonus[$i] <> "" Then
				$icount = $i -1
				ExitLoop
			EndIf
		Next
		If $icount = -1 Then $icount = 0
		For $i = 0 to UBound($aChartElixirBonus) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorElixir) ; <-Need a new Color

			If $i = $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 5 + ($Canvas[2] / UBound($aChartElixirBonus)) * $i, -2 + $Canvas[3] - ($Canvas[3] / _RoundUp($max)) * $aChartElixirBonus[$i] / 1000)
			EndIf
			If $i > $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_LINE, 5 + ($Canvas[2] / UBound($aChartElixirBonus)) * $i, -2 + $Canvas[3] - ($Canvas[3] / _RoundUp($max)) * $aChartElixirBonus[$i] / 1000)
			EndIf
		Next

		;Gold Attack
		Local $icount = -1
		;Find First Non Zero Number
		For $i = 0 to UBound($aChartGoldAttack) -1
			If $aChartGoldAttack[$i] <> 0 or $aChartGoldAttack[$i] <> "" Then
				$icount = $i -1
				ExitLoop
			EndIf
		Next
		If $icount = -1 Then $icount = 0
		For $i = 0 to UBound($aChartGoldAttack) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorGold)

			If $i = $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 5 + ($Canvas[2] / UBound($aChartGoldAttack)) * $i, -2 + $Canvas[3] - ($Canvas[3] / _RoundUp($max)) * $aChartGoldAttack[$i] / 1000)
			EndIf
			If $i > $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_LINE, 10 + ($Canvas[2] / UBound($aChartGoldAttack)) * $i, -2 + $Canvas[3] - ($Canvas[3] / _RoundUp($max)) * $aChartGoldAttack[$i] / 1000)
			EndIf
		Next
		;Gold Bonus
		Local $icount = -1
		;Find First Non Zero Number
		For $i = 0 to UBound($aChartGoldBonus) -1
			If $aChartGoldBonus[$i] <> 0 or $aChartGoldBonus[$i] <> "" Then
				$icount = $i -1
				ExitLoop
			EndIf
		Next
		If $icount = -1 Then $icount = 0
		For $i = 0 to UBound($aChartGoldBonus) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorGold) ;<-Need a new Color

			If $i = $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 5 + ($Canvas[2] / UBound($aChartGoldBonus)) * $i, -2 + $Canvas[3] - ($Canvas[3] / _RoundUp($max)) * $aChartGoldBonus[$i] / 1000)
			EndIf
			If $i > $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_LINE, 10 + ($Canvas[2] / UBound($aChartGoldBonus)) * $i, -2 + $Canvas[3] - ($Canvas[3] / _RoundUp($max)) * $aChartGoldBonus[$i] / 1000)
			EndIf
		Next

		;Green Circle's to indicate Fresh Starts
		For $i = 0 to UBound($aChartWasStartClicked) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x25ba07)
			If $aChartWasStartClicked[$i] = "True" Then
				GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 5+($Canvas[2]/UBound($aChartWasStartClicked))*$i+$j, -2+$Canvas[3]-$j, 0.5*($Canvas[2]/UBound($aChartWasStartClicked)), 0.5*($Canvas[2]/UBound($aChartWasStartClicked)) )
			EndIf
		Next

    GUICtrlSetGraphic(-1,$GUI_GR_REFRESH)

	;Lables for Y axis
    For $i=0 To $Canvas[3] Step $Canvas[3]/5
		If ($i/$Canvas[3])*_RoundUp($max) = 0 Then
			GUICtrlCreateLabel(($i/$Canvas[3])*_RoundUp($max),$Canvas[0]-65,$Canvas[1]+$Canvas[3]+$Canvas[4]-$i,30,-1,$SS_RIGHT)
			GUICtrlSetColor(-1,0x990000)
			GUICtrlSetFont(-1, 8, 800, 0, "Arial")
			GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
		Else
			GUICtrlCreateLabel(($i/$Canvas[3])*_RoundUp($max) & " K",$Canvas[0]-65,$Canvas[1]+$Canvas[3]+$Canvas[4]-$i - 5,30,-1,$SS_RIGHT)
				GUICtrlSetColor(-1,0x990000)
				;GUICtrlSetFont(-1, 8, 800, 0, "Arial")
				GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)

			GUICtrlCreateLabel(($i/$Canvas[3])*_RoundUp($maxDark),$Canvas[0]-65,$Canvas[1]+$Canvas[3]+$Canvas[4]-$i + 5,30,-1,$SS_RIGHT)
				;GUICtrlSetColor(-1,0x990000)
				GUICtrlSetFont(-1, 8, 800, 0, "Arial")
				GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
		EndIf
    Next
GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc


Func _CreateBarChart3($sTitle1="",$sTitle2="",$iX=20,$iY=20,$iW=400,$iH=400)
	Local $colorGold = 0xFFD700
	Local $colorElixir =0xDD1AD5
	Local $colorDark = 0x242024
	Local $colorRed = 0xed0404
	;set default values for the frame
    If $iX=-1 Then $iX=20
    If $iY=-1 Then $iY=20
    If $iW=-1 Then $iW=400
    If $iH=-1 Then $iH=400

	;Read File to Array
	Local $aChartGoldRate[96]
	Local $aChartElixirRate[96]
	Local $aChartDarkERate[96]
	Local $aChartWasStartClicked[96]

	If FileExists($ChartPath&"Total.ini") Then
		FileOpen($ChartPath&"Total.ini")
			$aChartGoldRate = StringSplit(IniRead($ChartPath&"Rate.ini", "ChartData", "GoldRate",""), "|", $STR_NOCOUNT)
			$aChartElixirRate = StringSplit(IniRead($ChartPath&"Rate.ini", "ChartData", "ElixirRate",""), "|", $STR_NOCOUNT)
			$aChartDarkERate = StringSplit(IniRead($ChartPath&"Rate.ini", "ChartData", "DarkERate",""), "|", $STR_NOCOUNT)
			$aChartWasStartClicked = StringSplit(IniRead($ChartPath&"Rate.ini", "ChartData", "WasFirstRate",""), "|", $STR_NOCOUNT)
		FileClose($ChartPath&"Total.ini")
	Else
		SetLog("No Chart Data Found")
		Return
	EndIf
	Local $maxHalf = 0
	Local $maxMin = 0; To Look for Max value on the Neg side

	If Number($maxHalf) < _ArrayMax($aChartGoldRate, 1) Then $maxHalf = _ArrayMax($aChartGoldRate, 1)
	If Number($maxHalf) < _ArrayMax($aChartElixirRate, 1) Then $maxHalf = _ArrayMax($aChartElixirRate, 1)
	If Number($maxHalf) < _ArrayMax($aChartDarkERate, 1) Then $maxHalf = _ArrayMax($aChartDarkERate, 1)

	If Number($maxMin) > _ArrayMin($aChartGoldRate, 1) Then $maxMin = _ArrayMin($aChartGoldRate, 1)
	If Number($maxMin) > _ArrayMin($aChartElixirRate, 1) Then $maxMin = _ArrayMin($aChartElixirRate, 1)
	If Number($maxMin) > _ArrayMin($aChartDarkERate, 1) Then $maxMin = _ArrayMin($aChartDarkERate, 1)

	If Abs($maxMin) > Number($maxHalf) Then $maxHalf = Abs($maxMin)

	;Set Scales for Chart Type
	Local $max = $maxHalf * 2  ;_ArrayMax($arValues,1);compare numerically
	;Local $maxDark = 200

    ;create frame for the chart
    $grp = GUICtrlCreateGroup("", $iX, $iY, $iW, $iH)

    ;title
    GUICtrlCreateLabel($sTitle1,$iX+15, $iY+10,$iW-30,-1,$SS_CENTER)
    GUICtrlSetColor(-1,0x002244)
    GUICtrlSetFont(-1, 9, 800, 0, "Arial")
    GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
    GUICtrlCreateLabel($sTitle2,$iX+15, $iY+25,$iW-30,-1,$SS_CENTER)
    GUICtrlSetColor(-1,0x002244)
    GUICtrlSetFont(-1, 8, 800, 0, "Arial")
    GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
    Local $Canvas

	; X axis Lables
	$Canvas = _CreateBarCanvas($iX+15, $iY+15, $iW-50, $iH-60)
;	For $i = 0 To 95 Step 4
;		GUICtrlCreateLabel( (96 -$i) /4 &" Hrs", $iX+52+(($Canvas[2]/96))*$i+5, $iY+$iH-30)
;			GUICtrlSetColor(-1,0x990000)
;			GUICtrlSetFont(-1, 8, 800, 0, "Arial")
;			GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
;	;Next
		GUICtrlCreateLabel( "Oldest           ------------->           Newest",$iX+52+(($Canvas[2]/96))*35,$iY+$iH-18)
			GUICtrlSetColor(-1,0x990000)
			GUICtrlSetFont(-1, 8, 800, 0, "Arial")
			GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)

    ;draw the Lines
    GUICtrlCreateGraphic($Canvas[0]-0.5*$Canvas[4], $Canvas[1]+0.5*$Canvas[4], $Canvas[2], $Canvas[3],0)


		;Dark
		Local $icount = -1
		;Find First Non Zero Number
		For $i = 0 to UBound($aChartGoldRate) -1
			If $aChartGoldRate[$i] <> 0 or $aChartGoldRate[$i] <> "" Then
				$icount = $i -1
				ExitLoop
			EndIf
		Next
		If $icount = -1 Then $icount = 0
		For $i = 0 to UBound($aChartDarkERate) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorDark)
			If $i = $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 5+($Canvas[2]/UBound($aChartDarkERate))*$i, -2+$Canvas[3] - ($Canvas[3]/_RoundUp($max))*($aChartDarkERate[$i]+$maxHalf))
			EndIf
			If $i > $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_LINE, 5+($Canvas[2]/UBound($aChartDarkERate))*$i, -2+$Canvas[3] - ($Canvas[3]/_RoundUp($max))*($aChartDarkERate[$i]+$maxHalf))
			EndIf
		Next
		;Elixir
		$icount = -1
		;Find First Non Zero Number
		For $i = 0 to UBound($aChartGoldRate) -1
			If $aChartGoldRate[$i] <> 0 or $aChartGoldRate[$i] <> "" Then
				$icount = $i -1
				ExitLoop
			EndIf
		Next
		If $icount = -1 Then $icount = 0
		For $i = 0 to UBound($aChartElixirRate) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorElixir)
			If $i = $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 5+($Canvas[2]/UBound($aChartElixirRate))*$i, -2 + $Canvas[3] - ($Canvas[3] / _RoundUp($max))*($aChartElixirRate[$i]+$maxHalf) )
			EndIf
			If $i > $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_LINE, 5+($Canvas[2]/UBound($aChartElixirRate))*$i, -2 + $Canvas[3] - ($Canvas[3] / _RoundUp($max))*($aChartElixirRate[$i]+$maxHalf) )
			EndIf
		Next

		;Gold
		$icount = -1
		;Find First Non Zero Number
		For $i = 0 to UBound($aChartGoldRate) -1
			If $aChartGoldRate[$i] <> 0 or $aChartGoldRate[$i] <> "" Then
				$icount = $i -1
				ExitLoop
			EndIf
		Next
		If $icount = -1 Then $icount = 0
		For $i = 0 to UBound($aChartGoldRate) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorGold)
			If $i = $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 5+($Canvas[2]/UBound($aChartGoldRate))*$i, -2+$Canvas[3] - ($Canvas[3]/_RoundUp($max))*($aChartGoldRate[$i]+$maxHalf) )
			EndIf
			If $i > $icount Then
				GUICtrlSetGraphic(-1, $GUI_GR_LINE, 5+($Canvas[2]/UBound($aChartGoldRate))*$i, -2+$Canvas[3] - ($Canvas[3]/_RoundUp($max))*($aChartGoldRate[$i]+$maxHalf) )
			EndIf

		Next
		;Draw Red Zero Line
		For $i = 0 to UBound($aChartDarkERate) -1 Step 4
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 1)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorRed)
			If $i = 0 Then
				GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 5+($Canvas[2]/UBound($aChartDarkERate))*$i, -2+$Canvas[3] - ($Canvas[3]/_RoundUp($max))*(0+$maxHalf))
			Else
				GUICtrlSetGraphic(-1, $GUI_GR_LINE, 50+($Canvas[2]/UBound($aChartDarkERate))*$i, -2+$Canvas[3] - ($Canvas[3]/_RoundUp($max))*(0+$maxHalf))
			EndIf
		Next


		;Green Circle's to indicate Fresh Starts
		For $i = 0 to UBound($aChartWasStartClicked) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x25ba07)
			If $aChartWasStartClicked[$i] = "True" Then
 				GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, -25+($Canvas[2]/UBound($aChartWasStartClicked))*$i+$j, -2+$Canvas[3]-$j, 0.5*($Canvas[2]/UBound($aChartWasStartClicked)), 0.5*($Canvas[2]/UBound($aChartWasStartClicked)) )
			EndIf
		Next

    GUICtrlSetGraphic(-1,$GUI_GR_REFRESH)

	;Lables for Y axis
    For $i=0 To $Canvas[3] Step $Canvas[3]/5
		If ($i/$Canvas[3])*_RoundUp($max)- ($maxHalf) = 0 Then
			GUICtrlCreateLabel(($i/$Canvas[3])*_RoundUp($max)- ($maxHalf),$Canvas[0]-65,$Canvas[1]+$Canvas[3]+$Canvas[4]-$i,30,-1,$SS_RIGHT)
			GUICtrlSetColor(-1,0x990000)
			GUICtrlSetFont(-1, 8, 800, 0, "Arial")
			GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
		Else
			GUICtrlCreateLabel(($i/$Canvas[3])*_RoundUp($max) - ($maxHalf) & " /Hr",$Canvas[0]-65,$Canvas[1]+$Canvas[3]+$Canvas[4]-$i - 5,30,-1,$SS_RIGHT)
				GUICtrlSetColor(-1,0x990000)
				GUICtrlSetFont(-1, 8, 800, 0, "Arial")
				GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
;			GUICtrlCreateLabel(($i/$Canvas[3])*_RoundUp($maxDark) & " K",$Canvas[0]-65,$Canvas[1]+$Canvas[3]+$Canvas[4]-$i + 5,30,-1,$SS_RIGHT)
;				;GUICtrlSetColor(-1,0x990000)
;				GUICtrlSetFont(-1, 8, 800, 0, "Arial")
;				GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
		EndIf
    Next
GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

Func _RoundUp($m)
    Local $rv = Round(Ceiling($m/10)*10,-1)
    ;ConsoleWrite($rv&@CRLF)
    Return $rv
EndFunc

Func _CreateBarCanvas($iX=0, $iY=0, $iW=400, $iH=400, $iDepthCanvas=30, $BgColor=0xEEEEEE)
    Local $iXCanvas=$iX+$iDepthCanvas
    Local $iYCanvas=$iY+10+2*$iDepthCanvas
    Local $iWCanvas=$iW-2*$iDepthCanvas
    Local $iHCanvas=$iH-2*$iDepthCanvas
    Local $BgColor2 = $BgColor - 0x333333
    ;create bg for the bars
    For $i=0 To $iDepthCanvas; Step 0.5
        GUICtrlCreateGraphic($iXCanvas+$i, $iYCanvas-$i, $iWCanvas, $iHCanvas, 0)
        GUICtrlSetBkColor(-1, $BgColor)
        GUICtrlSetColor(-1, $BgColor2)
    Next
    GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, $iHCanvas)
    GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $BgColor)
    GUICtrlSetGraphic(-1, $GUI_GR_LINE, -$iDepthCanvas-1, $iHCanvas+$iDepthCanvas+1)
    ;horizontal grid
    For $i=0 To $iHCanvas Step $iHCanvas/5
        GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, $i)
        GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $BgColor2)
        GUICtrlSetGraphic(-1, $GUI_GR_LINE, $iWCanvas, $i)

        GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, $i)
        GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $BgColor)
        GUICtrlSetGraphic(-1, $GUI_GR_LINE, -$iDepthCanvas, $i+$iDepthCanvas)
    Next
    Local $Canvas = StringSplit($iXCanvas+$iDepthCanvas &"|"& $iYCanvas-$iDepthCanvas&"|"&$iWCanvas&"|"&$iHCanvas&"|"&$iDepthCanvas,"|",2)
    ;ConsoleWrite($iXCanvas+$iDepthCanvas &"|"& $iYCanvas-$iDepthCanvas&"|"&$iWCanvas&"|"&$iHCanvas&@CRLF)
    Return $Canvas
EndFunc

Func _CreateBarChart2($sTitle1="",$sTitle2="",$iX=20,$iY=20,$iW=400,$iH=400)
	Local $colorGold = 0xFFD700
	Local $colorElixir =0xDD1AD5
	Local $colorDark = 0x242024
	;set default values for the frame
    If $iX=-1 Then $iX=20
    If $iY=-1 Then $iY=20
    If $iW=-1 Then $iW=400
    If $iH=-1 Then $iH=400

	;Read File to Array
	Local $aChartGold24hr[24]
	Local $aChartElixir24hr[24]
	Local $aChartDarkE24hr[24]
	Local $aChartWasStartClicked[24]
	;Read File to Array
	If FileExists($ChartPath&"Total.ini") Then
		FileOpen($ChartPath&"Total.ini")
			$aChartGold24hr = StringSplit(IniRead($ChartPath&"Total.ini", "ChartData", "GoldTotal","0"), "|", $STR_NOCOUNT)
			$aChartElixir24hr = StringSplit(IniRead($ChartPath&"Total.ini", "ChartData", "ElixirTotal","0"), "|", $STR_NOCOUNT)
			$aChartDarkE24hr = StringSplit(IniRead($ChartPath&"Total.ini", "ChartData", "DarkETotal","0"), "|", $STR_NOCOUNT)
			$aChartWasStartClicked = StringSplit(IniRead($ChartPath&"Total.ini", "ChartData", "WasStart","False"), "|", $STR_NOCOUNT)
		FileClose($ChartPath&"Total.ini")
	Else
		SetLog("No Chart Data Found")
		Return
	EndIf
	;Set Scales for Chart Type
	Local $max = 10;_ArrayMax($arValues,1);compare numerically
	Local $maxDark = 200

    ;create frame for the chart
    $grp = GUICtrlCreateGroup("", $iX, $iY, $iW, $iH)

    ;title
    GUICtrlCreateLabel($sTitle1,$iX+15, $iY+10,$iW-30,-1,$SS_CENTER)
    GUICtrlSetColor(-1,0x002244)
    GUICtrlSetFont(-1, 9, 800, 0, "Arial")
    GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
    GUICtrlCreateLabel($sTitle2,$iX+15, $iY+25,$iW-30,-1,$SS_CENTER)
    GUICtrlSetColor(-1,0x002244)
    GUICtrlSetFont(-1, 8, 800, 0, "Arial")
    GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
    Local $Canvas

	; X axis Lables
	$Canvas = _CreateBarCanvas($iX+15, $iY+15, $iW-50, $iH-60)
	For $i = 0 To 95 Step 4
		GUICtrlCreateLabel( (96 -$i) /4 &" Hrs", $iX+52+(($Canvas[2]/96))*$i+5, $iY+$iH-30)
		GUICtrlSetColor(-1,0x990000)
		GUICtrlSetFont(-1, 8, 800, 0, "Arial")
		GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
        Next
		GUICtrlCreateLabel( "Oldest           ------------->           Newest",$iX+52+(($Canvas[2]/96))*35,$iY+$iH-18)
		GUICtrlSetColor(-1,0x990000)
		GUICtrlSetFont(-1, 8, 800, 0, "Arial")
		GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)

    ;draw the Lines
    GUICtrlCreateGraphic($Canvas[0]-0.5*$Canvas[4], $Canvas[1]+0.5*$Canvas[4], $Canvas[2], $Canvas[3],0)
		;Dark
		For $i = 0 to UBound($aChartDarkE24hr) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorDark)
			If $i = 0 Then
				GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 5+($Canvas[2]/UBound($aChartDarkE24hr))*$i+$j, -2+$Canvas[3]-$j - ($Canvas[3]/_RoundUp($maxDark))*$aChartDarkE24hr[$i]/1000)
			Else
				GUICtrlSetGraphic(-1, $GUI_GR_LINE, 5+($Canvas[2]/UBound($aChartDarkE24hr))*$i+$j, -2+$Canvas[3]-$j - ($Canvas[3]/_RoundUp($maxDark))*$aChartDarkE24hr[$i]/1000)
			EndIf
		Next
		;Gold
		For $i = 0 to UBound($aChartGold24hr) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorGold)
			If $i = 0 Then
				GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 5+($Canvas[2]/UBound($aChartGold24hr))*$i+$j, -2+$Canvas[3]-$j - ($Canvas[3]/_RoundUp($max))*$aChartGold24hr[$i]/1000000)
			Else
				GUICtrlSetGraphic(-1, $GUI_GR_LINE, 5+($Canvas[2]/UBound($aChartGold24hr))*$i+$j, -2+$Canvas[3]-$j - ($Canvas[3]/_RoundUp($max))*$aChartGold24hr[$i]/1000000)
			EndIf
		Next
		;Elixir
		For $i = 0 to UBound($aChartElixir24hr) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorElixir)
			If $i = 0 Then
				GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 5+($Canvas[2]/UBound($aChartElixir24hr))*$i+$j, -2+$Canvas[3]-$j - ($Canvas[3]/_RoundUp($max))*$aChartElixir24hr[$i]/1000000)
			Else
				GUICtrlSetGraphic(-1, $GUI_GR_LINE, 5+($Canvas[2]/UBound($aChartElixir24hr))*$i+$j, -2+$Canvas[3]-$j - ($Canvas[3]/_RoundUp($max))*$aChartElixir24hr[$i]/1000000)
			EndIf
		Next
		;Green Circle's to indicate Fresh Starts
		For $i = 0 to UBound($aChartWasStartClicked) -1
			GUICtrlSetGraphic(-1, $GUI_GR_PENSIZE, 3)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x25ba07)
			If $aChartWasStartClicked[$i] = "True" Then
				GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 5+($Canvas[2]/UBound($aChartWasStartClicked))*$i+$j, -2+$Canvas[3]-$j, 0.5*($Canvas[2]/UBound($aChartWasStartClicked)), 0.5*($Canvas[2]/UBound($aChartWasStartClicked)) )
			EndIf
		Next

    GUICtrlSetGraphic(-1,$GUI_GR_REFRESH)

	;Lables for Y axis
    For $i=0 To $Canvas[3] Step $Canvas[3]/5
		If ($i/$Canvas[3])*_RoundUp($max) = 0 Then
			GUICtrlCreateLabel(($i/$Canvas[3])*_RoundUp($max),$Canvas[0]-65,$Canvas[1]+$Canvas[3]+$Canvas[4]-$i,30,-1,$SS_RIGHT)
			GUICtrlSetColor(-1,0x990000)
			GUICtrlSetFont(-1, 8, 800, 0, "Arial")
			GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
		Else
			GUICtrlCreateLabel(($i/$Canvas[3])*_RoundUp($max) & " M",$Canvas[0]-65,$Canvas[1]+$Canvas[3]+$Canvas[4]-$i - 5,30,-1,$SS_RIGHT)
				GUICtrlSetColor(-1,0x990000)
				;GUICtrlSetFont(-1, 8, 800, 0, "Arial")
				GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
			GUICtrlCreateLabel(($i/$Canvas[3])*_RoundUp($maxDark) & " K",$Canvas[0]-65,$Canvas[1]+$Canvas[3]+$Canvas[4]-$i + 5,30,-1,$SS_RIGHT)
				;GUICtrlSetColor(-1,0x990000)
				GUICtrlSetFont(-1, 8, 800, 0, "Arial")
				GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
		EndIf
    Next
GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc

Func _CreateBarChart1($sTitle1="",$sTitle2="",$iX=20,$iY=20,$iW=400,$iH=400 )
    Local $max = 10;_ArrayMax($arValues,1);compare numerically
	Local $maxDark = 200
	Local $arNames[96]
	Local $arValues[96]
    Local $arColours[UBound($arNames)]
	Local $GraphStartPushed[96]
	Local $colorGold = 0xFFD700
	Local $colorGoldsh = 0xaaab0d
	Local $colorElixir =0xDD1AD5
	Local $colorElixirsh = 0xba2cb5
	Local $colorDark = 0x242024

	;Assign matching colors to correct slots.
    For $i=0 To UBound($arValues)-1 Step 4
        $arColours[$i] = $colorGold
		$arColours[$i+1] = $colorElixir
		$arColours[$i+2] = $colorDark
    Next

	;Read File to Array
	Local $aChartGold24hr[24]
	Local $aChartElixir24hr[24]
	Local $aChartDarkE24hr[24]
	Local $aChartWasStartClicked[24]

	If FileExists($ChartPath&"Total.ini") Then
		FileOpen($ChartPath&"Total.ini")
	;Load the Arrays with Data
		$aChartGold24hr = StringSplit(IniRead($ChartPath&"Total.ini", "ChartData", "GoldTotal","0"), "|", $STR_NOCOUNT)
		$aChartElixir24hr = StringSplit(IniRead($ChartPath&"Total.ini", "ChartData", "ElixirTotal","0"), "|", $STR_NOCOUNT)
		$aChartDarkE24hr = StringSplit(IniRead($ChartPath&"Total.ini", "ChartData", "DarkETotal","0"), "|", $STR_NOCOUNT)
		$aChartWasStartClicked = StringSplit(IniRead($ChartPath&"Total.ini", "ChartData", "WasStart","False"), "|", $STR_NOCOUNT)
		FileClose($ChartPath&"Total.ini")
	Else
		SetLog("No Chart Data Found")
		Return
	EndIf


    For $i=0 To 95
        $arNames[$i]=UBound($arNames) -$i ; 96
    Next
	Local $j=0
    For $i=0 To UBound($arValues) - 1 Step 4
        $arValues[$i] = Round(Number($aChartGold24hr[$j])/1000000, 3)    ;<----Load Gold data points
		$arValues[$i + 1] = Round(Number($aChartElixir24hr[$j])/1000000, 3) ;<----Load Elixir data Points
		$arValues[$i + 2] = Round(Number($aChartDarkE24hr[$j]), 3) ;<----Load Dark E Data Points
		$arValues[$i + 3] = 0 ; <--- Needed for a space between the groupings of three per each hour point.
		$GraphStartPushed[$i] = 0
		$GraphStartPushed[$i + 1] = $aChartWasStartClicked[$j] ; load Values for marking data points where the bot was started
		$GraphStartPushed[$i + 2] = 0
		$GraphStartPushed[$i + 3] = 0
		$j += 1
    Next

    ;set default values for the frame
    If $iX=-1 Then $iX=20
    If $iY=-1 Then $iY=20
    If $iW=-1 Then $iW=400
    If $iH=-1 Then $iH=400

    ;create frame for the chart
    $grp = GUICtrlCreateGroup("", $iX, $iY, $iW, $iH)

    ;title
    GUICtrlCreateLabel($sTitle1,$iX+15, $iY+10,$iW-30,-1,$SS_CENTER)
    GUICtrlSetColor(-1,0x002244)
    GUICtrlSetFont(-1, 9, 800, 0, "Arial")
    GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
    GUICtrlCreateLabel($sTitle2,$iX+15, $iY+25,$iW-30,-1,$SS_CENTER)
    GUICtrlSetColor(-1,0x002244)
    GUICtrlSetFont(-1, 8, 800, 0, "Arial")
    GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
    Local $Canvas

	; X axis Lables
	$Canvas = _CreateBarCanvas($iX+15, $iY+15, $iW-50, $iH-60)
	For $i = 0 To UBound($arNames)-1 Step 4
		GUICtrlCreateLabel($arNames[($i)]/4 &" Hrs", $iX+52+(($Canvas[2]/UBound($arNames)))*$i+5, $iY+$iH-30)
		GUICtrlSetColor(-1,0x990000)
		GUICtrlSetFont(-1, 8, 800, 0, "Arial")
		GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
	Next
	GUICtrlCreateLabel( "Oldest           ------------->           Newest",$iX+52+(($Canvas[2]/UBound($arNames)))*35,$iY+$iH-18)
	GUICtrlSetColor(-1,0x990000)
	GUICtrlSetFont(-1, 8, 800, 0, "Arial")
	GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)


	;draw the bars
    GUICtrlCreateGraphic($Canvas[0]-0.5*$Canvas[4], $Canvas[1]+0.5*$Canvas[4], $Canvas[2], $Canvas[3],0)
    For $i=0 To UBound($arValues)-1
        For $j=$Canvas[4]/2.5 To 0 Step -0.5
			;Set the Bar Color
			If $arColours[$i] = $colorGold Then
				GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorGoldsh, $arColours[$i])

			ElseIf $arColours[$i] = $colorElixir Then
				GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $colorElixirsh, $arColours[$i])

			Else
				GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $arColours[$i] - 0x333333, $arColours[$i])
			EndIf
			; Draw the bar to correct scale, (dark vs gold or elixir) and add green circle if needed to middle bar
			If $arColours[$i] = $colorDark Then
				GUICtrlSetGraphic(-1, $GUI_GR_RECT, 5+($Canvas[2]/UBound($arValues))*$i+$j, -2+$Canvas[3]-$j, 0.9*($Canvas[2]/UBound($arValues)), -($Canvas[3]/_RoundUp($maxDark))*$arValues[$i]/1000)

			ElseIf $arColours[$i] = $colorElixir and $GraphStartPushed[$i] = "True" Then
				GUICtrlSetGraphic(-1, $GUI_GR_RECT, 5+($Canvas[2]/UBound($arValues))*$i+$j, -2+$Canvas[3]-$j, 0.9*($Canvas[2]/UBound($arValues)), -($Canvas[3]/_RoundUp($max))*$arValues[$i])
				GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x25ba07, 0x3bdd1a)
				GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 5+($Canvas[2]/UBound($arValues))*$i+$j, -2+$Canvas[3]-$j, 0.9*($Canvas[2]/UBound($arValues)), 0.9*($Canvas[2]/UBound($arValues)) )

			Else
				GUICtrlSetGraphic(-1, $GUI_GR_RECT, 5+($Canvas[2]/UBound($arValues))*$i+$j, -2+$Canvas[3]-$j, 0.9*($Canvas[2]/UBound($arValues)), -($Canvas[3]/_RoundUp($max))*$arValues[$i])

			EndIf
		Next
    Next
    GUICtrlSetGraphic(-1,$GUI_GR_REFRESH)

	;Lables for Y axis
    For $i=0 To $Canvas[3] Step $Canvas[3]/5
		If ($i/$Canvas[3])*_RoundUp($max) = 0 Then
			GUICtrlCreateLabel(($i/$Canvas[3])*_RoundUp($max),$Canvas[0]-65,$Canvas[1]+$Canvas[3]+$Canvas[4]-$i,30,-1,$SS_RIGHT)
			GUICtrlSetColor(-1,0x990000)
			GUICtrlSetFont(-1, 8, 800, 0, "Arial")
			GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
		Else
			GUICtrlCreateLabel(($i/$Canvas[3])*_RoundUp($max) & " M",$Canvas[0]-65,$Canvas[1]+$Canvas[3]+$Canvas[4]-$i - 5,30,-1,$SS_RIGHT)
				GUICtrlSetColor(-1,0x990000)
				;GUICtrlSetFont(-1, 8, 800, 0, "Arial")
				GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
			GUICtrlCreateLabel(($i/$Canvas[3])*_RoundUp($maxDark) & " K",$Canvas[0]-65,$Canvas[1]+$Canvas[3]+$Canvas[4]-$i + 5,30,-1,$SS_RIGHT)
				;GUICtrlSetColor(-1,0x990000)
				GUICtrlSetFont(-1, 8, 800, 0, "Arial")
				GUICtrlSetBkColor(-1,$GUI_BKCOLOR_TRANSPARENT)
		EndIf

    Next
    GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc
; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Child Mod - Options
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: LunaEclipse(February, 2016)
; Modified ......: TheRevenor (Jul, 2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
$hGUI_ModOptions = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_MOD)
GUISetBkColor($COLOR_WHITE, $hGUI_ModOptions)

GUISwitch($hGUI_ModOptions)

	; SmartZap Settings
	Local $x = 20, $y = 25
	$grpStatsMisc = GUICtrlCreateGroup(GetTranslated(705,1, "NewSmartZap"), $x - 20, $y - 20, 437, 218)
		GUICtrlCreateIcon($pIconLib, $eIcnNewSmartZap1, $x - 10, $y + 5, 25, 25)
		GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x - 10, $y + 42, 25, 25)
		$chkSmartLightSpell = GUICtrlCreateCheckbox(GetTranslated(705,2, "Use Lightning Spells to Zap Drills"), $x + 20 + 2, $y + 5, -1, -1)
		$txtTip = GetTranslated(705,3, "Check this to drop Lightning Spells on top of Dark Elixir Drills.") & @CRLF & @CRLF & _
				GetTranslated(705,4, "Remember to go to the tab 'troops' and put the maximum capacity ") & @CRLF & _
				GetTranslated(705,5, "of your spell factory and the number of spells so that the bot ") & @CRLF & _
				GetTranslated(705,6, "can function perfectly.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartLightSpell")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$chkNoobZap = GUICtrlCreateCheckbox(GetTranslated(705,7, "Use NoobZap to Zap any Dark Drills"), $x + 20 + 2, $y + 30, -1, -1)
			$txtTip = GetTranslated(705,8, "Check this to drop lightning spells on any Dark Elixir Drills,") & @CRLF & @CRLF & _
					  GetTranslated(705,9, "__If You Do Not Like SmartZap, This Is The Right Choice.__")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkNoobZap")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$chkSmartZapDB = GUICtrlCreateCheckbox(GetTranslated(705,10, "Only Zap Drills in Dead Bases"), $x + 20 + 2, $y + 55, -1, -1)
		$txtTip = GetTranslated(705,11, "It is recommended you only zap drills in dead bases as most of the ") & @CRLF & _
				GetTranslated(705,12, "Dark Elixir in a live base will be in the storage.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartZapDB")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 220 + 9, $y + 11, 24, 24)
	$grpNewSmartZap = GUICtrlCreateGroup("", $x + 219, $y - 1, 192, 106)
		$lblSmartZap = GUICtrlCreateLabel(GetTranslated(705,13, "Min. amount of Dark Elixir:"), $x + 180 + 79, $y + 12, -1, -1)
		$txtMinDark = GUICtrlCreateInput("250", $x + 309, $y + 32, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = GetTranslated(705,14, "The value here depends a lot on what level your Town Hall is, ") & @CRLF & _
				GetTranslated(705,15, "and what level drills you most often see.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "txtMinDark")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 220 + 9, $y + 57, 24, 24)
		$lblNoobZap = GUICtrlCreateLabel(GetTranslated(705,16, "Expected gain of Dark Drills:"), $x + 180 + 79, $y + 58, -1, -1)
		$txtExpectedDE = GUICtrlCreateInput("95", $x + 309, $y + 78, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = GetTranslated(705,17, "Set value for expected gain every dark drill") & @CRLF & _
				GetTranslated(705,18, "NoobZap will be stop if, last zap gained less DE then expected")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetOnEvent(-1, "txtExpectedDE")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkSmartZapSaveHeroes = GUICtrlCreateCheckbox(GetTranslated(705,19, "TH snipe NoZap if Heroes Deployed"), $x + 20 + 2, $y + 80, -1, -1)
		$txtTip = GetTranslated(705,20, "This will stop SmartZap from zapping a base on a Town Hall Snipe ") & @CRLF & _
				GetTranslated(705,21, "if your heroes were deployed. ") & @CRLF & @CRLF & _
				GetTranslated(705,22, "This protects their health so they will be ready for battle sooner!")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartZapSaveHeroes")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picSmartZap = GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x - 10, $y + 112, 24, 24)
		$lblLightningUsed = GUICtrlCreateLabel("0", $x + 20, $y + 110, 396, 30, $SS_CENTER)
			GUICtrlSetFont(-1, 16, $FW_BOLD, Default, "arial", $CLEARTYPE_QUALITY)
			GUICtrlSetBkColor (-1, 0xbfdfff)
			$txtTip = GetTranslated(705,23, "Amount of used spells.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlCreateIcon($pIconLib, $eIcnNewSmartZap2, $x - 12, $y + 150, 30, 30)
		$lblSmartZap = GUICtrlCreateLabel("0", $x + 20, $y + 150, 396, 30, $SS_CENTER)
			GUICtrlSetFont(-1, 16, $FW_BOLD, Default, "arial", $CLEARTYPE_QUALITY)
			GUICtrlSetBkColor (-1, 0xbfdfff)
			$txtTip = GetTranslated(705,24, "Number of dark elixir zapped during the attack with lightning.")
			GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

#cs	; CoC Starts
	Local $x = 20, $y = 155
	$grpCoCStats = GUICtrlCreateGroup("", $x - 20, $y, 438, 45)
		$y += 10
		$x += -10
		$chkCoCStats = GUICtrlCreateCheckbox(GetTranslated(654,23, "CoCStats Activate"), $x, $y, -1, -1)
			$txtTip = GetTranslated(654,24, "Activate sending raid results to CoCStats.com")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkCoCStats")
		$x += 135
		$lblAPIKey = GUICtrlCreateLabel(GetTranslated(654,25, "API Key:"), $x - 18, $y + 4, -1, 21, $SS_LEFT)
			$txtAPIKey = GUICtrlCreateInput("", $x + 30, $y, 250, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			$txtTip = GetTranslated(654,26, "Join in CoCStats.com and input API Key here")
			GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Collect Treasury
	Local $x = 226, $y = 95
	$grpTreasury = GUICtrlCreateGroup(GetTranslated(654,27, "Collect Treasury"), $x - 226, $y + 110, 438, 100)
	$chkCollectTresory = GUICtrlCreateCheckbox(GetTranslated(654,28, "Enable"), $x - 210, $y + 135, -1, -1)
		$txtTip = GetTranslated(654,29, "Enable auto collect of treasury.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkCollectTresory")
		GUICtrlSetState(-1, $GUI_UNCHECKED)
	$leurequisertarienTresor = GUICtrlCreateLabel("", $x - 180, $y + 135, -1, -1, $SS_RIGHT)
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x - 120, $y + 150, 16, 16)
		GUICtrlSetState(-1, $GUI_HIDE)
	$chkTRFull = GUICtrlCreateCheckbox(GetTranslated(654,30, "When Full"), $x - 210, $y + 165, -1, -1)
		$txtTip = GetTranslated(654,31, "Check to the bot collect the treasury when full")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetState(-1, $GUI_HIDE)

	$txtTreasuryGold = GUICtrlCreateInput("0", $x - 100, $y + 150, 60, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = GetTranslated(654,32, "Minimum Gold amount below which the bot will collect the treasury.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 7)
		GUICtrlSetState(-1, $GUI_HIDE)
	$chkCollectTresoryGold = GUICtrlCreateCheckbox(GetTranslated(654,33, "Gold"), $x - 90, $y + 125, -1, -1)
		$txtTip = GetTranslated(654,34, "Enable automatic collect of treasury according to Gold amount.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkCollectTresoryGold")
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x - 15, $y + 150, 16, 16)
		GUICtrlSetState(-1, $GUI_HIDE)
	$btnResetOR = GUICtrlCreateButton(GetTranslated(654,35, "Reset"), $x - 92, $y + 180, 45, 18)
		GUICtrlSetOnEvent(-1, "ResetOr")
		GUICtrlSetState(-1, $GUI_HIDE)

	$txtTreasuryElixir = GUICtrlCreateInput("0", $x + 5, $y + 150, 60, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = GetTranslated(654,36, "Minimum Elixir amount below which the bot will collect the treasury.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 7)
		GUICtrlSetState(-1, $GUI_HIDE)
	$chkCollectTresoryElixir = GUICtrlCreateCheckbox(GetTranslated(654,37, "Elixir"), $x + 10, $y + 125, -1, -1)
		$txtTip = GetTranslated(654,38, "Enable automatic collect of treasury according to Elixir amount.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkCollectTresoryElixir")
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 90, $y + 150, 16, 16)
		GUICtrlSetState(-1, $GUI_HIDE)
	$btnResetEL = GUICtrlCreateButton(GetTranslated(654,35, "Reset"), $x + 13, $y + 180, 45, 18)
		GUICtrlSetOnEvent(-1, "ResetEL")
		GUICtrlSetState(-1, $GUI_HIDE)

	$txtTreasuryDark = GUICtrlCreateInput("0", $x + 110, $y + 150, 60, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		$txtTip = GetTranslated(654,39, "Minimum Dark Elixir amount below which the bot will collect the treasury.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetLimit(-1, 6)
		GUICtrlSetState(-1, $GUI_HIDE)
	$chkCollectTresoryDark = GUICtrlCreateCheckbox(GetTranslated(654,40, "Dark Elixir"), $x + 115, $y + 125, -1, -1)
		$txtTip = GetTranslated(654,41, "Enable automatic collect of treasury according to Dark Elixir amount.")
		_GUICtrlSetTip(-1, $txtTip)
		GUICtrlSetOnEvent(-1, "chkCollectTresoryDark")
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		GUICtrlSetState(-1, $GUI_HIDE)
	$btnResetDE = GUICtrlCreateButton(GetTranslated(654,35, "Reset"), $x + 118, $y + 180, 45, 18)
		GUICtrlSetOnEvent(-1, "ResetDE")
		GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
#ce

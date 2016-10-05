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
    $grpStatsMisc = GUICtrlCreateGroup(GetTranslated(654,1, "Smart Zap && Extreme Zap"), $x - 20, $y - 20, 438, 148)
		GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x - 10, $y + 20, 24, 24)
		GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x - 10, $y - 7, 24, 24)
		$chkSmartLightSpell = GUICtrlCreateCheckbox(GetTranslated(654,2, "Use Lightning Spells to SmartZap Drills"), $x + 20, $y - 5, -1, -1)
			$txtTip = GetTranslated(654,3, "Check this to drop Lightning Spells on top of Dark Elixir Drills.") & @CRLF & @CRLF & _
					  GetTranslated(654,4, "Remember to go to the tab 'troops' and put the maximum capacity ") & @CRLF & _
					  GetTranslated(654,5, "of your spell factory and the number of spells so that the bot ") & @CRLF & _
					  GetTranslated(654,6, "can function perfectly.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartLightSpell")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$chkExtLightSpell = GUICtrlCreateCheckbox(GetTranslated(654,7, "Use ExtremeZap To Zap Dark Drill"), $x + 20, $y + 21, -1, -1)
			$txtTip = GetTranslated(654,8, "Check this to drop Extreme lightning spells on Dark Elixir Drills,") & @CRLF & @CRLF & _
					  GetTranslated(654,9, "__If You Do Not Like SmartZap, This Is The Right Choice.__")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "ExtLightSpell")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$chkSmartZapDB = GUICtrlCreateCheckbox(GetTranslated(654,10, "Only Zap Drills in Dead Bases"), $x + 20, $y + 47, -1, -1)
			$txtTip = GetTranslated(654,11, "It is recommended you only zap drills in dead bases as most of the ") & @CRLF & _
					  GetTranslated(654,12, "Dark Elixir in a live base will be in the storage.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartZapDB")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblSmartZap = GUICtrlCreateLabel(GetTranslated(654,13, "Min. amount of Dark Elixir:"), $x + 0, $y + 74, 160, -1, $SS_RIGHT)
		$txtMinDark = GUICtrlCreateInput("250", $x + 180, $y + 69, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		    $txtTip = GetTranslated(654,14, "The value here depends a lot on what level your Town Hall is, ") & @CRLF & _
					  GetTranslated(654,15, "and what level drills you most often see.") & @CRLF & @CRLF & _
					  GetTranslated(654,16, "Input The Min Dark Elixir If You Want To Extreme Drill Zap")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetOnEvent(-1, "txtMinDark")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkSmartZapSaveHeroes = GUICtrlCreateCheckbox(GetTranslated(654,17, "Don't Zap on Town Hall Snipe when Heroes Deployed"), $x + 20, $y + 94, -1, -1)
			$txtTip = GetTranslated(654,18, "This will stop SmartZap from zapping a base on a Town Hall Snipe ") & @CRLF & _
					  GetTranslated(654,19, "if your heroes were deployed. ") & @CRLF & @CRLF & _
					  GetTranslated(654,20, "This protects their health so they will be ready for battle sooner!")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSmartZapSaveHeroes")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
	Local $x = 236, $y = 25
		$picSmartZap = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 160, $y + 3, 24, 24)
		$lblSmartZap = GUICtrlCreateLabel("0", $x + 60, $y + 5, 80, 30, $SS_RIGHT)
			GUICtrlSetFont(-1, 16, $FW_BOLD, Default, "arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, 0x279B61)
			$txtTip = GetTranslated(654,21, "Number of dark elixir zapped during the attack with lightning.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x + 160, $y + 40, 24, 24)
		$lblLightningUsed = GUICtrlCreateLabel("0", $x + 60, $y + 40, 80, 30, $SS_RIGHT)
			GUICtrlSetFont(-1, 16, $FW_BOLD, Default, "arial", $CLEARTYPE_QUALITY)
			GUICtrlSetColor(-1, 0x279B61)
			$txtTip = GetTranslated(654,22, "Amount of used spells.")
			_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; CoC Starts
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

#cs	; Android Setting
	Local $x = 20, $y = 330
	$grpHideAndroid = GUICtrlCreateGroup(GetTranslated(654,42, "Android Options"), $x - 20, $y - 20, 438, 43)
		$cmbAndroid = GUICtrlCreateCombo("", $x - 10, $y - 5, 130, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(654,43, "Use this to select the Android Emulator to use with this profile.")
			_GUICtrlSetTip(-1, $txtTip)
			setupAndroidComboBox()
			GUICtrlSetState(-1, $GUI_SHOW)
			GUICtrlSetOnEvent(-1, "cmbAndroid")
		$lblAndroidInstance = GUICtrlCreateLabel(GetTranslated(654,44, "Instance:"), $x + 130, $y - 2 , 60, 21, $SS_RIGHT)
		$txtAndroidInstance = GUICtrlCreateInput("", $x + 200, $y - 5, 210, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
			$txtTip = GetTranslated(654,45, "Enter the Instance to use with this profile.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "txtAndroidInstance")
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
#ce

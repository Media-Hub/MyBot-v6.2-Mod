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
;    $grpStatsMisc = GUICtrlCreateGroup(GetTranslated(654,1, "Smart Zap && Extreme Zap"), $x - 20, $y - 20, 438, 148)
	$grpUnbreakableHelp = GUICtrlCreateGroup("Smart Zap && Extreme Zap", $x - 20, $y - 20, 440, 200)
	$txtHelp = "Wait For The Next Version"
	$lblUnbreakableHelp = GUICtrlCreateLabel($txtHelp, $x - 10, $y, 430, 125)
#cs		GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x - 10, $y + 20, 24, 24)
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
#ce
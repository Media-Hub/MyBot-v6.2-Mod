; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Child Mod - MultiCoC
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
$hGUI_MultiCoC = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_MOD)
GUISetBkColor($COLOR_WHITE, $hGUI_MultiCoC)

GUISwitch($hGUI_MultiCoC)

	; Multi Farming
	Local $x = 20, $y = 25
	$grpMultyFarming = GUICtrlCreateGroup( "Multi Farming With Smart Switch Setting", $x - 20, $y - 20, 438, 65)
	;$x -= 10
		$chkMultyFarming = GUICtrlCreateCheckbox(GetTranslated(17,1, "Multi Farming"), $x - 10, $y -7, -1 , -1)
			$txtTip = GetTranslated(17,3, "Will switch account and attack, then switch back")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "MultiFarming")
		$chkSwitchDonate = GUICtrlCreateCheckbox(GetTranslated(6,1, "Donate"), $x - 10, $y +13, -1, -1)
			$txtTip = GetTranslated(17,4, "Will switch account For Donate, then switch back")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "SwitchDonate")
		$Account = GUICtrlCreateInput("2", $x +170, $y -5, 18, 15, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(17,5, "How many account to use For multy-farming")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblmultyAcc = GUICtrlCreateLabel(GetTranslated(17,2, "How Many:"), $x +100, $y -2, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblmultyAccBtn = GUICtrlCreateLabel(GetTranslated(17, 22, "Fast Switch:"), $x +100, $y +18, -1, -1)
			$txtTip = GetTranslated(17, 22, "Fast switch between accounts")
			_GUICtrlSetTip(-1, $txtTip)
		$btnmultyAcc1 = GUICtrlCreateButton("#1", $x + 170, $y +15, 20, 18)
			$txtTip = GetTranslated(17,22, "Switch to Main Account")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnmultyAcc1")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$btnmultyAcc2 = GUICtrlCreateButton("#2", $x + 200, $y +15, 20, 18)
			$txtTip = GetTranslated(17,23, "Switch to Second Account")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnmultyAcc2")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$btnmultyAcc3 = GUICtrlCreateButton("#3", $x + 230, $y +15, 20, 18)
			$txtTip = GetTranslated(17,24, "Switch to Third Account")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnmultyAcc3")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$btnmultyAcc4 = GUICtrlCreateButton("#4", $x + 260, $y +15, 20, 18)
			$txtTip = GetTranslated(17,25, "Switch to Fourth Account")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnmultyAcc4")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$btnmultyAcc5 = GUICtrlCreateButton("#5", $x + 290, $y +15, 20, 18)
			$txtTip = GetTranslated(17,26, "Switch to Fifth Account")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnmultyAcc5")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$btnmultyAcc6 = GUICtrlCreateButton("#6", $x + 320, $y +15, 20, 18)
			$txtTip = GetTranslated(17,27, "Switch to Sixth Account")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnmultyAcc6")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$btnmultyDetectAcc = GUICtrlCreateButton("?", $x + 350, $y +15, 20, 18)
			$txtTip = GetTranslated(17,28, "Detect Current Account")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "btnmultyDetectAcc")
			GUICtrlSetState(-1, $GUI_ENABLE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Chalicucu & demen: switch CoC Acc GUI
	Local $x = 20, $y = 95
	GUICtrlCreateGroup("Switch CoC Accounts Setting", $x - 20, $y - 20, 438, 290)
		$chkSwitchAcc = GUICtrlCreateCheckbox("Enable Switch Account", $x - 10, $y - 5, -1, -1)
			$txtTip = "Switch to another account & profile when remain train time >=3 minutes" & @CRLF & _
			          "This function supports maximum 8 CoC accounts & 9 Bot profiles" & @CRLF & _
			          "Make sure to align the accounts with profiles in listing order"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSwitchAcc")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
	$y += 30
		$lbSwitchMode = GUICtrlCreateLabel("Switching Mode", $x, $y, 130, 20)
		$cmbSwitchMode = GUICtrlCreateCombo("", $x + 140, $y - 2, 110, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, "Choose switching mode for play list")
			GUICtrlSetData(-1, "Shortest Training" & "|" & "Ordered play list" & "|" & "Random")
			GUICtrlSetOnEvent(-1, "cmbSwitchMode")
			GUICtrlSetState (-1, $GUI_ENABLE)
	$y += 30
		$lbTotalCoCAcc = GUICtrlCreateLabel("Total CoC Accounts", $x , $y, 130, 20)
		$txtTotalCoCAcc = GUICtrlCreateInput("0", $x + 140 , $y - 2, 70, 20,  BitOR($SS_LEFT, $ES_AUTOHSCROLL))
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetTip(-1,"Number of Google Accounts on emulator. Supporting maximum 8 Accounts.")
	$y += 30
		$lbAccBottingOrder = GUICtrlCreateLabel("Accounts Playing List", $x , $y, 130, 20)
		$txtAccBottingOrder = GUICtrlCreateInput("12345678", $x + 140 , $y - 2, 70, 20,  BitOR($SS_LEFT, $ES_AUTOHSCROLL))
			GUICtrlSetTip(-1,"Input group of accounts you want to play.")
	$y += 30
		$lbProfileIdxOrder = GUICtrlCreateLabel("Mapping Profile Indexs", $x , $y, 130, 20)
		$txtProfileIdxOrder = GUICtrlCreateInput("12345678", $x + 140 , $y - 2, 70, 20,  BitOR($SS_LEFT, $ES_AUTOHSCROLL))
			GUICtrlSetLimit(-1, 8)
			GUICtrlSetTip(-1,"Input the order of Profiles correspond to CoC Accounts order.")
	$y += 30
		$chkAccRelax = GUICtrlCreateCheckbox("Attack relax together", $x, $y, -1, -1)
			$txtTip = "If attack is not planned for current profile" & @CRLF & _
			          "Then bot stop emulator and relax"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkAccRelaxTogether")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
	$x += 130
		$chkAtkPln = GUICtrlCreateCheckbox("Check attack plan", $x, $y, -1, -1)
			$txtTip = "Enable/Disable attack plan"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkAtkPln")
			GUICtrlSetState(-1, $GUI_UNCHECKED)
	Local $x = 30, $y = 270
		$lbMapHelpAccPro = GUICtrlCreateLabel("Mapped Acc - Profile:", $x, $y, 130, 20)
			GUICtrlSetColor(-1, $COLOR_BLUE)
	$y += 15
		$lbMapHelp = GUICtrlCreateLabel("", $x , $y, 230, 40)
			GUICtrlSetColor(-1, $COLOR_BLUE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)



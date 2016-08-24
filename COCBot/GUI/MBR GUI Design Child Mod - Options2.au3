; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Child Mod - Options2
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
$hGUI_ModOptions2 = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_MOD)
GUISetBkColor($COLOR_WHITE, $hGUI_ModOptions2)

GUISwitch($hGUI_ModOptions2)

$hGUI_ModOptions2_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))

$hGUI_ModOptions2_TAB_ITEM1 = GUICtrlCreateTabItem("Multi Accounts Option")
	Local $xStart = 0, $yStart = 0
	Local $x = $xStart + 30, $y = $yStart + 50
	$grpProfiles = GUICtrlCreateGroup(GetTranslated(7,26, "Switch Profiles"), $x - 25, $y - 25, 427, 85)
		$y -= 0
		$cmbProfile = GUICtrlCreateCombo("", $x - 15, $y + 1, 120, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip =GetTranslated(19,3, "Use this to switch to a different profile") & @CRLF & GetTranslated(19,4,"Your profiles can be found in") & ": " & @CRLF &  $sProfilePath
			_GUICtrlSetTip(-1, $txtTip)
			setupProfileComboBox()
			GUICtrlSetState(-1, $GUI_SHOW)
			GUICtrlSetOnEvent(-1, "cmbProfile")
		$txtVillageName = GUICtrlCreateInput(GetTranslated(19,5,"MyVillage"), $x - 15, $y, 120, 20, BitOR($SS_CENTER, $ES_AUTOHSCROLL))
			GUICtrlSetLimit (-1, 100, 0)
			GUICtrlSetFont(-1, 9, 400, 1)
			_GUICtrlSetTip(-1, GetTranslated(7,31, "Your village/profile's name"))
			GUICtrlSetState(-1, $GUI_HIDE)

		$bIconAdd = _GUIImageList_Create(22, 22, 4)
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd.bmp")
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd_2.bmp")
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd_2.bmp")
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd_4.bmp")
			_GUIImageList_AddBitmap($bIconAdd, @ScriptDir & "\images\Button\iconAdd.bmp")
		$bIconConfirm = _GUIImageList_Create(22, 22, 4)
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm.bmp")
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm_2.bmp")
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm_2.bmp")
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm_4.bmp")
			_GUIImageList_AddBitmap($bIconConfirm, @ScriptDir & "\images\Button\iconConfirm.bmp")
		$bIconDelete = _GUIImageList_Create(22, 22, 4)
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete.bmp")
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete_2.bmp")
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete_2.bmp")
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete_4.bmp")
			_GUIImageList_AddBitmap($bIconDelete, @ScriptDir & "\images\Button\iconDelete.bmp")
		$bIconCancel = _GUIImageList_Create(22, 22, 4)
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel.bmp")
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel_2.bmp")
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel_2.bmp")
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel_4.bmp")
			_GUIImageList_AddBitmap($bIconCancel, @ScriptDir & "\images\Button\iconCancel.bmp")
		$bIconEdit = _GUIImageList_Create(22, 22, 4)
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit.bmp")
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit_2.bmp")
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit_2.bmp")
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit_4.bmp")
			_GUIImageList_AddBitmap($bIconEdit, @ScriptDir & "\images\Button\iconEdit.bmp")
		; IceCube (Misc v1.0)
		$bIconRecycle = _GUIImageList_Create(22, 22, 4)
			_GUIImageList_AddBitmap($bIconRecycle, @ScriptDir & "\images\Button\iconRecycle.bmp")
			_GUIImageList_AddBitmap($bIconRecycle, @ScriptDir & "\images\Button\iconRecycle_2.bmp")
			_GUIImageList_AddBitmap($bIconRecycle, @ScriptDir & "\images\Button\iconRecycle_2.bmp")
			_GUIImageList_AddBitmap($bIconRecycle, @ScriptDir & "\images\Button\iconRecycle_4.bmp")
			_GUIImageList_AddBitmap($bIconRecycle, @ScriptDir & "\images\Button\iconRecycle.bmp")
		; IceCube (Misc v1.0)

		$btnAdd = GUICtrlCreateButton("", $x + 115, $y + 1, 22, 22)
			_GUICtrlButton_SetImageList($btnAdd, $bIconAdd, 4)
			GUICtrlSetOnEvent(-1, "btnAddConfirm")
			GUICtrlSetState(-1, $GUI_SHOW)
			_GUICtrlSetTip(-1, GetTranslated(7,103, "Add New Profile"))
		$btnConfirmAdd = GUICtrlCreateButton("", $x + 115, $y + 1, 22, 22)
			_GUICtrlButton_SetImageList($btnConfirmAdd, $bIconConfirm, 4)
			GUICtrlSetOnEvent(-1, "btnAddConfirm")
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, GetTranslated(7,104, "Confirm"))
		$btnConfirmRename = GUICtrlCreateButton("", $x + 115, $y + 1, 22, 22)
			_GUICtrlButton_SetImageList($btnConfirmRename, $bIconConfirm, 4)
			GUICtrlSetOnEvent(-1, "btnRenameConfirm")
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, GetTranslated(7,104, "Confirm"))
		$btnDelete = GUICtrlCreateButton("", $x + 142, $y + 1, 22, 22)
			_GUICtrlButton_SetImageList($btnDelete, $bIconDelete, 4)
			GUICtrlSetOnEvent(-1, "btnDeleteCancel")
			GUICtrlSetState(-1, $GUI_SHOW)
			_GUICtrlSetTip(-1, GetTranslated(7,105, "Delete Profile"))
			If GUICtrlRead($cmbProfile) = "<No Profiles>" Then
				GUICtrlSetState(-1, $GUI_DISABLE)
			Else
				GUICtrlSetState(-1, $GUI_ENABLE)
			EndIf

		$btnCancel = GUICtrlCreateButton("", $x + 142, $y + 1, 22, 22)
			_GUICtrlButton_SetImageList($btnCancel, $bIconCancel, 4)
			GUICtrlSetOnEvent(-1, "btnDeleteCancel")
			GUICtrlSetState(-1, $GUI_HIDE)
			_GUICtrlSetTip(-1, GetTranslated(7,106, "Cancel"))
		$btnRename = GUICtrlCreateButton("", $x + 170, $y + 1, 22, 22)
			_GUICtrlButton_SetImageList($btnRename, $bIconEdit, 4)
			GUICtrlSetOnEvent(-1, "btnRenameConfirm")
			_GUICtrlSetTip(-1, GetTranslated(7,107, "Rename Profile"))
			If GUICtrlRead($cmbProfile) = "<No Profiles>" Then
				GUICtrlSetState(-1, $GUI_DISABLE)
			Else
				GUICtrlSetState(-1, $GUI_ENABLE)
			EndIf
		; IceCube (Misc v1.0)
		$btnRecycle = GUICtrlCreateButton("", $x + 198, $y + 1, 22, 22)
			_GUICtrlButton_SetImageList($btnRecycle, $bIconRecycle, 4)
			GUICtrlSetOnEvent(-1, "btnRecycle")
			GUICtrlSetState(-1, $GUI_SHOW)
			_GUICtrlSetTip(-1, "Recycle Profile by removing all settings no longer suported that could lead to bad behaviour")
			If GUICtrlRead($cmbProfile) = "<No Profiles>" Then
				GUICtrlSetState(-1, $GUI_DISABLE)
			Else
				GUICtrlSetState(-1, $GUI_ENABLE)
			EndIf
		; IceCube (Misc v1.0)

; Defining botting type of eachh profile - SwitchAcc - DEMEN
	    $lblProfile = GUICtrlCreateLabel("Profile Type:", $x + 235, $y - 5, -1, -1)
			$txtTip = "Choosing type for this Profile" & @CRLF & "Active Profile for botting" & @CRLF & "Donate Profile for donating only" & @CRLF & "Idle Profile for staying inactive"
			GUICtrlSetTip(-1, $txtTip)

	    $radActiveProfile= GUICtrlCreateRadio("Active", $x + 235, $y + 13, -1, 16)
			GUICtrlSetTip(-1, "Set as Active Profile for training troops & attacking")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "radProfileType")

		$radDonateProfile = GUICtrlCreateRadio("Donate", $x + 295, $y + 13, -1, 16)
			GUICtrlSetTip(-1, "Set as Donating Profile for training troops & donating only")
			GUICtrlSetOnEvent(-1, "radProfileType")

		$radIdleProfile = GUICtrlCreateRadio("Idle", $x + 355, $y + 13, -1, 16)
			GUICtrlSetTip(-1, "Set as Idle Profile. The Bot will ignore this Profile")
			GUICtrlSetOnEvent(-1, "radProfileType")

	    $lblMatchProfileAcc = GUICtrlCreateLabel("Matching Acc. No.", $x + 235, $y + 37, -1, 16)
			$txtTip = "Select the index of CoC Account to match with this Profile"
			GUICtrlSetTip(-1, $txtTip)

		$cmbMatchProfileAcc = GUICtrlCreateCombo("", $x + 335, $y + 33, 60, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "---" & "|" & "Acc. 1" & "|" & "Acc. 2" & "|" & "Acc. 3" & "|" & "Acc. 4" & "|" & "Acc. 5" & "|" & "Acc. 6", "---")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "cmbMatchProfileAcc")

	GUICtrlCreateGroup("", -99, -99, 1, 1)
;GUISetState()

; SwitchAcc - DEMEN
	Local $x = 25, $y = 130
	$grpSwitchAcc = GUICtrlCreateGroup("Switch Account Mode", $x - 20, $y - 20, 210, 150)

		$chkSwitchAcc = GUICtrlCreateCheckbox("Enable Switch Account", $x - 10, $y, -1, -1)
			$txtTip = "Switch to another account & profile when troop training time is >= 3 minutes" & @CRLF & "This function supports maximum 6 CoC accounts & 6 Bot profiles" & @CRLF & "Make sure to create sufficient Profiles equal to number of CoC Accounts, and align the index of accounts order with profiles order"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSwitchAcc")

		$lblTotalAccount = GUICtrlCreateLabel("Total CoC Acc:", $x + 15, $y + 29, -1, -1)
			$txtTip = "Choose number of CoC Accounts pre-logged"
			GUICtrlSetState(-1, $GUI_DISABLE)

		$cmbTotalAccount= GUICtrlCreateCombo("", $x + 100, $y + 25, -1, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "Auto detect" & "|" & "1 Account" & "|" & "2 Accounts" & "|" & "3 Accounts" & "|" & "4 Accounts" & "|" & "5 Accounts" & "|" & "6 Accounts", "Auto detect")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$radSmartSwitch= GUICtrlCreateRadio("Smart switch", $x + 15 , $y + 55, -1, 16)
			GUICtrlSetTip(-1, "Switch to account with the shortest remain training time")
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$radNormalSwitch = GUICtrlCreateRadio("Normal switch", $x + 100, $y + 55, -1, 16)
			GUICtrlSetTip(-1, "Switching accounts continously")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "radNormalSwitch")

		$y += 80

		$chkUseTrainingClose = GUICtrlCreateCheckbox("Combo Sleep after Switch Account", $x, $y, -1, -1)
			$txtTip = "Close CoC combo with Switch Account when there is more than 3 mins remaining on training time of all accounts."
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUseTrainingClose")

		$radCloseCoC= GUICtrlCreateRadio("Close CoC", $x + 15 , $y + 30, -1, 16)
			GUICtrlSetState(-1, $GUI_CHECKED)

		$radCloseAndroid = GUICtrlCreateRadio("Close Android", $x + 100, $y + 30, -1, 16)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Profiles & Account matching

    Local $x = 238, $y = 130
	  $grpSwitchAccMapping = GUICtrlCreateGroup("Profiles", $x - 20, $y - 20, 215, 250)

		$btnUpdateProfiles = GUICtrlCreateButton("Update Profiles/ Acc matching", $x, $y - 5 , 170, 25)
		GUICtrlSetOnEvent(-1, "btnUpdateProfile")

		Global $lblProfileList[8]

	  $y += 25
		 For $i = 0 To 7
			$lblProfileList[$i] = GUICtrlCreateLabel("", $x, $y + ($i) * 25, 190, 18, $SS_LEFT)
		 Next

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Restart Android - DEMEN
	Local $x = 25, $y = 280
	$grpRestartAndroid = GUICtrlCreateGroup("Restart Android", $x - 20, $y - 20, 210, 100)

	    $chkRestartAndroid = GUICtrlCreateCheckbox("Restart Android every" & ":", $x, $y, -1, -1)
			$txtTip = "Restart Android after long searches or after getting stuck at opening train window"
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkRestartAndroid")
		$txtRestartAndroidSearchLimit = GUICtrlCreateInput("200", $x + 20, $y + 30, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblRestartAndroidSearchLimit = GUICtrlCreateLabel("Search(es)", $x + 57, $y + 32, -1, -1)

		$txtRestartAndroidTrainError = GUICtrlCreateInput("10", $x + 20, $y + 55, 30, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 4)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblRestartAndroidTrainError = GUICtrlCreateLabel("times error at Train Window", $x + 57, $y + 57, -1, -1)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

$hGUI_ModOptions2_TAB_ITEM2 = GUICtrlCreateTabItem("Switch Profile Option")
	; Switch Profile
	Local $xStart = 0, $yStart = 0
	Local $x = $xStart + 30, $y = $yStart + 50
	$grpGoldSwitch = GUICtrlCreateGroup(GetTranslated(19,7,"Gold Switch Profile Conditions"), $x - 20, $y - 20, 420, 75) ;Gold Switch
		$chkGoldSwitchMax = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x - 10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,9,"Enable this to switch profiles when gold is above amount.")
			_GUICtrlSetTip(-1, $txtTip)
		$cmbGoldMaxProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			_GUICtrlSetTip(-1, $txtTip)
		$lblGoldMax = GUICtrlCreateLabel(GetTranslated(19,11,"When Gold is Above"), $x + 145, $y, -1, -1)
		$txtMaxGoldAmount = GUICtrlCreateInput("6000000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,12,"Set the amount of Gold to trigger switching Profile.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 7)

$y += 30
		$chkGoldSwitchMin = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x - 10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,13,"Enable this to switch profiles when gold is below amount.")
			_GUICtrlSetTip(-1, $txtTip)
		$cmbGoldMinProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			_GUICtrlSetTip(-1, $txtTip)
		$lblGoldMin = GUICtrlCreateLabel(GetTranslated(19,14,"When Gold is Below"), $x + 145, $y, -1, -1)
		$txtMinGoldAmount = GUICtrlCreateInput("500000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,12,"Set the amount of Gold to trigger switching Profile.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 7)
		$picProfileGold = GUICtrlCreatePic(@ScriptDir & "\Images\GoldStorage.jpg", $x + 335, $y - 40, 60, 60)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
$y += 48
	$grpElixirSwitch = GUICtrlCreateGroup(GetTranslated(19,15,"Elixir Switch Profile Conditions"), $x - 20, $y - 20, 420, 75) ; Elixir Switch
		$chkElixirSwitchMax = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x - 10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,16,"Enable this to switch profiles when Elixir is above amount.")
			_GUICtrlSetTip(-1, $txtTip)

		$cmbElixirMaxProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			_GUICtrlSetTip(-1, $txtTip)
		$lblElixirMax = GUICtrlCreateLabel(GetTranslated(19,17,"When Elixir is Above"), $x + 145, $y, -1, -1)
		$txtMaxElixirAmount = GUICtrlCreateInput("6000000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,18,"Set the amount of Elixir to trigger switching Profile.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 7)
$y += 30
		$chkElixirSwitchMin = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x - 10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,19,"Enable this to switch profiles when Elixir is below amount.")
			_GUICtrlSetTip(-1, $txtTip)
		$cmbElixirMinProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			_GUICtrlSetTip(-1, $txtTip)
		$lblElixirMin = GUICtrlCreateLabel(GetTranslated(19,20,"When Elixir is Below"), $x + 145, $y, -1, -1)
		$txtMinElixirAmount = GUICtrlCreateInput("500000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,18,"Set the amount of Elixir to trigger switching Profile.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 7)
		$picProfileElixir = GUICtrlCreatePic(@ScriptDir & "\Images\ElixirStorage.jpg", $x + 335, $y - 40, 60, 60)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
$y += 48
	$grpDESwitch = GUICtrlCreateGroup(GetTranslated(19,21,"Dark Elixir Switch Profile Conditions"), $x - 20, $y - 20, 420, 75) ;DE Switch
		$chkDESwitchMax = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x - 10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,22,"Enable this to switch profiles when Dark Elixir is above amount.")
			_GUICtrlSetTip(-1, $txtTip)
		$cmbDEMaxProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			_GUICtrlSetTip(-1, $txtTip)
		$lblDEMax = GUICtrlCreateLabel(GetTranslated(19,23,"When Dark Elixir is Above"), $x + 145, $y, -1, -1)
		$txtMaxDEAmount = GUICtrlCreateInput("200000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,24,"Set the amount of Dark Elixir to trigger switching Profile.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
$y += 30
		$chkDESwitchMin = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x - 10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,25,"Enable this to switch profiles when Dark Elixir is below amount.")
			_GUICtrlSetTip(-1, $txtTip)
		$cmbDEMinProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			_GUICtrlSetTip(-1, $txtTip)
		$lblDEMin = GUICtrlCreateLabel(GetTranslated(19,26,"When  Dark Elixir is Below"), $x + 145, $y, -1, -1)
		$txtMinDEAmount = GUICtrlCreateInput("10000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,24,"Set the amount of Dark Elixir to trigger switching Profile.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picProfileDE = GUICtrlCreatePic(@ScriptDir & "\Images\DEStorage.jpg", $x + 335, $y - 40, 60, 60)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
$y += 48
	$grpTrophySwitch = GUICtrlCreateGroup(GetTranslated(19,27,"Trophy Switch Profile Conditions"), $x - 20, $y - 20, 420, 75) ; Trophy Switch
		$chkTrophySwitchMax = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x - 10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,28,"Enable this to switch profiles when Trophies are above amount.")
			_GUICtrlSetTip(-1, $txtTip)
		$cmbTrophyMaxProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			_GUICtrlSetTip(-1, $txtTip)
		$lblTrophyMax = GUICtrlCreateLabel(GetTranslated(19,29,"When Trophies are Above"), $x + 145, $y, -1, -1)
		$txtMaxTrophyAmount = GUICtrlCreateInput("3000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,30,"Set the amount of Trophies to trigger switching Profile.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 4)
$y += 30
		$chkTrophySwitchMin = GUICtrlCreateCheckbox(GetTranslated(19,8,"Switch To"), $x-10, $y - 5, -1, -1)
			$txtTip = GetTranslated(19,31,"Enable this to switch profiles when Trophies are below amount.")
			_GUICtrlSetTip(-1, $txtTip)
		$cmbTrophyMinProfile = GUICtrlCreateCombo("", $x + 60, $y - 5, 75, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(19,10,"Select which profile to be switched to when conditions met")
			_GUICtrlSetTip(-1, $txtTip)
		$lblTrophyMin = GUICtrlCreateLabel(GetTranslated(19,32,"When Trophies are Below"), $x + 145, $y, -1, -1)
		$txtMinTrophyAmount = GUICtrlCreateInput("1000", $x + 275, $y - 5, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(19,30,"Set the amount of Trophies to trigger switching Profile.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 4)
		$picProfileTrophy = GUICtrlCreatePic(@ScriptDir & "\Images\TrophyLeague.jpg", $x + 335, $y - 40, 60, 60)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
		setupProfileComboBoxswitch()

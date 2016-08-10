; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Tab Profiles
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func cmbProfile()
	saveConfig()

	FileClose($hLogFileHandle)
	FileClose($hAttackLogFileHandle)

	; Setup the profile in case it doesn't exist.
	setupProfile()

	readConfig()
	applyConfig()
	saveConfig()

	;DonateStats ============================
	InitDonateStats()

	SetLog("Profile " & $sCurrProfile & " loaded from " & $config, $COLOR_GREEN)

	btnUpdateProfile()			;- Refreshing setting of all profiles in SwitchAcc Mode - DEMEN

EndFunc   ;==>cmbProfile

; Actions While Training (SleepMode, HibernateMode, SwitchAcc) - DEMEN

Func radProfileType()
	If GUICtrlRead($radIdleProfile) = $GUI_CHECKED Then
	   _GUICtrlComboBox_SetCurSel($cmbMatchProfileAcc, 0)
	EndIf
	btnUpdateProfile()
EndFunc   ;==>radProfileType

Func cmbMatchProfileAcc()

	If _GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc) = 0 Then
		GUICtrlSetState($radIdleProfile, $GUI_CHECKED)
	EndIf

    If _GUICtrlComboBox_GetCurSel($cmbTotalAccount) <> 0 And _GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc) > _GUICtrlComboBox_GetCurSel($cmbTotalAccount) Then
	   MsgBox($MB_OK, "SwitchAcc Mode", "Account [" & _GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc) & "] exceeds Total Account declared" ,30, $hGUI_BOT)
	   _GUICtrlComboBox_SetCurSel($cmbMatchProfileAcc, 0)
	   GUICtrlSetState($radIdleProfile, $GUI_CHECKED)
	   btnUpdateProfile()
	EndIf

	If _GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc) <> 0 And _ArraySearch($aMatchProfileAcc,_GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc)) <> -1 Then
	   MsgBox($MB_OK, "SwitchAcc Mode", "Account [" & _GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc) & "] has been assigned to Profile [" & _ArraySearch($aMatchProfileAcc,_GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc)) + 1 & "]" ,30, $hGUI_BOT)
	   _GUICtrlComboBox_SetCurSel($cmbMatchProfileAcc, 0)
	   GUICtrlSetState($radIdleProfile, $GUI_CHECKED)
	EndIf
	btnUpdateProfile()

	If _GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc) <> 0 And UBound(_ArrayFindAll($aMatchProfileAcc,_GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc))) > 1 Then
	   MsgBox($MB_OK, "SwitchAcc Mode", "Account [" & _GUICtrlComboBox_GetCurSel($cmbMatchProfileAcc) & "] has been assigned to another profile" ,30, $hGUI_BOT)
	   _GUICtrlComboBox_SetCurSel($cmbMatchProfileAcc, 0)
	   GUICtrlSetState($radIdleProfile, $GUI_CHECKED)
	   btnUpdateProfile()
	EndIf

EndFunc   ;==>cmbMatchProfileAcc

Func btnUpdateProfile()

    saveConfig()
	setupProfile()
	readConfig()
	applyConfig()
	saveConfig()

   $ProfileList = _GUICtrlComboBox_GetListArray($cmbProfile)
   $nTotalProfile = _GUICtrlComboBox_GetCount($cmbProfile)

   For $i = 0 To 7
	  If $i <= $nTotalProfile - 1 Then
		 $aconfig[$i] = $sProfilePath & "\" & $ProfileList[$i + 1] & "\config.ini"
		 $aProfileType[$i] = IniRead($aconfig[$i], "Switch Account", "Profile Type", 3)
		 $aMatchProfileAcc[$i] = IniRead($aconfig[$i], "Switch Account", "Match Profile Acc", "")

		 If $i <= 3 Then
			For $j = $grpVillageAcc[$i] To $lblHourlyStatsDarkAcc[$i]
			   GUICtrlSetState($j, $GUI_SHOW)
			Next
		 EndIf

		 Switch $aProfileType[$i]
		 Case 1
			GUICtrlSetData($lblProfileList[$i],"Profile [" & $i+1 & "]: " & $ProfileList[$i+1] & " - Acc [" & $aMatchProfileAcc[$i] & "] - Active")
			GUICtrlSetState($lblProfileList[$i], $GUI_ENABLE)
			If $i <= 3 Then GUICtrlSetData($grpVillageAcc[$i], "Village: " & $ProfileList[$i+1] & " (Active)")

		 Case 2
			GUICtrlSetData($lblProfileList[$i],"Profile [" & $i+1 & "]: " & $ProfileList[$i+1] & " - Acc [" & $aMatchProfileAcc[$i] & "] - Donate")
			GUICtrlSetState($lblProfileList[$i], $GUI_ENABLE)
			If $i <= 3 Then
			   GUICtrlSetData($grpVillageAcc[$i], "Village: " & $ProfileList[$i+1] & " (Donate)")
			   For $j = $aStartHide[$i] To $lblHourlyStatsDarkAcc[$i]
				  GUICtrlSetState($j, $GUI_HIDE)
			   Next
			EndIf
		 Case 3
			GUICtrlSetData($lblProfileList[$i],"Profile [" & $i+1 & "]: " & $ProfileList[$i+1] & " - Acc [" & $aMatchProfileAcc[$i] & "] - Idle")
			GUICtrlSetState($lblProfileList[$i], $GUI_DISABLE)
			If $i <= 3 Then
			   GUICtrlSetData($grpVillageAcc[$i], "Village: " & $ProfileList[$i+1] & " (Idle)")
			   For $j = $aStartHide[$i] To $lblHourlyStatsDarkAcc[$i]
				  GUICtrlSetState($j, $GUI_HIDE)
			   Next
			EndIf
		 EndSwitch

	  Else
		 GUICtrlSetData($lblProfileList[$i], "")
		 If $i <= 3 Then
			For $j = $grpVillageAcc[$i] to $lblHourlyStatsDarkAcc[$i]
			   GUICtrlSetState($j, $GUI_HIDE)
			Next
		 EndIf
	  EndIf
   Next

EndFunc

Func chkSwitchAcc()
	If GUICtrlRead($chkSwitchAcc) = $GUI_CHECKED Then
	   If _GUICtrlComboBox_GetCount($cmbProfile) <= 1 Then
		  GUICtrlSetState($chkSwitchAcc, $GUI_UNCHECKED)
		  MsgBox($MB_OK, "SwitchAcc Mode", "Cannot enable SwitchAcc Mode" & @CRLF & "You have only " & _GUICtrlComboBox_GetCount($cmbProfile) & " Profile set", 30, $hGUI_BOT)
	   Else
		  For $i = $lblTotalAccount To $chkRestartAndroidSearchLimit
			 GUICtrlSetState($i, $GUI_ENABLE)
			 GUICtrlSetState($chkCloseWaitEnable, $GUI_DISABLE)
			 GUICtrlSetState($chkMultyFarming, $GUI_DISABLE)
			 GUICtrlSetState($chkSwitchDonate, $GUI_DISABLE)
		  Next
		  If GUICtrlRead($radNormalSwitch) = $GUI_CHECKED And GUICtrlRead($chkUseTrainingClose) = $GUI_CHECKED Then
			 GUICtrlSetState($radSmartSwitch, $GUI_CHECKED)
		  EndIf
	   EndIf
	Else
		For $i = $lblTotalAccount To $chkRestartAndroidSearchLimit
			 GUICtrlSetState($i, $GUI_DISABLE)
			 GUICtrlSetState($chkCloseWaitEnable, $GUI_ENABLE)
			 GUICtrlSetState($chkMultyFarming, $GUI_ENABLE)
			 GUICtrlSetState($chkSwitchDonate, $GUI_ENABLE)
		  Next
	EndIf
EndFunc   ;==>chkSwitchAcc

Func radNormalSwitch()
	If GUICtrlRead($chkUseTrainingClose) = $GUI_CHECKED Then
		GUICtrlSetState($radSmartSwitch, $GUI_CHECKED)
		MsgBox($MB_OK, "SwitchAcc Mode", "Cannot enable Sleep Mode together with Normal Switch Mode", 30, $hGUI_BOT)
	EndIf
EndFunc   ;==>radNormalSwitch  - Normal Switch is not on the same boat with Sleep Combo

Func chkUseTrainingClose()
	If GUICtrlRead($chkUseTrainingClose) = $GUI_CHECKED And GUICtrlRead($chkSwitchAcc) = $GUI_CHECKED And GUICtrlRead($radNormalSwitch) = $GUI_CHECKED Then
		GUICtrlSetState($chkUseTrainingClose, $GUI_UNCHECKED)
		MsgBox($MB_OK, "SwitchAcc Mode", "Cannot enable Sleep Mode together with Normal Switch Mode", 30, $hGUI_BOT)
	EndIf
EndFunc   ;==>chkUseTrainingClose

Func chkRestartAndroidSearchLimit()
	If GUICtrlRead($chkRestartAndroidSearchLimit) = $GUI_CHECKED Then
		GUICtrlSetState($txtRestartAndroidSearchLimit, $GUI_ENABLE)
		GUICtrlSetState($lblRestartAndroidSearchLimit, $GUI_ENABLE)
	Else
		GUICtrlSetState($txtRestartAndroidSearchLimit, $GUI_DISABLE)
		GUICtrlSetState($lblRestartAndroidSearchLimit, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkHibernate

; ============= SwitchAcc Mode ============= - DEMEN

Func btnAddConfirm()
	Switch @GUI_CtrlId
		Case $btnAdd
			GUICtrlSetState($cmbProfile, $GUI_HIDE)
			GUICtrlSetState($txtVillageName, $GUI_SHOW)
			GUICtrlSetState($btnAdd, $GUI_HIDE)
			GUICtrlSetState($btnConfirmAdd, $GUI_SHOW)
			GUICtrlSetState($btnDelete, $GUI_HIDE)
			GUICtrlSetState($btnCancel, $GUI_SHOW)
			GUICtrlSetState($btnConfirmRename, $GUI_HIDE)
			GUICtrlSetState($btnRename, $GUI_HIDE)
			; IceCube (Misc v1.0)
			GUICtrlSetState($btnRecycle, $GUI_HIDE)
			; IceCube (Misc v1.0)
		Case $btnConfirmAdd
			Local $newProfileName = StringRegExpReplace(GUICtrlRead($txtVillageName), '[/:*?"<>|]', '_')
			If FileExists($sProfilePath & "\" & $newProfileName) Then
				MsgBox($MB_ICONWARNING, GetTranslated(637, 11, "Profile Already Exists"), GetTranslated(637, 12, "%s already exists.\r\nPlease choose another name for your profile.", $newProfileName))
				Return
			EndIf

			$sCurrProfile = $newProfileName
			; Setup the profile if it doesn't exist.
			createProfile()
			setupProfileComboBox()
			setupProfileComboBoxswitch()
			selectProfile()
			GUICtrlSetState($txtVillageName, $GUI_HIDE)
			GUICtrlSetState($cmbProfile, $GUI_SHOW)
			GUICtrlSetState($btnAdd, $GUI_SHOW)
			GUICtrlSetState($btnConfirmAdd, $GUI_HIDE)
			GUICtrlSetState($btnDelete, $GUI_SHOW)
			GUICtrlSetState($btnCancel, $GUI_HIDE)
			GUICtrlSetState($btnConfirmRename, $GUI_HIDE)
			GUICtrlSetState($btnRename, $GUI_SHOW)
			; IceCube (Misc v1.0)
			GUICtrlSetState($btnRecycle, $GUI_SHOW)
			; IceCube (Misc v1.0)

			If GUICtrlGetState($btnDelete) <> $GUI_ENABLE Then GUICtrlSetState($btnDelete, $GUI_ENABLE)
			If GUICtrlGetState($btnRename) <> $GUI_ENABLE Then GUICtrlSetState($btnRename, $GUI_ENABLE)
			; IceCube (Misc v1.0)
			If GUICtrlGetState($btnRecycle) <> $GUI_ENABLE Then GUICtrlSetState($btnRecycle, $GUI_ENABLE)
			; IceCube (Misc v1.0)
			;DonateStats =============================
			InitDonateStats()
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_RED)
	EndSwitch
EndFunc   ;==>btnAddConfirm

Func btnDeleteCancel()
	Switch @GUI_CtrlId
		Case $btnDelete
			Local $msgboxAnswer = MsgBox($MB_ICONWARNING + $MB_OKCANCEL, GetTranslated(637, 8, "Delete Profile"), GetTranslated(637, 14, "Are you sure you really want to delete the profile?\r\nThis action can not be undone."))
			If $msgboxAnswer = $IDOK Then
				; Confirmed profile deletion so delete it.
				deleteProfile()
				; reset inputtext
				GUICtrlSetData($txtVillageName, GetTranslated(637,4, "MyVillage"))
				If _GUICtrlComboBox_GetCount($cmbProfile) > 1 Then
					; select existing profile
					setupProfileComboBox()
					selectProfile()
				Else
					; create new default profile
					createProfile(True)
				EndIf
			EndIf
		Case $btnCancel
			GUICtrlSetState($txtVillageName, $GUI_HIDE)
			GUICtrlSetState($cmbProfile, $GUI_SHOW)
			GUICtrlSetState($btnConfirmAdd, $GUI_HIDE)
			GUICtrlSetState($btnAdd, $GUI_SHOW)
			GUICtrlSetState($btnCancel, $GUI_HIDE)
			GUICtrlSetState($btnDelete, $GUI_SHOW)
			GUICtrlSetState($btnConfirmRename, $GUI_HIDE)
			GUICtrlSetState($btnRename, $GUI_SHOW)
			; IceCube (Misc v1.0)
			GUICtrlSetState($btnRecycle, $GUI_SHOW)
			; IceCube (Misc v1.0)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_RED)
	EndSwitch

	If GUICtrlRead($cmbProfile) = "<No Profiles>" Then
		GUICtrlSetState($btnDelete, $GUI_DISABLE)
		GUICtrlSetState($btnRename, $GUI_DISABLE)
		; IceCube (Misc v1.0)
		GUICtrlSetState($btnRecycle, $GUI_DISABLE)
		; IceCube (Misc v1.0)
	EndIf
EndFunc   ;==>btnDeleteCancel

; IceCube (Misc v1.0)
Func btnRecycle()
	FileDelete($config)
	SaveConfig()
	SetLog("Profile " & $sCurrProfile & " was recycled with success", $COLOR_GREEN)
	SetLog("All unused settings were removed", $COLOR_GREEN)
EndFunc   ;==>btnRecycle
; IceCube (Misc v1.0)

Func btnRenameConfirm()
	Switch @GUI_CtrlId
		Case $btnRename
			GUICtrlSetData($txtVillageName, GUICtrlRead($cmbProfile))
			GUICtrlSetState($cmbProfile, $GUI_HIDE)
			GUICtrlSetState($txtVillageName, $GUI_SHOW)
			GUICtrlSetState($btnAdd, $GUI_HIDE)
			GUICtrlSetState($btnConfirmAdd, $GUI_HIDE)
			GUICtrlSetState($btnDelete, $GUI_HIDE)
			GUICtrlSetState($btnCancel, $GUI_SHOW)
			GUICtrlSetState($btnRename, $GUI_HIDE)
			GUICtrlSetState($btnConfirmRename, $GUI_SHOW)
			; IceCube (Misc v1.0)
			GUICtrlSetState($btnRecycle, $GUI_HIDE)
			; IceCube (Misc v1.0)
		Case $btnConfirmRename
			Local $newProfileName = StringRegExpReplace(GUICtrlRead($txtVillageName), '[/:*?"<>|]', '_')
			If FileExists($sProfilePath & "\" & $newProfileName) Then
				MsgBox($MB_ICONWARNING, GetTranslated(7, 108, "Profile Already Exists"), $newProfileName & " " & GetTranslated(7, 109, "already exists.") & @CRLF & GetTranslated(7, 110, "Please choose another name for your profile"))
				Return
			EndIf

			$sCurrProfile = $newProfileName
			; Rename the profile.
			renameProfile()
			setupProfileComboBox()
			setupProfileComboBoxswitch()
			selectProfile()

			GUICtrlSetState($txtVillageName, $GUI_HIDE)
			GUICtrlSetState($cmbProfile, $GUI_SHOW)
			GUICtrlSetState($btnConfirmAdd, $GUI_HIDE)
			GUICtrlSetState($btnAdd, $GUI_SHOW)
			GUICtrlSetState($btnCancel, $GUI_HIDE)
			GUICtrlSetState($btnDelete, $GUI_SHOW)
			GUICtrlSetState($btnConfirmRename, $GUI_HIDE)
			GUICtrlSetState($btnRename, $GUI_SHOW)
			; IceCube (Misc v1.0)
			GUICtrlSetState($btnRecycle, $GUI_SHOW)
			; IceCube (Misc v1.0)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_RED)
	EndSwitch
EndFunc   ;==>btnRenameConfirm
Func setupProfileComboBoxswitch()
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbGoldMaxProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbGoldMaxProfile, $profileString, "<No Profiles>")
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbGoldMinProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbGoldMinProfile, $profileString, "<No Profiles>")
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbElixirMaxProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbElixirMaxProfile, $profileString, "<No Profiles>")
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbElixirMinProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbElixirMinProfile, $profileString, "<No Profiles>")
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbDEMaxProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbDEMaxProfile, $profileString, "<No Profiles>")
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbDEMinProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbDEMinProfile, $profileString, "<No Profiles>")
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbTrophyMaxProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbTrophyMaxProfile, $profileString, "<No Profiles>")
		; Clear the combo box current data in case profiles were deleted
		GUICtrlSetData($cmbTrophyMinProfile, "", "")
		; Set the new data of available profiles
		GUICtrlSetData($cmbTrophyMinProfile, $profileString, "<No Profiles>")
EndFunc   ;==>setupProfileComboBox

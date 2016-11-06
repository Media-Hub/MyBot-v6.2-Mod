; #FUNCTION# ====================================================================================================================
; Name ..........: GUI Control - Mod
; Description ...: Extended GUI Control for Mod
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

; GUI Control for SwitchAcc Mode - DEMEN
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
		btnUpdateProfile()
	EndIf

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
			For $i = $lblTotalAccount To $radNormalSwitch
				GUICtrlSetState($i, $GUI_ENABLE)
			Next
			If GUICtrlRead($radNormalSwitch) = $GUI_CHECKED And GUICtrlRead($chkUseTrainingClose) = $GUI_CHECKED Then
				GUICtrlSetState($radSmartSwitch, $GUI_CHECKED)
			EndIf
		EndIf
	Else
		For $i = $lblTotalAccount To $radNormalSwitch
			GUICtrlSetState($i, $GUI_DISABLE)
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
; ============= SwitchAcc Mode ============= - DEMEN


; GUI Control for Classic Four Finger Attack
Func cmbDeployAB()
	If _GUICtrlCombobox_GetCurSel($cmbDeployAB) = 4 Then
		GUICtrlSetState($chkSmartAttackRedAreaAB, $GUI_UNCHECKED)
		GUICtrlSetState($chkSmartAttackRedAreaAB, $GUI_DISABLE)
	Else
		GUICtrlSetState($chkSmartAttackRedAreaAB, $GUI_ENABLE)
	EndIf
EndFunc

Func cmbDeployDB()
	If _GUICtrlCombobox_GetCurSel($cmbDeployDB) = 4 Then
		GUICtrlSetState($chkSmartAttackRedAreaDB, $GUI_UNCHECKED)
		GUICtrlSetState($chkSmartAttackRedAreaDB, $GUI_DISABLE)
	Else
		GUICtrlSetState($chkSmartAttackRedAreaDB, $GUI_ENABLE)
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Tab Mod Option
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: LunaEclipse(February, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func chkSmartLightSpell()
    If GUICtrlRead($chkSmartLightSpell) = $GUI_CHECKED Then
		GUICtrlSetState($chkExtLightSpell, $GUI_DISABLE)
        GUICtrlSetState($chkSmartZapDB, $GUI_ENABLE)
        GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_ENABLE)
        GUICtrlSetState($txtMinDark, $GUI_ENABLE)
        $ichkSmartZap = 1
    Else
		GUICtrlSetState($chkExtLightSpell, $GUI_ENABLE)
        GUICtrlSetState($chkSmartZapDB, $GUI_DISABLE)
        GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_DISABLE)
        GUICtrlSetState($txtMinDark, $GUI_DISABLE)
        $ichkSmartZap = 0
    EndIf
EndFunc   ;==>chkSmartLightSpell

Func chkSmartZapDB()
    If GUICtrlRead($chkSmartZapDB) = $GUI_CHECKED Then
        $ichkSmartZapDB = 1
    Else
        $ichkSmartZapDB = 0
    EndIf
EndFunc   ;==>chkSmartZapDB

Func chkSmartZapSaveHeroes()
    If GUICtrlRead($chkSmartZapSaveHeroes) = $GUI_CHECKED Then
        $ichkSmartZapSaveHeroes = 1
    Else
        $ichkSmartZapSaveHeroes = 0
    EndIf
EndFunc   ;==>chkSmartZapSaveHeroes

Func txtMinDark()
	$itxtMinDE = GUICtrlRead($txtMinDark)
EndFunc   ;==>txtMinDark

Func ExtLightSpell()
	If GUICtrlRead($chkExtLightSpell) = $GUI_CHECKED Then
		GUICtrlSetState($chkSmartZapDB, $GUI_ENABLE)
		GUICtrlSetState($txtMinDark, $GUI_ENABLE)
		GUICtrlSetState($chkSmartLightSpell, $GUI_DISABLE)
		$ichkExtLightSpell = 1
	Else
		GUICtrlSetState($chkSmartLightSpell, $GUI_ENABLE)
		;GUICtrlSetState($chkSmartZapDB, $GUI_DISABLE)
		;GUICtrlSetState($txtMinDark, $GUI_DISABLE)
		$ichkExtLightSpell = 0
	EndIf
EndFunc   ;==>GUILightSpell

; CoCStarts
Func chkCoCStats()
	If GUICtrlRead($chkCoCStats) = $GUI_CHECKED Then
		$ichkCoCStats = 1
		GUICtrlSetState($txtAPIKey, $GUI_ENABLE)
	Else
		$ichkCoCStats = 0
		GUICtrlSetState($txtAPIKey, $GUI_DISABLE)
	EndIf
	IniWrite($config, "Stats", "chkCoCStats", $ichkCoCStats)
EndFunc   ;==>chkCoCStats

; Collect Treasury
Func chkCollectTresory()
	If GUICtrlRead($chkCollectTresory) = $GUI_CHECKED Then
		For $i = $leurequisertarienTresor To $btnResetDE
			GUICtrlSetState($i, $GUI_SHOW)
		Next
		If GUICtrlRead($chkCollectTresoryGold) = $GUI_UNCHECKED Then
			GUICtrlSetState($btnResetOR, $GUI_DISABLE)
			GUICtrlSetState($btnResetEL, $GUI_DISABLE)
			GUICtrlSetState($btnResetDE, $GUI_DISABLE)
		EndIf
		$ichkCollectTresory = 1
	Else
		For $i = $leurequisertarienTresor To $btnResetDE
			GUICtrlSetState($i, $GUI_HIDE)
		Next
		$ichkCollectTresory = 0
	EndIf
EndFunc   ;==>chkCollectTresory

Func chkCollectTresoryGold()
	If GUICtrlRead($chkCollectTresoryGold) = $GUI_CHECKED And GUICtrlRead($chkCollectTresory) = $GUI_CHECKED Then
		GUICtrlSetState($txtTreasuryGold, $GUI_ENABLE)
		GUICtrlSetState($btnResetOR, $GUI_ENABLE)
	ElseIf GUICtrlRead($chkCollectTresoryGold) = $GUI_CHECKED And GUICtrlRead($chkCollectTresory) = $GUI_UNCHECKED Then
		GUICtrlSetState($txtTreasuryGold, $GUI_DISABLE)
		GUICtrlSetState($btnResetOR, $GUI_DISABLE)
	ElseIf GUICtrlRead($chkCollectTresoryGold) = $GUI_UNCHECKED And GUICtrlRead($chkCollectTresory) = $GUI_CHECKED Then
		GUICtrlSetState($txtTreasuryGold, $GUI_DISABLE)
		GUICtrlSetState($btnResetOR, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkCollectTresoryGold

Func ResetOr()
	Global $ResetOR = 0
	GUICtrlSetData($txtTreasuryGold, $ResetOR)
	$itxtTreasuryGold = GUICtrlRead($txtTreasuryGold)
EndFunc   ;==>ResetOr

Func chkCollectTresoryElixir()
	If GUICtrlRead($chkCollectTresoryElixir) = $GUI_CHECKED And GUICtrlRead($chkCollectTresory) = $GUI_CHECKED Then
		GUICtrlSetState($txtTreasuryElixir, $GUI_ENABLE)
		GUICtrlSetState($btnResetEL, $GUI_ENABLE)
	ElseIf GUICtrlRead($chkCollectTresoryElixir) = $GUI_CHECKED And GUICtrlRead($chkCollectTresory) = $GUI_UNCHECKED Then
		GUICtrlSetState($txtTreasuryElixir, $GUI_DISABLE)
		GUICtrlSetState($btnResetEL, $GUI_DISABLE)
	ElseIf GUICtrlRead($chkCollectTresoryElixir) = $GUI_UNCHECKED And GUICtrlRead($chkCollectTresory) = $GUI_CHECKED Then
		GUICtrlSetState($txtTreasuryElixir, $GUI_DISABLE)
		GUICtrlSetState($btnResetEL, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkCollectTresoryElixir

Func ResetEL()
	Global $ResetEL = 0
	GUICtrlSetData($txtTreasuryElixir, $ResetEL)
	$itxtTreasuryElixir = GUICtrlRead($txtTreasuryElixir)
EndFunc   ;==>ResetEL

Func chkCollectTresoryDark()
	If GUICtrlRead($chkCollectTresoryDark) = $GUI_CHECKED And GUICtrlRead($chkCollectTresory) = $GUI_CHECKED Then
		GUICtrlSetState($txtTreasuryDark, $GUI_ENABLE)
		GUICtrlSetState($btnResetDE, $GUI_ENABLE)
	ElseIf GUICtrlRead($chkCollectTresoryDark) = $GUI_CHECKED And GUICtrlRead($chkCollectTresory) = $GUI_UNCHECKED Then
		GUICtrlSetState($txtTreasuryDark, $GUI_DISABLE)
		GUICtrlSetState($btnResetDE, $GUI_DISABLE)
	ElseIf GUICtrlRead($chkCollectTresoryDark) = $GUI_UNCHECKED And GUICtrlRead($chkCollectTresory) = $GUI_CHECKED Then
		GUICtrlSetState($txtTreasuryDark, $GUI_DISABLE)
		GUICtrlSetState($btnResetDE, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkCollectTresoryDark

Func ResetDE()
	Global $ResetDE = 0
	GUICtrlSetData($txtTreasuryDark, $ResetDE)
	$itxtTreasuryDark = GUICtrlRead($txtTreasuryDark)
EndFunc   ;==>ResetDE
#cs
; Android Setting
Func setupAndroidComboBox()
	Local $androidString = ""
	Local $aAndroid = getInstalledEmulators()

	; Convert the array into a string
	$androidString = _ArrayToString($aAndroid, "|")

	; Set the new data of valid Emulators
	GUICtrlSetData($cmbAndroid, $androidString, $aAndroid[0])
EndFunc   ;==>setupAndroidComboBox

Func cmbAndroid()
	$sAndroid = GUICtrlRead($cmbAndroid)
	modifyAndroid()
EndFunc   ;==>cmbAndroid

Func txtAndroidInstance()
	$sAndroidInstance = GUICtrlRead($txtAndroidInstance)
	modifyAndroid()
EndFunc   ;==>$txtAndroidInstance
#ce
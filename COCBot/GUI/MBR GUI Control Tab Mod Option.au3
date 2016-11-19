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
		GUICtrlSetState($chkSmartZapDB, $GUI_ENABLE)
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_ENABLE)
		GUICtrlSetState($txtMinDark, $GUI_ENABLE)
		GUICtrlSetState($chkNoobZap, $GUI_ENABLE)
		$ichkSmartZap = 1
		If GUICtrlRead($chkDBTimeStopAtk) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkDBTimeStopAtk, $GUI_CHECKED)
			GUICtrlSetData($txtDBTimeStopAtk, 10)
			chkDBTimeStopAtk()
		EndIf
		If GUICtrlRead($chkABTimeStopAtk) = $GUI_UNCHECKED Then
			GUICtrlSetState($chkABTimeStopAtk, $GUI_CHECKED)
			GUICtrlSetData($txtABTimeStopAtk, 10)
			chkABTimeStopAtk()
		EndIf
	Else
		GUICtrlSetState($chkSmartZapDB, $GUI_DISABLE)
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_DISABLE)
		GUICtrlSetState($txtMinDark, $GUI_DISABLE)
		GUICtrlSetState($chkNoobZap, $GUI_DISABLE)
		$ichkSmartZap = 0
	EndIf
EndFunc   ;==>chkSmartLightSpell

Func chkNoobZap()
	If GUICtrlRead($chkNoobZap) = $GUI_CHECKED Then
		GUICtrlSetState($txtExpectedDE, $GUI_ENABLE)
		$ichkNoobZap = 1
	Else
		GUICtrlSetState($txtExpectedDE, $GUI_DISABLE)
		$ichkNoobZap = 0
	EndIf
EndFunc   ;==>chkDumbZap

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

Func txtExpectedDE()
	$itxtExpectedDE = GUICtrlRead($txtExpectedDE)
EndFunc   ;==>TxtExpectedDE

#cs
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
#ce
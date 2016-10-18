; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), kaganus (August 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func btnLoots()
	Run("Explorer.exe " & $sProfilePath & "\" & $sCurrProfile & "\Loots")
EndFunc   ;==>btnLoots

Func btnLogs()
	Run("Explorer.exe " & $sProfilePath & "\" & $sCurrProfile & "\Logs")
EndFunc   ;==>btnLogs

Func btnResetStats()
	ResetStats()
EndFunc   ;==>btnResetStats

Func ResetDonateStats()
	For $i = 0 To UBound($TroopName) - 1
		$type = Eval("e" & $TroopName[$i])
		Assign("Donated" & $type & "ViPER", 0, 4)
		GUICtrlSetData(Eval("lblDonated" & $type), 0)
	Next
	For $i = 0 To UBound($TroopDarkName) - 1
		$type = Eval("e" & $TroopDarkName[$i])
		Assign("Donated" & $type & "ViPER", 0, 4)
		GUICtrlSetData(Eval("lblDonated" & $type), 0)
	Next
	Assign("Donated" & $ePSpell & "ViPER", 0, 4)
	GUICtrlSetData(Eval("lblDonated" & $ePSpell), 0)
	Assign("Donated" & $eESpell & "ViPER", 0, 4)
	GUICtrlSetData(Eval("lblDonated" & $eESpell), 0)
	Assign("Donated" & $eHaSpell & "ViPER", 0, 4)
	GUICtrlSetData(Eval("lblDonated" & $eHaSpell), 0)
	Assign("Donated" & $eSkSpell & "ViPER", 0, 4)
	GUICtrlSetData(Eval("lblDonated" & $eHaSpell), 0)
	GUICtrlSetData($lblTotalDonated,"Total Donated: " & 0)
	GUICtrlSetData($lblTotalDonatedDark,"Total Donated: " & 0)
	GUICtrlSetData($lblTotalDonatedSpell,"Total Donated: " & 0)
EndFunc
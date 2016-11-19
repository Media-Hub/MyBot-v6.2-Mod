; #FUNCTION# ====================================================================================================================
; Name ..........: CheckBaseQuick
; Description ...: Performs a quick check of base; requestCC, DonateCC, Train if required, collect resources, and pick up healed heroes.
;                : Used for prep before take a break & Personal Break exit, or during long trophy drops
; Syntax ........: CheckBasepQuick()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (2015-12)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CheckBaseQuick()

	If IsMainPage() Then ; check for main page

		If $Debugsetlog = 1 Then Setlog("CheckBaseQuick now...", $COLOR_DEBUG) ;Debug

		RequestCC() ; fill CC
		If _Sleep($iDelayRunBot1) Then Return
		checkMainScreen(False) ; required here due to many possible exits
		If $Restart = True Then Return

		DonateCC() ; donate troops
		If _Sleep($iDelayRunBot1) Then Return
		checkMainScreen(False) ; required here due to many possible function exits
		If $Restart = True Then Return

;		CheckOverviewFullArmy(True) ; Check if army needs to be trained due donations ;REMOVED FUNCTION OCT UPDATE
		If Not ($FullArmy) And $bTrainEnabled = True Then
			TestTrainRevamp()
			If $Restart = True Then Return
		EndIf

		Collect() ; Empty Collectors
		If _Sleep($iDelayRunBot1) Then Return

	Else
		If $Debugsetlog = 1 Then Setlog("Not on main page, CheckBaseQuick skipped", $COLOR_DEBUG) ;Debug
	EndIf

EndFunc   ;==>CheckBaseQuick

Func CheckBaseQuick2($bStopRecursion = False, $sReturnHome = "")

	If $bStopRecursion = True Then $bDisableBreakCheck = True ; Set flag to stop checking for attackdisable messages, stop recursion

	Switch $sReturnHome
		Case "cloud" ; PB found while in clouds searching for base, must press return home and wait for main base
			If _CheckPixel2($aRtnHomeCloud1, $bCapturePixel, Default, "Return Home Btn chk1", $COLOR_DEBUG) And _
					_CheckPixel2($aRtnHomeCloud2, $bCapturePixel, Default, "Return Home Btn chk2", $COLOR_DEBUG) Then ; verify return home button
				ClickP($aRtnHomeCloud1, 1, 0, "#0513") ; click return home button, return to main screen for base check before log off
				Local $wCount = 0
				While IsMainPage() = False ; wait for main screen
					If _Sleep($iDelayGetResources1) Then Return ; wait 250ms
					$wCount += 1
					If $wCount > 40 Then ; wait up to 40*250ms = 10 seconds for main page then exit
						Setlog("Warning, Main page not found", $COLOR_WARNING)
						ExitLoop
					EndIf
				WEnd
			EndIf
	EndSwitch

	If IsMainPage() Then ; check for main page

		If $Debugsetlog = 1 Then Setlog("CheckBaseQuick now...", $COLOR_DEBUG) ;Debug

		RequestCC() ; fill CC
		If _Sleep($iDelayRunBot1) Then Return
		checkMainScreen(False) ; required here due to many possible exits
		If $Restart = True Then
			If $bStopRecursion = True Then $bDisableBreakCheck = False
			Return
		EndIf

		DonateCC() ; donate troops
		If _Sleep($iDelayRunBot1) Then Return
		checkMainScreen(False) ; required here due to many possible function exits
		If $Restart = True Then
			If $bStopRecursion = True Then $bDisableBreakCheck = False
			Return
		EndIf

;		CheckOverviewFullArmy(True) ; Check if army needs to be trained due donations ;REMOVED FUNCTION OCT UPDATE
		If Not ($FullArmy) And $bTrainEnabled = True Then
			TestTrainRevamp()
			If $Restart = True Then Return
		Else
			If $bStopRecursion = True Then $bDisableBreakCheck = False
			Return
		EndIf

		Collect() ; Empty Collectors
		If _Sleep($iDelayRunBot1) Then Return

	Else
		If $Debugsetlog = 1 Then Setlog("Not on main page, CheckBaseQuick skipped", $COLOR_DEBUG) ;Debug
	EndIf
	
	If $bStopRecursion = True Then $bDisableBreakCheck = False ; reset flag to stop checking for attackdisable messages, stop recursion

EndFunc   ;==>CheckBaseQuick2
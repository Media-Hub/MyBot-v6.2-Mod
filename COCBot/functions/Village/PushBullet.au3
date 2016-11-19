; #FUNCTION# ====================================================================================================================
; Name ..........: PushBullet
; Description ...: This function will report to your mobile phone your values and last attack
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Antidote (2015-03)
; Modified ......: Full revamp by IceCube (2016) v1.3
;				   Sardo and Didipe (2015-05) rewrite code
;				   kgns (2015-06) $pushLastModified addition
;				   Sardo (2015-06) compliant with new pushbullet syntax (removed title)
;				   Boju(2016-05)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#include <Array.au3>
#include <String.au3>




Func _RemoteControlPushBullet()
	If ($PushBulletEnabled = 0 And $TelegramEnabled = 0) Or $pRemote = 0 Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $PushBulletEnabled = 1 And $PushBulletToken <> "" Then
		$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		Local $pushbulletApiUrl
		If $pushLastModified = 0 Then
			$pushbulletApiUrl = "https://api.pushbullet.com/v2/pushes?active=true&limit=1" ; if this is the first time looking for pushes, get the last one
		Else
			$pushbulletApiUrl = "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $pushLastModified ; get the one pushed after the last one received
		EndIf
		$oHTTP.Open("Get", $pushbulletApiUrl, False)
		$access_token = $PushBulletToken
		$oHTTP.SetCredentials($access_token, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		$oHTTP.Send()
		$Result = $oHTTP.ResponseText

		Local $modified = _StringBetween($Result, '"modified":', ',', "", False)
		If UBound($modified) > 0 Then
			$pushLastModified = Number($modified[0]) ; modified date of the newest push that we received
			$pushLastModified -= 120 ; back 120 seconds to avoid loss of messages
		EndIf

		Local $findstr = StringRegExp(StringUpper($Result), '"BODY":"BOT')
		If $findstr = 1 Then
			Local $body = _StringBetween($Result, '"body":"', '"', "", False)
			Local $iden = _StringBetween($Result, '"iden":"', '"', "", False)
			For $x = UBound($body) - 1 To 0 Step -1
				If $body <> "" Or $iden <> "" Then
					$body[$x] = StringUpper(StringStripWS($body[$x], $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES))
					$iden[$x] = StringStripWS($iden[$x], $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)

					$iForceNotify = 1

					Switch $body[$x]
						Case GetTranslated(620,1, "BOT") & " " & GetTranslated(620,14, "HELP")
							Local $txtHelp = "PushBullet Help" & GetTranslated(620,13, " - You can remotely control your bot sending commands following this syntax:")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & GetTranslated(620,14, -1) & GetTranslated(620,2, " - send this help message")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & GetTranslated(620,15,"DELETE") & GetTranslated(620,3, " - delete all your previous PushBullet messages")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,16,"RESTART") & GetTranslated(620,4, " - restart the bot named <Village Name> and Emulator")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,17,"STOP") & GetTranslated(620,5, " - stop the bot named <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,18,"PAUSE") & GetTranslated(620,6, " - pause the bot named <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,19,"RESUME") & GetTranslated(620,7, " - resume the bot named <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,20,"STATS") & GetTranslated(620,8, " - send Village Statistics of <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,21,"LOG") & GetTranslated(620,9, " - send the current log file of <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,22,"LASTRAID") & GetTranslated(620,10, " - send the last raid loot screenshot of <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,23,"LASTRAIDTXT") & GetTranslated(620,11, " - send the last raid loot values of <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,24,"SCREENSHOT") & GetTranslated(620,12, " - send a screenshot of <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,300,"SCREENSHOTHD") & GetTranslated(620,301, " - send a screenshot in high resolution of <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,302,"BUILDER") & GetTranslated(620,303, " - send a screenshot of builder status of <Village Name>")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,304,"SHIELD") & GetTranslated(620,305, " - send a screenshot of shield status of <Village Name>")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,306,"RESETSTATS") & GetTranslated(620,307, " - reset Village Statistics")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,308,"TROOPS") & GetTranslated(620,309, " - send Troops & Spells Stats")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,310,"HALTATTACKON") & GetTranslated(620,311, " - Turn On 'Halt Attack' in the 'Misc' Tab with the 'stay online' option")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,312,"HALTATTACKOFF") & GetTranslated(620,313, " - Turn Off 'Halt Attack' in the 'Misc' Tab")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,314,"HIBERNATE") & GetTranslated(620,315, " - send Troops & Spells Stats")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,316,"SHUTDOWN") & GetTranslated(620,317, " - Turn On 'Halt Attack' in the 'Misc' Tab with the 'stay online' option")
							$txtHelp &= "\n" & GetTranslated(620,1, -1) & " <" & $iOrigPushBullet & "> " & GetTranslated(620,318,"STANDBY") & GetTranslated(620,319, " - Turn Off 'Halt Attack' in the 'Misc' Tab")
							$txtHelp &= '\n'
							$txtHelp &= '\n' & GetTranslated(620,25, "Examples:")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & $iOrigPushBullet & " " & GetTranslated(620,20,"STATS")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & GetTranslated(620,304,"BUILDER")
							$txtHelp &= '\n' & GetTranslated(620,1, -1) & " " & $iOrigPushBullet & " " & GetTranslated(620,24,"SCREENSHOTHD")
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,26, "Request for Help") & "\n" & $txtHelp)
							SetLog("Notify PushBullet: Your request has been received from ' " & $iOrigPushBullet & ". Help has been sent", $COLOR_GREEN)
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & GetTranslated(620,15,"DELETE")
							_DeletePushOfPushBullet()
							SetLog("Notify PushBullet: Your request has been received.", $COLOR_GREEN)
						Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,16,"RESTART")
							_DeleteMessageOfPushBullet($iden[$x])
							SetLog("Notify PushBullet: Your request has been received. Bot and Android Emulator restarting...", $COLOR_GREEN)
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,46, "Request to Restart") & "..." & "\n" & GetTranslated(620,47, "Your bot and Emulator are now restarting") & "...")
							SaveConfig()
							_Restart()
						Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,17,"STOP")
							_DeleteMessageOfPushBullet($iden[$x])
							SetLog("Notify PushBullet: Your request has been received. Bot is now stopped", $COLOR_GREEN)
							If $Runstate = True Then
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,48, "Request to Stop") & "..." & "\n" & GetTranslated(620,49, "Your bot is now stopping") & "...")
								btnStop()
							Else
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,48, "Request to Stop") & "..." & "\n" & GetTranslated(620,50, "Your bot is currently stopped, no action was taken"))
							EndIf
						Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,18,"PAUSE")
							If $TPaused = False And $Runstate = True Then
								If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = False And IsAttackPage() Then
									SetLog("Notify PushBullet: PushBullet: Unable to pause during attack", $COLOR_RED)
									_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,86, "Request to Pause") & "\n" & GetTranslated(620,87, "Unable to pause during attack, try again later."))
								ElseIf ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = True And IsAttackPage() Then
									ReturnHome(False, False)
									$Is_SearchLimit = True
									$Is_ClientSyncError = False
									UpdateStats()
									$Restart = True
									TogglePauseImpl("Push")
								Else
									TogglePauseImpl("Push")
								EndIf
							Else
								SetLog("Notify PushBullet: Your bot is currently paused, no action was taken", $COLOR_GREEN)
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,86, "Request to Pause") & "\n" & GetTranslated(620,88, "Your bot is currently paused, no action was taken"))
							EndIf
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,19,"RESUME")
							If $TPaused = True And $Runstate = True Then
								TogglePauseImpl("Push")
							Else
								SetLog("Notify PushBullet: Your bot is currently resumed, no action was taken", $COLOR_GREEN)
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,27, "Request to Resume") & "\n" & GetTranslated(620,28, "Your bot is currently resumed, no action was taken"))
							EndIf
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,20,"STATS")
							SetLog("Notify PushBullet: Your request has been received. Statistics sent", $COLOR_GREEN)
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,39, "Stats Village Report") & "\n" & GetTranslated(620,91, "At Start") & "\n[" & GetTranslated(620,35, "G") & "]: " & _NumberFormat($iGoldStart) & " [" & GetTranslated(620,36, "E") & "]: " & _NumberFormat($iElixirStart) & " [" & GetTranslated(620,37, "D") & "]: " & _NumberFormat($iDarkStart) & " [" & GetTranslated(620,38, "T") & "]: " & $iTrophyStart & "\n\n" & GetTranslated(620,40, "Now (Current Resources)") &"\n[" & GetTranslated(620,35, "G") & "]: " & _NumberFormat($iGoldCurrent) & " [" & GetTranslated(620,36, "E") & "]: " & _NumberFormat($iElixirCurrent) & " [" & GetTranslated(620,37, "D") & "]: " & _NumberFormat($iDarkCurrent) & " [" & GetTranslated(620,38, "T") & "]: " & $iTrophyCurrent & " [" & GetTranslated(620,41, "GEM") & "]: " & $iGemAmount & "\n \n [" & GetTranslated(620,42, "No. of Free Builders") & "]: " & $iFreeBuilderCount & "\n " & GetTranslated(620,43, "[No. of Wall Up]") & ": " & GetTranslated(620,35, "G") & ": " & $iNbrOfWallsUppedGold & "/ " & GetTranslated(620,36, "E") & ": " & $iNbrOfWallsUppedElixir & "\n\n" & GetTranslated(620,44, "Attacked") & ": " & GUICtrlRead($lblresultvillagesattacked) & "\n" & GetTranslated(620,45, "Skipped") & ": " & $iSkippedVillageCount)
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,21,"LOG")
							SetLog("Notify PushBullet: Your request has been received from " & $iOrigPushBullet & ". Log is now sent", $COLOR_GREEN)
							_PushFileToPushBullet($sLogFName, GetTranslated(620,29, "logs"), "text/plain; charset=utf-8", $iOrigPushBullet & " | " & GetTranslated(620,30, "Current Log") & " \n")
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,22,"LASTRAID")
							If $AttackFile <> "" Then
								_PushFileToPushBullet($AttackFile, GetTranslated(620,31, "Loots"), "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(620,32, "Last Raid") & " \n" & $AttackFile)
							Else
								_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,33, "There is no last raid screenshot") & ".")
							EndIf
							SetLog("Notify PushBullet: Push Last Raid Snapshot...", $COLOR_GREEN)
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,23,"LASTRAIDTXT")
							SetLog("Notify PushBullet: Your request has been received. Last Raid txt sent", $COLOR_GREEN)
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,34, "Last Raid txt") & "\n" & "[" & GetTranslated(620,35, "G") & "]: " & _NumberFormat($iGoldLast) & " [" & GetTranslated(620,36, "E") & "]: " & _NumberFormat($iElixirLast) & " [" & GetTranslated(620,37, "D") & "]: " & _NumberFormat($iDarkLast) & " [" & GetTranslated(620,38, "T") & "]: " & $iTrophyLast)
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & GetTranslated(620,24,"SCREENSHOT")
							SetLog("Notify PushBullet: ScreenShot request received", $COLOR_GREEN)
							$PBRequestScreenshot = 1
							$iForceNotify = 0
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " &  StringUpper($iOrigPushBullet) & " " & GetTranslated(620,300,"SCREENSHOTHD")
							SetLog("Notify PushBullet: ScreenShot HD request received", $COLOR_GREEN)
							$PBRequestScreenshot = 1
							$PBRequestScreenshotHD = 1
							$iForceNotify = 0
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " &  StringUpper($iOrigPushBullet) & " " & GetTranslated(620,302,"BUILDER")
							SetLog("Notify PushBullet: Builder Status request received", $COLOR_GREEN)
							$RequestBuilderInfo = 1
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " &  StringUpper($iOrigPushBullet) & " " & GetTranslated(620,304,"SHIELD")
							SetLog("Notify PushBullet: Shield Status request received", $COLOR_GREEN)
							$RequestShieldInfo = 1
							$iForceNotify = 0
							_DeleteMessageOfPushBullet($iden[$x])
						Case GetTranslated(620,1, -1) & " " &  StringUpper($iOrigPushBullet) & " " & GetTranslated(620,306,"RESETSTATS")
							btnResetStats()
							SetLog("Notify PushBullet: Your request has been received. Statistics resetted", $COLOR_GREEN)
							_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,5113,"Request for ResetStats has been resetted."))
						Case GetTranslated(620,1, -1) & " " &  StringUpper($iOrigPushBullet) & " " & GetTranslated(620,308,"TROOPS")
							SetLog("Notify PushBullet: Your request has been received. Sending Troop/Spell Stats...", $COLOR_GREEN)
							Local $txtTroopStats = " | " & GetTranslated(620,5114,"Troops/Spells set to Train") & ":\n" & "Barbs:" & $BarbComp & " Arch:" & $ArchComp & " Gobl:" & $GoblComp
							$txtTroopStats &= "\n" & "Giant:" & $GiantComp & " WallB:" & $WallComp & " Wiza:" & $WizaComp
							$txtTroopStats &= "\n" & "Balloon:" & $BallComp & " Heal:" & $HealComp & " Dragon:" & $DragComp & " Pekka:" & $PekkComp
							$txtTroopStats &= "\n" & "Mini:" & $MiniComp & " Hogs:" & $HogsComp & " Valks:" & $ValkComp
							$txtTroopStats &= "\n" & "Golem:" & $GoleComp & " Witch:" & $WitcComp & " Lava:" & $LavaComp
							$txtTroopStats &= "\n" & "LSpell:" & $LSpellComp & " HeSpell:" & $HSpellComp & " RSpell:" & $RSpellComp & " JSpell:" & $JSpellComp
							$txtTroopStats &= "\n" & "FSpell:" & $FSpellComp & " PSpell:" & $PSpellComp & " ESpell:" & $ESpellComp & " HaSpell:" & $HaSpellComp & "\n"
							$txtTroopStats &= "\n" & GetTranslated(620,5115,"Current Trained Troops & Spells") & ":"
							For $i = 0 to Ubound($TroopSpellStats)-1
								If $TroopSpellStats[$i][0] <> "" Then
									$txtTroopStats &= "\n" & $TroopSpellStats[$i][0] & ":" & $TroopSpellStats[$i][1]
								EndIf
							Next
							$txtTroopStats &= "\n\n" & GetTranslated(620,5116,"Current Army Camp") & ": " & $CurCamp & "/" & $TotalCamp
							_PushToPushBullet($iOrigPushBullet & $txtTroopStats)
						Case GetTranslated(620,1, -1) & " " &  StringUpper($iOrigPushBullet) & " " & GetTranslated(620,310,"HALTATTACKON")
							GUICtrlSetState($chkBotStop, $GUI_CHECKED)
							btnStop()
							$ichkBotStop = 1 ; set halt attack variable
							$icmbBotCond = 18; set stay online
							btnStart()
						Case GetTranslated(620,1, -1) & " " &  StringUpper($iOrigPushBullet) & " " & GetTranslated(620,312,"HALTATTACKOFF")
							GUICtrlSetState($chkBotStop, $GUI_UNCHECKED)
							btnStop()
							btnStart()
						Case GetTranslated(620,1, -1) & " " &  StringUpper($iOrigPushBullet) & " " & GetTranslated(620,314,"HIBERNATE")
							SetLog("Notify PushBullet: Your request has been received from " & $iOrigPushBullet & ". Hibernate PC", $COLOR_GREEN)
							_PushToPushBullet(GetTranslated(620,550,"PC Hibernate sequence initiated"))
							Shutdown(64)
						Case GetTranslated(620,1, -1) & " " &  StringUpper($iOrigPushBullet) & " " & GetTranslated(620,316,"SHUTDOWN")
							SetLog("Notify PushBullet: Your request has been received from " & $iOrigPushBullet & ". Shut down PC", $COLOR_GREEN)
							_PushToPushBullet(GetTranslated(620,551,"PC Shutdown sequence initiated"))
							Shutdown(5)
						Case GetTranslated(620,1, -1) & " " &  StringUpper($iOrigPushBullet) & " " & GetTranslated(620,318,"STANDBY")
							SetLog("Notify PushBullet: Your request has been received from " & $iOrigPushBullet & ". Standby PC", $COLOR_GREEN)
							_PushToPushBullet(GetTranslated(620,552,"PC Standby sequence initiated"))
							Shutdown(32)
						Case Else
								Local $lenstr = StringLen(GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & "")
								Local $teststr = StringLeft($body[$x], $lenstr)
								If $teststr = (GetTranslated(620,1, -1) & " " & StringUpper($iOrigPushBullet) & " " & "") Then
									SetLog("Notify PushBullet: received command syntax wrong, command ignored.", $COLOR_RED)
									_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,51, "Command not recognized") & "\n" & GetTranslated(620,52, "Please push BOT HELP to obtain a complete command list."))
									_DeleteMessageOfPushBullet($iden[$x])
								EndIf
					EndSwitch
					$body[$x] = ""
					$iden[$x] = ""

					$iForceNotify = 0
				EndIf
			Next
		EndIf
	EndIf
	;PushBullet ---------------------------------------------------------------------------------


	;Telegram ---------------------------------------------------------------------------------
	If $TelegramEnabled = 1 And $TelegramToken <> ""  Then
		$lastmessage = GetLastMsg()
        If $lastmessage = "\/start" And $lastremote <> $lastuid Then
			$lastremote = $lastuid
			_PushToPushBullet(GetTranslated(620,548,"select your remote"))
		Else
			local $body2 = StringUpper(StringStripWS($lastmessage, $STR_STRIPLEADING + $STR_STRIPTRAILING + $STR_STRIPSPACES)) ;upercase & remove space laset message
			If $lastremote <> $lastuid Then
				$lastremote = $lastuid
				Switch $body2
					Case GetTranslated(620,1,"Help")
						Local $txtHelp =  "Telegram Help" & GetTranslated(620,13, " - You can remotely control your bot sending commands following this syntax:")
						$txtHelp &= '\n' & GetTranslated(620,14, -1) & GetTranslated(620,2, " - send this help message")
						$txtHelp &= '\n' & GetTranslated(620,16,"RESTART") & GetTranslated(620,4, " - restart the bot named <Village Name> and Emulator")
						$txtHelp &= '\n' & GetTranslated(620,17,"STOP") & GetTranslated(620,5, " - stop the bot named <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,18,"PAUSE") & GetTranslated(620,6, " - pause the bot named <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,19,"RESUME") & GetTranslated(620,7, " - resume the bot named <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,20,"STATS") & GetTranslated(620,8, " - send Village Statistics of <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,21,"LOG") & GetTranslated(620,9, " - send the current log file of <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,22,"LASTRAID") & GetTranslated(620,10, " - send the last raid loot screenshot of <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,23,"LASTRAIDTXT") & GetTranslated(620,11, " - send the last raid loot values of <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,24,"SCREENSHOT") & GetTranslated(620,12, " - send a screenshot of <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,300,"SCREENSHOTHD") & GetTranslated(620,301, " - send a screenshot in high resolution of <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,302,"BUILDER") & GetTranslated(620,303, " - send a screenshot of builder status of <Village Name>")
						$txtHelp &= '\n' & GetTranslated(620,304,"SHIELD") & GetTranslated(620,305, " - send a screenshot of shield status of <Village Name>")
						$txtHelp &= "\n" & GetTranslated(620,306,"RESETSTATS") & GetTranslated(620,307, " - reset Village Statistics")
						$txtHelp &= "\n" & GetTranslated(620,308,"TROOPS") & GetTranslated(620,309, " - send Troops & Spells Stats")
						$txtHelp &= "\n" & GetTranslated(620,310,"HALTATTACKON") & GetTranslated(620,311, " - Turn On 'Halt Attack' in the 'Misc' Tab with the 'stay online' option")
						$txtHelp &= "\n" & GetTranslated(620,312,"HALTATTACKOFF") & GetTranslated(620,313, " - Turn Off 'Halt Attack' in the 'Misc' Tab")
						$txtHelp &= "\n" & GetTranslated(620,314,"HIBERNATE") & GetTranslated(620,315, " - send Troops & Spells Stats")
						$txtHelp &= "\n" & GetTranslated(620,316,"SHUTDOWN") & GetTranslated(620,317, " - Turn On 'Halt Attack' in the 'Misc' Tab with the 'stay online' option")
						$txtHelp &= "\n" & GetTranslated(620,318,"STANDBY") & GetTranslated(620,319, " - Turn Off 'Halt Attack' in the 'Misc' Tab")

						_PushToTelegram($iOrigPushBullet & " | " & GetTranslated(620,529,"Request for Help") & "\n" & $txtHelp)
						SetLog("Notify Telegram: Your request has been received from ' " & $iOrigPushBullet & ". Help has been sent", $COLOR_GREEN)
					Case GetTranslated(620,16,"RESTART")
						SetLog("Notify Telegram: Your request has been received. Bot and Emulator restarting...", $COLOR_GREEN)
						_PushToTelegram($iOrigPushBullet & " | " & GetTranslated(620,541,"Request to Restart...") & "\n" & GetTranslated(620,542,"Your bot and Emulator are now restarting..."))
						SaveConfig()
						_Restart()
					Case GetTranslated(620,17,"STOP")
						SetLog("Notify Telegram: Your request has been received. Bot is now stopped", $COLOR_GREEN)
						If $Runstate = True Then
							 _PushToTelegram($iOrigPushBullet & " | " & GetTranslated(620,543,"Request to Stop...") & "\n" & GetTranslated(620,544,"Your bot is now stopping..."))
							 btnStop()
						Else
							_PushToTelegram($iOrigPushBullet & " | " & GetTranslated(620,543,"Request to Stop...") & "\n" & GetTranslated(620,545,"Your bot is currently stopped, no action was taken"))
						EndIf
					Case GetTranslated(620,18,"PAUSE")
						If $TPaused = False And $Runstate = True Then
							If ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = False And IsAttackPage() Then
								SetLog("Notify Telegram: Unable to pause during attack", $COLOR_RED)
								_PushToTelegram($iOrigPushBullet & " | " & GetTranslated(620,530,"Request to Pause") & "\n" & GetTranslated(620,5134,"Unable to pause during attack, try again later."))
							ElseIf ( _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])) = True And IsAttackPage() Then
								ReturnHome(False, False)
								$Is_SearchLimit = True
								$Is_ClientSyncError = True
								;UpdateStats()
								$Restart = True
								TogglePauseImpl("Push")
								Return True
							Else
								TogglePauseImpl("Push")
							EndIf
						Else
							SetLog("Notify Telegram: Your bot is currently paused, no action was taken", $COLOR_GREEN)
							_PushToTelegram($iOrigPushBullet & " | " & GetTranslated(620,530,"Request to Pause") & "\n" & GetTranslated(620,593,"Your bot is currently paused, no action was taken"))
						EndIf
					Case GetTranslated(620,19,"RESUME")
						If $TPaused = True And $Runstate = True Then
							TogglePauseImpl("Push")
						Else
							SetLog("Notify Telegram: Your bot is currently resumed, no action was taken", $COLOR_GREEN)
							_PushToTelegram($iOrigPushBullet & " | " & GetTranslated(620,531,"Request to Resume") & "\n" & GetTranslated(620,594,"Your bot is currently resumed, no action was taken"))
						EndIf
					Case GetTranslated(620,20,"STATS")
						SetLog("Notify Telegram: Your request has been received. Statistics sent", $COLOR_GREEN)
						Local $GoldGainPerHour = 0
						Local $ElixirGainPerHour = 0
						Local $DarkGainPerHour = 0
						Local $TrophyGainPerHour = 0
						If $FirstAttack = 2 Then
							$GoldGainPerHour = _NumberFormat(Round($iGoldTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "K / h"
							$ElixirGainPerHour = _NumberFormat(Round($iElixirTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600)) & "K / h"
						EndIf
						If $iDarkStart <> "" Then
							$DarkGainPerHour = _NumberFormat(Round($iDarkTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600 * 1000)) & " / h"
						EndIf
						$TrophyGainPerHour = _NumberFormat(Round($iTrophyTotal / (Int(TimerDiff($sTimer) + $iTimePassed)) * 3600 * 1000)) & " / h"
						Local $txtStats = " | " & GetTranslated(620,534,"Stats Village Report") & "\n" & GetTranslated(620,535,"At Start") & "\n[G]: " & _NumberFormat($iGoldStart) & " [E]: "
							  $txtStats &= _NumberFormat($iElixirStart) & " [D]: " & _NumberFormat($iDarkStart) & " [T]: " & $iTrophyStart
							  $txtStats &= "\n\n" & GetTranslated(620,536,"Now (Current Resources)") & "\n[G]: " & _NumberFormat($iGoldCurrent) & " [E]: " & _NumberFormat($iElixirCurrent)
							  $txtStats &= " [D]: " & _NumberFormat($iDarkCurrent) & " [T]: " & $iTrophyCurrent & " [GEM]: " & $iGemAmount
							  $txtStats &= "\n\n" & GetTranslated(620,526,"Gain per Hour") & ":\n[G]: " & $GoldGainPerHour & " [E]: " & $ElixirGainPerHour
							  $txtStats &= "\n[D]: " & $DarkGainPerHour & " [T]: " & $TrophyGainPerHour
							  $txtStats &= "\n\n" & GetTranslated(620,537,"No. of Free Builders") & ": " & $iFreeBuilderCount & "\n[" & GetTranslated(620,538,"No. of Wall Up") & "]: G: "
							  $txtStats &= $iNbrOfWallsUppedGold & "/ E: " & $iNbrOfWallsUppedElixir & "\n\n" & GetTranslated(620,539,"Attacked") & ": "
							  $txtStats &= GUICtrlRead($lblresultvillagesattacked) & "\n" & GetTranslated(620,540,"Skipped") & ": " & $iSkippedVillageCount
						_PushToTelegram($iOrigPushBullet & $txtStats)
					Case GetTranslated(620,21,"LOG")
						SetLog("Notify Telegram: Your request has been received from " & $iOrigPushBullet & ". Log is now sent", $COLOR_GREEN)
						_PushFileToTelegram($sLogFName, "logs", "text\/plain; charset=utf-8", $iOrigPushBullet & " | Current Log " & "\n")
					Case GetTranslated(620,22,"LASTRAID")
						 If $LootFileName <> "" Then
							_PushFileToTelegram($LootFileName, GetTranslated(620,31, "Loots"), "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(620,595,"Last Raid") & "\n" & $LootFileName)
							SetLog("Notify Telegram: Push Last Raid Snapshot...", $COLOR_GREEN)
						Else
							_PushToTelegram($iOrigPushBullet & " | " & GetTranslated(620,532,"There is no last raid screenshot."))
							SetLog("Notify Telegram: Push Last Raid Snapshot...", $COLOR_GREEN)
						EndIf
					Case GetTranslated(620,23,"LASTRAIDTXT")
						SetLog("Notify Telegram: Your request has been received. Last Raid txt sent", $COLOR_GREEN)
						_PushToTelegram($iOrigPushBullet & " | " & GetTranslated(620,533,"Last Raid txt") & "\n" & "[G]: " & _NumberFormat($iGoldLast) & " [E]: " & _NumberFormat($iElixirLast) & " [D]: " & _NumberFormat($iDarkLast) & " [T]: " & $iTrophyLast)
					Case GetTranslated(620,24,"SCREENSHOT")
						SetLog("Notify Telegram: ScreenShot request received", $COLOR_GREEN)
						$TGRequestScreenshot = 1
					Case GetTranslated(620,300,"SCREENSHOTHD")
						SetLog("Notify Telegram: ScreenShot HD request received", $COLOR_GREEN)
						$TGRequestScreenshot = 1
						$TGRequestScreenshotHD = 1
						$iForceNotify = 0
					Case GetTranslated(620,302,"BUILDER")
						SetLog("Notify Telegram: Builder Status request received", $COLOR_GREEN)
						$TGRequestBuilderInfo = 1
					Case GetTranslated(620,304,"SHIELD")
						SetLog("Notify Telegram: Shield Status request received", $COLOR_GREEN)
						$TGRequestShieldInfo = 1
						$iForceNotify = 0
					Case GetTranslated(620,306,"RESETSTATS")
						btnResetStats()
						SetLog("Notify Telegram: Your request has been received. Statistics resetted", $COLOR_GREEN)
						_PushToTelegram($iOrigPushBullet & " | " & GetTranslated(620,5113,"Request for ResetStats has been resetted."))
					Case GetTranslated(620,307,"TROOPS")
						SetLog("Notify Telegram: Your request has been received. Sending Troop/Spell Stats...", $COLOR_GREEN)
						Local $txtTroopStats = " | " & GetTranslated(620,5114,"Troops/Spells set to Train") & ":\n" & "Barbs:" & $BarbComp & " Arch:" & $ArchComp & " Gobl:" & $GoblComp
						$txtTroopStats &= "\n" & "Giant:" & $GiantComp & " WallB:" & $WallComp & " Wiza:" & $WizaComp
						$txtTroopStats &= "\n" & "Balloon:" & $BallComp & " Heal:" & $HealComp & " Dragon:" & $DragComp & " Pekka:" & $PekkComp
						$txtTroopStats &= "\n" & "Mini:" & $MiniComp & " Hogs:" & $HogsComp & " Valks:" & $ValkComp
						$txtTroopStats &= "\n" & "Golem:" & $GoleComp & " Witch:" & $WitcComp & " Lava:" & $LavaComp
						$txtTroopStats &= "\n" & "LSpell:" & $LSpellComp & " HeSpell:" & $HSpellComp & " RSpell:" & $RSpellComp & " JSpell:" & $JSpellComp
						$txtTroopStats &= "\n" & "FSpell:" & $FSpellComp & " PSpell:" & $PSpellComp & " ESpell:" & $ESpellComp & " HaSpell:" & $HaSpellComp & "\n"
						$txtTroopStats &= "\n" & GetTranslated(620,5115,"Current Trained Troops & Spells") & ":"
						For $i = 0 to Ubound($TroopSpellStats)-1
							If $TroopSpellStats[$i][0] <> "" Then
								$txtTroopStats &= "\n" & $TroopSpellStats[$i][0] & ":" & $TroopSpellStats[$i][1]
							EndIf
						Next
						$txtTroopStats &= "\n\n" & GetTranslated(620,5116,"Current Army Camp") & ": " & $CurCamp & "/" & $TotalCamp
						_PushToTelegram($iOrigPushBullet & $txtTroopStats)
					Case GetTranslated(620,310,"HALTATTACKON")
						GUICtrlSetState($chkBotStop, $GUI_CHECKED)
						btnStop()
						$ichkBotStop = 1 ; set halt attack variable
						$icmbBotCond = 18; set stay online
						btnStart()
					Case GetTranslated(620,312,"HALTATTACKOFF")
						GUICtrlSetState($chkBotStop, $GUI_UNCHECKED)
						btnStop()
						btnStart()
					Case GetTranslated(620,314,"HIBERNATE")
						SetLog("Notify Telegram: Your request has been received from " & $iOrigPushBullet & ". Hibernate PC", $COLOR_GREEN)
						_PushToTelegram(GetTranslated(620,550,"PC Hibernate sequence initiated"))
						Shutdown(64)
					Case GetTranslated(620,316,"SHUTDOWN")
						SetLog("Notify Telegram: Your request has been received from " & $iOrigPushBullet & ". Shut down PC", $COLOR_GREEN)
						_PushToTelegram(GetTranslated(620,551,"PC Shutdown sequence initiated"))
						Shutdown(5)
					Case GetTranslated(620,318,"STANDBY")
						SetLog("Notify Telegram: Your request has been received from " & $iOrigPushBullet & ". Standby PC", $COLOR_GREEN)
						_PushToTelegram(GetTranslated(620,552,"PC Standby sequence initiated"))
						Shutdown(32)
				EndSwitch

			EndIf
		EndIf
	EndIf
	;Telegram ---------------------------------------------------------------------------------

EndFunc   ;==>_RemoteControl

Func _PushBullet($pMessage = "")
	If ($PushBulletEnabled = 0 Or $PushBulletToken = "") And ($TelegramEnabled = 0 Or $TelegramToken = "") Then Return

 	If $iForceNotify = 0 Then
		If $iPlannedNotifyWeekdaysEnable = 1 Then
			If $iPlannedNotifyWeekdays[@WDAY - 1] = 1 Then
				If $iPlannedNotifyHoursEnable = 1 Then
					Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
					If $iPlannedNotifyHours[$hour[0]] = 0 Then
						SetLog("Notify not planned for this hour, Skipped..", $COLOR_ORANGE)
						SetLog($pMessage, $COLOR_ORANGE)
						Return ; exit func if no planned
					EndIf
				EndIf
			Else
				SetLog("Notify not planned to: " & _DateDayOfWeek(@WDAY), $COLOR_ORANGE)
				SetLog($pMessage, $COLOR_ORANGE)
				Return ; exit func if not planned
			EndIf
		Else
			If $iPlannedNotifyHoursEnable = 1 Then
				Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
				If $iPlannedNotifyHours[$hour[0]] = 0 Then
					SetLog("Notify not planned for this hour, Skipped..", $COLOR_ORANGE)
					SetLog($pMessage, $COLOR_ORANGE)
					Return ; exit func if no planned
				EndIf
			EndIf
		EndIf
	EndIf

	;PushBullet ---------------------------------------------------------------------------------
	If $PushBulletEnabled = 1 And $PushBulletToken <> "" Then
		$iForceNotify = 0

		$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		;$access_token = $PushBulletToken
		$oHTTP.Open("Get", "https://api.pushbullet.com/v2/devices", False)
		$oHTTP.SetCredentials($PushBulletToken, "", 0)
		$oHTTP.Send()
		$Result = $oHTTP.ResponseText
		Local $device_iden = _StringBetween($Result, 'iden":"', '"')
		Local $device_name = _StringBetween($Result, 'nickname":"', '"')
		Local $device = ""
		Local $pDevice = 1
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
		$oHTTP.SetCredentials($PushBulletToken, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN
		Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
		$oHTTP.Send($pPush)
	EndIf
	;PushBullet ---------------------------------------------------------------------------------

	;Telegram ---------------------------------------------------------------------------------
	If $TelegramEnabled = 1 And $TelegramToken <> ""  Then
		 $access_token2 = $TelegramToken
		 $oHTTP2 = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		 $oHTTP2.Open("Get", "https://api.telegram.org/bot" & $access_token2 & "/getupdates" , False)
		 $oHTTP2.Send()
		 $Result = $oHTTP2.ResponseText
		 local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
		 $TelegramChatID = _Arraypop($chat_id)
		 $oHTTP2.Open("Post", "https://api.telegram.org/bot" & $access_token2&"/sendmessage", False)
		 ;$oHTTP2.SetRequestHeader("Content-Type", "application/json")
		 $oHTTP2.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")
	     Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
		 Local $Time = @HOUR & '.' & @MIN
		 local $pPush3 = '{"text":"' & $pmessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $TelegramChatID & '}}'
		 $oHTTP2.Send($pPush3)
	EndIf
	;Telegram ---------------------------------------------------------------------------------

EndFunc   ;==>_PushBullet

Func _PushToBoth($pMessage)
	If ($PushBulletEnabled = 0 Or $PushBulletToken = "") And ($TelegramEnabled = 0 Or $TelegramToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $PushBulletEnabled = 1 And $PushBulletToken <> "" Then
		$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
		$access_token = $PushBulletToken
		$oHTTP.SetCredentials($access_token, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN
		Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
		$oHTTP.Send($pPush)
	EndIf
	;PushBullet ---------------------------------------------------------------------------------

	;Telegram ---------------------------------------------------------------------------------
	If $TelegramEnabled = 1 And $TelegramToken <> ""  Then
	   $access_token2 = $TelegramToken
	   $oHTTP2 = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	   $url= "https://api.telegram.org/bot"
	   $oHTTP2.Open("Post",  $url & $access_token2 & "/sendMessage", False)
	   $oHTTP2.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")

	   Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
	   Local $Time = @HOUR & '.' & @MIN
	   local $pPush3 = '{"text":"' & $pmessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $TelegramChatID & '}}'
	   $oHTTP2.Send($pPush3)
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==>_Push

Func _PushToPushBullet($pMessage)
	If ($PushBulletEnabled = 0 Or $PushBulletToken = "") And ($TelegramEnabled = 0 Or $TelegramToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $PushBulletEnabled = 1 And $PushBulletToken <> "" Then
		$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
		$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
		$access_token = $PushBulletToken
		$oHTTP.SetCredentials($access_token, "", 0)
		$oHTTP.SetRequestHeader("Content-Type", "application/json")
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN
		Local $pPush = '{"type": "note", "body": "' & $pMessage & "\n" & $Date & "__" & $Time & '"}'
		$oHTTP.Send($pPush)
	EndIf
	;PushBullet ---------------------------------------------------------------------------------
EndFunc   ;==>_PushToPushBullet

Func _PushToTelegram($pMessage)
	If ($PushBulletEnabled = 0 Or $PushBulletToken = "") And ($TelegramEnabled = 0 Or $TelegramToken = "") Then Return

	;Telegram ---------------------------------------------------------------------------------
	If $TelegramEnabled = 1 And $TelegramToken <> ""  Then
	   $access_token2 = $TelegramToken
	   $oHTTP2 = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	   $url= "https://api.telegram.org/bot"
	   $oHTTP2.Open("Post",  $url & $access_token2 & "/sendMessage", False)
	   $oHTTP2.SetRequestHeader("Content-Type", "application/json; charset=ISO-8859-1,utf-8")

	   Local $Date = @YEAR & '-' & @MON & '-' & @MDAY
	   Local $Time = @HOUR & '.' & @MIN
	   local $pPush3 = '{"text":"' & $pmessage & '\n' & $Date & '__' & $Time & '", "chat_id":' & $TelegramChatID & '}}'
	   $oHTTP2.Send($pPush3)
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==>_PushToTelegram


Func _PushFileToBoth($File, $Folder, $FileType, $body)
	If ($PushBulletEnabled = 0 Or $PushBulletToken = "") And ($TelegramEnabled = 0 Or $TelegramToken = "") Then Return


	;PushBullet ---------------------------------------------------------------------------------
	If $PushBulletEnabled = 1 And $PushBulletToken <> "" Then
		If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then
			$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			$oHTTP.Open("Post", "https://api.pushbullet.com/v2/upload-request", False)
			$access_token = $PushBulletToken
			$oHTTP.SetCredentials($access_token, "", 0)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"file_name": "' & $File & '", "file_type": "' & $FileType & '"}'
			$oHTTP.Send($pPush)
			$Result = $oHTTP.ResponseText
			Local $upload_url = _StringBetween($Result, 'upload_url":"', '"')
			Local $awsaccesskeyid = _StringBetween($Result, 'awsaccesskeyid":"', '"')
			Local $acl = _StringBetween($Result, 'acl":"', '"')
			Local $key = _StringBetween($Result, 'key":"', '"')
			Local $signature = _StringBetween($Result, 'signature":"', '"')
			Local $policy = _StringBetween($Result, 'policy":"', '"')
			Local $file_url = _StringBetween($Result, 'file_url":"', '"')
			If IsArray($upload_url) And IsArray($awsaccesskeyid) And IsArray($acl) And IsArray($key) And IsArray($signature) And IsArray($policy) Then
				$Result = RunWait($pCurl & " -i -X POST " & $upload_url[0] & ' -F awsaccesskeyid="' & $awsaccesskeyid[0] & '" -F acl="' & $acl[0] & '" -F key="' & $key[0] & '" -F signature="' & $signature[0] & '" -F policy="' & $policy[0] & '" -F content-type="' & $FileType & '" -F file=@"' & $sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File & '"', "", @SW_HIDE)
				$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
				$oHTTP.SetCredentials($access_token, "", 0)
				$oHTTP.SetRequestHeader("Content-Type", "application/json")
				Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $file_url[0] & '", "body": "' & $body & '"}'
				$oHTTP.Send($pPush)
			Else
				SetLog("Notify PushBullet: Unable to send file " & $File, $COLOR_RED)
				_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,53, "Unable to Upload File") & "\n" & GetTranslated(620,54, "Occured an error type") & " 1 " & GetTranslated(620,55, "uploading file to PushBullet server") & "...")
			EndIf
		Else
			SetLog("Notify PushBullet: Unable to send file " & $File, $COLOR_RED)
			_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,53, "Unable to Upload File") & "\n" & GetTranslated(620,54, "Occured an error type") & " 2 " & GetTranslated(620,55, "uploading file to PushBullet server") & "...")
		EndIf
	EndIf
	;PushBullet ---------------------------------------------------------------------------------

	;Telegram ---------------------------------------------------------------------------------
	If $TelegramEnabled = 1 And $TelegramToken <> ""  Then
		If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then
			$access_token2 = $TelegramToken
			$oHTTP2 = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			Local $telegram_url = "https://api.telegram.org/bot" & $access_token2 & "/sendPhoto"
			$Result = RunWait($pCurl & " -i -X POST " & $telegram_url & ' -F chat_id="' & $TelegramChatID &' " -F photo=@"' & $sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File  & '"', "", @SW_HIDE)
			$oHTTP2.Open("Post", "https://api.telegram.org/bot" & $access_token2 & "/sendPhoto", False)
			$oHTTP2.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $telegram_url & '", "body": "' & $body & '"}'
			$oHTTP2.Send($pPush)
		Else
			SetLog("Notify Telegram: Unable to send file " & $File, $COLOR_RED)
			_PushToTelegram($iOrigPushBullet & " | " & GetTranslated(620,554,"Unable to Upload File") & "\n" & GetTranslated(620,555,"Occured an error type 2 uploading file to Telegram server..."))
		EndIf
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==>_PushFile

Func _PushFileToPushBullet($File, $Folder, $FileType, $body)
	If ($PushBulletEnabled = 0 Or $PushBulletToken = "") And ($TelegramEnabled = 0 Or $TelegramToken = "") Then Return

	;PushBullet ---------------------------------------------------------------------------------
	If $PushBulletEnabled = 1 And $PushBulletToken <> "" Then
		If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then
			$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			$oHTTP.Open("Post", "https://api.pushbullet.com/v2/upload-request", False)
			$access_token = $PushBulletToken
			$oHTTP.SetCredentials($access_token, "", 0)
			$oHTTP.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"file_name": "' & $File & '", "file_type": "' & $FileType & '"}'
			$oHTTP.Send($pPush)
			$Result = $oHTTP.ResponseText
			Local $upload_url = _StringBetween($Result, 'upload_url":"', '"')
			Local $awsaccesskeyid = _StringBetween($Result, 'awsaccesskeyid":"', '"')
			Local $acl = _StringBetween($Result, 'acl":"', '"')
			Local $key = _StringBetween($Result, 'key":"', '"')
			Local $signature = _StringBetween($Result, 'signature":"', '"')
			Local $policy = _StringBetween($Result, 'policy":"', '"')
			Local $file_url = _StringBetween($Result, 'file_url":"', '"')
			If IsArray($upload_url) And IsArray($awsaccesskeyid) And IsArray($acl) And IsArray($key) And IsArray($signature) And IsArray($policy) Then
				$Result = RunWait($pCurl & " -i -X POST " & $upload_url[0] & ' -F awsaccesskeyid="' & $awsaccesskeyid[0] & '" -F acl="' & $acl[0] & '" -F key="' & $key[0] & '" -F signature="' & $signature[0] & '" -F policy="' & $policy[0] & '" -F content-type="' & $FileType & '" -F file=@"' & $sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File & '"', "", @SW_HIDE)
				$oHTTP.Open("Post", "https://api.pushbullet.com/v2/pushes", False)
				$oHTTP.SetCredentials($access_token, "", 0)
				$oHTTP.SetRequestHeader("Content-Type", "application/json")
				Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $file_url[0] & '", "body": "' & $body & '"}'
				$oHTTP.Send($pPush)
			Else
				SetLog("Notify PushBullet: Unable to send file " & $File, $COLOR_RED)
				_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,53, "Unable to Upload File") & "\n" & GetTranslated(620,54, "Occured an error type") & " 1 " & GetTranslated(620,55, "uploading file to PushBullet server") & "...")
			EndIf
		Else
			SetLog("Notify PushBullet: Unable to send file " & $File, $COLOR_RED)
			_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,53, "Unable to Upload File") & "\n" & GetTranslated(620,54, "Occured an error type") & " 2 " & GetTranslated(620,55, "uploading file to PushBullet server") & "...")
		EndIf
	EndIf
	;PushBullet ---------------------------------------------------------------------------------

EndFunc   ;==>_PushFileToPushBullet

Func _PushFileToTelegram($File, $Folder, $FileType, $body)
	If ($PushBulletEnabled = 0 Or $PushBulletToken = "") And ($TelegramEnabled = 0 Or $TelegramToken = "") Then Return

	;Telegram ---------------------------------------------------------------------------------
	If $TelegramEnabled = 1 And $TelegramToken <> ""  Then
		If FileExists($sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File) Then
			$access_token2 = $TelegramToken
			$oHTTP2 = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
			Local $telegram_url = "https://api.telegram.org/bot" & $access_token2 & "/sendPhoto"
			$Result = RunWait($pCurl & " -i -X POST " & $telegram_url & ' -F chat_id="' & $TelegramChatID &' " -F photo=@"' & $sProfilePath & "\" & $sCurrProfile & '\' & $Folder & '\' & $File  & '"', "", @SW_HIDE)
			$oHTTP2.Open("Post", "https://api.telegram.org/bot" & $access_token2 & "/sendPhoto", False)
			$oHTTP2.SetRequestHeader("Content-Type", "application/json")
			Local $pPush = '{"type": "file", "file_name": "' & $File & '", "file_type": "' & $FileType & '", "file_url": "' & $telegram_url & '", "body": "' & $body & '"}'
			$oHTTP2.Send($pPush)
		Else
			SetLog("Notify Telegram: Unable to send file " & $File, $COLOR_RED)
			_PushToTelegram($iOrigPushBullet & " | " & GetTranslated(620,554,"Unable to Upload File") & "\n" & GetTranslated(620,555,"Occured an error type 2 uploading file to Telegram server..."))
		EndIf
	EndIf
	;Telegram ---------------------------------------------------------------------------------
EndFunc   ;==>_PushFile

Func _DeletePushOfPushBullet()
	If ($PushBulletEnabled = 0 And $TelegramEnabled = 0) Or ($PushBulletToken = "" And $TelegramToken = "") Then Return

	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("DELETE", "https://api.pushbullet.com/v2/pushes", False)
	$access_token = $PushBulletToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
EndFunc   ;==>_DeletePush

Func _DeleteMessageOfPushBullet($iden)
	If ($PushBulletEnabled = 0 And $TelegramEnabled = 0) Or ($PushBulletToken = "" And $TelegramToken = "") Then Return

	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("Delete", "https://api.pushbullet.com/v2/pushes/" & $iden, False)
	$access_token = $PushBulletToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$iden = ""
EndFunc   ;==>_DeleteMessage

Func PushMsgToBoth($Message, $Source = "")

 	If $iForceNotify = 0 And $Message <> "DeleteAllPBMessages" Then
		If $iPlannedNotifyWeekdaysEnable = 1 Then
			If $iPlannedNotifyWeekdays[@WDAY - 1] = 1 Then
				If $iPlannedNotifyHoursEnable = 1 Then
					Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
					If $iPlannedNotifyHours[$hour[0]] = 0 Then
						SetLog("Notify not planned for this hour, Skipped..", $COLOR_ORANGE)
						SetLog($Message, $COLOR_ORANGE)
						Return ; exit func if no planned
					EndIf
				EndIf
			Else
				SetLog("Notify not planned to: " & _DateDayOfWeek(@WDAY), $COLOR_ORANGE)
				SetLog($Message, $COLOR_ORANGE)
				Return ; exit func if not planned
			EndIf
		Else
			If $iPlannedNotifyHoursEnable = 1 Then
				Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
				If $iPlannedNotifyHours[$hour[0]] = 0 Then
					SetLog("Notify not planned for this hour, Skipped..", $COLOR_ORANGE)
					SetLog($Message, $COLOR_ORANGE)
					Return ; exit func if no planned
				EndIf
			EndIf
		EndIf
	EndIf

	$iForceNotify = 0

	Local $hBitmap_Scaled
	Switch $Message
		Case "Restarted"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1)  And $pRemote = 1 Then _PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,56, "Bot restarted"))
		Case "OutOfSync"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1)  And $pOOS = 1 Then _PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,57, "Restarted after Out of Sync Error") & "\n" & GetTranslated(620,58, "Attacking now") & "...")
		Case "LastRaid"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1)  And $pLastRaidTxt = 1 Then
				_PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,34, "Last Raid txt") & "\n" & "[" & GetTranslated(620,35, "G") & "]: " & _NumberFormat($iGoldLast) & " [" & GetTranslated(620,36, "E") & "]: " & _NumberFormat($iElixirLast) & " [" & GetTranslated(620,37, "D") & "]: " & _NumberFormat($iDarkLast) & " [" & GetTranslated(620,38, "T") & "]: " & $iTrophyLast)
				If _Sleep($iDelayPushMsg1) Then Return
				SetLog("Notify PushBullet: Last Raid Text has been sent!", $COLOR_GREEN)
			EndIf
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1)  And $pLastRaidImg = 1 Then
				_CaptureRegion()
				;create a temporary file to send with pushbullet...
				Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
				Local $Time = @HOUR & "." & @MIN
				If $ScreenshotLootInfo = 1 Then
					$AttackFile = $Date & "__" & $Time & " " & GetTranslated(620,35, "G") & $iGoldLast & " " & GetTranslated(620,36, "E") & $iElixirLast & " " & GetTranslated(620,37, "D") & $iDarkLast & " " & GetTranslated(620,38, "T") & $iTrophyLast & " " & GetTranslated(620,59, "S") & StringFormat("%3s", $SearchCount) & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
				Else
					$AttackFile = $Date & "__" & $Time & ".jpg" ; separator __ is need  to not have conflict with saving other files if $TakeSS = 1 and $chkScreenshotLootInfo = 0
				EndIf
				$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
				_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirLoots & $AttackFile)
				_GDIPlus_ImageDispose($hBitmap_Scaled)
				;push the file
				SetLog("Notify PushBullet: Last Raid screenshot has been sent!", $COLOR_GREEN)
				_PushFileToBoth($AttackFile, GetTranslated(620,31, "Loots"), "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(620,32, "Last Raid") & "\n" & $AttackFile)
				;wait a second and then delete the file
				If _Sleep($iDelayPushMsg1) Then Return
				Local $iDelete = FileDelete($dirLoots & $AttackFile)
				If Not ($iDelete) Then SetLog("Notify PushBullet: An error occurred deleting temporary screenshot file.", $COLOR_RED)
			EndIf
		Case "FoundWalls"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pWallUpgrade = 1 Then _PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,60, "Found Wall level") & " " & $icmbWalls + 4 & "\n" & " " & GetTranslated(620,61, "Wall segment has been located") & "...\n" & GetTranslated(620,62, "Upgrading") & "...")
		Case "SkypWalls"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pWallUpgrade = 1 Then _PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,63, "Cannot find Wall level") & $icmbWalls + 4 & "\n" & GetTranslated(620,64, "Skip upgrade") & "...")
		Case "AnotherDevice3600"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pAnotherDevice = 1 Then _PushToBoth($iOrigPushBullet & " | 1. " & GetTranslated(620,65, "Another Device has connected") & "\n" & GetTranslated(620,66, "Another Device has connected, waiting") & " " & Floor(Floor($sTimeWakeUp / 60) / 60) & " " & GetTranslated(603,14, "Hours") & " " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " " & GetTranslated(603,9, "minutes") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "AnotherDevice60"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pAnotherDevice = 1 Then _PushToBoth($iOrigPushBullet & " | 2. " & GetTranslated(620,65, "Another Device has connected") & "\n" & GetTranslated(620,66, "Another Device has connected, waiting") & " " & Floor(Mod(Floor($sTimeWakeUp / 60), 60)) & " " & GetTranslated(603,9, "minutes") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "AnotherDevice"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pAnotherDevice = 1 Then _PushToBoth($iOrigPushBullet & " | 3. " & GetTranslated(620,65, "Another Device has connected") & "\n" & GetTranslated(620,66, "Another Device has connected, waiting") & " " & Floor(Mod($sTimeWakeUp, 60)) & " " & GetTranslated(603,8, "seconds"))
		Case "TakeBreak"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pTakeAbreak = 1 Then _PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,67, "Chief, we need some rest!") & "\n" & GetTranslated(620,68, "Village must take a break.."))
		Case "Update"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pBOTUpdate = 1 Then _PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,167, "Chief, there is a new version of the bot available"))
		Case "BuilderIdle"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pBuilderIdle = 1 Then
				Local $iAvailBldr = $iFreeBuilderCount - $iSaveWallBldr
				if $iAvailBldr > 0 Then
					if $iReportIdleBuilder <> $iAvailBldr Then
						_PushToPushBullet($iOrigPushBullet & " | " & GetTranslated(620,200,"You have") & " " & $iAvailBldr & GetTranslated(620,201," builder(s) idle."))
						SetLog("Notify: " & GetTranslated(620,200,"You have") & " " & $iAvailBldr & GetTranslated(620,201," builder(s) idle."), $COLOR_GREEN)
						$iReportIdleBuilder = $iAvailBldr
					EndIf
				Else
					$iReportIdleBuilder = 0
				EndIf
			EndIf
		Case "CocError"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pOOS = 1 Then _PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,69, "CoC Has Stopped Error") & ".....")
		Case "Pause"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pRemote = 1 And $Source = "Push" Then _PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,70, "Request to Pause") & "..." & "\n" & GetTranslated(620,71, "Your request has been received. Bot is now paused"))
		Case "Resume"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pRemote = 1 And $Source = "Push" Then _PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,72, "Request to Resume") & "..." & "\n" & GetTranslated(620,73, "Your request has been received. Bot is now resumed"))
		Case "OoSResources"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pOOS = 1 Then _PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,74, "Disconnected after") & " " & StringFormat("%3s", $SearchCount) & " " & GetTranslated(620,75, "skip(s)") & "\n" & GetTranslated(620,76, "Cannot locate Next button, Restarting Bot") & "...")
		Case "MatchFound"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pMatchFound = 1 Then _PushToBoth($iOrigPushBullet & " | " & $sModeText[$iMatchMode] & " " & GetTranslated(620,89, "Match Found! after") & " " & StringFormat("%3s", $SearchCount) & " " & GetTranslated(620,75, "skip(s)") & "\n" & "[" & GetTranslated(620,35, "G") & "]: " & _NumberFormat($searchGold) & "; [" & GetTranslated(620,36, "E") & "]: " & _NumberFormat($searchElixir) & "; [" & GetTranslated(620,37, "D") & "]: " & _NumberFormat($searchDark) & "; [" & GetTranslated(620,38, "T") & "]: " & $searchTrophy)
		Case "UpgradeWithGold"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pWallUpgrade = 1 Then _PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,77, "Upgrade completed by using GOLD") & "\n" & GetTranslated(620,78, "Complete by using GOLD") & "...")
		Case "UpgradeWithElixir"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pWallUpgrade = 1 Then _PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,79, "Upgrade completed by using ELIXIR") & "\n" & GetTranslated(620,80, "Complete by using ELIXIR") & "...")
		Case "NoUpgradeWallButton"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pWallUpgrade = 1 Then _PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,81, "No Upgrade Gold Button") & "\n" & GetTranslated(620,81, "Cannot find gold upgrade button") & "...")
		Case "NoUpgradeElixirButton"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pWallUpgrade = 1 Then _PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,82, "No Upgrade Elixir Button") & "\n" & GetTranslated(620,83, "Cannot find elixir upgrade button") & "...")
		Case "RequestScreenshot"
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion()
			If $PBRequestScreenshotHD = 1 Or $TGRequestScreenshotHD = 1 Then
				$hBitmap_Scaled = $hBitmap
			Else
				$hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, _GDIPlus_ImageGetWidth($hBitmap) / 2, _GDIPlus_ImageGetHeight($hBitmap) / 2) ;resize image
			EndIf
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap_Scaled, $dirTemp & $Screnshotfilename)
			_GDIPlus_ImageDispose($hBitmap_Scaled)
			If $PBRequestScreenshotHD = 1 Then
				_PushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(620,84, "Screenshot of your village") & " " & "\n" & $Screnshotfilename)
				SetLog("Notify PushBullet: Screenshot sent!", $COLOR_GREEN)
			EndIf
			If $TGRequestScreenshotHD = 1 Then
				_PushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $iOrigPushBullet & " | " & GetTranslated(620,84, "Screenshot of your village") & " " & "\n" & $Screnshotfilename)
				SetLog("Notify Telegram: Screenshot sent!", $COLOR_GREEN)
			EndIf
			$PBRequestScreenshot = 0
			$PBRequestScreenshotHD = 0
			$TGRequestScreenshot = 0
			$TGRequestScreenshotHD = 0
			;wait a second and then delete the file
			If _Sleep($iDelayPushMsg2) Then Return
			Local $iDelete = FileDelete($dirTemp & $Screnshotfilename)
			If Not ($iDelete) Then SetLog("Notify PushBullet: An error occurred deleting the temporary screenshot file.", $COLOR_RED)
		Case "BuilderInfo"
			Click(0,0, 5)
			Click(274,8)
			_Sleep (500)
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion(224, 74, 446, 262)
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap, $dirTemp & $Screnshotfilename)
			If $PBRequestBuilderInfo = 1 Then
				_PushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $iOrigPushBullet & " | " &  "Buider Information" & "\n" & $Screnshotfilename)
				SetLog("Notify PushBullet: Builder Information sent!", $COLOR_GREEN)
			EndIf
			If $TGRequestBuilderInfo = 1 Then
				_PushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $iOrigPushBullet & " | " &  "Buider Information" & "\n" & $Screnshotfilename)
				SetLog("Notify Telegram: Builder Information sent!", $COLOR_GREEN)
			EndIf
			$PBRequestBuilderInfo = 0
			$TGRequestBuilderInfo = 0
			;wait a second and then delete the file
			If _Sleep($iDelayPushMsg2) Then Return
			Local $iDelete = FileDelete($dirTemp & $Screnshotfilename)
			If Not ($iDelete) Then SetLog("An error occurred deleting the temporary screenshot file.", $COLOR_RED)
			Click(0,0, 5)
		Case "ShieldInfo"
			Click(0,0, 5)
			Click(435,8)
			_Sleep (500)
			Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
			Local $Time = @HOUR & "." & @MIN
			_CaptureRegion(200, 165, 660, 568)
			Local $Screnshotfilename = "Screenshot_" & $Date & "_" & $Time & ".jpg"
			_GDIPlus_ImageSaveToFile($hBitmap, $dirTemp & $Screnshotfilename)
			If $PBRequestShieldInfo = 1 Then
				_PushFileToPushBullet($Screnshotfilename, "Temp", "image/jpeg", $iOrigPushBullet & " | " &  "Shield Information" & "\n" & $Screnshotfilename)
				SetLog("Notify PushBullet: Shield Information sent!", $COLOR_GREEN)
			EndIf
			If $TGRequestShieldInfo = 1 Then
				_PushFileToTelegram($Screnshotfilename, "Temp", "image/jpeg", $iOrigPushBullet & " | " &  "Shield Information" & "\n" & $Screnshotfilename)
				SetLog("Notify Telegram: Shield Information sent!", $COLOR_GREEN)
			EndIf
			$PBRequestShieldInfo = 0
			$TGRequestShieldInfo = 0
			;wait a second and then delete the file
			If _Sleep($iDelayPushMsg2) Then Return
			Local $iDelete = FileDelete($dirTemp & $Screnshotfilename)
			If Not ($iDelete) Then SetLog("An error occurred deleting the temporary screenshot file.", $COLOR_RED)
			Click(0,0, 5)
		Case "DeleteAllPBMessages"
			_DeletePushOfPushBullet()
			SetLog("Notify PushBullet: All messages deleted.", $COLOR_GREEN)
			$iDeleteAllPBPushesNow = False ; reset value
		Case "CampFull"
			If ($PushBulletEnabled = 1 Or $TelegramEnabled = 1) And $pCampFull = 1 Then
				If $pCampFullTest = 0 Then
					_PushToBoth($iOrigPushBullet & " | " & GetTranslated(620,85, "Your Army Camps are now Full"))
					$pCampFullTest = 1
				EndIf
			EndIf
	EndSwitch
EndFunc   ;==>PushMsgToBoth

Func _DeleteOldPushesOfPushBullet()
	If ($PushBulletEnabled = 0 And $TelegramEnabled = 0) Or ($PushBulletToken = "" And $TelegramToken = "") Or $ichkDeleteOldPBPushes = 0 Then Return
	;local UTC time
	Local $tLocal = _Date_Time_GetLocalTime()
	Local $tSystem = _Date_Time_TzSpecificLocalTimeToSystemTime(DllStructGetPtr($tLocal))
	Local $timeUTC = _Date_Time_SystemTimeToDateTimeStr($tSystem, 1)
	Local $timestamplimit = 0
	$oHTTP = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP.Open("Get", "https://api.pushbullet.com/v2/pushes?active=true&modified_after=" & $timestamplimit, False) ; limit to 48h read push, antiban purpose
	$access_token = $PushBulletToken
	$oHTTP.SetCredentials($access_token, "", 0)
	$oHTTP.SetRequestHeader("Content-Type", "application/json")
	$oHTTP.Send()
	$Result = $oHTTP.ResponseText
	Local $findstr = StringRegExp($Result, ',"created":')
	Local $msgdeleted = 0
	If $findstr = 1 Then
		Local $body = _StringBetween($Result, '"body":"', '"', "", False)
		Local $iden = _StringBetween($Result, '"iden":"', '"', "", False)
		Local $created = _StringBetween($Result, '"created":', ',', "", False)
		If IsArray($body) And IsArray($iden) And IsArray($created) Then
			For $x = 0 To UBound($created) - 1
				If $iden <> "" And $created <> "" Then
					Local $hdif = _DateDiff('h', _GetDateFromUnix($created[$x]), $timeUTC)
					If $hdif >= $icmbHoursPushBullet Then
						;	setlog("PushBullet, deleted message: (+" & $hdif & "h)" & $body[$x] )
						$msgdeleted += 1
						_DeleteMessageOfPushBullet($iden[$x])
						;else
						;	setlog("PushBullet, skipped message: (+" & $hdif & "h)" & $body[$x] )
					EndIf
				EndIf
				$body[$x] = ""
				$iden[$x] = ""
			Next
		EndIf
	EndIf
	If $msgdeleted > 0 Then
		SetLog("Notify PushBullet: removed " & $msgdeleted & " messages older than " & $icmbHoursPushBullet & " h ", $COLOR_GREEN)
		;_PushToBoth($iOrigPushBullet & " | removed " & $msgdeleted & " messages older than " & $icmbHoursPushBullet & " h ")
	EndIf
EndFunc   ;==>_DeleteOldPushes



Func GetLastMsg()
    If $TelegramEnabled = 0 Or $TelegramToken = "" Then Return
	$access_token2 = $TelegramToken
	$oHTTP2 = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$oHTTP2.Open("Get", "https://api.telegram.org/bot" & $access_token2 & "/getupdates" , False)
	$oHTTP2.Send()
	$Result = $oHTTP2.ResponseText
	;SetLog("Telegram Result=" & $Result, $COLOR_RED)

	local $chat_id = _StringBetween($Result, 'm":{"id":', ',"f')
	$TelegramChatID = _Arraypop($chat_id)

	local $uid = _StringBetween($Result, 'update_id":', '"message"')             ;take update id
	$lastuid = StringTrimRight(_Arraypop($uid), 2)


	;SetLog("Telegram chat_id=" & $TelegramChatID, $COLOR_RED)
	;SetLog("Telegram lastuid=" & $lastuid, $COLOR_RED)

	Local $findstr2 = StringRegExp(StringUpper($Result), '"TEXT":"')
	If $findstr2 = 1 Then
		local $rmessage = _StringBetween($Result, 'text":"' ,'"}}' )           ;take message
		local $lastmessage = _Arraypop($rmessage)								 ;take last message
		;SetLog("Notify Telegram: $lastmessage=" & $lastmessage, $COLOR_RED)
	EndIf


	$oHTTP2.Open("Get", "https://api.telegram.org/bot" & $access_token2 & "/getupdates?offset=" & $lastuid  , False)
	$oHTTP2.Send()
	$Result2 = $oHTTP2.ResponseText

	;local $chat_id_ = _StringBetween($Result2, 'm":{"id":', ',"f')
	;local $TelegramChatID_ = _Arraypop($chat_id_)

	;local $uid_ = _StringBetween($Result2, 'update_id":', '"message"' )             ;take update id
	;$lastuid_ = StringTrimRight(_Arraypop($uid_), 2)

	;SetLog("Telegram Result2=" & $Result2, $COLOR_PURPLE)
	;SetLog("Telegram TelegramChatID=" & $TelegramChatID_, $COLOR_PURPLE)
	;SetLog("Telegram lastuid_=" & $lastuid_, $COLOR_PURPLE)

	Local $findstr2 = StringRegExp(StringUpper($Result2), '"TEXT":"')
	If $findstr2 = 1 Then
		local $rmessage = _StringBetween($Result2, 'text":"' ,'"}}' )           ;take message
		local $lastmessage = _Arraypop($rmessage)		;take last message
		If $lastmessage = "" Then
			local $rmessage = _StringBetween($Result2, 'text":"' ,'","entities"' )           ;take message
			local $lastmessage = _Arraypop($rmessage)		;take last message
		EndIf

		;If StringLeft($rmessage, 18) = "SELECT YOUR REMOTE" Then
		;	local $lastmessage = _Arraypop(StringTrimLeft($rmessage, 29))
		;EndIf
		;SetLog("Notify Telegram: $lastmessage2=" & $lastmessage, $COLOR_PURPLE)
		return $lastmessage
	EndIf

EndFunc

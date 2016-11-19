; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
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

$hGUI_NOTIFY = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_VILLAGE)
;GUISetBkColor($COLOR_WHITE, $hGUI_NOTIFY)

$hGUI_NOTIFY_TAB = GUICtrlCreateTab(0, 0, $_GUI_MAIN_WIDTH - 30, $_GUI_MAIN_HEIGHT - 255 - 30, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
;$hGUI_NOTIFY_TAB_ITEM1 = GUICtrlCreateTabItem("How")
;	Local $x = 25, $y = 45
;GUICtrlCreateTabItem("")

$hGUI_NOTIFY_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslated(600,18,"PushBullet/Telegram"))

	Local $x = 25, $y = 45
		$grpPushBullet = GUICtrlCreateGroup(GetTranslated(619,2, "PushBullet/Telegram Notify"), $x - 20, $y - 20, 430, 334)
		$x -= 10
		$picPushBullet = GUICtrlCreateIcon ($pIconLib, $eIcnPushBullet, $x + 3, $y, 32, 32)
		$chkPBenabled = GUICtrlCreateCheckbox(GetTranslated(619,3, "Enable PushBullet"), $x + 40, $y)
			GUICtrlSetOnEvent(-1, "chkPBTGenabled")
			_GUICtrlSetTip(-1, GetTranslated(619,4, "Enable PushBullet notifications"))
		 $chkTGenabled = GUICtrlCreateCheckbox(GetTranslated(619,303, "Enable Telegram"), $x + 40, $y + 22)
			GUICtrlSetOnEvent(-1, "chkPBTGenabled")
			_GUICtrlSetTip(-1, GetTranslated(619,304, "Enable Telegram notifications"))
		$chkPBRemote = GUICtrlCreateCheckbox(GetTranslated(619,5, "Remote Control"), $x + 40, $y + 44)
			_GUICtrlSetTip(-1, GetTranslated(619,6, "Enables PushBullet Remote function"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y = 45
		$chkDeleteAllPBPushes = GUICtrlCreateCheckbox(GetTranslated(619,7, "Delete Msg on Start"), $x + 160, $y)
			_GUICtrlSetTip(-1, GetTranslated(619,8, "It will delete all previous push notification when you start bot"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$btnDeletePBmessages = GUICtrlCreateButton(GetTranslated(619,9, "Delete all Msg now"), $x + 300, $y, 100, 20)
			_GUICtrlSetTip(-1, GetTranslated(619,10, "Click here to delete all PushBullet messages."))
			GUICtrlSetOnEvent(-1, "btnDeletePBMessages")
			IF $btnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 22
		$chkDeleteOldPBPushes = GUICtrlCreateCheckbox(GetTranslated(619,11, "Delete Msg older than"), $x + 160, $y)
			_GUICtrlSetTip(-1, GetTranslated(619,12, "Delete all previous push notification older than specified hour"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "chkDeleteOldPBPushes")
		$cmbHoursPushBullet = GUICtrlCreateCombo("", $x + 300, $y, 100, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslated(619,13, "Set the interval for messages to be deleted."))
			$sTxtHours = GetTranslated(603,14, "Hours")
			GUICtrlSetData(-1, "1 " & GetTranslated(603,15, "Hour") &"|2 " & $sTxtHours & "|3 " & $sTxtHours & "|4 " & $sTxtHours & "|5 " & $sTxtHours & "|6 " & $sTxtHours & "|7 " & $sTxtHours & "|8 " &$sTxtHours & "|9 " & $sTxtHours & "|10 " & $sTxtHours & "|11 " & $sTxtHours & "|12 " & $sTxtHours & "|13 " & $sTxtHours & "|14 " & $sTxtHours & "|15 " & $sTxtHours & "|16 " & $sTxtHours & "|17 " & $sTxtHours & "|18 " & $sTxtHours & "|19 " & $sTxtHours & "|20 " & $sTxtHours & "|21 " & $sTxtHours & "|22 " & $sTxtHours & "|23 " & $sTxtHours & "|24 " & $sTxtHours )
			_GUICtrlComboBox_SetCurSel(-1,0)
			GUICtrlSetState (-1, $GUI_DISABLE)
		$y += 55
		$lblPushBulletTokenValue = GUICtrlCreateLabel(GetTranslated(619,14, "Token (PushBullet)") & ":", $x, $y, -1, -1, $SS_RIGHT)
		$PushBulletTokenValue = GUICtrlCreateInput("", $x + 120, $y - 3, 280, 19)
			_GUICtrlSetTip(-1, GetTranslated(619,15, "You need a Token to use PushBullet notifications. Get a token from PushBullet.com"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 25
		$lblTelegramTokenValue = GUICtrlCreateLabel(GetTranslated(619,314, "Token (Telegram)") & ":", $x, $y, -1, -1, $SS_RIGHT)
		$TelegramTokenValue = GUICtrlCreateInput("", $x + 120, $y - 3, 280, 19)
			_GUICtrlSetTip(-1, GetTranslated(619,315, "You need a Token to use Telegram notifications. Get a token from Telegram.com"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 25
		$lblOrigPushBullet = GUICtrlCreateLabel(GetTranslated(619,16, "Origin") & ":", $x, $y, -1, -1, $SS_RIGHT)
			$txtTip = GetTranslated(619,17, "Origin - Village name.")
			_GUICtrlSetTip(-1, $txtTip)
		$OrigPushBullet = GUICtrlCreateInput("", $x + 120, $y - 3, 280, 19)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 25
		$lblNotifyPBWhen = GUICtrlCreateLabel(GetTranslated(619,18, "Send a PushBullet/Telegram message for these options") & ":", $x, $y, -1, -1, $SS_RIGHT)
		$y += 15
		$chkAlertPBVMFound = GUICtrlCreateCheckbox(GetTranslated(619,19, "Match Found"), $x + 10, $y)
			_GUICtrlSetTip(-1, GetTranslated(619,20, "Send the amount of available loot when bot finds a village to attack."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertPBLastRaid = GUICtrlCreateCheckbox(GetTranslated(619,21, "Last raid as image"), $x + 100, $y)
			_GUICtrlSetTip(-1, GetTranslated(619,22, "Send the last raid screenshot."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertPBLastRaidTxt = GUICtrlCreateCheckbox(GetTranslated(619,23, "Last raid as Text"), $x + 210, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
			_GUICtrlSetTip(-1, GetTranslated(619,24, "Send the last raid results as text."))
		$chkAlertPBCampFull = GUICtrlCreateCheckbox(GetTranslated(619,25, "Army Camp Full"), $x + 315, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,26, "Sent an Alert when your Army Camp is full."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 20
		$chkAlertPBWallUpgrade = GUICtrlCreateCheckbox(GetTranslated(619,27, "Wall upgrade"), $x + 10, $y, -1, -1)
			 _GUICtrlSetTip(-1, GetTranslated(619,28, "Send info about wall upgrades."))
			 GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertPBOOS = GUICtrlCreateCheckbox(GetTranslated(619,29, "Error: Out Of Sync"), $x + 100, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,30, "Send an Alert when you get the Error: Client and Server out of sync"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertPBVBreak = GUICtrlCreateCheckbox(GetTranslated(619,31, "Take a break"), $x + 210, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,32, "Send an Alert when you have been playing for too long and your villagers need to rest."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertBuilderIdle = GUICtrlCreateCheckbox(GetTranslated(619,200, "Builder Idle"), $x + 315, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,201, "Send an Alert when at least one builder is idle."))
			GUICtrlSetState(-1, $GUI_DISABLE)			
		$y += 20
		$chkAlertPBVillage = GUICtrlCreateCheckbox(GetTranslated(619,33, "Village Report"), $x + 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,34, "Send a Village Report."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertPBLastAttack = GUICtrlCreateCheckbox(GetTranslated(619,35, "Alert Last Attack"), $x + 100, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,36, "Send info about the Last Attack."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertPBOtherDevice = GUICtrlCreateCheckbox(GetTranslated(619,37, "Another device"), $x + 210, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,38, "Send an Alert when your village is connected to from another device."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		$y += 20
		$chkAlertPBMaintenance = GUICtrlCreateCheckbox(GetTranslated(619,202, "Maintenance"), $x + 10, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,34, "Send an Alert when CoC is under maintenance by SuperCell"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertPBBAN = GUICtrlCreateCheckbox(GetTranslated(619,204, "BAN"), $x + 100, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,205, "Send an Alert if your village was BANNED by SuperCell"))
			GUICtrlSetState(-1, $GUI_DISABLE)
		$chkAlertPBUpdate= GUICtrlCreateCheckbox(GetTranslated(619,206, "BOT Update"), $x + 210, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslated(619,207, "Send an Alert when there is a new version of the bot."))
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)		
GUICtrlCreateTabItem("")
$hGUI_NOTIFY_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslated(600,19,"Instructions"))
	    Local $NotifyHelp = _IECreateEmbedded()
		GUICtrlCreateObj($NotifyHelp, 5, 25, 430, 334)
		If FileExists(@ScriptDir & "\Help\NotifyHelp_" & $sDefaultLanguage & ".mht") Then
			_IENavigate($NotifyHelp, @ScriptDir & "\Help\NotifyHelp_" & $sDefaultLanguage & ".mht", 1)
			$NotifyHelp.document.body.style.border = "0px"
		ElseIf FileExists(@ScriptDir & "\Help\NotifyHelp_English.mht") Then
			_IENavigate($NotifyHelp, @ScriptDir & "\Help\NotifyHelp_English.mht", 1)
			$NotifyHelp.document.body.style.border = "0px"
		EndIf
GUICtrlCreateTabItem("")


$hGUI_NOTIFY_TAB_ITEM6 = GUICtrlCreateTabItem(GetTranslated(600,300,"Notify Schedule"))
	$x = 25
	$y = 150 - 105
	$grpSchedulerNotify = GUICtrlCreateGroup(GetTranslated(619,39, "Notify Schedule"), $x - 20, $y - 20, 430, 334)
	$x += 10
	$y += 10

	GUICtrlCreateIcon($pIconLib, $eIcnPBNotify, $x - 5, $y, 64, 64, $BS_ICON)
	$chkNotifyHours = GUICtrlCreateCheckbox(GetTranslated(619,40, "Only during these hours of day"), $x+70, $y-6)
	GUICtrlSetOnEvent(-1, "chkNotifyHours")

	$x += 59
	$y += 85
	$lbNotifyhours1 = GUICtrlCreateLabel(" 0", $x + 30, $y)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyhours2 = GUICtrlCreateLabel(" 1", $x + 45, $y)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyhours3 = GUICtrlCreateLabel(" 2", $x + 60, $y)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyhours4 = GUICtrlCreateLabel(" 3", $x + 75, $y)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyhours5 = GUICtrlCreateLabel(" 4", $x + 90, $y)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyhours6 = GUICtrlCreateLabel(" 5", $x + 105, $y)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyhours7 = GUICtrlCreateLabel(" 6", $x + 120, $y)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyhours8 = GUICtrlCreateLabel(" 7", $x + 135, $y)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyhours9 = GUICtrlCreateLabel(" 8", $x + 150, $y)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyhours10 = GUICtrlCreateLabel(" 9", $x + 165, $y)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyhours11 = GUICtrlCreateLabel("10", $x + 180, $y)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyhours12 = GUICtrlCreateLabel("11", $x + 195, $y)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 15
	$chkNotifyhours0 = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours1 = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours2 = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours3 = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours4 = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours5 = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours6 = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours7 = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours8 = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours9 = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours10 = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours11 = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhoursE1 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
	GUICtrlSetImage(-1, $pIconLib, $eIcnGoldStar, 0)
	GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
	$txtTip = GetTranslated(619,326, "This button will clear or set the entire row of boxes")
	GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkNotifyhoursE1")
	$lbNotifyhoursAM = GUICtrlCreateLabel("AM", $x + 10, $y)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 15
	$chkNotifyhours12 = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours13 = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours14 = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours15 = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours16 = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours17 = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours18 = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours19 = GUICtrlCreateCheckbox("", $x + 135, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours20 = GUICtrlCreateCheckbox("", $x + 150, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours21 = GUICtrlCreateCheckbox("", $x + 165, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours22 = GUICtrlCreateCheckbox("", $x + 180, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhours23 = GUICtrlCreateCheckbox("", $x + 195, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyhoursE2 = GUICtrlCreateCheckbox("", $x + 211, $y+1, 13, 13, BitOR($BS_PUSHLIKE, $BS_ICON))
	GUICtrlSetImage(-1, $pIconLib, $eIcnGoldStar, 0)
	GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_DISABLE)
	$txtTip = GetTranslated(619,326, "This button will clear or set the entire row of boxes")
	GUICtrlSetTip(-1, $txtTip)
	GUICtrlSetOnEvent(-1, "chkNotifyhoursE2")
	$lbNotifyhoursPM = GUICtrlCreateLabel("PM", $x + 10, $y)
	GUICtrlSetState(-1, $GUI_DISABLE)


	$x = 35
	$y = 220



	$chkNotifyWeekDays = GUICtrlCreateCheckbox(GetTranslated(619,346, "Notify only in this day of the week"), $x + 70, $y - 6)
	GUICtrlSetOnEvent(-1, "chkNotifyWeekDays")
		GUICtrlSetState(-1, $GUI_DISABLE)

	$x += 59
	$y += 19
	$lbNotifyWeekdays0 = GUICtrlCreateLabel(GetTranslated(619,337, " S"), $x + 30, $y)
	GUICtrlSetTip(-1, GetTranslated(619,329, "Sunday"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyWeekdays1 = GUICtrlCreateLabel(GetTranslated(619,338, " M"), $x + 45, $y)
	GUICtrlSetTip(-1, GetTranslated(619,330, "Monday"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyWeekdays2 = GUICtrlCreateLabel(GetTranslated(619,339, " T"), $x + 60, $y)
	GUICtrlSetTip(-1, GetTranslated(619,331, "Tuesday"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyWeekdays3 = GUICtrlCreateLabel(GetTranslated(619,340, " W"), $x + 75, $y)
	GUICtrlSetTip(-1, GetTranslated(619,332, "Wednesday"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyWeekdays4 = GUICtrlCreateLabel(GetTranslated(619,341, " T"), $x + 90, $y)
	GUICtrlSetTip(-1, GetTranslated(619,333, "Thursday"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyWeekdays5 = GUICtrlCreateLabel(GetTranslated(619,342, " F"), $x + 105, $y)
	GUICtrlSetTip(-1, GetTranslated(619,334, "Friday"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lbNotifyWeekdays6 = GUICtrlCreateLabel(GetTranslated(619,343, " S"), $x + 120, $y)
	GUICtrlSetTip(-1, GetTranslated(619,335, "Saturday"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	$y += 13
	$chkNotifyWeekdays0 = GUICtrlCreateCheckbox("", $x + 30, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyWeekdays1 = GUICtrlCreateCheckbox("", $x + 45, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyWeekdays2 = GUICtrlCreateCheckbox("", $x + 60, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyWeekdays3 = GUICtrlCreateCheckbox("", $x + 75, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyWeekdays4 = GUICtrlCreateCheckbox("", $x + 90, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyWeekdays5 = GUICtrlCreateCheckbox("", $x + 105, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)
	$chkNotifyWeekdays6 = GUICtrlCreateCheckbox("", $x + 120, $y, 15, 15)
	GUICtrlSetState(-1, $GUI_CHECKED + $GUI_DISABLE)




;GUISetState()

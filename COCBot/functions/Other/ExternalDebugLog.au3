; #FUNCTION# ====================================================================================================================
; Name ..........: External Debug Log
; Description ...: This file contains all functions of External Debug Log feature
; Syntax ........: ---
; Parameters ....: 	$Function = the name of function from where function is called. Will be in the name of the log file
;					$Text = the text to be shown/saved
;					$Priority = If = 0, will only save log in file, if = 1, will also show line in BOT log
;					$Color = the color of debug line on BOT log
; Return values .: ---
; Author ........: RoroTiti - 31/10/2016
; Modified ......: ---
; Remarks .......: This file is part of MyBotRun. Copyright 2016
;                  MyBotRun is distributed under the terms of the GNU GPL
;				   Because this file is a part of an open-sourced project, I allow all MODders and DEVelopers to use these functions.
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: No
;================================================================================================================================

Func DebLog($Function, $Text, $Priority = 0, $Color = $COLOR_DEBUG)

	If $Priority = 1 Then SetLog($Text, $Color)
	_FileWriteLog($dirLogs & "DocOc\DebugFileDocOc-" & $Function & ".log", $Text)

EndFunc   ;==>DebLog

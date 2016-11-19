;~ #AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#include-once
#include <Math.au3>
#include <File.au3>
#include <Array.au3>
#include <WinAPI.au3>
#include <String.au3>
#include <GuiTab.au3>
#include <GuiEdit.au3>
#include <WinAPIEx.au3>
#include <GuiButton.au3>
#include <Constants.au3>
#include <SendMessage.au3>
#include <WinAPIFiles.au3>
#include <GuiImageList.au3>
#include <APIConstants.au3>
#include <FileConstants.au3>
#include <ScreenCapture.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>


#Tidy_Off
Global $hCBTPROC_CALLBKERROR
Global $hCBTPROC_HOOKERROR
Global $hERROR_HWND
Global $hRECDATA_HWND
Global $tCOPYDATA
Global $pCOPYDATA
Global $tENTERDATA
Global $pENTERDATA
Global $iLASTLINE
Global $hUSER32
Global $hWINDOW_PROC
Global $hNEWDLG_HWND
Global $hSNDDLG_HWND
Global $hSCRDLG_HWND
Global $hSCRDLG_HWND1
Global $hABTDLG_HWND
Global $iTHREADID
Global $hLASTWIN_HWND
Global $hGETERROR
Global $sBTN_TRYAGAIN
Global $sBTN_CONTINUE
Global $sBTN_CANCEL
Global $hBTN_MORE
Global $hBTN_SAVE
Global $hBTN_LASTSCR
Global $hBTN_LASTSCR1
Global $hBTN_SENDDLG
Global $hSND_EDIT1
Global $hSND_EDIT2
Global $hBTN_SENDOK
Global $hBTN_CHECKBOX
Global $sBTN_OK_SNDDLG
Global $sBTN_OK_SCRDLG
Global $sBTN_OK_ABOUT
Global $hSCR_HBITMAP
Global $hSCR_HBITMAP1
Global $hLBL_INFO
Global $hLBL_ERROR
Global $hBTN_OPENFOLDER
Global $sERROR_TITLE 	= @ScriptName
Global $sERROR_TEXT 	= "A crash has been detected in MyBot!" & @CRLF & @CRLF & _
							"To help the development process, this program will try and gather" & _
							" the information about the crash and the state os your Bot at the time of crash. " & _
							"Please report about this bug to developer"
Global $sOK_BTN 		= "OK"
Global $sTRYAGAIN_BTN 	= "Try Again"
Global $sCONTINUE_BTN 	= "Continue"
Global $sCANCEL_BTN		= "Cancel"
Global $sSEND_BTN 		= "Submit"
Global $sLASTSCRN_BTN 	= "Bot Screen"
Global $sLASTSCRN_BTN1 	= "Android Screen"
Global $sOPENFOLDER_BTN = "Find Bug File"
Global $sSAVE_BTN		= "Save..."
Global $sENVIROMMENT 	= "Environment( Language:" & @OSLang & " - Keyboard:" & @KBLayout & " - OS:" & @OSVersion & " /  CPU:" & @CPUArch & " - OS:" & @OSArch & " )" & @CRLF & @CRLF
Global $sABOUT_TITLE	= "About"
Global $sTRYCONTINUE	= "Due to system of errors, it is still not possible to continue (so far) safely!" & @CRLF & @CRLF & "Sorry for the inconvenience..."
Global $hPARENT			= 0
Global $hINSTANCE 		= _WinAPI_GetModuleHandle(0)
Global $vUSERICON 		= 0
Global $hWINGROW 		= 0
Global $iDLG_WIDTH 		= 628
Global $iDLG_HEIGHT 	= 155
Global $iDLG_HGROW		= 322
Global Const $CS_VREDRAW 	= 0x0001
Global Const $CS_HREDRAW 	= 0x0002
Global $_WM_CTLCOLOR_BACKGROUND = _WinAPI_GetStockObject($WHITE_BRUSH)
Global Const $sCLASSNAME = 'MyBot_ErrorTrapWindow'

Global $sScriptPath      = ''
Global $iScriptLine      = 0
Global Static $sMyBotDir = StringRegExpReplace(@ScriptFullPath, '\\[^\\]+$', '') & '\'

Global $hDebugLog  = "" ; For Debug
Global $hErrorLog =  ""; TrapMod File
Global $hBotLog   = ""; Bot Log File
Global $hArmyLog   = ""; Troop Related
Global $hAttackLog  = ""; Attack Related
Global $hOcrLog   = "";Ocr Related
Global $hClickLog   = ""; Click Related
Global $hBuildingLog   = ""; Village and Building related
Global $hModLog   = ""; Village and Building related
Global $aDebugFiles[9][2] = [[$hDebugLog, "debug"], _
							 [$hErrorLog,"error"], _
							 [$hBotLog,"bot"], _
							 [$hArmyLog,"army"], _
							 [$hAttackLog,"ocr"], _
							 [$hOcrLog,"attack"], _
							 [$hClickLog,"click"], _
							 [$hBuildingLog,"building"], _
							 [$hModLog,"mod"]]

Global Static $sAutoIt_Incl_Dir = StringRegExpReplace(@AutoItExe, '\\[^\\]+$', '') & '\Include'
Global Static $aUDL = StringRegExp(RegRead('HKCU\Software\AutoIt v3\AutoIt', 'Include'), '([^;]+)(?:;|$)', 3)

#Tidy_On



OnAutoItExitRegister("__ShutDown")

;~ __MainWindow() ; For Debug Only
Func _MyBotErrorTrap($sTitle = "", $sText = "", $fUseCallBack = True)
	Local $iPID, $sCommandLine

	If $sTitle Then $sERROR_TITLE = $sTitle
	$sERROR_TITLE &= " - MyBot"

	If $sText Then $sERROR_TEXT = $sText
	If $fUseCallBack Then
		$iTHREADID = _WinAPI_GetCurrentThreadId()

		$hCBTPROC_CALLBKERROR = DllCallbackRegister("__CBTProc_ErrorTrap", "int", "int;int;int")
		If Not $hCBTPROC_CALLBKERROR Then
			Return 0
		EndIf

		$hCBTPROC_HOOKERROR = _WinAPI_SetWindowsHookEx($WH_CBT, DllCallbackGetPtr($hCBTPROC_CALLBKERROR), 0, $iTHREADID)
		If Not $hCBTPROC_HOOKERROR Then
			DllCallbackFree($hCBTPROC_CALLBKERROR)
			Return 0
		EndIf
	Else
		$CmdLineRaw = StringReplace($CmdLineRaw, "-debug", "")
		$CmdLineRaw = StringReplace($CmdLineRaw, "/debug", "")
		If StringInStr($CmdLineRaw, "/MyBotErrorTrap") Then
			$CmdLineRaw = StringReplace($CmdLineRaw, "/MyBotErrorTrap", "")

			If IsDeclared("__iLineNumber") Then
				$tCOPYDATA = DllStructCreate('ulong_ptr;dword;ptr')
				$pCOPYDATA = DllStructGetPtr($tCOPYDATA)
				$tENTERDATA = DllStructCreate('wchar[1024]')
				$pENTERDATA = DllStructGetPtr($tENTERDATA)
				DllStructSetData($tCOPYDATA, 2, 1024)
				DllStructSetData($tCOPYDATA, 3, $pENTERDATA)
				$hUSER32 = DllOpen("User32.dll")
				$hRECDATA_HWND = WinGetHandle('[CLASS:MyBot_ErrorTrapWindow;TITLE:WM_COPYDATA]')
				AdlibRegister("__SENDDATA", 50)
			EndIf
			Return 1
		Else
			Opt("TrayIconHide", 1)
		EndIf
		If IsDeclared("__iLineNumber") Then __RECVDATA()

		$sCommandLine = @AutoItExe & ' /ErrorStdOut /AutoIt3ExecuteScript "' & @ScriptFullPath & '" ' & $CmdLineRaw & ' /MyBotErrorTrap'
		$iPID = Run($sCommandLine, @ScriptDir, 0, $STDERR_MERGED)
		ProcessWait($iPID)
		While 1
			$hGETERROR &= StdoutRead($iPID)
			If @error Then
				ExitLoop
			EndIf
			Sleep(10)
		WEnd
		Select
			Case Not $hGETERROR
				Exit
			Case $iLASTLINE
				$hGETERROR = StringRegExpReplace($hGETERROR, "\d+[0-9]", $iLASTLINE & @CRLF)
				$hGETERROR = StringReplace($hGETERROR, "•", @CRLF & "Module: Main/", 1)
		EndSelect
		$hGETERROR = StringReplace($hGETERROR, @LF, @CRLF)

		__MainWindow()
	EndIf
	Return 1
EndFunc   ;==>_MyBotErrorTrap

Func __CBTProc_ErrorTrap($nCode, $wParam, $lParam)
	If $nCode < 0 Then
		Return _WinAPI_CallNextHookEx($hCBTPROC_HOOKERROR, $nCode, $wParam, $lParam)
	EndIf

	Switch $nCode
		;Case 3 ; HCBT_CREATEWND
		;
		Case 5 ; HCBT_ACTIVATE
			If Not _WinAPI_FindWindow("#32770", "AutoIt Error") Then
				Return _WinAPI_CallNextHookEx($hCBTPROC_HOOKERROR, $nCode, $wParam, $lParam)
			EndIf
			$hERROR_HWND = HWnd($wParam)
			$hGETERROR = ControlGetText($hERROR_HWND, "", "Static2")
			If IsDeclared("__iLineNumber") Then
				$hGETERROR = StringRegExpReplace($hGETERROR, "\d+[0-9]", Eval("__iLineNumber") & @CRLF)
				$hGETERROR = StringReplace($hGETERROR, "•", @CRLF & "Module: Main/", 1)
			EndIf
			$hGETERROR = StringReplace($hGETERROR, @LF, @CRLF)


			__ParseErrorMsg($sScriptPath, $iScriptLine, $hGETERROR)



			_WinAPI_UnhookWindowsHookEx($hCBTPROC_HOOKERROR)
			_WinAPI_DestroyWindow($hERROR_HWND)

			Local $aEnumWin = _WinAPI_EnumWindows()
			For $i = 1 To $aEnumWin[0][0]
				If WinGetProcess($aEnumWin[$i][0]) = @AutoItPID And $aEnumWin[$i][1] = "AutoIt v3 GUI" Then
					_GUICtrlTab_ClickTab($TabMain, 0)

					Local $hDC_Capture = _WinAPI_GetWindowDC($frmBot)
					Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC_Capture)
					$hSCR_HBITMAP = _WinAPI_CreateCompatibleBitmap($hDC_Capture, _WinAPI_GetWindowWidth($frmBot), _WinAPI_GetWindowHeight($frmBot))
					Local $hObjectOld = _WinAPI_SelectObject($hMemDC, $hSCR_HBITMAP)
					DllCall("user32.dll", "int", "PrintWindow", "hwnd", $frmBot, "handle", $hMemDC, "int", 0)
					_WinAPI_SelectObject($hMemDC, $hSCR_HBITMAP)
					_WinAPI_BitBlt($hMemDC, 0, 0, $_GUI_MAIN_WIDTH, $_GUI_MAIN_HEIGHT, $hDC_Capture, 0, 0, 0x00CC0020)
					_WinAPI_DeleteDC($hMemDC)
					_WinAPI_SelectObject($hMemDC, $hObjectOld)
					_WinAPI_ReleaseDC($frmBot, $hDC_Capture)

					$hBitmapScreenshot = _GDIPlus_BitmapCreateFromHBITMAP($hSCR_HBITMAP)
					_GDIPlus_ImageSaveToFile($hBitmapScreenshot, $dirDebug & "\BotScreen.png")
					_GDIPlus_BitmapDispose($hBitmapScreenshot)
					_WinAPI_DeleteObject($hSCR_HBITMAP)

					$hLASTWIN_HWND = $aEnumWin[$i][0]
					ExitLoop
				EndIf
			Next
			_WinAPI_ShowWindow($hLASTWIN_HWND, @SW_HIDE) ; More fast than WinSetState()!!!


;~ 			If $RunState then
				If WinGetAndroidHandle() <> 0 Then

					Local $SuspendMode
					Local $iLeft = 0, $iTop = 0, $iRight = $AndroidClientWidth, $iBottom = $AndroidClientHeight ; set size of ENTIRE screen to save
					Local $iW = Number($iRight) - Number($iLeft)
					Local $iH = Number($iBottom) - Number($iTop)
					Local $hGraphic, $hBrush

					Local $hCtrl = ControlGetHandle($hWnd, $AppPaneName, $AppClassInstance)
					Local $hDC_Capture = _WinAPI_GetDC($hCtrl)
					Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC_Capture)
					$hSCR_HBITMAP1 = _WinAPI_CreateCompatibleBitmap($hDC_Capture, $iW, $iH)
					Local $hObjectOld = _WinAPI_SelectObject($hMemDC, $hSCR_HBITMAP1)
					DllCall("user32.dll", "int", "PrintWindow", "hwnd", $hCtrl, "handle", $hMemDC, "int", 0)
					_WinAPI_SelectObject($hMemDC, $hSCR_HBITMAP1)
					_WinAPI_BitBlt($hMemDC, 0, 0, $iW, $iH, $hDC_Capture, $iLeft, $iTop, 0x00CC0020)
					_WinAPI_DeleteDC($hMemDC)
					_WinAPI_SelectObject($hMemDC, $hObjectOld)
					_WinAPI_ReleaseDC($hCtrl, $hDC_Capture)

					$hBitmapScreenshot = _GDIPlus_BitmapCreateFromHBITMAP($hSCR_HBITMAP1)
					$hGraphic = _GDIPlus_ImageGetGraphicsContext($hBitmapScreenshot)
					$hBrush = _GDIPlus_BrushCreateSolid(0xFF000029)
					_GDIPlus_GraphicsFillRect($hGraphic, 0, 0, 250, 50, $hBrush)
					If $aCCPos[0] <> -1 Then _GDIPlus_GraphicsFillRect($hGraphic, $aCCPos[0] - $IsCCAutoLocated[2], $aCCPos[1] - $IsCCAutoLocated[3], 66, 18, $hBrush)
					_GDIPlus_ImageSaveToFile($hBitmapScreenshot, $dirDebug & "\AndroidScreen.png")
					_GDIPlus_BrushDispose($hBrush)
					_GDIPlus_GraphicsDispose($hGraphic)
					_GDIPlus_BitmapDispose($hBitmapScreenshot)
					_WinAPI_DeleteObject($hSCR_HBITMAP1)

				EndIf
;~ 			EndIf


			$hGETERROR = "Found Error in " & @ScriptName & "  at Line: " & $iScriptLine & @CRLF & "Error Description : " & @CRLF & $hGETERROR & @CRLF & @CRLF

			$FuncCall = Call("__OAER_OnExit") ;	_OnAutoItErrorRegister Hook Unregister and Terminate it
			If @error Then
				$hGETERROR = $hGETERROR & "Previous AutoIt Error Register Not Found" & @CRLF & @CRLF
			Else
				$hGETERROR = $hGETERROR & "Previous AutoIt Error Register Found and Terminated Call" & @CRLF & @CRLF
			EndIf

			$hGETERROR = $hGETERROR & "Primary Display  :  " & @DesktopWidth & " x " & @DesktopHeight & " - " & @DesktopDepth & "bit" & @CRLF & @CRLF
			$hGETERROR = $hGETERROR & "Android Screen Size  :  " & $AndroidClientWidth & " x " & $AndroidClientHeight & @CRLF
			$hGETERROR = $hGETERROR & "Android Version  :  " & $AndroidVersion & " " & $Android & " " & $AndroidInstance & " " & $Title & @CRLF
			$hGETERROR = $hGETERROR & "Bot Title  :  " & $sBotTitle & @CRLF
			$hGETERROR = $hGETERROR & "Bot Action : " & $BotAction & " -  Running :  " & $RunState & " ( Paused : " & $TPaused & " ) " & @CRLF
			$hGETERROR = $hGETERROR & "Village  :  " & $iVillageName & @CRLF
			$hGETERROR = $hGETERROR & "Profile  :  " & $sCurrProfile & @CRLF
			$hGETERROR = $hGETERROR & "Debug Mode  :  " & $DebugMode & @CRLF
			$hGETERROR = $hGETERROR & "Developer Mode  :  " & $DevMode & @CRLF
			$hGETERROR = $hGETERROR & "Debug Click  :  " & $debugClick & @CRLF
			$hGETERROR = $hGETERROR & "Bot Log File : " & $sLogFName & @CRLF

			__MainWindow()
	EndSwitch

	Return _WinAPI_CallNextHookEx($hCBTPROC_HOOKERROR, $nCode, $wParam, $lParam)
EndFunc   ;==>__CBTProc_ErrorTrap

Func __ParseErrorMsg(ByRef $sPath, ByRef $iCodeLine, ByRef $sMsg)

	Local $sScriptPath_Pttrn = '(?is)^.*Line \d+\s+\(File "(.*?)"\):\s+.*Error: .*'
	Local $sScriptLine_Pttrn = '(?is)^.*Line (\d+)\s+\(File ".*?"\):\s+.*Error: .*'
	Local $sErrDesc_Pttrn = '(?is)^.*Line \d+\s+\(File ".*?"\):\s+(.*Error: .*)'

	If Not StringRegExp($sMsg, $sScriptPath_Pttrn) Then
		Return SetError(1, 0, 0)
	EndIf

	$sPath = StringRegExpReplace($sMsg, $sScriptPath_Pttrn, '\1')
	$iCodeLine = StringRegExpReplace($sMsg, $sScriptLine_Pttrn, '\1')
	$sMsg = StringRegExpReplace($sMsg, $sErrDesc_Pttrn, '\1')

	$sMsg = StringStripWS(StringRegExpReplace($sMsg, '(?mi)^Error:\h*|:$', ''), 3)

;~ Here read error line from source file

EndFunc   ;==>__ParseErrorMsg

Func __SENDDATA()
	DllStructSetData($tENTERDATA, 1, Eval("__iLineNumber"))
	DllCall($hUSER32, 'lresult', 'SendMessage', 'hwnd', $hRECDATA_HWND, 'uint', $WM_COPYDATA, 'ptr', 0, 'ptr', $pCOPYDATA)
EndFunc   ;==>__SENDDATA

Func __RECVDATA()
	__RegWinClass()
	$hRECDATA_HWND = _WinAPI_CreateWindowEx(0, $sCLASSNAME, "WM_COPYDATA", 0, 0, 0, 0, 0, 0)
EndFunc   ;==>__RECVDATA

Func __RegWinClass()
	Local $tWCEX, $tClass, $hIcon

	If $hWINDOW_PROC Then Return 0
	$hWINDOW_PROC = DllCallbackRegister('__CallWindowProc', 'lresult', 'hwnd;uint;wparam;lparam')

	$tClass = DllStructCreate('wchar[' & StringLen($sCLASSNAME) + 1 & ']')
	DllStructSetData($tClass, 1, $sCLASSNAME)
	$hIcon = _WinAPI_LoadShell32Icon(77)
	$tWCEX = DllStructCreate($tagWNDCLASSEX)
	DllStructSetData($tWCEX, 'Size', DllStructGetSize($tWCEX))
	DllStructSetData($tWCEX, 'Style', 0) ;BitOR($CS_VREDRAW, $CS_HREDRAW))
	DllStructSetData($tWCEX, 'hWndProc', DllCallbackGetPtr($hWINDOW_PROC))
	DllStructSetData($tWCEX, 'ClsExtra', 0)
	DllStructSetData($tWCEX, 'WndExtra', 0)
	DllStructSetData($tWCEX, 'hInstance', $hINSTANCE)
	DllStructSetData($tWCEX, 'hIcon', $hIcon)
	DllStructSetData($tWCEX, 'hCursor', _WinAPI_LoadCursor(0, $IDC_ARROW))
	DllStructSetData($tWCEX, 'hBackground', _WinAPI_GetSysColorBrush($COLOR_WINDOW))
	DllStructSetData($tWCEX, 'MenuName', 0)
	DllStructSetData($tWCEX, 'ClassName', DllStructGetPtr($tClass))
	DllStructSetData($tWCEX, 'hIconSm', 0)
	Return _WinAPI_RegisterClassEx($tWCEX)
EndFunc   ;==>__RegWinClass

Func __MainWindow()
	Local $aiMem = ProcessGetStats(), $aiIOs = ProcessGetStats(-1, 1), $sMoreInfo, $hLeftIcon, $hFont
	Local Const $STM_SETIMAGE = 0x0172

	If Not $hWINDOW_PROC Then __RegWinClass()

	$hNEWDLG_HWND = _WinAPI_CreateWindowEx(BitOR($WS_EX_TOPMOST, $WS_EX_CONTEXTHELP), $sCLASSNAME, $sERROR_TITLE, BitOR($WS_CAPTION, $WS_POPUPWINDOW, $WS_DLGFRAME), _
			(@DesktopWidth / 2) - ($iDLG_WIDTH / 2), (@DesktopHeight / 2) - ($iDLG_HEIGHT / 2), $iDLG_WIDTH, $iDLG_HEIGHT, 0)

;~ 	__WinCtrlStatic($hNEWDLG_HWND, "", 0, 0, 622, 128, BitOR($WS_DISABLED, $SS_GRAYFRAME), $WS_EX_DLGMODALFRAME)

	$hLeftIcon = __WinCtrlStatic($hNEWDLG_HWND, "", 16, 10, 32, 32, BitOR($WS_DISABLED, $SS_Icon))
	_WinAPI_DestroyIcon(_SendMessage($hLeftIcon, $STM_SETIMAGE, 1, _WinAPI_LoadIcon(0, $IDI_INFORMATION)))

	$hLBL_INFO = __WinCtrlStatic($hNEWDLG_HWND, $sERROR_TEXT, 60, 10, 435, 106)
	$hFont = _WinAPI_CreateFont(14, 0, 0, 0, $FW_MEDIUM, False, False, False, $DEFAULT_CHARSET, $OUT_DEFAULT_PRECIS, $CLIP_DEFAULT_PRECIS, $DEFAULT_QUALITY, 0, 'Tahoma')
	_WinAPI_SetFont($hLBL_INFO, $hFont)

	$sBTN_TRYAGAIN = _GUICtrlButton_Create($hNEWDLG_HWND, $sTRYAGAIN_BTN, 504, 10, 108, 26) ; Try Again
	$sBTN_CONTINUE = _GUICtrlButton_Create($hNEWDLG_HWND, $sCONTINUE_BTN, 504, 50, 108, 26) ; Continue
	$sBTN_CANCEL = _GUICtrlButton_Create($hNEWDLG_HWND, $sCANCEL_BTN, 504, 90, 108, 26) ; Cancel
	$hBTN_MORE = _GUICtrlButton_Create($hNEWDLG_HWND, "", 12, 94, 26, 26) ; More...

	__WinCtrlStatic($hNEWDLG_HWND, "", 0, 128, $iDLG_WIDTH, 2, BitOR($WS_DISABLED, $SS_GRAYFRAME, $SS_SUNKEN))

	__WinCtrlGroupBox($hNEWDLG_HWND, "Exception Reason", 10, 136, 602, 130)

	$hGETERROR &= @CRLF & @CRLF & $sENVIROMMENT
	$hLBL_ERROR = _GUICtrlEdit_Create($hNEWDLG_HWND, $hGETERROR, 18, 152, 590, 110, BitOR($ES_MULTILINE, $ES_AUTOVSCROLL, $ES_READONLY, $WS_VSCROLL), $WS_EX_TRANSPARENT)

	__WinCtrlGroupBox($hNEWDLG_HWND, "Memory Information", 10, 272, 192, 130)
	$sMoreInfo = "Working Set Size" & @TAB & Int($aiMem[0] / 1024) & @CRLF
	$sMoreInfo &= "Peak Working Set" & @TAB & Int($aiMem[1] / 1024) & @CRLF & @CRLF
	$aiMem = MemGetStats()
	$sMoreInfo &= "Total Physical" & @TAB & Int($aiMem[1] / 1024) & @CRLF
	$sMoreInfo &= "Available Physical" & @TAB & Int($aiMem[2] / 1024) & @CRLF
	$sMoreInfo &= "Total PageFile" & @TAB & Int($aiMem[3] / 1024) & @CRLF
	$sMoreInfo &= "Available PageFile" & @TAB & Int($aiMem[4] / 1024) & @CRLF
	$sMoreInfo &= "Total Virtual" & @TAB & Int($aiMem[5] / 1024) & @CRLF
	$sMoreInfo &= "Available Virtual" & @TAB & Int($aiMem[6] / 1024)
	$hGETERROR &= @CRLF & @CRLF & "* Memory information *" & @CRLF & @CRLF & $sMoreInfo & @CRLF
	_GUICtrlEdit_Create($hNEWDLG_HWND, $sMoreInfo, 18, 288, 181, 110, BitOR($ES_MULTILINE, $ES_AUTOVSCROLL, $ES_READONLY, $WS_VSCROLL), $WS_EX_TRANSPARENT)

	__WinCtrlGroupBox($hNEWDLG_HWND, "IO Operations", 215, 272, 192, 130)
	$sMoreInfo = @CRLF & "Read Operations" & @TAB & $aiIOs[0] & @CRLF
	$sMoreInfo &= "Write Operations" & @TAB & $aiIOs[1] & @CRLF
	$sMoreInfo &= "Others Operations" & @TAB & $aiIOs[2] & @CRLF
	$sMoreInfo &= "Read Bytes" & @TAB & $aiIOs[3] & @CRLF
	$sMoreInfo &= "Write Bytes" & @TAB & $aiIOs[4] & @CRLF
	$sMoreInfo &= "Other Bytes R\W" & @TAB & $aiIOs[5]
	$hGETERROR &= @CRLF & "* IO information *" & @CRLF & $sMoreInfo & @CRLF
	_GUICtrlEdit_Create($hNEWDLG_HWND, $sMoreInfo, 223, 288, 181, 110, BitOR($ES_MULTILINE, $ES_AUTOVSCROLL, $ES_READONLY, $WS_VSCROLL), $WS_EX_TRANSPARENT)

	__WinCtrlGroupBox($hNEWDLG_HWND, "OS Information", 420, 272, 192, 130)
	$sMoreInfo = @CRLF & "Architecture" & @TAB & @OSArch & @CRLF
	$sMoreInfo &= "Version number" & @TAB & @OSVersion & @CRLF
	$sMoreInfo &= "ServicePack" & @TAB & @OSServicePack & @CRLF
	$sMoreInfo &= "Build number" & @TAB & @OSBuild & @CRLF
	$sMoreInfo &= "Language" & @TAB & @OSLang & @CRLF
	$sMoreInfo &= "Keyboard Layout" & @TAB & @KBLayout
	$hGETERROR &= @CRLF & "* OS information *" & @CRLF & $sMoreInfo & @CRLF
	_GUICtrlEdit_Create($hNEWDLG_HWND, $sMoreInfo, 428, 288, 181, 110, BitOR($ES_MULTILINE, $ES_AUTOVSCROLL, $ES_READONLY, $WS_VSCROLL), $WS_EX_TRANSPARENT)

	_Log($hGETERROR, "error")
	$hBTN_SENDDLG = _GUICtrlButton_Create($hNEWDLG_HWND, $sSEND_BTN, 10, 412, 105, 26, $BS_VCENTER)
	_GUICtrlButton_Enable($hBTN_SENDDLG, False)
	$hBTN_OPENFOLDER = _GUICtrlButton_Create($hNEWDLG_HWND, $sOPENFOLDER_BTN, 162, 412, 105, 26)
	If Not @Compiled Then
		_GUICtrlButton_Enable($hBTN_OPENFOLDER, False)
	EndIf

	$hBTN_LASTSCR1 = _GUICtrlButton_Create($hNEWDLG_HWND, $sLASTSCRN_BTN1, 272, 412, 105, 26)
	If Not $hSCR_HBITMAP1 Then
		_GUICtrlButton_Enable($hBTN_LASTSCR1, False)
	EndIf
	$hBTN_LASTSCR = _GUICtrlButton_Create($hNEWDLG_HWND, $sLASTSCRN_BTN, 392, 412, 105, 26)
	If Not $hSCR_HBITMAP Then
		_GUICtrlButton_Enable($hBTN_LASTSCR, False)
	EndIf
	$hBTN_SAVE = _GUICtrlButton_Create($hNEWDLG_HWND, $sSAVE_BTN, 507, 412, 105, 26)

	If @OSVersion = "WIN_XP" Then
		__ButtonSetIcon($sBTN_TRYAGAIN, 24)
		__ButtonSetIcon($hBTN_SAVE, 6)
	Else
		__ButtonSetIcon($sBTN_TRYAGAIN, 238)
		__ButtonSetIcon($hBTN_SAVE, 258)
	EndIf
	__ButtonSetIcon($sBTN_CONTINUE, 109)
	__ButtonSetIcon($sBTN_CANCEL, 131)
	__ButtonSetIcon($hBTN_SENDDLG, 156)
	__ButtonSetIcon($hBTN_LASTSCR, 139)
	__ButtonSetIcon($hBTN_LASTSCR1, 139)
	__ButtonSetIcon($hBTN_OPENFOLDER, 55)
	__ButtonSetIcon($hBTN_MORE, 1, 24, 24, 4, "Cliconfg.rll")

	_WinAPI_ShowWindow($hNEWDLG_HWND, @SW_SHOW)

;~ 	WinWaitClose($hNEWDLG_HWND)
	While 1
		Sleep(1000)
	WEnd
EndFunc   ;==>__MainWindow

Func __CallWindowProc($hWnd, $iMsg, $wParam, $lParam)
	Local $nNotifyCode, $hCtrlWnd, $hDC

	Switch $iMsg
		Case $WM_COPYDATA
			If $hWnd = $hRECDATA_HWND Then
				$tCOPYDATA = DllStructCreate('ulong_ptr;dword;ptr', $lParam)
				$tENTERDATA = DllStructCreate('wchar[1024]', DllStructGetData($tCOPYDATA, 3))

				$iLASTLINE = DllStructGetData($tENTERDATA, 1)
				Return 1
			EndIf

		Case $WM_COMMAND
			$nNotifyCode = _WinAPI_HiWord($wParam)
			If $nNotifyCode Then Return 0
			$hCtrlWnd = $lParam

			Switch $hCtrlWnd
				Case $sBTN_OK_ABOUT
					_SendMessage($hWnd, $WM_CLOSE)

			EndSwitch

		Case $WM_SYSCOMMAND
			Switch BitAND($wParam, 0xFFF0)
				Case 0xF180 ; SC_CONTEXTHELP
					__AboutDlg($hWnd)
					Return 0
			EndSwitch

		Case $WM_CLOSE
			If $hWnd = $hNEWDLG_HWND Then
				$iDLG_HEIGHT = _WinAPI_GetWindowHeight($hWnd)
				While $iDLG_HEIGHT > 25
					WinSetTrans($hWnd, "", $iDLG_HEIGHT)
					WinMove($hWnd, "", Default, (@DesktopHeight / 2) - ($iDLG_HEIGHT / 2), $iDLG_WIDTH, $iDLG_HEIGHT)
					$iDLG_HEIGHT -= 20
					Sleep(10)
				WEnd
			EndIf
			_WinAPI_DestroyWindow($hWnd)

		Case $WM_DESTROY
			If $hWnd = $hNEWDLG_HWND Then
				Exit
			EndIf

		Case $WM_KEYDOWN
			If _WinAPI_LoWord($wParam) = 27 Then
				_SendMessage($hWnd, $WM_CLOSE)
				_Log("Esc Event Kill Bot","mod")
				__KillBot()
			EndIf

;~ 		Case $WM_NOTIFY

		Case $WM_CTLCOLORSTATIC, $WM_CTLCOLOREDIT
			$hDC = $wParam
			$hCtrlWnd = $lParam
			Switch $hCtrlWnd
				Case $hLBL_INFO, $hLBL_ERROR
					_WinAPI_SetTextColor($hDC, 0x0000FF)

				Case Else
;~ 					_WinAPI_SetBkMode($hDC, $TRANSPARENT)

			EndSwitch
			Return $_WM_CTLCOLOR_BACKGROUND
	EndSwitch

	Switch $hWnd
		Case $hSNDDLG_HWND

			Switch $iMsg
				Case $WM_COMMAND
					Switch $hCtrlWnd
						Case $hBTN_SENDOK
							MsgBox(262208, "Test Mode", "Send Failed.", 0, $hWnd)

						Case $sBTN_OK_SNDDLG
							_SendMessage($hWnd, $WM_CLOSE)
;~ 							__KillBot()	 ;Forum Not Supported to Register Tickets

					EndSwitch
			EndSwitch

		Case $hSCRDLG_HWND

			Switch $iMsg
				Case $WM_COMMAND
					Switch $hCtrlWnd
						Case $sBTN_OK_SCRDLG
							_SendMessage($hWnd, $WM_CLOSE)

						Case $hBTN_CHECKBOX
							MsgBox(262208, "Test Mode", "Send Failed.", 0, $hWnd)

					EndSwitch
			EndSwitch

		Case $hSCRDLG_HWND1

			Switch $iMsg
				Case $WM_COMMAND
					Switch $hCtrlWnd
						Case $sBTN_OK_SCRDLG
							_SendMessage($hWnd, $WM_CLOSE)

						Case $hBTN_CHECKBOX
							MsgBox(262208, "Test Mode", "Send Failed.", 0, $hWnd)

					EndSwitch
			EndSwitch

		Case $hNEWDLG_HWND

			Switch $iMsg
				Case $WM_COMMAND
					Switch $hCtrlWnd
						Case $sBTN_TRYAGAIN
							$CmdLineRaw = StringReplace($CmdLineRaw, "-debug", "")
							$CmdLineRaw = StringReplace($CmdLineRaw, "/debug", "")
							If Not @Compiled Then
								ShellExecute(@AutoItExe, $CmdLineRaw, "")
							Else
								ShellExecute(@AutoItExe, $CmdLineRaw & " /debug") ; -debug
							EndIf
							_SendMessage($hWnd, $WM_CLOSE)
							__KillBot()

						Case $sBTN_CONTINUE
							_WinAPI_ShowWindow($hNEWDLG_HWND, @SW_HIDE)
							MsgBox(262208, "Error - Can't Continue Further", $sTRYCONTINUE, 0, $hLASTWIN_HWND)
							_WinAPI_ShowWindow($hLASTWIN_HWND, @SW_SHOW) ; Call("_Main") ; On Error Resume Next Not Supported In AutoIt, Made this for Future Use
;~ 							ShellExecute(@AutoItExe, $CmdLineRaw, "")
							_SendMessage($hWnd, $WM_CLOSE)
							__KillBot()

						Case $sBTN_CANCEL
							_SendMessage($hWnd, $WM_CLOSE)
							__KillBot()

						Case $hBTN_MORE
							Local $iNewHeight = $iDLG_HEIGHT + $iDLG_HGROW

							Switch $hWINGROW
								Case 0
									$hWINGROW = 1
									__ButtonSetIcon($hBTN_MORE, 3, 24, 24, 4, "Cliconfg.rll")
								Case 1
									$hWINGROW = 0
									$iNewHeight = $iDLG_HEIGHT
									__ButtonSetIcon($hBTN_MORE, 1, 24, 24, 4, "Cliconfg.rll")
							EndSwitch
;~ 							Left = Default or (@DesktopWidth / 2) - ($iDLG_WIDTH / 2)
							WinMove($hWnd, "", Default, (@DesktopHeight / 2) - (($iNewHeight) / 2), Default, $iNewHeight)

						Case $hBTN_SAVE
							__SaveBugDetails($hWnd)

						Case $hBTN_OPENFOLDER
							__OpenSrcFolder($hWnd)

						Case $hBTN_LASTSCR
							__ScreenDlg($hWnd)

						Case $hBTN_LASTSCR1
							__ScreenDlg1($hWnd)

						Case $hBTN_SENDDLG
							__SendBugDlg($hWnd)

					EndSwitch
					Return 0
			EndSwitch
	EndSwitch

	Return _WinAPI_DefWindowProcW($hWnd, $iMsg, $wParam, $lParam)
EndFunc   ;==>__CallWindowProc

Func __SaveBugDetails($hWnd)

	_WinAPI_ShowWindow($hNEWDLG_HWND, @SW_HIDE)
	Global $SaveReport = False
	Local $sFileName
	While Not $SaveReport
		$sFileName = FileSaveDialog("Choose a Name  to Save Bug report", @ScriptDir, "Zip (*.zip)", 2, $sMyBotDir & "MyBot_BugReport", $hWnd)
		If Not @error Then
			If FileExists($sFileName) Then
				Local $iMsg = MsgBox(3, "File already exist", "Area you sure you want to overwrite")
				If $iMsg = 6 Then
					FileDelete($sFileName)
					$SaveReport = True
					ExitLoop
				EndIf
				If $iMsg = 7 Then
					ContinueLoop
				EndIf
				If $iMsg = 2 Then
					ExitLoop
				EndIf
			Else
				$SaveReport = True
				ExitLoop
			EndIf
		Else
			$SaveReport = False
			ExitLoop
		EndIf

	WEnd
	If $SaveReport Then
		_Zip_Create($sFileName)
		_Zip_AddFolder($sFileName, $sMyBotDir & "lib")
		If FileExists($sMyBotDir & "Profiles\" & $iVillageName) Then
			_Zip_AddFolder($sFileName, $sMyBotDir & "Profiles\" & $iVillageName, 0)
		EndIf

		_WinAPI_ShellOpenFolderAndSelectItems(__GetDir($sFileName), StringSplit(__GetFileName($sFileName), "|"), 1)
	EndIf
	_WinAPI_ShowWindow($hNEWDLG_HWND, @SW_SHOW)
EndFunc   ;==>__SaveBugDetails

Func __OpenSrcFolder($hWnd)

	_WinAPI_EnableWindow($hWnd, False)
	_WinAPI_ShowWindow($hNEWDLG_HWND, @SW_HIDE)
	if FileExists($sMyBotDir & "lib\MyBotBugTracker.exe") Then
		Local $iPID = ShellExecute($sMyBotDir & "lib\MyBotBugTracker.exe","/line:"&$iScriptLine)

		if @error then MsgBox(2359296,"Error", "Can't Execute MyBot Tracker.")
		ProcessWaitClose($iPID)

	Else
		MsgBox(2359296,"Error", "MyBot Bug Tracker Not Found",10)
	EndIf
	_WinAPI_ShowWindow($hNEWDLG_HWND, @SW_SHOW)
	_WinAPI_EnableWindow($hWnd, True)
	_WinAPI_SetActiveWindow($hWnd)

EndFunc   ;==>__OpenSrcFolder

Func __SendBugDlg($hWnd)
	Local $ICON_SMALL = 0

	_WinAPI_EnableWindow($hWnd, False)
	$hSNDDLG_HWND = _WinAPI_CreateWindowEx(BitOR($WS_EX_TOPMOST, $WS_EX_CONTEXTHELP), $sCLASSNAME, $sSEND_BTN, _
			BitOR($WS_CAPTION, $WS_POPUPWINDOW, $WS_DLGFRAME), (@DesktopWidth / 2) - (500 / 2), (@DesktopHeight / 2) - (400 / 2), 500, 400, $hWnd)

	__WinCtrlGroupBox($hSNDDLG_HWND, "Title: ", 4, 4, 486, 36)
	__WinCtrlGroupBox($hSNDDLG_HWND, "Description: ", 4, 46, 486, 264)

	$hSND_EDIT1 = _GUICtrlEdit_Create($hSNDDLG_HWND, $sERROR_TITLE, 10, 18, 474, 18, $ES_LEFT, $WS_EX_TRANSPARENT)
	_GUICtrlEdit_SetLimitText($hSND_EDIT1, 80)

	$hSND_EDIT2 = _GUICtrlEdit_Create($hSNDDLG_HWND, $hGETERROR & @CRLF & "Last System Error Message: " & _WinAPI_GetLastErrorMessage(), 10, 64, 476, 242, _
			BitOR($ES_MULTILINE, $ES_AUTOVSCROLL, $WS_VSCROLL, $ES_WANTRETURN), $WS_EX_TRANSPARENT)

	__WinCtrlStatic($hSNDDLG_HWND, "", 0, 322, 500, 2, BitOR($WS_DISABLED, $SS_GRAYFRAME, $SS_SUNKEN))

	$hBTN_SENDOK = _GUICtrlButton_Create($hSNDDLG_HWND, $sSEND_BTN, 209, 334, 108, 26)
	$sBTN_OK_SNDDLG = _GUICtrlButton_Create($hSNDDLG_HWND, $sOK_BTN, 327, 334, 108, 26)

	__ButtonSetIcon($hBTN_SENDOK, 156) ; Send
	__ButtonSetIcon($sBTN_OK_SNDDLG, 144) ; OK

	_WinAPI_ShowWindow($hSNDDLG_HWND, @SW_SHOW)

	_WinAPI_DestroyIcon(_SendMessage($hSNDDLG_HWND, $WM_SETICON, $ICON_SMALL, _WinAPI_LoadShell32Icon(156)))

	WinWaitClose($hSNDDLG_HWND)
	_WinAPI_EnableWindow($hWnd, True)
	_WinAPI_SetActiveWindow($hWnd)
EndFunc   ;==>__SendBugDlg

Func __ScreenDlg($hWnd)
	Local Const $STM_SETIMAGE = 0x0172, $ICON_SMALL = 0, $SS_REALSIZECONTROL = 0x40
	Local $hCtrlWnd, $iWidth = $_GUI_MAIN_WIDTH + 50, $iHeight = $_GUI_MAIN_HEIGHT + 75, $iCtrlWidth = $_GUI_MAIN_WIDTH * 0.95, $iCtrlHeight = $_GUI_MAIN_HEIGHT * 0.95, $iScale

	_WinAPI_EnableWindow($hWnd, False)
	$hSCRDLG_HWND = _WinAPI_CreateWindowEx(BitOR($WS_EX_TOPMOST, $WS_EX_CONTEXTHELP), $sCLASSNAME, $sLASTSCRN_BTN, BitOR($WS_CAPTION, $WS_POPUPWINDOW, $WS_DLGFRAME), (@DesktopWidth / 2) - ($iWidth / 2), (@DesktopHeight / 2) - ($iHeight / 2), $iWidth, $iHeight, $hWnd) ; Wide...

	$hCtrlWnd = __WinCtrlStatic($hSCRDLG_HWND, "", 0, 0, 0, 0, BitOR($WS_DISABLED, $SS_REALSIZECONTROL, $SS_SUNKEN, $SS_BITMAP))


	Local $hImage = _GDIPlus_ImageLoadFromFile($dirDebug & "\BotScreen.png")
	$hSCR_HBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)

	_SendMessage($hCtrlWnd, $STM_SETIMAGE, 0, $hSCR_HBITMAP)
	_GDIPlus_Startup()
	Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hSCR_HBITMAP)
	Local $iOWidth = _GDIPlus_ImageGetWidth($hBitmap)
	Local $iOHeight = _GDIPlus_ImageGetHeight($hBitmap)
	_GDIPlus_BitmapDispose($hBitmap)

	$iScale = _Min($iCtrlWidth / $iOWidth, $iCtrlHeight / $iOHeight)
	Select
		Case $iOWidth > $iCtrlWidth
			$iCtrlWidth = Round($iOWidth * $iScale)
		Case Else
			$iCtrlWidth = $iOWidth
	EndSelect
	Select
		Case $iOHeight > $iCtrlHeight
			$iCtrlHeight = Round($iOHeight * $iScale)
		Case Else
			$iCtrlHeight = $iOHeight
	EndSelect
	_WinAPI_MoveWindow($hCtrlWnd, ($iWidth / 2) - ($iCtrlWidth / 2), (($iHeight - 90) / 2) - ($iCtrlHeight / 2), $iCtrlWidth, $iCtrlHeight)

	_GDIPlus_Shutdown()

	__WinCtrlStatic($hSCRDLG_HWND, "", 0, $iCtrlHeight + 15, $iWidth, 2, BitOR($WS_DISABLED, $SS_GRAYFRAME, $SS_SUNKEN))

	$sBTN_OK_SCRDLG = _GUICtrlButton_Create($hSCRDLG_HWND, $sOK_BTN, $iWidth - 140, $iCtrlHeight + 35, 108, 26)

	__ButtonSetIcon($sBTN_OK_SCRDLG, 144) ; OK

	_WinAPI_ShowWindow($hSCRDLG_HWND, @SW_SHOW)

	_WinAPI_DestroyIcon(_SendMessage($hSCRDLG_HWND, $WM_SETICON, $ICON_SMALL, _WinAPI_LoadShell32Icon(139)))

	WinWaitClose($hSCRDLG_HWND)
	_WinAPI_EnableWindow($hWnd, True)
	_WinAPI_SetActiveWindow($hWnd)
EndFunc   ;==>__ScreenDlg

Func __ScreenDlg1($hWnd)
	Local Const $STM_SETIMAGE = 0x0172, $ICON_SMALL = 0, $SS_REALSIZECONTROL = 0x40
	Local $hCtrlWnd, $iWidth = $AndroidClientWidth - 100, $iHeight = $AndroidClientHeight - 50, $iCtrlWidth = $iWidth * 0.90, $iCtrlHeight = $iHeight * 0.90, $iScale

	_WinAPI_EnableWindow($hWnd, False)
	$hSCRDLG_HWND1 = _WinAPI_CreateWindowEx(BitOR($WS_EX_TOPMOST, $WS_EX_CONTEXTHELP), $sCLASSNAME, $sLASTSCRN_BTN1, BitOR($WS_CAPTION, $WS_POPUPWINDOW, $WS_DLGFRAME), (@DesktopWidth / 2) - ($iWidth / 2), (@DesktopHeight / 2) - ($iHeight / 2), $iWidth, $iHeight, $hWnd) ; Wide...

	$hCtrlWnd = __WinCtrlStatic($hSCRDLG_HWND1, "", 0, 0, 0, 0, BitOR($WS_DISABLED, $SS_REALSIZECONTROL, $SS_SUNKEN, $SS_BITMAP))


	Local $hImage = _GDIPlus_ImageLoadFromFile($dirDebug & "\AndroidScreen.png")
	$hSCR_HBITMAP1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)

	_SendMessage($hCtrlWnd, $STM_SETIMAGE, 0, $hSCR_HBITMAP1)
	_GDIPlus_Startup()
	Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hSCR_HBITMAP1)
	Local $iOWidth = _GDIPlus_ImageGetWidth($hBitmap)
	Local $iOHeight = _GDIPlus_ImageGetHeight($hBitmap)
	_GDIPlus_BitmapDispose($hBitmap)

	$iScale = _Min($iCtrlWidth / $iOWidth, $iCtrlHeight / $iOHeight)
	Select
		Case $iOWidth > $iCtrlWidth
			$iCtrlWidth = Round($iOWidth * $iScale)
		Case Else
			$iCtrlWidth = $iOWidth
	EndSelect
	Select
		Case $iOHeight > $iCtrlHeight
			$iCtrlHeight = Round($iOHeight * $iScale)
		Case Else
			$iCtrlHeight = $iOHeight
	EndSelect
	_WinAPI_MoveWindow($hCtrlWnd, ($iWidth / 2) - ($iCtrlWidth / 2), (($iHeight - 90) / 2) - ($iCtrlHeight / 2), $iCtrlWidth, $iCtrlHeight)

	_GDIPlus_Shutdown()

	__WinCtrlStatic($hSCRDLG_HWND1, "", 0, $iCtrlHeight + 15, $iWidth, 2, BitOR($WS_DISABLED, $SS_GRAYFRAME, $SS_SUNKEN))

	$sBTN_OK_SCRDLG = _GUICtrlButton_Create($hSCRDLG_HWND1, $sOK_BTN, $iWidth - 140, $iCtrlHeight + 35, 108, 26)

	__ButtonSetIcon($sBTN_OK_SCRDLG, 144) ; OK

	_WinAPI_ShowWindow($hSCRDLG_HWND1, @SW_SHOW)

	_WinAPI_DestroyIcon(_SendMessage($hSCRDLG_HWND1, $WM_SETICON, $ICON_SMALL, _WinAPI_LoadShell32Icon(139)))

	WinWaitClose($hSCRDLG_HWND1)
	_WinAPI_EnableWindow($hWnd, True)
	_WinAPI_SetActiveWindow($hWnd)
EndFunc   ;==>__ScreenDlg1

Func __AboutDlg($hWnd)
	Local $sText, $hStatic, $hFont, $hLeftIcon
	Local Const $ICON_SMALL = 0 ;, $STM_SETIMAGE = 0x0172

	_WinAPI_EnableWindow($hWnd, False)
	$hABTDLG_HWND = _WinAPI_CreateWindowEx($WS_EX_TOPMOST, $sCLASSNAME, $sABOUT_TITLE, _
			BitOR($WS_CAPTION, $WS_POPUPWINDOW, $WS_DLGFRAME), (@DesktopWidth / 2) - (477 / 2), (@DesktopHeight / 2) - (369 / 2), 477, 369, $hWnd)

	$sText = 'Case $HCBT_ACTIVATE' & @CRLF & _
			'	If Not WinExists("[CLASS:#32770;TITLE:MyBot Error]") Or $hERROR_HWND Then' & @CRLF & _
			'		Return _WinAPI_CallNextHookEx($hBOT_HOOKERROR, $nCode, $wParam, $lParam)' & @CRLF & _
			'	EndIf' & @CRLF & @CRLF & _
			'	 ' & @CRLF & _
			'	Local $aEnumWin = _WinAPI_EnumWindows()' & @CRLF & _
			'	For $i = 1 To $aEnumWin[0][0]' & @CRLF & _
			'		If WinGetProcess($aEnumWin[$i][0]) = @MyBotPID And $aEnumWin[$i][1] = $sBotTitle Then' & @CRLF & _
			'			$hSCR_HBITMAP = _ScreenCapture_CaptureWnd("", $aEnumWin[$i][0])' & @CRLF & _
			'			$hLASTWIN_HWND = $aEnumWin[$i][0]' & @CRLF & _
			'			ExitLoop' & @CRLF & _
			'		EndIf' & @CRLF & _
			'	Next' & @CRLF & _
			'   ' & @CRLF & _
			'	_WinAPI_ShowWindow($hLASTWIN_HWND, @SW_HIDE) ; More fast than WinSetState()!!!' & @CRLF & _
			'	$hERROR_HWND = WinGetHandle("[CLASS:#32770;TITLE:MyBot Error]")' & @CRLF & _
			'	$hGETERROR = StringReplace(ControlGetText($hERROR_HWND, "", "Static2"), @LF, @CRLF)' & @CRLF & _
			'	$hGETERROR = StringRegExpReplace($hGETERROR, "\d+[0-9]", Eval("__iLineNumber") & @CRLF)' & @CRLF & _
			'	_NewDialog()' & @CRLF & _
			'Case $HCBT_DESTROYWND' & @CRLF & _
			'	If $wParam = $hERROR_HWND Then' & @CRLF & _
			'		_WinAPI_UnhookWindowsHookEx($hBOT_HOOKERROR)'
	__WinCtrlStatic($hABTDLG_HWND, $sText, 0, 0, 471, 289, BitOR($WS_DISABLED, $SS_LEFTNOWORDWRAP))

;~ 	$hLeftIcon = __WinCtrlStatic($hABTDLG_HWND, "", 16, 10, 32, 32, BitOR($WS_DISABLED, $SS_Icon))

	$hLeftIcon = _GUIImageList_Create(32, 32, 5, 4)
	Local $hBitmap = _WinAPI_LoadImage(0, _IconAni(), $IMAGE_BITMAP, 0, 0, BitOR($LR_LOADFROMFILE, $LR_CREATEDIBSECTION, $LR_LOADTRANSPARENT))
	_GUIImageList_Add($hLeftIcon, $hBitmap)

	__WinCtrlStatic($hABTDLG_HWND, "", 61, 16, 377, 265, BitOR($WS_DISABLED, $SS_GRAYFRAME, $SS_SUNKEN), $WS_EX_DLGMODALFRAME)

	$sText = "Detection and treatment of errors in the MyBot!" & @CRLF & @CRLF & "" & _
			"Please visit our Web forums: https://mybot.run/forums" & @CRLF & @CRLF & _
			"By running this program, the user accepts all responsibility that arises from the use of this software" & @CRLF & _
			"as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version." & @CRLF & @CRLF & _
			"This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty" & @CRLF & _
			"of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details." & @CRLF & @CRLF & _
			"You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>." & @CRLF & _
			"Copyright (C) 2015-2016 MyBot.run"
	$hStatic = __WinCtrlStatic($hABTDLG_HWND, $sText, 65, 20, 369, 257, $SS_CENTER)
	$hFont = _WinAPI_CreateFont(14, 0, 0, 0, $FW_MEDIUM, False, False, False, $DEFAULT_CHARSET, _
			$OUT_DEFAULT_PRECIS, $CLIP_DEFAULT_PRECIS, $DEFAULT_QUALITY, 0, 'Tahoma')
	_WinAPI_SetFont($hStatic, $hFont)

	__WinCtrlStatic($hABTDLG_HWND, "MyBot ErrorTrap MOD Powred By: Media Hub", 10, 315, 300, 16, BitOR($WS_DISABLED, $SS_LEFTNOWORDWRAP))

	__WinCtrlStatic($hABTDLG_HWND, "", 0, 292, 477, 2, BitOR($WS_DISABLED, $SS_GRAYFRAME, $SS_SUNKEN))

	$sBTN_OK_ABOUT = _GUICtrlButton_Create($hABTDLG_HWND, $sOK_BTN, 375, 304, 88, 26) ; Ok
	__ButtonSetIcon($sBTN_OK_ABOUT, 144) ; OK

	_WinAPI_ShowWindow($hABTDLG_HWND, @SW_SHOW)

	_WinAPI_DestroyIcon(_SendMessage($hABTDLG_HWND, $WM_SETICON, $ICON_SMALL, _WinAPI_LoadShell32Icon(154)))

	Local $iIndex = 0, $iStep, $hDll = DllOpen("comctl32.dll"), $hDC = _WinAPI_GetDC($hABTDLG_HWND)
	$iStep = 1
	While WinExists($hABTDLG_HWND)
		DllCall($hDll, "bool", "ImageList_Draw", "handle", $hLeftIcon, "int", $iIndex, "handle", $hDC, "int", 16, "int", 10, "uint", 0)
		$iIndex += $iStep
		If $iIndex > 22 Then
			$iStep = -1
		EndIf
		If $iIndex < 0 Then
			$iStep = 1
		EndIf
		Sleep(50)
	WEnd
	DllClose($hDll)
	_WinAPI_ReleaseDC($hABTDLG_HWND, $hDC)
	_WinAPI_DeleteObject($hFont)
	_WinAPI_EnableWindow($hWnd, True)
	_WinAPI_SetActiveWindow($hWnd)
EndFunc   ;==>__AboutDlg

Func __WinCtrlGroupBox($hWnd, $sText, $iLeft, $iTop, $iWidth, $iHeight, $iStyle = -1, $iExStyle = -1)
	Local $iForcedStyle = BitOR($WS_GROUP, $BS_GROUPBOX, $WS_VISIBLE, $WS_CHILD)
	Local Static $iCtrlID = 0

	__GetLastCtrlID($hWnd, $iCtrlID)

	If $iStyle = -1 Then
		$iStyle = $iForcedStyle
	Else
		$iStyle = BitOR($iStyle, $iForcedStyle)
	EndIf
	If $iExStyle = -1 Then $iExStyle = 0
;~ 	$iExStyle = BitOR($iExStyle, $WS_EX_NOACTIVATE)
	Local $hGroup = _WinAPI_CreateWindowEx($iExStyle, "BUTTON", $sText, $iStyle, $iLeft, $iTop, $iWidth, $iHeight, $hWnd, $iCtrlID)
	_SendMessage($hGroup, $WM_SETFONT, _WinAPI_GetStockObject($DEFAULT_GUI_FONT), True)
	Return $hGroup
EndFunc   ;==>__WinCtrlGroupBox

Func __WinCtrlStatic($hWnd, $sText, $iLeft, $iTop, $iWidth, $iHeight, $iStyle = -1, $iExStyle = -1)
	Local $iForcedStyle = BitOR($WS_TABSTOP, $WS_VISIBLE, $WS_CHILD, $SS_NOTIFY)
	Local Static $iCtrlID = 0

	__GetLastCtrlID($hWnd, $iCtrlID)

	If $iStyle = -1 Then
		$iStyle = $iForcedStyle
	Else
		$iStyle = BitOR($iStyle, $iForcedStyle)
	EndIf
	If $iExStyle = -1 Then $iExStyle = 0
;~ 	$iExStyle = BitOR($iExStyle, $WS_EX_NOACTIVATE)
	Local $hStatic = _WinAPI_CreateWindowEx($iExStyle, "Static", $sText, $iStyle, $iLeft, $iTop, $iWidth, $iHeight, $hWnd, $iCtrlID)
	_SendMessage($hStatic, $WM_SETFONT, _WinAPI_GetStockObject($DEFAULT_GUI_FONT), True)
	Return $hStatic
EndFunc   ;==>__WinCtrlStatic

Func __GetLastCtrlID($hWnd, ByRef $iCtrlID)
	Local $avEnumChild = _WinAPI_EnumChildWindows($hWnd, False)
	If @error Then
		$iCtrlID = 1
	Else
		$iCtrlID = _WinAPI_GetDlgCtrlID($avEnumChild[$avEnumChild[0][0]][0]) + 1
	EndIf
EndFunc   ;==>__GetLastCtrlID

Func __ButtonSetIcon($hWnd, $iIndex, $iWidth = 16, $iHeight = 16, $iAlign = 0, $sDll = "Shell32.dll")
	Local $hImageList

	$hImageList = _GUIImageList_Create($iWidth, $iHeight, 5, 3)
	_GUIImageList_AddIcon($hImageList, @SystemDir & "\" & $sDll, $iIndex, True)
	_GUICtrlButton_SetImageList($hWnd, $hImageList, $iAlign)
EndFunc   ;==>__ButtonSetIcon

Func __ShutDown()
	If $hUSER32 Then DllClose($hUSER32)
	If $hWINDOW_PROC Then
		_WinAPI_UnregisterClass($sCLASSNAME, $hINSTANCE)
		DllCallbackFree($hWINDOW_PROC)
	EndIf
	If $hCBTPROC_HOOKERROR Then
		DllCallbackFree($hCBTPROC_CALLBKERROR)
	EndIf
	If $hSCR_HBITMAP Then
		_WinAPI_DeleteObject($hSCR_HBITMAP)
		_GDIPlus_Shutdown()
	EndIf
	__KillBot()
EndFunc   ;==>__ShutDown

Func _IconAni()
	Local $hFileHwnd, $bData, $sFileName = @TempDir & "\Icon.bmp" ; , $s1FileName = "test.bmp"
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= 'qqoQsE9P+WUKyAEBIqdlAfoBAfA+FBSA1FVVOk9PRGAjAyBQoKhoaGiurq7Aqqqqi4uLYDGgGIHoC0Gbm6IuLuYjGJ0BAeQXVQAiIrUHAJpGmcAibGxsyckIybCw4BRPNTU1g4M75guBgYoXF+ELAAEBzAEBdAEBQuAObe8BAfImaz5gPnJaWizDdgAAPAA8PIKCgs7OzoiRkZHAdjk5OQBJAeYLUlI/h4eWXgJeYAf2AAB9AAAClQ4W+AICzwAAAUScBAT5Tk5JVQRVOOYLOjo6h4cQh6KiooBrEhISBwBJ5gsAAE9PR2pqAF739/6bm99tMG2tHBwGOqRFAgIQwAEB0sYNFRXSwFpaKk9PRYI7gQhAPj4+fX19YDoUxBQUgHc0NDTgC+AyAUUwT1hYN/r6+0GgkOTk/ggILCPDQAEBowAA9IYjLeAtm19fH8KCJFygOREALh8fHyBrKioqR0Akw4XgSkFBQaAPTyBPPff3+OALmJgBxxYBAeEBAYAABgCAC6nVyVxcKFMcUzzDmoAURnUZGRnHYJrgF+ALSUlJ4ALgMgGAGmFhYYqKe/hk+PngC+7u4wigsbRAAQFsAACebKY8xDx3gBdNTUmgdvBk//AFYEHwCzAd0F7wC8BTUBgAKysrZWVljIwQjKGhoVB+sLClCP39/bNsi4vRKgAqfQMDcAAAxQHMBSYmql1dKlbwVjRJScAFoRXwBcAFR3MQMFljWRMTE5BTtgy2tsAF8IOTk5PvBO/utnL8/P90dAPdfKBkPT11Xl4jf2A10Go2WVAAMF9gRyAkIgwiIpNZ8ImIiIirIKurkpKS8AW/v3K/xgWAgCGKUISwfjgQOMMAAPAXhDc3GN4aGt1zIwAREdz0RkbgjyFANHYHoweANkBiYmLg4ODGBcEOwZGPwAWwfnJy/AoACpkAAIkBAYkYDAzhLzwWE1xcKbhXVzXJBUATIEixEIlJCADt7cSPe3sgGP8AMjK3AABvAACAmAAAhwEBv88FgfMFNTWIYGAfwomP4SSQR8AFU2DR0dH5BQSbmzGbf3//dnYI/1xc4G+fAAByAAAAlwAAhQEBBs7PBSAAJyeqXl7uIMAFgDylXlGwKiBsI36BsHgsLC/BwbLwBYRSUgAX/yAg/1BsYfKP1wEBi8ALwoO9x88FMAIQH11dIpIL5B5/YBGAKsAFIIqwJLAegCRfgF9B2dnmIyN9WAgBAfPAcQAAcwGMAa38X/MFNzeDQK//9oOgBCAGYAtTJOAwsIqwEsFgXJ6emisrwE38BXD5AQGTUBL/CyAADMQM5mCnUlJAI3IAAH/AC6BAUCogBiAMEDFTTlJCUqAlVhoa9/4F/gsiqPAFyP8FKSmlXHxcJ/Z9U0ggBmAFgEg2jDY2g6L1fW5iYv+PAcBNwQAAawEBzfGvATExkPKDkR1zBMAL8fAjVVVV8GVAN/mJ8I8slJR/cCAM3VC6AQHG0M8d8INaWi3wCzazH/AXgHJTJBMBdZdBcXEYerKyH6wgAOsBAQXwI9z/BT09dFhYDjHzfZARwAV5eXlWPFZWsHIjNvaD8AWEhIKM9n0CAvABAbQe/5Chv3jzicKb8YnwBWALoMTAo6OjgYGBgH7ACwH5g1xcLvb2+6OCo7QnAQHrAwMzj40gAObA0f8FAgL7ICHoVVU50tBN0BZgFwBTwMPDw5CQkMAFEE9B+ZWioqlwcPQdAbAB2AICwEGzAOD1ldEqAAgI8PKPPGIW8QXAV1dXtLS0AFPwEYOQv/yDgICJMDD0iUABAbgBAa+2EgKOAmSDyTXAL1NTQICTY/MF8F9bW1swWcBfC2ALCzMzM5Av+R1c8FxnERExF3DEMHEPR/H8BSEhtsApplgwLwDpAyAYIHIXFxc3NzcHwy8DAPAFSUlVAwPp8R0CAqBAe9/ic68ofjCcXl4kwzUjbFlZfllgg/AFU/BAAcO/QklACFxccfBNAADXADAAaAAA2UaHzAAA4wQs8AU5OX6T'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= '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'
	$bData &= 'AA8ADwAPAA8ADwAPAA8A/w8ADwAPAA8ADwAPAAcAoI4gk5P/vr4RlNrawP/u7v/9/V8CDwBPDwAPAAQA0HwSEgGJhgCG/5yc/7y8//zY2CBmjwIPAA8ADwCRCwQCAjF3GBj/e3uDZH1giaCg/8/PjwYnDwAPAA0AbGyXfVlZn1EG8IlQBqATIJz7+x8DZw8ADwAHALKyUaImBjaCNieQhYX/zMwfAx8PAA8ABwAQlC+Qb2//5G5u5KKdnaEfDwAPABcPAA8AcqPlcGqkpKQIkZGRAH1SUlJU4FRUk5OTb3EPAA8AAw8AAADt7e27u7sAoKCgpqamZWUAZUpKSl1dXbh8uLifAg8ADwAPAAAA6CDo6L29vQCPqqoAqoGBgUZGRmJ8YmLPiQ8ADwAPAAkA7ATs7ICKurq6cnL+cuAMDwIPAA8ADwCvo+CEwM3NzdXV1d8BDwDfDwAPAA8AIB5wl+ag2g8A/w8ADwAPAA8ADwAPAA8ADwD/DwAPAA8ADwAPAA8ADwAPAP8PAA8ADwAPAA8ADwAPAA8Afw8ADwAPAA8ADwAPAAoAf7AC/2cC+vr/ubn/YN7e//v7PxMTAKIAov8QEP9gYP8Ajo7/n5//zs4Y//T0fxUKAG9v/wAMDP8mJv9/fwD/enr/paX/3wbffxUHANTU/zIyg4EYgABhYf+AgAEaDL29P00EAMbG/zUGNcQXgAA0NP+CggD/cXH/hIT/0gbS3wcDAA=='

	$hFileHwnd = FileOpen($sFileName, 10)
	If @error Then Return SetError(1, 0, 0)
	FileWrite($hFileHwnd, __IconAni(__IconAniB64($bData)))
	FileClose($hFileHwnd)
	If FileExists($sFileName) Then Return $sFileName


	Return SetError(1, 0, 0)

EndFunc   ;==>_IconAni

Func __IconAniB64($sInput)
	Local $struct = DllStructCreate("int")
	Local $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _
			"str", $sInput, _
			"int", 0, _
			"int", 1, _
			"ptr", 0, _
			"ptr", DllStructGetPtr($struct, 1), _
			"ptr", 0, _
			"ptr", 0)
	If @error Or Not $a_Call[0] Then
		Return SetError(1, 0, "") ; error calculating the length of the buffer needed
	EndIf
	Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")
	$a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _
			"str", $sInput, _
			"int", 0, _
			"int", 1, _
			"ptr", DllStructGetPtr($a), _
			"ptr", DllStructGetPtr($struct, 1), _
			"ptr", 0, _
			"ptr", 0)
	If @error Or Not $a_Call[0] Then
		Return SetError(2, 0, "") ; error decoding
	EndIf
	Return DllStructGetData($a, 1)
EndFunc   ;==>__IconAniB64

Func __IconAni($bBinary)
	$bBinary = Binary($bBinary)
	Local $tInput = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
	DllStructSetData($tInput, 1, $bBinary)
	Local $tBuffer = DllStructCreate("byte[" & 16 * DllStructGetSize($tInput) & "]") ; initially oversizing buffer
	Local $a_Call = DllCall("ntdll.dll", "int", "RtlDecompressBuffer", _
			"ushort", 2, _
			"ptr", DllStructGetPtr($tBuffer), _
			"dword", DllStructGetSize($tBuffer), _
			"ptr", DllStructGetPtr($tInput), _
			"dword", DllStructGetSize($tInput), _
			"dword*", 0)

	If @error Or $a_Call[0] Then
		Return SetError(1, 0, "") ; error decompressing
	EndIf

	Local $tOutput = DllStructCreate("byte[" & $a_Call[6] & "]", DllStructGetPtr($tBuffer))

	Return SetError(0, 0, DllStructGetData($tOutput, 1))
EndFunc   ;==>__IconAni

Func __KillBot($aProfile=False)

	_GUICtrlTab_ClickTab($TabMain, 0)
	BotClose($aProfile)

	If $hMutex_BotTitle <> 0 Then _WinAPI_CloseHandle($hMutex_BotTitle)
	If $hMutex_Profile <> 0 Then _WinAPI_CloseHandle($hMutex_Profile)
	If $hMutex_MyBot <> 0 Then _WinAPI_CloseHandle($hMutex_MyBot)
	_GDIPlus_Shutdown()
	GUIDelete($frmBot)
	Exit 1

EndFunc   ;==>__KillBot

Func FlushDebugFolder()

	DirRemove($dirDebug, 1)
	DirCreate($dirDebug)
	FlushDebugFiles()

EndFunc   ;==>FlushDebugFolder

Func FlushDebugFiles()

	Local $hc
	For $hc = UBound($aDebugFiles) - 1 To 0 Step -1
		$aDebugFiles[$hc][0] = FileOpen($dirDebug & "\" & $aDebugFiles[$hc][1] & ".log", $FO_OVERWRITE)
		FileWrite($aDebugFiles[$hc][0], "")
		FileClose($aDebugFiles[$hc][0])
		$aDebugFiles[$hc][0] = FileOpen($dirDebug & "\" & $aDebugFiles[$hc][1] & ".log", $FO_APPEND)
	Next

EndFunc   ;==>FlushDebugFiles

Func _ConsoleWrite($data, $LogType = "bot")

	ConsoleWrite($data)
	_Log($data, $LogType)

EndFunc   ;==>_ConsoleWrite


Func _Log($data, $LogType = "bot", $NewLine = True)
	Global $aDebugFiles
	If IsArray($data) Then $data = _ArrayToString($data) & @CRLF

	If $data = "" Or Not IsString($data) Then Return
	If $NewLine = True Then $data &= @CRLF
	$data = StringStripWS($data, 2)
	Local $LogTypeArray = StringSplit($LogType, ",")
	_ArrayDelete($LogTypeArray, 0)
	If UBound($LogTypeArray) >= 1 Then
		For $LogType In $LogTypeArray
			Local $RetArrayres = _ArrayFindAll($aDebugFiles, $LogType, Default, Default, Default, Default, 1, False)
			If IsArray($RetArrayres) Then
				$aDebugFiles[$RetArrayres[0]][0] = FileOpen($dirDebug & "\" & $aDebugFiles[$RetArrayres[0]][1] & ".log", $FO_APPEND)
				FileWrite($aDebugFiles[$RetArrayres[0]][0], $data & @CRLF)
			EndIf
		Next
	EndIf

EndFunc   ;==>_Log

Func __GetFileName($sFilePath)

	Local $aFolders = ""
	Local $FileName = ""
	Local $iArrayFoldersSize = 0

	If (Not IsString($sFilePath)) Then
		Return SetError(1, 0, -1)
	EndIf

	$aFolders = StringSplit($sFilePath, "\")
	$iArrayFoldersSize = UBound($aFolders)
	$FileName = $aFolders[($iArrayFoldersSize - 1)]

	Return $FileName

EndFunc   ;==>__GetFileName

Func __GetDir($sFilePath)

	Local $aFolders = StringSplit($sFilePath, "\")
	Local $iArrayFoldersSize = UBound($aFolders)
	Local $FileDir = ""

	If (Not IsString($sFilePath)) Then
		Return SetError(1, 0, -1)
	EndIf

	$aFolders = StringSplit($sFilePath, "\")
	$iArrayFoldersSize = UBound($aFolders)

	For $i = 1 To ($iArrayFoldersSize - 2)
		$FileDir &= $aFolders[$i] & "\"
	Next

	Return $FileDir

EndFunc   ;==>__GetDir


;~ If UBound($CMDLine) > 1 Then
;~ 	If $CMDLine[1] <> "" Then _Zip_VirtualZipOpen()
;~ EndIf

Func _Zip_Create($hFilename)
	$hFp = FileOpen($hFilename, 26)
	$sString = Chr(80) & Chr(75) & Chr(5) & Chr(6) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0) & Chr(0)
	FileWrite($hFp, $sString)
	If @error Then Return SetError(1, 0, 0)
	FileClose($hFp)

	While Not FileExists($hFilename)
		Sleep(10)
	WEnd
	Return $hFilename
EndFunc   ;==>_Zip_Create

Func _Zip_AddFile($hZipFile, $hFile2Add, $flag = 1)
	Local $DLLChk = _Zip_DllChk()
	Local $files = _Zip_Count($hZipFile)
	If $DLLChk <> 0 Then Return SetError($DLLChk, 0, 0) ;no dll
	If Not _IsFullPath($hZipFile) Then Return SetError(4, 0) ;zip file isn't a full path
	If Not FileExists($hZipFile) Then Return SetError(1, 0, 0) ;no zip file
	$oApp = ObjCreate("Shell.Application")
	$copy = $oApp.NameSpace($hZipFile).CopyHere($hFile2Add)
	While 1
		If $flag = 1 Then _Hide()
		_ChangeTitle()
		If _Zip_Count($hZipFile) = ($files + 1) Then ExitLoop
		Sleep(10)
	WEnd
	Return SetError(0, 0, 1)
EndFunc   ;==>_Zip_AddFile

Func _Zip_AddFolder($hZipFile, $hFolder, $flag = 1)
	Local $DLLChk = _Zip_DllChk()
	If $DLLChk <> 0 Then Return SetError($DLLChk, 0, 0) ;no dll
	If Not _IsFullPath($hZipFile) Then Return SetError(4, 0) ;zip file isn't a full path
	If Not FileExists($hZipFile) Then Return SetError(1, 0, 0) ;no zip file
	If StringRight($hFolder, 1) <> "\" Then $hFolder &= "\"
	$files = _Zip_Count($hZipFile)
	$oApp = ObjCreate("Shell.Application")
	$oCopy = $oApp.NameSpace($hZipFile).CopyHere($oApp.Namespace($hFolder))
	While 1
		If $flag = 1 Then _Hide()
		_ChangeTitle()
		If _Zip_Count($hZipFile) = ($files + 1) Then ExitLoop
		Sleep(10)
	WEnd
	Return SetError(0, 0, 1)
EndFunc   ;==>_Zip_AddFolder

Func _Zip_AddFolderContents($hZipFile, $hFolder, $flag = 1)
	Local $DLLChk = _Zip_DllChk()
	If $DLLChk <> 0 Then Return SetError($DLLChk, 0, 0) ;no dll
	If Not _IsFullPath($hZipFile) Then Return SetError(4, 0) ;zip file isn't a full path
	If Not FileExists($hZipFile) Then Return SetError(1, 0, 0) ;no zip file
	If StringRight($hFolder, 1) <> "\" Then $hFolder &= "\"
	$files = _Zip_Count($hZipFile)
	$oApp = ObjCreate("Shell.Application")
	$oFolder = $oApp.NameSpace($hFolder)
	$oCopy = $oApp.NameSpace($hZipFile).CopyHere($oFolder.Items)
	$oFC = $oApp.NameSpace($hFolder).items.count
	While 1
		If $flag = 1 Then _Hide()
		_ChangeTitle()
		If _Zip_Count($hZipFile) = ($files + $oFC) Then ExitLoop
		Sleep(10)
	WEnd
	Return SetError(0, 0, 1)
EndFunc   ;==>_Zip_AddFolderContents

Func _Zip_Delete($hZipFile, $hFilename, $flag = 1)
	Local $DLLChk = _Zip_DllChk()
	If $DLLChk <> 0 Then Return SetError($DLLChk, 0, 0) ;no dll
	If Not _IsFullPath($hZipFile) Then Return SetError(4, 0) ;zip file isn't a full path
	If Not FileExists($hZipFile) Then Return SetError(1, 0, 0) ;no zip file
	$list = _Zip_List($hZipFile)
	$dir = @TempDir & "\tmp" & Floor(Random(0, 100))
	For $i = 1 To $list[0]
		If $list[$i] <> $hFilename Then _Zip_Unzip($hZipFile, $list[$i], $dir, $flag)
	Next
	FileDelete($hZipFile)
	_Zip_Create($hZipFile)
	_Zip_AddFolderContents($hZipFile, $dir, $flag)
	DirRemove($dir)
EndFunc   ;==>_Zip_Delete

Func _Zip_UnzipAll($hZipFile, $hDestPath, $flag = 1)
	Local $DLLChk = _Zip_DllChk()
	If $DLLChk <> 0 Then Return SetError($DLLChk, 0, 0) ;no dll
	If Not _IsFullPath($hZipFile) Then Return SetError(4, 0) ;zip file isn't a full path
	If Not FileExists($hZipFile) Then Return SetError(2, 0, 0) ;no zip file
	If Not FileExists($hDestPath) Then DirCreate($hDestPath)
	Local $aArray[1]
	$oApp = ObjCreate("Shell.Application")
	$oApp.Namespace($hDestPath).CopyHere($oApp.Namespace($hZipFile).Items)
	For $item In $oApp.Namespace($hZipFile).Items
		_ArrayAdd($aArray, $item)
	Next
	While 1
		If $flag = 1 Then _Hide()
		_ChangeTitle()
		If FileExists($hDestPath & "\" & $aArray[UBound($aArray) - 1]) Then
			Return SetError(0, 0, 1)
			ExitLoop
		EndIf
		Sleep(500)
	WEnd
EndFunc   ;==>_Zip_UnzipAll

Func _Zip_Unzip($hZipFile, $hFilename, $hDestPath, $flag = 1)
	Local $DLLChk = _Zip_DllChk()
	If $DLLChk <> 0 Then Return SetError($DLLChk, 0, 0) ;no dll
	If Not _IsFullPath($hZipFile) Then Return SetError(4, 0) ;zip file isn't a full path
	If Not FileExists($hZipFile) Then Return SetError(1, 0, 0) ;no zip file
	If Not FileExists($hDestPath) Then DirCreate($hDestPath)
	$oApp = ObjCreate("Shell.Application")
	$hFolderitem = $oApp.NameSpace($hZipFile).Parsename($hFilename)
	$oApp.NameSpace($hDestPath).Copyhere($hFolderitem)
	While 1
		If $flag = 1 Then _Hide()
		_ChangeTitle()
		If FileExists($hDestPath & "\" & $hFilename) Then
			Return SetError(0, 0, 1)
			ExitLoop
		EndIf
		Sleep(500)
	WEnd
EndFunc   ;==>_Zip_Unzip

Func _Zip_Count($hZipFile)
	Local $DLLChk = _Zip_DllChk()
	If $DLLChk <> 0 Then Return SetError($DLLChk, 0, 0) ;no dll
	If Not _IsFullPath($hZipFile) Then Return SetError(4, 0) ;zip file isn't a full path
	If Not FileExists($hZipFile) Then Return SetError(1, 0, 0) ;no zip file
	$items = _Zip_List($hZipFile)
	Return UBound($items) - 1
EndFunc   ;==>_Zip_Count

Func _Zip_CountAll($hZipFile)
	Local $DLLChk = _Zip_DllChk()
	If $DLLChk <> 0 Then Return SetError($DLLChk, 0, 0) ;no dll
	If Not _IsFullPath($hZipFile) Then Return SetError(4, 0) ;zip file isn't a full path
	If Not FileExists($hZipFile) Then Return SetError(1, 0, 0) ;no zip file
	$oApp = ObjCreate("Shell.Application")
	$oDir = $oApp.NameSpace(StringLeft($hZipFile, StringInStr($hZipFile, "\", 0, -1)))
	$sZipInf = $oDir.GetDetailsOf($oDir.ParseName(StringTrimLeft($hZipFile, StringInStr($hZipFile, "\", 0, -1))), -1)
	Return StringRight($sZipInf, StringLen($sZipInf) - StringInStr($sZipInf, ": ") - 1)
EndFunc   ;==>_Zip_CountAll

Func _Zip_List($hZipFile)
	Local $aArray[1]
	Local $DLLChk = _Zip_DllChk()
	If $DLLChk <> 0 Then Return SetError($DLLChk, 0, 0) ;no dll
	If Not _IsFullPath($hZipFile) Then Return SetError(4, 0) ;zip file isn't a full path
	If Not FileExists($hZipFile) Then Return SetError(1, 0, 0) ;no zip file
	$oApp = ObjCreate("Shell.Application")
	$hList = $oApp.Namespace($hZipFile).Items
	For $item In $hList
		_ArrayAdd($aArray, $item.name)
	Next
	$aArray[0] = UBound($aArray) - 1
	Return $aArray
EndFunc   ;==>_Zip_List

Func _Zip_Search($hZipFile, $sSearchString)
	Local $aArray
	Local $DLLChk = _Zip_DllChk()
	If $DLLChk <> 0 Then Return SetError($DLLChk, 0, 0) ;no dll
	If Not _IsFullPath($hZipFile) Then Return SetError(4, 0) ;zip file isn't a full path
	If Not FileExists($hZipFile) Then Return SetError(1, 0, 0) ;no zip file
	$list = _Zip_List($hZipFile)
	For $i = 0 To UBound($list) - 1
		If StringInStr($list[$i], $sSearchString) > 0 Then
			_ArrayAdd($aArray, $list[$i])
		EndIf
	Next
	If UBound($aArray) - 1 = 0 Then
		Return SetError(1, 0, 0)
	Else
		Return $aArray
	EndIf
EndFunc   ;==>_Zip_Search

Func _Zip_SearchInFile($hZipFile, $sSearchString)
	Local $aArray
	$list = _Zip_List($hZipFile)
	For $i = 1 To UBound($list) - 1
		_Zip_Unzip($hZipFile, $list[$i], @TempDir & "\tmp_zip.file")
		$read = FileRead(@TempDir & "\tmp_zip.file")
		If StringInStr($read, $sSearchString) > 0 Then
			_ArrayAdd($aArray, $list[$i])
		EndIf
	Next
	If UBound($aArray) - 1 = 0 Then
		Return SetError(1, 0, 1)
	Else
		Return $aArray
	EndIf
EndFunc   ;==>_Zip_SearchInFile

Func _Zip_VirtualZipCreate($hZipFile, $sPath)
	$list = _Zip_List($hZipFile)
	If @error Then Return SetError(@error, 0, 0)
	If Not FileExists($sPath) Then DirCreate($sPath)
	If StringRight($sPath, 1) = "\" Then $sPath = StringLeft($sPath, StringLen($sPath) - 1)
	For $i = 1 To $list[0]
		If Not @Compiled Then
			$Cmd = @AutoItExe
			$params = '"' & @ScriptFullPath & '" ' & '"' & $hZipFile & "," & $list[$i] & '"'
		Else
			$Cmd = @ScriptFullPath
			$params = '"' & $hZipFile & "," & $list[$i] & '"'
		EndIf
		FileCreateShortcut($Cmd, $sPath & "\" & $list[$i], -1, $params, "Virtual Zipped File", _GetIcon($list[$i], 0), "", _GetIcon($list[$i], 1))
	Next
	$list = _ArrayInsert($list, 1, $sPath)
	Return $list
EndFunc   ;==>_Zip_VirtualZipCreate

Func _Zip_VirtualZipOpen()
	$ZipSplit = StringSplit($CMDLine[1], ",")
	$ZipName = $ZipSplit[1]
	$ZipFile = $ZipSplit[2]
	_Zip_Unzip($ZipName, $ZipFile, @TempDir & "\", 4 + 16) ;no progress + yes to all
	If @error Then Return SetError(@error, 0, 0)
	ShellExecute(@TempDir & "\" & $ZipFile)
EndFunc   ;==>_Zip_VirtualZipOpen

Func _Zip_VirtualZipDelete($aVirtualZipHandle)
	For $i = 2 To UBound($aVirtualZipHandle) - 1
		If FileExists($aVirtualZipHandle[1] & "\" & $aVirtualZipHandle[$i]) Then FileDelete($aVirtualZipHandle[1] & "\" & $aVirtualZipHandle[$i])
	Next
	Return 0
EndFunc   ;==>_Zip_VirtualZipDelete

Func _Zip_DllChk()
	If Not FileExists(@SystemDir & "\zipfldr.dll") Then Return 2
	If Not RegRead("HKEY_CLASSES_ROOT\CLSID\{E88DCCE0-B7B3-11d1-A9F0-00AA0060FA31}", "") Then Return 3
	Return 0
EndFunc   ;==>_Zip_DllChk

Func _GetIcon($file, $ReturnType = 0)
	$FileType = StringSplit($file, ".")
	$FileType = $FileType[UBound($FileType) - 1]
	$FileParam = RegRead("HKEY_CLASSES_ROOT\." & $FileType, "")
	$DefaultIcon = RegRead("HKEY_CLASSES_ROOT\" & $FileParam & "\DefaultIcon", "")

	If Not @error Then
		$IconSplit = StringSplit($DefaultIcon, ",")
		ReDim $IconSplit[3]
		$Iconfile = $IconSplit[1]
		$IconID = $IconSplit[2]
	Else
		$Iconfile = @SystemDir & "\shell32.dll"
		$IconID = -219
	EndIf

	If $ReturnType = 0 Then
		Return $Iconfile
	Else
		Return $IconID
	EndIf
EndFunc   ;==>_GetIcon

Func _IsFullPath($path)
	If StringInStr($path, ":\") Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_IsFullPath

Func _ChangeTitle()

	If ControlGetHandle("[CLASS:#32770]", "", "[CLASS:SysAnimate32; INSTANCE:1]") <> "" Or ControlGetHandle("[CLASS:#32770]", "", "[CLASS:DirectUIHWND; INSTANCE:1]") <> "" Then
		$hWnd = WinGetHandle("[CLASS:#32770]")
		Local $sProcessTitleText = WinGetTitle($hWnd)
		If StringLen($sProcessTitleText) <> 0 Then
			If Not StringInStr($sProcessTitleText, "MyBot ErrorTrap") Then
				WinSetTitle($hWnd, "", "MyBot ErrorTrap - " & $sProcessTitleText)
			EndIf
		Else
			WinSetTitle($hWnd, "", "Mybot - Please Wait")
		EndIf
	EndIf

EndFunc   ;==>_ChangeTitle

Func _Hide()
	If ControlGetHandle("[CLASS:#32770]", "", "[CLASS:SysAnimate32; INSTANCE:1]") <> "" Or WinGetState("[CLASS:#32770]") <> @SW_HIDE Or ControlGetHandle("[CLASS:#32770]", "", "[CLASS:DirectUIHWND; INSTANCE:1]") <> "" Then
		$hWnd = WinGetHandle("[CLASS:#32770]")
		WinSetState($hWnd, "", @SW_HIDE)
	EndIf
EndFunc   ;==>_Hide


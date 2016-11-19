; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Child Mod - Donation
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
$hGUI_Donation = GUICreate("", $_GUI_MAIN_WIDTH - 28, $_GUI_MAIN_HEIGHT - 255 - 28, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $hGUI_MOD)
GUISetBkColor($COLOR_WHITE, $hGUI_Donation)

GUISwitch($hGUI_Donation)


;$hGUI_STATS_TAB_ITEM5 = GUICtrlCreateTabItem("Donation Stats")
	Local $xStart = 25, $yStart = 45
	$x = $xStart
	$y = $yStart
	$grpStatsETroops = GUICtrlCreateGroup("Elixir Troops", $x - 20, $y - 20, 425, 130)
	;Barbarian
		GUICtrlCreateIcon($pIconLib, $eIcnBarbarian, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eBarb, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Archer
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnArcher, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eArch, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Giant
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnGiant, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eGiant, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Goblin
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnGoblin, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eGobl, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Wall Breaker
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnWallBreaker, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eWall, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Balloon
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnBalloon, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eBall, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)

	;2nd ROW
	$x = $xStart
	$y += 35
	;Wizard
		GUICtrlCreateIcon($pIconLib, $eIcnWizard, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eWiza, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Healer
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnHealer, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eHeal, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Dragon
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnDragon, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eDrag, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Pekka
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnPekka, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $ePekk, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Baby Dragon
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnBabyDragon, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eBabyD, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Miner
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnMiner, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eMine, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)

	;3rd ROW
	$x = $xStart
	$y += 42

	;Total Label
	$x += 32 + 27 + 10 + 32 + 27 + 126
		$lblTotalDonated = GUICtrlCreateLabel("Total Donated: 0", $x, $y + 10, 150, 16)
			GUICtrlSetFont(-1,10, 800) ; bold
			GUICtrlSetBkColor (-1, 0xbfdfff)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $yStart + 130
	$grpStatsDTroops = GUICtrlCreateGroup("Dark Elixir Troops", $x - 20, $y - 20, 425, 100)
	;Minion
		GUICtrlCreateIcon($pIconLib, $eIcnMinion, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eMini, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Hog Rider
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnHogRider, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eHogs, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Valkyrie
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnValkyrie, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eValk, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Golem
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnGolem, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eGole, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Witch
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnWitch, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eWitc, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Lava Hound
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnLavaHound, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eLava, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;2nd ROW
	$x = $xStart
	$y += 35
	;Bowler
		GUICtrlCreateIcon($pIconLib, $eIcnBowler, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eBowl, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)

	$y += 12
	;Total Donation
	$x += 32 + 27 + 10 + 32 + 27 + 126
		$lblTotalDonatedDark = GUICtrlCreateLabel("Total Donated: 0", $x, $y + 10, 150, 16)
			GUICtrlSetFont(-1,10, 800) ; bold
			GUICtrlSetBkColor (-1, 0xbfdfff)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $yStart + 130 + 100
	$grpStatsDTroops = GUICtrlCreateGroup("Dark Spells", $x - 20, $y - 20, 425, 70)
	;Poison
		GUICtrlCreateIcon($pIconLib, $eIcnPoisonSpell, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $ePSpell, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;EarthQuake
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnEarthQuakeSpell, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eESpell, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Haste
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnHasteSpell, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eHaSpell, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)
	;Skeleton
	$x += 32 + 27 + 10
		GUICtrlCreateIcon($pIconLib, $eIcnSkeletonSpell, $x - 5, $y, 32, 32)
			Assign("lblDonated" & $eSkSpell, GUICtrlCreateLabel("0", $x + 32, $y + 8, 27, 16), 2)

	$y += 11
	;Total Donation
	$x += 32 + 22
		$lblTotalDonatedSpell = GUICtrlCreateLabel("Total Donated: 0", $x - 7, $y + 16, 150, 16)
			GUICtrlSetFont(-1,10, 800) ; bold
			GUICtrlSetBkColor (-1, 0xbfdfff)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y -= 6
	$x += 15
	;Reset Donation Stats
	GUICtrlCreateButton("Reset Don. Stats", $x + 20, $y + 48, 110,30)
		GUICtrlSetOnEvent(-1, "ResetDonateStats")
;--> TAB Donation Stats

;GUICtrlCreateTabItem("")



; #FUNCTION# ====================================================================================================================
; Name ..........: BrewSpells
; Description ...: Create Normal Spells and Dark Spells
; Syntax ........: BrewSpells()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (08-2015)
; Modified ......: Monkeyhunter (01/05-2016) , ProMac(08-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $debugSetLogSpellBrew = False

Func BrewSpells()

	; ATTENTION : This function only works if the ArmyOverView Windows is open
	Local $iLightningSpell, $iHealSpell, $iRageSpell, $iJumpSpell, $iFreezeSpell, $iCloneSpell, $iPoisonSpell, $iEarthSpell, $iHasteSpell, $iSkeletonSpell

	If $iTotalCountSpell = 0 Then Return
	Local $WaitForSpells = IsWaitforSpellsActive()

	If $numFactorySpellAvaiables = 1 And ($LSpellComp > 0 Or $RSpellComp > 0 Or $HSpellComp > 0 Or $JSpellComp > 0 Or $FSpellComp > 0 Or $CSpellComp > 0) Then

		Local $iBarrHere = 0
		While Not (isSpellFactory())
			If Not (IsTrainPage()) Then Return
			_TrainMoveBtn(+1) ;click Next button
			$iBarrHere += 1
			If _Sleep($iDelayTrain3) Then ExitLoop
			If $iBarrHere = 8 Then ExitLoop
		WEnd
		If isSpellFactory() Then
			If $LSpellComp > 0 Then ; Lightning Spells
				Local $iTempLightningSpell = Number(getBarracksTroopQuantity(175 + 107 * 0, 295 + $midOffsetY))
				If $IsFullArmywithHeroesAndSpells = true and $WaitForSpells = True Then ;if spell factory full
					If $iTempLightningSpell = $LSpellComp Then ; check if replacement spells trained,
						$iLightningSpell = 0
					Else
						$iLightningSpell = $LSpellComp - $iTempLightningSpell ; add spells to queue to match GUI
					EndIf
				Else
					$iLightningSpell = $LSpellComp - ($CurLightningSpell + $iTempLightningSpell) ; not full, add more spell if needed
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Making Lightning Spell: " & $iLightningSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iLightningSpell > 0 Then
					If _ColorCheck(_GetPixelColor(235 + 107 * 0, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 0
						setlog("Not enough Elixir to create Lightning Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iLightningSpell > 0 Then
							GemClick(220 + 107 * 0, 354 + $midOffsetY, $iLightningSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iLightningSpell & " Lightning Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					If $iTempLightningSpell > 0 then Setlog("Already Brewed " & $iTempLightningSpell & " Lightning Spell(s)")
					If $iTempLightningSpell = 0 then Setlog("Already done Lightning Spell(s)")
				EndIf
			EndIf
			If $RSpellComp > 0 Then ; Heal Spells
				Local $iTempHealSpell = Number(getBarracksTroopQuantity(175 + 107 * 1, 295 + $midOffsetY))
				If $IsFullArmywithHeroesAndSpells = true and $WaitForSpells = True Then ;if spell factory full

					If $iTempHealSpell = $RSpellComp Then ; check if replacement spells trained,
						$iHealSpell = 0
					Else
						$iHealSpell = $RSpellComp - $iTempHealSpell ; add spells to queue to match GUI
					EndIf
				Else
					$iHealSpell = $RSpellComp - ($CurHealSpell + $iTempHealSpell) ; not full, add more spell if needed
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Making Heal Spell: " & $iHealSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iHealSpell > 0 Then
					If _ColorCheck(_GetPixelColor(235 + 107 * 1, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then
						setlog("Not enough Elixir to create Heal Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iHealSpell > 0 Then
							GemClick(220 + 107 * 1, 354 + $midOffsetY, $iHealSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iHealSpell & " Heal Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
					Else
					If $iTempHealSpell > 0 then Setlog("Already Brewed " & $iTempHealSpell & " Heal Spell(s)")
					If $iTempHealSpell = 0 then Setlog("Already done Heal Spell(s)")
				EndIf
			EndIf
			If $HSpellComp > 0 Then ; Rage Spells
				Local $iTempRageSpell = Number(getBarracksTroopQuantity(175 + 107 * 2, 295 + $midOffsetY))
				If $IsFullArmywithHeroesAndSpells = true and $WaitForSpells = True Then ;if spell factory full
					If $iTempRageSpell = $HSpellComp Then ; check if replacement spells trained,
						$iRageSpell = 0
					Else
						$iRageSpell = $HSpellComp - $iTempRageSpell ; add spells to queue to match GUI
					EndIf
				Else
					$iRageSpell = $HSpellComp - ($CurRageSpell + $iTempRageSpell) ; not full, add more spell if needed
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Making Rage Spell: " & $iRageSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iRageSpell > 0 Then
					If _ColorCheck(_GetPixelColor(235 + 107 * 2, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then
						setlog("Not enough Elixir to create Rage Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iRageSpell > 0 Then
							GemClick(220 + 107 * 2, 354 + $midOffsetY, $iRageSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iRageSpell & " Rage Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					If $iTempRageSpell > 0 then Setlog("Already Brewed " & $iTempRageSpell & " Rage Spell(s)")
					If $iTempRageSpell = 0 then Setlog("Already done Rage Spell(s)")
				EndIf
			EndIf
			If $JSpellComp > 0 Then ; Jump Spells
				Local $iTempJumpSpell = Number(getBarracksTroopQuantity(175 + 107 * 3, 295 + $midOffsetY))
				If $IsFullArmywithHeroesAndSpells = true and $WaitForSpells = True Then ;if spell factory full
					If $iTempJumpSpell = $JSpellComp Then ; check if replacement spells trained,
						$iJumpSpell = 0
					Else
						$iJumpSpell = $JSpellComp - $iTempJumpSpell ; add spells to queue to match GUI
					EndIf
				Else
					$iJumpSpell = $JSpellComp - ($CurJumpSpell + $iTempJumpSpell) ; not full, add more spell if needed
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Making Jump Spell: " & $iJumpSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iJumpSpell > 0 Then
					If _ColorCheck(_GetPixelColor(235 + 107 * 3, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 0
						setlog("Not enough Elixir to create Jump Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iJumpSpell > 0 Then
							GemClick(220 + 107 * 3, 354 + $midOffsetY, $iJumpSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iJumpSpell & " Jump Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					If $iTempJumpSpell > 0 then Setlog("Already Brewed " & $iTempJumpSpell & " Jump Spell(s)")
					If $iTempJumpSpell = 0 then Setlog("Already done Jump Spell(s)")
				EndIf
			EndIf
			If $FSpellComp > 0 Then ; Freeze Spells
				Local $iTempFreezeSpell = Number(getBarracksTroopQuantity(175 + 107 * 4, 295 + $midOffsetY))
				If $IsFullArmywithHeroesAndSpells = true and $WaitForSpells = True Then ;if spell factory full
					If $iTempFreezeSpell = $FSpellComp Then ; check if replacement spells trained,
						$iFreezeSpell = 0
					Else
						$iFreezeSpell = $FSpellComp - $iTempFreezeSpell ; add spells to queue to match GUI
					EndIf
				Else
					$iFreezeSpell = $FSpellComp - ($CurFreezeSpell + $iTempFreezeSpell) ; not full, add more spell if needed
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Making Freeze Spell: " & $iFreezeSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iFreezeSpell > 0 Then
					If _ColorCheck(_GetPixelColor(235 + 107 * 4, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 0
						setlog("Not enough Elixir to create Freeze Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iFreezeSpell > 0 Then
							GemClick(220 + 107 * 4, 354 + $midOffsetY, $iFreezeSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iFreezeSpell & " Freeze Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					If $iTempFreezeSpell > 0 then Setlog("Already Brewed " & $iTempFreezeSpell & " Freeze Spell(s)")
					If $iTempFreezeSpell = 0 then Setlog("Already done Freeze Spell(s)")
				EndIf
			EndIf
			If $CSpellComp > 0 Then ; Clone Spells
				Local $iTempCloneSpell = Number(getBarracksTroopQuantity(175 + 107 * 1, 401 + $midOffsetY))
				If $IsFullArmywithHeroesAndSpells = true and $WaitForSpells = True Then ;if spell factory full
					If $iTempCloneSpell = $CSpellComp Then ; check if replacement spells trained,
						$iCloneSpell = 0
					Else
						$iCloneSpell = $CSpellComp - $iTempCloneSpell ; add spells to queue to match GUI
					EndIf
				Else
					$iCloneSpell = $CSpellComp - ($CurCloneSpell + $iTempCloneSpell) ; not full, add more spell if needed
				EndIf
				If $debugsetlogTrain = 1 Then SetLog("Making Clone Spell: " & $iCloneSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iCloneSpell > 0 Then
					If _ColorCheck(_GetPixelColor(235 + 107 * 1, 480 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 0
						setlog("Not enough Elixir to create Clone Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iCloneSpell > 0 Then
							GemClick(220 + 107 * 1, 450 + $midOffsetY, $iCloneSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iCloneSpell & " Clone Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					If $iTempCloneSpell > 0 then Setlog("Already Brewed " & $iTempCloneSpell & " Clone Spell(s)")
					If $iTempCloneSpell = 0 then Setlog("Already done Clone Spell(s)")
				EndIf
			EndIf
		Else
			SetLog("Spell Factory not found...", $COLOR_BLUE)
		EndIf
	EndIf

	If $numFactoryDarkSpellAvaiables = 1 And ($PSpellComp > 0 Or $HaSpellComp > 0 Or $ESpellComp > 0 Or $SkSpellComp > 0) Then
		$iBarrHere = 0
		While Not (isDarkSpellFactory())
			If Not (IsTrainPage()) Then Return
			_TrainMoveBtn(+1) ;click Next button
			$iBarrHere += 1
			If $iBarrHere = 8 Then ExitLoop
			If _Sleep($iDelayTrain3) Then Return
		WEnd
		If isDarkSpellFactory() Then
			If $PSpellComp > 0 Then ; Poison Spells
				Local $iTempPoisonSpell = Number(getBarracksTroopQuantity(175 + 107 * 0, 295 + $midOffsetY))
				If $IsFullArmywithHeroesAndSpells = true and $WaitForSpells = True Then ;if spell factory full
					If $iTempPoisonSpell = $PSpellComp Then ; check if replacement spells trained,
						$iPoisonSpell = 0
					Else
						$iPoisonSpell = $PSpellComp - $iTempPoisonSpell ; add spells to queue to match GUI
						If $debugSetLogSpellBrew = True Then SetLog("$iPoisonSpell -= " & (Number($CurPoisonSpell - $PSpellComp)), $COLOR_BLUE)
						$iPoisonSpell -= (Number($CurPoisonSpell - $PSpellComp))
						If $debugSetLogSpellBrew = True Then SetLog("$iPoisonSpell = " & $iPoisonSpell, $COLOR_BLUE)
					EndIf
				Else
					$iPoisonSpell = $PSpellComp - ($CurPoisonSpell + $iTempPoisonSpell) ; not full, add more spell if needed
				EndIf
				;If $iPoisonSpellComp = $CurPoisonSpell Then $iPoisonSpell = 0
				If $debugsetlogTrain = 1 Then SetLog("Making Poison Spell: " & $iPoisonSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iPoisonSpell > 0 Then
					If _sleep($iDelayTrain2) Then Return
					If _ColorCheck(_GetPixelColor(231 + 107 * 0, 370 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False And _ ; White into number 0
							_ColorCheck(_GetPixelColor(234 + 107 * 0, 370 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 5
						setlog("Not enough Elixir to create Poison Spell", $COLOR_RED)
						If $debugsetlogTrain = 1 Then setlog("colorceck: " & 233 + 107 * 0 & "," & 375 + $midOffsetY, $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iPoisonSpell > 0 Then
							GemClick(222, 354 + $midOffsetY, $iPoisonSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iPoisonSpell & " Poison Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					If $iTempPoisonSpell > 0 then Setlog("Already Brewed " & $iTempPoisonSpell & " Poison Spell(s)")
					If $iTempPoisonSpell = 0 then Setlog("Already done Poison Spell(s)")
				EndIf
			EndIf

			If $ESpellComp > 0 Then ; EarthQuake Spells
				Local $iTempEarthSpell = Number(getBarracksTroopQuantity(175 + 107 * 1, 295 + $midOffsetY))
				If $IsFullArmywithHeroesAndSpells = true and $WaitForSpells = True Then ;if spell factory full
					If $iTempEarthSpell = $ESpellComp Then ; check if replacement spells trained,
						$iEarthSpell = 0
					Else
						$iEarthSpell = $ESpellComp - $iTempEarthSpell ; add spells to queue to match GUI
						If $debugSetLogSpellBrew = True Then SetLog("$iEarthSpell -= " & (Number($CurEarthSpell - $ESpellComp)), $COLOR_BLUE)
						$iEarthSpell -= (Number($CurEarthSpell - $ESpellComp))
						If $debugSetLogSpellBrew = True Then SetLog("$iEarthSpell = " & $iEarthSpell, $COLOR_BLUE)
					EndIf
				Else
					$iEarthSpell = $ESpellComp - ($CurEarthSpell + $iTempEarthSpell) ; not full, add more spell if needed
				EndIf
				;If $iEarthSpellComp = $CurEarthSpell Then $iEarthSpell = 0
				If $debugsetlogTrain = 1 Then SetLog("Making Earthquake Spell: " & $iEarthSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iEarthSpell > 0 Then
					If _sleep($iDelayTrain2) Then Return
					If _ColorCheck(_GetPixelColor(231 + 107 * 1, 370 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False And _ ; White into number 0
							_ColorCheck(_GetPixelColor(234 + 107 * 1, 370 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 5
						setlog("Not enough Elixir to create Earthquake Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iEarthSpell > 0 Then
							GemClick(329, 354 + $midOffsetY, $iEarthSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iEarthSpell & " EarthQuake Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					If $iTempEarthSpell > 0 then Setlog("Already Brewed " & $iTempEarthSpell & " EarthQuake Spell(s)")
					If $iTempEarthSpell = 0 then Setlog("Already done EarthQuake Spell(s)")
				EndIf
			EndIf

			If $HaSpellComp > 0 Then ; Haste Spells
				Local $iTempHasteSpell = Number(getBarracksTroopQuantity(175 + 107 * 2, 295 + $midOffsetY))
				If $IsFullArmywithHeroesAndSpells = true and $WaitForSpells = True Then ;if spell factory full
					If $iTempHasteSpell = $HaSpellComp Then ; check if replacement spells trained,
						$iHasteSpell = 0
					Else
						$iHasteSpell = $HaSpellComp - $iTempHasteSpell ; add spells to queue to match GUI
						If $debugSetLogSpellBrew = True Then SetLog("$iHasteSpell -= " & (Number($CurHasteSpell - $HaSpellComp)), $COLOR_BLUE)
						$iHasteSpell -= (Number($CurHasteSpell - $HaSpellComp))
						If $debugSetLogSpellBrew = True Then SetLog("$iHasteSpell = " & $iHasteSpell, $COLOR_BLUE)
					EndIf
				Else
					$iHasteSpell = $HaSpellComp - ($CurHasteSpell + $iTempHasteSpell) ; not full, add more spell if needed
				EndIf
				;If $iHasteSpellComp = $CurHasteSpell Then $iHasteSpell = 0
				If $debugsetlogTrain = 1 Then SetLog("Making Haste Spell: " & $iHasteSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iHasteSpell > 0 Then
					If _sleep($iDelayTrain2) Then Return
					If _ColorCheck(_GetPixelColor(231 + 107 * 2, 370 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False And _ ; White into number 0
							_ColorCheck(_GetPixelColor(234 + 107 * 2, 370 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 5
						setlog("Not enough Elixir to create Haste Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iHasteSpell > 0 Then
							GemClick(430, 354 + $midOffsetY, $iHasteSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iHasteSpell & " Haste Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					If $iTempHasteSpell > 0 then Setlog("Already Brewed " & $iTempHasteSpell & " Haste Spell(s)")
					If $iTempHasteSpell = 0 then Setlog("Already done Haste Spell(s)")
				EndIf
			EndIf
			If $SkSpellComp > 0 Then ; Skeleton Spells
				Local $iTempSkeletonSpell = Number(getBarracksTroopQuantity(175 + 107 * 3, 295 + $midOffsetY))
				If $IsFullArmywithHeroesAndSpells = true and $WaitForSpells = True Then ;if spell factory full
					If $iTempSkeletonSpell = $SkSpellComp Then ; check if replacement spells trained,
						$iSkeletonSpell = 0
					Else
						$iSkeletonSpell = $SkSpellComp - $iTempSkeletonSpell ; add spells to queue to match GUI
						If $debugSetLogSpellBrew = True Then SetLog("$iSkeletonSpell -= " & (Number($CurSkeletonSpell - $SkSpellComp)), $COLOR_BLUE)
						$iSkeletonSpell -= (Number($CurSkeletonSpell - $SkSpellComp))
						If $debugSetLogSpellBrew = True Then SetLog("$iSkeletonSpell = " & $iSkeletonSpell, $COLOR_BLUE)
					EndIf
				Else
					$iSkeletonSpell = $SkSpellComp - ($CurSkeletonSpell + $iTempSkeletonSpell) ; not full, add more spell if needed
				EndIf
				;If $iSkeletonSpellComp = $CurSkeletonSpell Then $iSkeletonSpell = 0
				If $debugsetlogTrain = 1 Then SetLog("Making Skeleton Spell: " & $iSkeletonSpell)
				If _sleep($iDelayTrain2) Then Return
				If $iSkeletonSpell > 0 Then
					If _sleep($iDelayTrain2) Then Return
					If _ColorCheck(_GetPixelColor(231 + 107 * 3, 370 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False And _ ; White into number 0
							_ColorCheck(_GetPixelColor(234 + 107 * 3, 370 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 5
						setlog("Not enough Elixir to create Skeleton Spell", $COLOR_RED)
						Return
					ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
						setlog("Spell Factory Full", $COLOR_RED)
						Return
					Else
						If $iSkeletonSpell > 0 Then
							GemClick(540, 354 + $midOffsetY, $iSkeletonSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iSkeletonSpell & " Skeleton Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				Else
					If $iTempSkeletonSpell > 0 then Setlog("Already Brewed " & $iTempSkeletonSpell & " Skeleton Spell(s)")
					If $iTempSkeletonSpell = 0 then Setlog("Already done Skeleton Spell(s)")
				EndIf
			EndIf
		Else
			SetLog("Dark Spell Factory not found...", $COLOR_BLUE)
		EndIf
	EndIf

EndFunc   ;==>BrewSpells

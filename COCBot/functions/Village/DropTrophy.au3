; #FUNCTION# ====================================================================================================================
; Name ..........: DropTrophy
; Description ...: Gets trophy count of village and compares to max trophy input. Will drop a troop and return home with no screenshot or gold wait.
; Syntax ........: DropTrophy()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #666
; Modified ......: Promac (2015-04), KnowJack(2015-08), Hervidero (2016-01), MonkeyHunter (2016-01)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func DropTrophy()
	If $DebugSetlog = 1 Then SetLog("Drop Trophy START", $COLOR_PURPLE)

	$iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1]) ; get OCR to read current Village Trophies
	If $DebugSetlog = 1 Then SetLog("Current Trophy Count: " & $iTrophyCurrent, $COLOR_PURPLE)
	If Number($iTrophyCurrent) <= Number($iTxtMaxTrophy) Then Return ; exit on trophy count to avoid other checks

	; Check if proper troop types avail during last checkarmycamp(), no need to call separately since droptrophy checked often
	Local $bHaveTroops = False
	For $i = 0 To UBound($aDTtroopsToBeUsed, 1) - 1
		If $aDTtroopsToBeUsed[$i][1] > 0 Then
			$bDisableDropTrophy = False
			$bHaveTroops = True
			If $DebugSetlog = 1 Then
				SetLog("Drop Trophy Found " & StringFormat("%3s", $aDTtroopsToBeUsed[$i][1]) & " " & $aDTtroopsToBeUsed[$i][0], $COLOR_PURPLE)
				ContinueLoop ; display all troop counts if debug flag set
			Else
				ExitLoop ; Finding 1 troop type is enough to use trophy drop, stop checking rest when no debug flag
			EndIf
		EndIf
	Next
	; if heroes enabled, check them and reset drop trophy disable
	If $iChkTrophyHeroes = 1 And $iHeroAvailable > 0 Then
		If $DebugSetlog = 1 Then SetLog("Drop Trophy Found Hero BK|AQ|GW: " & BitOR($iHeroAvailable, $HERO_KING) & "|" & BitOR($iHeroAvailable, $HERO_QUEEN) & "|" & BitOR($iHeroAvailable, $HERO_WARDEN), $COLOR_PURPLE)
		$bDisableDropTrophy = False
		$bHaveTroops = True
	EndIf
	If $bDisableDropTrophy = True Or $bHaveTroops = False Then ; troops available?
		Setlog("Drop Trophy temporarily disabled, missing proper troop type", $COLOR_RED)
		If $DebugSetlog = 1 Then SetLog("Drop Trophy END: No troops in $aDTtroopsToBeUsed array", $COLOR_PURPLE)
		Return
	EndIf

	Local $bDropSuccessful
	Local $iCount, $aRandomEdge, $iRandomXY
	Local Const $DTArmyPercent = Round(Int($itxtDTArmyMin) / 100, 2)
	Local $iTxtMaxTrophyNeedCheck = $iTxtMaxTrophy ; set trophy target to max trophy
	Local Const $iWaitTime = 3 ; wait time for base recheck during long drop times in minutes (3 minutes ~5-10 drop attacks)
	Local $iDateCalc, $sWaitToDate
	$sWaitToDate = _DateAdd('n', $iWaitTime, _NowCalc()) ; find delay time for checkbasequick
	If $DebugSetlog = 1 Then SetLog("ChkBaseQuick delay time = " & $sWaitToDate & ", Now = " & _NowCalc() & ", Diff = " & _DateDiff('s', _NowCalc(), $sWaitToDate), $COLOR_PURPLE)

	While Number($iTrophyCurrent) > Number($iTxtMaxTrophyNeedCheck)
		$iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
		SetLog("Trophy Count : " & $iTrophyCurrent, $COLOR_GREEN)
		; Check for enough troops before starting base search to save search costs
		; only 1 giant or hero needed to enable drop trophy to work
		If ($CurCamp < 5) And ($iChkTrophyHeroes = 1 And ($BarbarianKingAvailable Or $ArcherQueenAvailable Or $GrandWardenAvailable)) = False Then
			SetLog("No troops available to use on Drop Trophy", $COLOR_RED)
			ExitLoop ; no troops then cycle again
		EndIf
		
		$iTxtMaxTrophyNeedCheck = $itxtdropTrophy ; already checked above max trophy, so set target to min trophy value
		SetLog("Dropping Trophies to " & $itxtdropTrophy, $COLOR_BLUE)
		If _Sleep($iDelayDropTrophy4) Then ExitLoop
		$bDropSuccessful = True
		ZoomOut()
		PrepareSearch()
		If $OutOfGold = 1 Then Return ; Check flag for enough gold to search
		If $Restart = True Then Return

		If _Sleep($iDelayDropTrophy4) Then ExitLoop
		
		GetResources(False, $DT) ; no log, use $DT matchmode (DropThrophy)
		SetLog("Identification of your troops:", $COLOR_BLUE)
		PrepareAttack($DT) ; ==== Troops: checks for type, slot, and quantity ===
		If $Restart = True Then Return
		
		If $iChkTrophyAtkDead = 1 Then
			$isDeadBase = checkDeadBase()
			; check DE/drill for Zap
			$numDEDrill = 0
			$DEperDrill = 0
			Local $targetTHLvl = $searchTH <> "-" ? Number($searchTH) : $iTownHallLevel ; use own TH lvl if target lvl can't be determined
			Switch Number($targetTHLvl)
				Case 10, 11
					$numDEDrill = 3
				Case 8, 9 
					$numDEDrill = 2
				Case 7
					$numDEDrill = 1
			EndSwitch
			If $numDEDrill <> 0 Then
				$DEperDrill = Round(Number($searchDark) / $numDEDrill)
			EndIf			
			$zapBaseMatch = $isDeadBase And $ichkDBLightSpell = 1 And $CurLightningSpell > 0 And $DEperDrill >= Number($itxtDBLightMinDark)
			
			If $isDeadBase Then
				; check if we have enough troops and resource requirement is met
				If ($CurCamp >= ($TotalCamp * $DTArmyPercent / 100)) And CompareResources($DB) Then							
					SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
					SetLog("Dead Base Found on Drop Trophy!", $COLOR_GREEN, "Lucida Console", 7.5)
					If $ichkDBMeetCollOutside = 1 Then
						If AreCollectorsOutside($iDBMinCollOutsidePercent) Then
							SetLog("Collectors are outside.", $COLOR_GREEN, "Lucida Console", 7.5)
							GreedyAttack()
							ExitLoop ; or Return, Will end function, no troops left to drop Trophies, will need to Train new Troops first
						Else
							SetLog("Collectors are not outside!", $COLOR_RED, "Lucida Console", 7.5)
						EndIf
					Else
						GreedyAttack()
						ExitLoop ; or Return, Will end function, no troops left to drop Trophies, will need to Train new Troops first
					EndIf
				Else
					SetLog("Not enough troops (" & $itxtDTArmyMin & "%) or not enough resources to attack dead base", $COLOR_ORANGE)						
				EndIf
				
				If $zapBaseMatch Then ; collectors not outside but drills can still be zapped					
					SetLog($GetResourcesTXT, $COLOR_GREEN, "Lucida Console", 7.5)
					SetLog("Drills can be zapped!", $COLOR_GREEN, "Lucida Console")	
					If DEDropSmartSpell() = True Then
						ReturnHome($TakeLootSnapShot)
						$ReStart = True  ; Set restart flag after DE zap to return from AttackMain()
						ExitLoop
					Else ; select first troop type for drop trophy
						SelectDropTroop(0)
					EndIf
				EndIf
			Else
				SetLog("Not a Dead Base, Drop Trophy.", $COLOR_BLACK, "Lucida Console", 7.5)
				; select first troop type for drop trophy
				SelectDropTroop(0)
			EndIf
		Else
			; Normal Drop Trophy, no check for Dead Base
			$SearchCount = 0
				GetResources(False, $DT)

				SetLog("Identification of your troops:", $COLOR_BLUE)
				PrepareAttack($DT) ; ==== Troops :checks for type, slot, and quantity ===
				If $Restart = True Then Return

		EndIf

		If _Sleep($iDelayDropTrophy4) Then ExitLoop

		; Drop a Hero or Troop
		If $iChkTrophyHeroes = 1 Then
			$King = -1
			$Queen = -1
			$Warden = -1
			For $i = 0 To UBound($atkTroops) - 1
				If $atkTroops[$i][0] = $eKing Then
					$King = $i
				ElseIf $atkTroops[$i][0] = $eQueen Then
					$Queen = $i
				ElseIf $atkTroops[$i][0] = $eWarden Then
					$Warden = $i
				EndIf
			Next

			Local $corners[4][2] = [[425, 50], [800, 330], [425, 610], [50, 330]]
			Local $iCorner = Random(0, 3, 1)
			If $DebugSetlog = 1 Then Setlog("Hero Loc X:Y= " & $corners[$iCorner][0] & "|" & $corners[$iCorner][1], $COLOR_PURPLE)
			If $King <> -1 Then
				SetLog("Deploying King", $COLOR_BLUE)
				Click(GetXPosOfArmySlot($King, 68), 595 + $bottomOffsetY, 1, 0, "#0177") ; Select King
				If _Sleep($iDelayDropTrophy1) Then ExitLoop
				Click($corners[$iCorner][0], $corners[$iCorner][1], 1, 0, "#0178") ; Drop King
				If _Sleep($iDelayDropTrophy1) Then ExitLoop
				SetTrophyLoss()
				If IsAttackPage() Then SelectDropTroop($King) ; If King was not activated: Boost King before EndBattle to restore some health
				ReturnHome(False, False) ; Return home no screenshot
				If _Sleep($iDelayDropTrophy1) Then ExitLoop
			EndIf
			If $King = -1 And $Queen <> -1 Then
				SetLog("Deploying Queen", $COLOR_BLUE)
				Click(GetXPosOfArmySlot($Queen, 68), 595 + $bottomOffsetY, 1, 0, "#0179") ; Select Queen
				If _Sleep($iDelayDropTrophy1) Then ExitLoop
				Click($corners[$iCorner][0], $corners[$iCorner][1], 1, 0, "#0180") ; Drop Queen
				If _Sleep($iDelayDropTrophy1) Then ExitLoop
				SetTrophyLoss()
				If IsAttackPage() Then SelectDropTroop($Queen) ; If Queen was not activated: Boost Queen before EndBattle to restore some health
				ReturnHome(False, False) ; Return home no screenshot
				If _Sleep($iDelayDropTrophy1) Then ExitLoop
			EndIf
			If $King = -1 And $Queen = -1 And $Warden <> -1 Then
				SetLog("Deploying Warden", $COLOR_BLUE)
				Click(GetXPosOfArmySlot($Warden, 68), 595 + $bottomOffsetY, 1, 0, "#0000") ; Select Warden
				If _Sleep($iDelayDropTrophy1) Then ExitLoop
				Click($corners[$iCorner][0], $corners[$iCorner][1], 1, 0, "#0000") ; Drop Warden
				If _Sleep($iDelayDropTrophy1) Then ExitLoop
				SetTrophyLoss()
				If IsAttackPage() Then SelectDropTroop($Warden) ; If Warden was not activated: Boost Warden before EndBattle to restore some health
				ReturnHome(False, False) ; Return home no screenshot
				If _Sleep($iDelayDropTrophy1) Then ExitLoop
			EndIf
		EndIf
		If ($Queen = -1 And $King = -1 And $Warden = -1) Or $iChkTrophyHeroes = 0 Then
			$aRandomEdge = $Edges[Round(Random(0, 3))]
			$iRandomXY = Round(Random(0, 4))
			If $DebugSetlog = 1 Then Setlog("Troop Loc = " & $iRandomXY & ", X:Y= " & $aRandomEdge[$iRandomXY][0] & "|" & $aRandomEdge[$iRandomXY][1], $COLOR_PURPLE)
			Select
				Case $atkTroops[0][0] = $eBarb
					Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 0, "#0181") ;Drop one troop
					$CurBarb += 1
					$ArmyComp -= 1
					SetLog("Deploying 1 Barbarian", $COLOR_BLUE)
				Case $atkTroops[0][0] = $eArch
					Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 0, "#0182") ;Drop one troop
					$CurArch += 1
					$ArmyComp -= 1
					SetLog("Deploying 1 Archer", $COLOR_BLUE)
				Case $atkTroops[0][0] = $eGiant
					Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 0, "#0183") ;Drop one troop
					$CurGiant += 1
					$ArmyComp -= 5
					SetLog("Deploying 1 Giant", $COLOR_BLUE)
				Case $atkTroops[0][0] = $eWall
					Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 0, "#0184") ;Drop one troop
					$CurWall += 1
					$ArmyComp -= 2
					SetLog("Deploying 1 WallBreaker", $COLOR_BLUE)
				Case $atkTroops[0][0] = $eGobl
					Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 0, "#0185") ;Drop one troop
					$CurGobl += 1
					$ArmyComp -= 2
					SetLog("Deploying 1 Goblin", $COLOR_BLUE)
				Case $atkTroops[0][0] = $eMini
					Click($aRandomEdge[$iRandomXY][0], $aRandomEdge[$iRandomXY][1], 1, 0, "#0186") ;Drop one troop
					$CurMini += 1
					$ArmyComp -= 2
					SetLog("Deploying 1 Minion", $COLOR_BLUE)
				Case Else
					SetLog("You don�t have Tier 1/2 Troops, Stop dropping trophies.", $COLOR_BLUE) ; preventing of deploying Tier 2/3 expensive troops
					$bDisableDropTrophy = True
					$bDropSuccessful = False
					ExitLoop
			EndSelect
			If $bDropSuccessful Then SetTrophyLoss()
			If _Sleep($iDelayDropTrophy1) Then ExitLoop
			ReturnHome(False, False) ;Return home no screenshot
			If _Sleep($iDelayDropTrophy1) Then ExitLoop
		EndIf
		$iDateCalc = _DateDiff('s', _NowCalc(), $sWaitToDate)
		If $DebugSetlog = 1 Then SetLog("ChkBaseQuick delay = " & $sWaitToDate & ", Now = " & _NowCalc() & ", Diff = " & $iDateCalc, $COLOR_PURPLE)
		If $iDateCalc <= 0 Then ; check length of time in drop trophy
			Setlog(" Checking base during long drop cycle", $COLOR_BLUE)
			CheckBaseQuick() ; check base during long drop times
			$sWaitToDate = _DateAdd('n', $iWaitTime, _NowCalc()) ; create new delay date/time
			If $DebugSetlog = 1 Then SetLog("ChkBaseQuick new delay time= " & $sWaitToDate, $COLOR_PURPLE)
		EndIf
	WEnd
	SetLog("Trophy Drop Complete", $COLOR_BLUE)
EndFunc   ;==>DropTrophy

Func GreedyAttack()	
	$SearchCount = 0
	$iMatchMode = $DB
	If $debugDeadBaseImage = 1 Then
		_CaptureRegion()
		_GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\Zombies\" & $Date & " at " & $Time & ".png")
		_WinAPI_DeleteObject($hBitmap)
	EndIf
	
	Attack()
	ReturnHome($TakeLootSnapShot)
	$Is_ClientSyncError = False ; reset OOS flag to get new new army
	$Is_SearchLimit = False ; reset search limit flag to get new new army
	$ReStart = True  ; Set restart flag after dead base attack to ensure troops are trained
	If $DebugSetlog = 1 Then SetLog("Drop Trophy END: Dead Base was attacked, reset army and return to Village.", $COLOR_PURPLE)
EndFunc

Func SetTrophyLoss()
	Local $sTrophyLoss
	If _ColorCheck(_GetPixelColor(30, 142, True), Hex(0x07010D, 6), 10) Then ; check if the village have a Dark Elixir Storage
		$sTrophyLoss = getTrophyLossAttackScreen(48, 214)
	Else
		$sTrophyLoss = getTrophyLossAttackScreen(48, 184)
	EndIf
	Setlog(" Trophy loss = " & $sTrophyLoss, $COLOR_PURPLE) ; record trophy loss
	$iDroppedTrophyCount -= Number($sTrophyLoss)
	UpdateStats()
EndFunc   ;==>SetTrophyLoss
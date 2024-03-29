; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Bot
; Description ...: Uses the ColorCheck until the screen is clear from Clouds to Get Resources values.
; Author ........: HungLe (2015)
; Modified ......: ProMac (2015), Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $GetResourcesTXT

Func GetResources($bLog = True, $pMatchMode = -1) ;Reads resources
	If _Sleep($iDelayGetResources1) Then Return
	$searchGold = ""
	$searchElixir = ""
	$searchDark = ""
	$searchTrophy = ""
	Local $iResult = 0
	Local $i = 0

	While _CheckPixel($aNoCloudsAttack, $bCapturePixel) = False ; wait for clouds to be gone
		If _Sleep($iDelayGetResources1) Then Return
		$i += 1
		If $i >= 180 Or isProblemAffect(True) Then ; Wait 45 sec max then restart bot and CoC
			$Is_ClientSyncError = True
			checkMainScreen()
			If $Restart Then
				$iNbrOfOoS += 1
				UpdateStats()
				SetLog("Disconnected At Search Clouds", $COLOR_RED)
				PushMsg("OoSResources")
			Else
				SetLog("Stuck At Search Clouds, Restarting CoC and Bot...", $COLOR_RED)
				$Is_ClientSyncError = False ; disable fast OOS restart if not simple error and restarting CoC
				CloseCoC(True)
			EndIf
			Return
		EndIf
	WEnd

	$i = 0
	While (getGoldVillageSearch(48, 69) = "") Or (getElixirVillageSearch(48, 69 + 29) = "") ; Wait 7.5 seconds max to read resources
		$i += 1
		If _Sleep($iDelayGetResources3) Then Return
		If $i >= 50 Or isProblemAffect(True) Then ExitLoop
	WEnd

	If _Sleep($iDelayRespond) Then Return
	$searchGold = getGoldVillageSearch(48, 69)
	If _Sleep($iDelayRespond) Then Return
	$searchElixir = getElixirVillageSearch(48, 69 + 29)
	If _Sleep($iDelayRespond) Then Return
	If _ColorCheck(_GetPixelColor(30, 142, True), Hex(0x07010D, 6), 10) Then ; check if the village have a Dark Elixir Storage
		$searchDark = getDarkElixirVillageSearch(48, 69 + 57)
		$searchTrophy = getTrophyVillageSearch(48, 69 + 99)
	Else
		$searchDark = "N/A"
		$searchTrophy = getTrophyVillageSearch(48, 69 + 69)
	EndIf

	If $searchGold = $searchGold2 And $searchElixir = $searchElixir2 Then $iStuck += 1
	If $searchGold <> $searchGold2 Or $searchElixir <> $searchElixir2 Then $iStuck = 0
	$searchGold2 = $searchGold
	$searchElixir2 = $searchElixir

	If $iStuck >= 5 Or isProblemAffect(True) Then
		$iStuck = 0
		$Is_ClientSyncError = True
		checkMainScreen()
		If $Restart Then
			$iNbrOfOoS += 1
			UpdateStats()
			SetLog("Connection Lost While Searching", $COLOR_RED)
			PushMsg("OoSResources")
		Else
			SetLog("Attack Is Disabled Or Slow connection issues, Restarting CoC and Bot...", $COLOR_RED)
			$Is_ClientSyncError = False ; disable fast OOS restart if not simple error and restarting CoC
			CloseCoC(True)
		EndIf
		Return
	EndIf

	Local $THString = ""
	$searchTH = "-"
	$THx = 0
	$THy = 0

	If $pMatchMode <> $DT Or $iChkTrophyAtkDead = 1 Then ; skip TH search if $pMatchmode = $DT (DropThrophy)
		If $OptTrophyMode = 1 Or ($OptBullyMode = 1 And $SearchCount >= $ATBullyMode) Or ($iCmbSearchMode <> $LB And ($iChkMeetTH[$DB] = 1 Or $iChkMeetTHO[$DB] = 1)) Or ($iCmbSearchMode <> $DB And ($iChkMeetTH[$LB] = 1 Or $iChkMeetTHO[$LB] = 1)) Then
			; CODE TO DETECT TOWNHALL ONLY WITH AUTOIT IMAGESEARCH
			$searchTH = checkTownHallADV2()

			If SearchTownHallLoc() = False And $searchTH <> "-" Then
				$THLoc = "In"
			ElseIf $searchTH <> "-" Then
				$THLoc = "Out"
			Else
				$THLoc = $searchTH
				$THx = 0
				$THy = 0
			EndIf
			;EndIf
			$THString = " [TH]:" & StringFormat("%2s", $searchTH) & ", " & $THLoc
		EndIf
	EndIf

	$SearchCount += 1 ; Counter for number of searches
	If $bLog = True Then SetLog(StringFormat("%3s", $SearchCount) & "> [G]:" & StringFormat("%7s", $searchGold) & " [E]:" & StringFormat("%7s", $searchElixir) & " [D]:" & StringFormat("%5s", $searchDark) & " [T]:" & StringFormat("%2s", $searchTrophy) & $THString, $COLOR_BLACK, "Lucida Console", 7.5)
	$GetResourcesTXT = StringFormat("%3s", $SearchCount) & "> [G]:" & StringFormat("%7s", $searchGold) & " [E]:" & StringFormat("%7s", $searchElixir) & " [D]:" & StringFormat("%5s", $searchDark) & " [T]:" & StringFormat("%2s", $searchTrophy) & $THString
EndFunc   ;==>GetResources
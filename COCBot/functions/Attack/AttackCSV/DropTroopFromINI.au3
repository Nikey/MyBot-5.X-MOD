; #FUNCTION# ====================================================================================================================
; Name ..........: DropTroopFromINI
; Description ...:
; Syntax ........: DropTroopFromINI($vectors, $indexStart, $indexEnd, $qtaMin, $qtaMax, $troopName, $delayPointmin,
;                  $delayPointmax, $delayDropMin, $delayDropMax, $sleepafterMin, $sleepAfterMax[, $debug = False])
; Parameters ....: $vectors             -
;                  $indexStart          -
;                  $indexEnd            -
;                  $qtaMin              -
;                  $qtaMax              -
;                  $troopName           -
;                  $delayPointmin       -
;                  $delayPointmax       -
;                  $delayDropMin        -
;                  $delayDropMax        -
;                  $sleepafterMin       -
;                  $sleepAfterMax       -
;                  $debug               - [optional] Default is False.
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func DropTroopFromINI($vectorString, $indexStart, $indexEnd, $qtaMin, $qtaMax, $troopName, $delayPointmin, $delayPointmax, $delayDropMin, $delayDropMax, $sleepafterMin, $sleepAfterMax, $debug = False)
	debugAttackCSV("drop using vectors " & $vectorString & " index " & $indexStart & "-" & $indexEnd & " and using " & $qtaMin & "-" & $qtaMax & " of " & $troopName)
	debugAttackCSV(" - delay for multiple troops in same point: " & $delayPointmin & "-" & $delayPointmax)
	debugAttackCSV(" - delay when  change deploy point : " & $delayDropMin & "-" & $delayDropMax)
	debugAttackCSV(" - delay after drop all troops : " & $sleepafterMin & "-" & $sleepAfterMax)

	; initialize vector arrays
	Local $vectorLetters = StringSplit($vectorString, "-")
	Local $vectorCount = $vectorLetters[0]
	Local $vectors[$vectorCount]
	For $i = 0 To $vectorCount - 1
		$vectors[$i] = Execute("$ATTACKVECTOR_" & $vectorLetters[$i + 1])
	Next

	; Qty to drop
	If $qtaMin <> $qtaMax Then
		Local $qty = Random($qtaMin, $qtaMax, 1)
	Else
		Local $qty = $qtaMin
	EndIf
	debugAttackCSV(">> qty to deploy: " & $qty)

	; number of troop to drop in one point...
	Local $qtyxpoint = Int($qty / ($indexEnd - $indexStart + 1))
	Local $extraunit = Mod($qty, ($indexEnd - $indexStart + 1))
	debugAttackCSV(">> qty x point: " & $qtyxpoint)
	debugAttackCSV(">> qty extra: " & $extraunit)
	; search slot where is the troop...
	Local $troopPosition = -1
	For $i = 0 To UBound($atkTroops) - 1
		If $atkTroops[$i][0] = Eval("e" & $troopName) Then
			$troopPosition = $i
		EndIf
	Next

	Local $usespell = True
	Switch Eval("e" & $troopName)
		Case $eLSpell
			If $ichkLightSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eHSpell
			If $ichkHealSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eRSpell
			If $ichkRageSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eJSpell
			If $ichkJumpSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eFSpell
			If $ichkFreezeSpell[$iMatchMode] = 0 Then $usespell = False
		Case $ePSpell
			If $ichkPoisonSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eESpell
			If $ichkEarthquakeSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eHaSpell
			If $ichkHasteSpell[$iMatchMode] = 0 Then $usespell = False
	EndSwitch

	If $troopPosition = -1 Or $usespell = False Then
		If $usespell = True Then
			Setlog("No troop found in your attack troops list")
			debugAttackCSV("No troop found in your attack troops list")
		Else
			If $DebugSetLog = 1 Then SetLog("discard use spell", $COLOR_PURPLE)
		EndIf

	Else
		Local $SuspendMode = SuspendAndroid()
		SelectDropTroop($troopPosition) ; select the troop...
		KeepClicks()
		Local $troopEnum = Eval("e" & $troopName)
		Local $qty2 = $qtyxpoint

		; delay time between 2 drops in same point
		If $delayPointmin <> $delayPointmax Then
			Local $delayPoint = Random($delayPointmin, $delayPointmax, 1)
		Else
			Local $delayPoint = $delayPointmin
		EndIf

		Local $delayDrop		
		; drop
		Local $hTimer = TimerInit()
		For $i = $indexStart To $indexEnd
			For $j = 0 To $vectorCount - 1
				If $i <= UBound($vectors[$j]) Then
					$pixel = ($vectors[$j])[$i - 1]
					
					If $i < $indexStart + $extraunit Then $qty2 += 1

					Switch $troopEnum
						Case $eBarb To $eLava ; drop normal troops
							If $debug = True Then
								Setlog("Click( " & $pixel[0] & ", " & $pixel[1] & " , " & $qty2 & ", " & $delayPoint & ",#0666)")
							Else
								PureClick($pixel[0], $pixel[1], $qty2, $delayPoint, "#0666")
							EndIf
						Case $eKing
							If $debug = True Then
								Setlog("dropHeroes(" & $pixel[0] & ", " & $pixel[1] & ", " & $King & ", -1, -1) ")
							Else
								dropHeroes($pixel[0], $pixel[1], $King, -1, -1)
							EndIf
						Case $eQueen
							If $debug = True Then
								Setlog("dropHeroes(" & $pixel[0] & ", " & $pixel[1] & ", -1, " & $Queen & ", -1) ")
							Else
								dropHeroes($pixel[0], $pixel[1], -1, $Queen, -1)
							EndIf
						Case $eWarden
							If $debug = True Then
								Setlog("dropHeroes(" & $pixel[0] & ", " & $pixel[1] & ", -1, -1, " & $Warden & ") ")
							Else
								dropHeroes($pixel[0], $pixel[1], -1, -1, $Warden)
							EndIf
						Case $eCastle
							If $debug = True Then
								Setlog("dropCC(" & $pixel[0] & ", " & $pixel[1] & ", " & $CC & ")")
							Else
								dropCC($pixel[0], $pixel[1], $CC)
							EndIf
						Case $eLSpell To $eHaSpell
							If $debug = True Then
								Setlog("Drop Spell Click( " & $pixel[0] & ", " & $pixel[1] & " , " & $qty2 & ", " & $delayPoint & ",#0666)")
							Else
								Click($pixel[0], $pixel[1], $qty2, $delayPoint, "#0667")
							EndIf
						Case Else
							Setlog("Error parsing line")
					EndSwitch
					debugAttackCSV($troopName & " qty " & $qty2 & " in (" & $pixel[0] & "," & $pixel[1] & ") delay " & $delayPoint)
				EndIf
			Next
			If $i <> $indexEnd Then
				; delay time between 2 drops in different point
				If $delayDropMin <> $delayDropMax Then
					$delayDrop = Random($delayDropMin, $delayDropMax, 1)
				Else
					$delayDrop = $delayDropMin
				EndIf
				debugAttackCSV(">> delay change drop point: " & $delayDrop)
				If $delayDrop <> 0 Then
				    SuspendAndroid($SuspendMode)
					ReleaseClicks()
					If _Sleep($delayDrop) Then Return
					KeepClicks()
				EndIf
			EndIf
		Next

	    ReleaseClicks()
	    SuspendAndroid($SuspendMode)

		; sleep time after deploy all troops
		If $sleepafterMin <> $sleepAfterMax Then
			Local $sleepafter = Random($sleepafterMin, $sleepAfterMax, 1)
		Else
			Local $sleepafter = $sleepafterMin
		EndIf
		debugAttackCSV(">> delay after drop all troops: " & $sleepafter)
		If $sleepafter <> 0 Then
			If _Sleep($sleepafter) Then Return
		EndIf
	EndIf
EndFunc   ;==>DropTroopFromINI
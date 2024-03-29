; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCapacity
; Description ...: Obtains current and total capacity of troops from Training - Army Overview window
; Syntax ........: getArmyCapacity([$bOpenArmyWindow = False[, $bCloseArmyWindow = False]])
; Parameters ....: $bOpenArmyWindow     - [optional] a boolean value. Default is False.
;                  $bCloseArmyWindow    - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: Separated from checkArmyCamp()
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyCapacity($bOpenArmyWindow = False, $bCloseArmyWindow = False)
	If $debugSetlog = 1 Then Setlog("Begin getArmyCapacity", $COLOR_PURPLE)

	If $bOpenArmyWindow = False And IsTrainPage() = False Then ; check for train page
		SetError(1)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow = True Then
		If openArmyOverview() = False Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($iDelaycheckArmyCamp5) Then Return
	EndIf

	Local $aGetArmySize[3] = ["", "", ""]
	Local $sArmyInfo = ""
	Local $sInputbox, $iTried, $iHoldCamp
	Local $tmpTotalCamp = 0
	Local $tmpCurCamp = 0

	; Verify troop current and full capacity
	$iTried = 0 ; reset loop safety exit counter
	$sArmyInfo = getArmyCampCap(192, 144 + $midOffsetY) ; OCR read army trained and total
	If $debugSetlog = 1 Then Setlog("OCR $sArmyInfo = " & $sArmyInfo, $COLOR_PURPLE)

	While $iTried < 100 ; 30 - 40 sec
		$iTried += 1
		If _Sleep($iDelaycheckArmyCamp5) Then Return ; Wait 250ms before reading again
		$sArmyInfo = getArmyCampCap(192, 144 + $midOffsetY) ; OCR read army trained and total
		If $debugSetlog = 1 Then Setlog("OCR $sArmyInfo = " & $sArmyInfo, $COLOR_PURPLE)
		If StringInStr($sArmyInfo, "#", 0, 1) < 2 Then ContinueLoop ; In case the CC donations recieved msg are blocking, need to keep checking numbers till valid

		$aGetArmySize = StringSplit($sArmyInfo, "#") ; split the trained troop number from the total troop number
		If IsArray($aGetArmySize) Then
			If $aGetArmySize[0] > 1 Then ; check if the OCR was valid and returned both values
				If Number($aGetArmySize[2]) < 10 Or Mod(Number($aGetArmySize[2]), 5) <> 0 Then ; check to see if camp size is multiple of 5, or try to read again
					If $debugSetlog = 1 Then Setlog("OCR value is not valid camp size", $COLOR_PURPLE)
					ContinueLoop
				EndIf
				$tmpCurCamp = Number($aGetArmySize[1])
				If $debugSetlog = 1 Then Setlog("$tmpCurCamp = " & $tmpCurCamp, $COLOR_PURPLE)
				$tmpTotalCamp = Number($aGetArmySize[2])
				If $debugSetlog = 1 Then Setlog("$TotalCamp = " & $TotalCamp & ", Camp OCR = " & $aGetArmySize[2], $COLOR_PURPLE)
				If $iHoldCamp = $tmpTotalCamp Then ExitLoop ; check to make sure the OCR read value is same in 2 reads before exit
				$iHoldCamp = $tmpTotalCamp ; Store last OCR read value
			EndIf
		EndIf
	WEnd

	If $iTried <= 99 Then
		$CurCamp = $tmpCurCamp
		If $TotalCamp = 0 Then $TotalCamp = $tmpTotalCamp
		If $debugSetlog = 1 Then Setlog("Current Camp = " & $CurCamp & ", Total Camp = " & $TotalCamp, $COLOR_PURPLE)
	Else
		Setlog("Army size read error, Troop numbers may not train correctly", $COLOR_RED) ; log if there is read error
		$CurCamp = 0
		CheckOverviewFullArmy()
	EndIf

	If $TotalCamp = 0 Or ($TotalCamp <> $tmpTotalCamp) Then ; if Total camp size is still not set or value not same as read use forced value
		If $ichkTotalCampForced = 0 Then ; check if forced camp size set in expert tab
			$sInputbox = InputBox("Question", "Enter your total Army Camp capacity", "200", "", Default, Default, Default, Default, 240, $frmbot)
			$TotalCamp = Number($sInputbox)
			$iValueTotalCampForced = $TotalCamp
			$ichkTotalCampForced = 1
			Setlog("Army Camp User input = " & $TotalCamp, $COLOR_RED) ; log if there is read error AND we ask the user to tell us.
		Else
			$TotalCamp = Number($iValueTotalCampForced)
		EndIf
	EndIf
	If _Sleep($iDelaycheckArmyCamp4) Then Return

	If $TotalCamp > 0 Then
		SetLog("Total Army Camp capacity: " & $CurCamp & "/" & $TotalCamp & " (" & Int($CurCamp / $TotalCamp * 100) & "%)")
	Else
		SetLog("Total Army Camp capacity: " & $CurCamp & "/" & $TotalCamp)
	EndIf

	If ($CurCamp >= ($TotalCamp * $fulltroop / 100)) And $CommandStop = -1 Then
		$fullArmy = True
	EndIf

	If ($CurCamp + 1) = $TotalCamp Then
		$fullArmy = True
	EndIf

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf
EndFunc   ;==>getArmyCapacity
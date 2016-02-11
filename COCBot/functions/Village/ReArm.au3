; #FUNCTION# ====================================================================================================================
; Name ..........: ReArm.au3
; Description ...: Rearms and reloads traps that have been triggered.
; Syntax ........: ReArm()
; Parameters ....:
; Return values .:
; Authors .......: Saviart, Hervidero
; Modified ......: Hervidero, ProMac, KnowJack (May/July-2015) added check for loot available to prevent spending gems. changed screen capture to pixel capture.
;                  Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ReArm()
	If $ichkTrap = 0 Then Return ; If re-arm is not enable in GUI return and skip this code
	If $ineedRearm = False Then Return ; If re-arm is not needed skip this code
	Local $y = 562 + $bottomOffsetY  ; Add 60 y pixel for 860x780 window

	SetLog("Checking if Village needs Rearming..", $COLOR_BLUE)

	If isInsideDiamond($TownHallPos) = False Then
		LocateTownHall(True) ; get only new TH location during rearm, due BotFirstDetect now must have TH or there is an error.
		SaveConfig()
		If _Sleep($iDelayReArm1) Then Return
	EndIf

	ClickP($aAway, 1, 0, "#0224") ; Click away
	If _Sleep($iDelayReArm2) Then Return
	If IsMainPage() Then Click($TownHallPos[0], $TownHallPos[1] + 5, 1, 0, "#0225")
	If _Sleep($iDelayReArm3) Then Return

	;Traps
	Local $offColors[3][3] = [[0x080d0a, 30, 26], [0xF6EF57, 70,5], [0xf5f6f2, 79, 0]] ; 2nd pixel brown wrench, 3rd pixel gold, 4th pixel edge of button
	Global $RearmPixel = _MultiPixelSearch2(340, $y, 575, $y + 58, 1, 1, Hex(0xf5f7f2, 6), $offColors, 30) ; first gray/white pixel of button
	If IsArray($RearmPixel) Then
		Click($RearmPixel[0] + 20, $RearmPixel[1] + 20, 1, 0, "#0326") ; Click RearmButton
		If _Sleep($iDelayReArm4) Then Return
		Click(515, 400, 1, 0, "#0226")
		If _Sleep($iDelayReArm4) Then Return
		If isGemOpen(True) = True Then
			Setlog("Not enough loot to rearm traps.....", $COLOR_RED)
			Click(585, 252, 1, 0, "#0227") ; Click close gem window "X"
			If _Sleep($iDelayReArm5) Then Return
		Else
			SetLog("Rearmed Trap(s)", $COLOR_GREEN)
			If _Sleep($iDelayReArm5) Then Return
		EndIf
	EndIf

	If Number($iTownHallLevel) > 8 Then
		;Xbow
		Local $offColors[3][3] = [[0xb44bdc, 50, 17], [0xE955E0, 70, 7], [0xF4F6F2, 79, 0]]; xbow, elixir, edge
		Local $XbowPixel = _MultiPixelSearch2(380, $y, 625, $y + 38, 1, 1, Hex(0xF3F5F1, 6), $offColors, 30)
		If IsArray($XbowPixel) Then
			Click($XbowPixel[0] + 20, $XbowPixel[1] + 20, 1, 0, "#0228") ; Click RearmButton
			If _Sleep($iDelayReArm4) Then Return
			Click(515, 400, 1, 0, "#0229")
			If _Sleep($iDelayReArm4) Then Return
			If isGemOpen(True) = True Then
				Setlog(" Not enough Elixir to rearm x-bow.....", $COLOR_RED)
				Click(585, 252, 1, 0, "#0230") ; Click close gem window "X"
				If _Sleep($iDelayReArm5) Then Return
			Else
				SetLog("Reloaded Xbow(s)", $COLOR_GREEN)
				If _Sleep($iDelayReArm5) Then Return
			EndIf
		EndIf

	EndIf

	If Number($iTownHallLevel) > 9 Then
		;Inferno
		Local $offColors[3][3] = [[0x0e0e0c, 16, 21], [0x000000, 67, 7], [0xF3F5F1, 79, 0]]; inferno, dark, edge
		Global $InfernoPixel = _MultiPixelSearch2(475, $y, 675, $y + 38, 1, 1, Hex(0xF3F5F1, 6), $offColors, 30)
		If IsArray($InfernoPixel) Then
			Click($InfernoPixel[0] + 20, $InfernoPixel[1] + 20, 1, 0, "#0231") ; Click InfernoButton
			If _Sleep($iDelayReArm4) Then Return
			Click(515, 400, 1, 0, "#0232")
			If _Sleep($iDelayReArm4) Then Return
			If isGemOpen(True) = True Then
				Setlog("Not enough Dark Elixir to rearm Inferno .....", $COLOR_RED)
				Click(585, 252, 1, 0, "#0233") ; Click close gem window "X"
				If _Sleep($iDelayReArm5) Then Return
			Else
				SetLog("Reloaded Inferno(s)", $COLOR_GREEN)
				If _Sleep($iDelayReArm5) Then Return
			EndIf
		EndIf
	EndIf

	ClickP($aAway, 1, 0, "#0234") ; Click away
	$ineedRearm = False
	If _Sleep($iDelayReArm5) Then Return
	checkMainScreen(False) ; check for screen errors while running function
EndFunc   ;==>ReArm
; #FUNCTION# ====================================================================================================================
; Name ..........: GetLocationMine
; Description ...:
; Syntax ........: GetLocationMine()
; Parameters ....:
; Return values .: String with locations
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetLocationMine()
	If $iDetectedImageType = 0 Then
		Local $result = DllCall($hFuncLib, "str", "getLocationMineExtractor", "ptr", $hBitmapFirst)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationMine: " & $result[0] ,$COLOR_TEAL)
	Else
		Local $result = DllCall($hFuncLib, "str", "getLocationSnowMineExtractor", "ptr", $hBitmapFirst)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationSnowMine: " & $result[0] ,$COLOR_TEAL)
	EndIf
	; filter out false positive results outside of village area
	Local $found = GetListPixel($result[0])
	For $i = 0 To Ubound($found) - 1
		If Not(isInsideDiamond($found[$i])) Then 
			_ArrayDelete($found, $i)
			$i -= 1
		EndIf	
		If $i = (Ubound($found) - 1) Then ExitLoop
	Next
	Return $found
EndFunc   ;==>GetLocationMine

Func GetLocationMineImgLocV6()
	Global $goldmineImages
	_CaptureRegion()
	Local $sendHBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
	If $iDetectedImageType = 0 Then ; LOAD NORMAL goldmine image
		Local $loadimage
		Local $useimages = "*NORM*.png"
		; assign goldmineImages an empty array with goldmineimagesx[0]=0
		Assign("goldmineImages" , StringSplit("", ""))
		; put in a temp array the list of files matching condition "*T*.bmp or *NORM*.bmp"
		$loadimage = _FileListToArrayRec(@ScriptDir & "\images\GoldMine\" , $useimages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		; assign value at goldmineImages0 if $x it's not empty
		If UBound($loadimage) Then Assign("goldmineImages" , $loadimage)
	Else ; LOAD SNOW goldmine image		
		Local $loadimage
		Local $useimages = "*SNOW*.png"
		; assign goldmineImages an empty array with goldmineimagesx[0]=0
		Assign("goldmineImages" , StringSplit("", ""))
		; put in a temp array the list of files matching condition "*T*.bmp or *NORM*.bmp"
		$loadimage = _FileListToArrayRec(@ScriptDir & "\images\Goldmine\" , $useimages, $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
		; assign value at goldmineImages0 if $x it's not empty
		If UBound($loadimage) Then Assign("goldmineImages" , $loadimage)
	EndIf
	Local $igoldLocation[0]
	If $goldmineImages[0] > 0  Then
		For $nn = 1 To $goldmineImages[0]
			Local $FFile = @ScriptDir & "\images\Goldmine\"  & $goldmineImages[$nn]
			Local $goldTolerance = StringSplit ($goldmineImages[$nn] , "T")
			Local $Tolerance = $goldTolerance[2]
			Local $res = DllCall($LibDir & "\ImgLocV6.dll", "str", "SearchTile", "handle", $sendHBitmap, "str", $FFile, "float", $Tolerance, "str", $DefaultCocSearchArea, "str", $DefaultCocDiamond)
			$goldLocation = StringSplit($res[0], "|")
			If $goldLocation[1] > 0 Then
				Local $tempgoldLocation[$goldLocation[1]]
				Local $yy = 0
				For $zz = 2 to (UBound($goldLocation) - 2) Step + 2
					Local $itempgoldLocation = [$goldLocation[$zz] , $goldLocation[$zz + 1]]
					$tempgoldLocation[$yy] = $itempgoldLocation
					$yy += 1
				Next
				_ArrayAdd($igoldLocation, $tempgoldLocation)
			EndIf
		Next
	EndIf
	Return $igoldLocation
EndFunc   ;==>GetLocationMineImgLocV6

Func GetLocationElixir()
	If $iDetectedImageType = 0 Then
		Local $result = DllCall($hFuncLib, "str", "getLocationElixirExtractor", "ptr", $hBitmapFirst)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationElixir: " & $result[0] ,$COLOR_TEAL)
	Else
		Local $result = DllCall($hFuncLib, "str", "getLocationSnowElixirExtractor", "ptr", $hBitmapFirst)
		If $debugBuildingPos = 1 Then Setlog("#*# GetLocationSnowElixir: " & $result[0] ,$COLOR_TEAL)
	EndIf
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationElixir

Func GetLocationDarkElixir()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirExtractor", "ptr", $hBitmapFirst)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixir: " & $result[0] ,$COLOR_TEAL)
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationDarkElixir

Func GetLocationTownHall()
	Local $result = DllCall($hFuncLib, "str", "getLocationTownHall", "ptr", $hBitmapFirst)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationTownHall: " & $result[0] ,$COLOR_TEAL)
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationTownHall

Func GetLocationDarkElixirStorageWithLevel()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirStorageWithLevel", "ptr", $hBitmapFirst)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixirStorageWithLevel: " & $result[0] ,$COLOR_TEAL)
	Return $result[0]
EndFunc   ;==>GetLocationDarkElixirStorage

Func GetLocationDarkElixirStorage()
	Local $result = DllCall($hFuncLib, "str", "getLocationDarkElixirStorage", "ptr", $hBitmapFirst)
	If $debugBuildingPos = 1 Then Setlog("#*# GetLocationDarkElixirStorage: " & $result[0] ,$COLOR_TEAL)
	Return GetListPixel($result[0])
EndFunc   ;==>GetLocationDarkElixirStorage

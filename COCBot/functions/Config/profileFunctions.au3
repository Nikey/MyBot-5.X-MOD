; #FUNCTION# ====================================================================================================================
; Name ..........: profileFunctions.au3
; Description ...: Functions for the new profile system
; Author ........: LunaEclipse(February, 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; ===============================================================================================================================

Global $profileString = "" ; used for profile dropdown combo

Func setupProfileComboBox()
	; Array to store Profile names to add to ComboBox
	Local $aProfiles = _FileListToArray($sProfilePath, "*", $FLTA_FOLDERS)
	If @error Then
		; No folders for profiles so lets set the combo box to a generic entry
		$profileString = "<No Profiles>"
	Else
		; Lets create a new array without the first entry which is a count for populating the combo box
		Local $aProfileList[$aProfiles[0]]
		For $i = 1 to $aProfiles[0]
			$aProfileList[$i - 1] = $aProfiles[$i]
		Next

		; Convert the array into a string
		$profileString = _ArrayToString($aProfileList, "|")
	EndIF

	; Clear the combo box current data in case profiles were deleted
	GUICtrlSetData($cmbProfile, "", "")
	GUICtrlSetData($cmbGoldMaxProfile, "", "")
	GUICtrlSetData($cmbGoldMinProfile, "", "")
	GUICtrlSetData($cmbElixirMaxProfile, "", "")
	GUICtrlSetData($cmbElixirMinProfile, "", "")
	GUICtrlSetData($cmbDEMaxProfile, "", "")
	GUICtrlSetData($cmbDEMinProfile, "", "")
	GUICtrlSetData($cmbTrophyMaxProfile, "", "")
	GUICtrlSetData($cmbTrophyMinProfile, "", "")
	; Set the new data of available profiles
	GUICtrlSetData($cmbProfile, $profileString, "<No Profiles>")
	GUICtrlSetData($cmbGoldMaxProfile, $profileString, "<No Profiles>")
	GUICtrlSetData($cmbGoldMinProfile, $profileString, "<No Profiles>")
	GUICtrlSetData($cmbElixirMaxProfile, $profileString, "<No Profiles>")
	GUICtrlSetData($cmbElixirMinProfile, $profileString, "<No Profiles>")
	GUICtrlSetData($cmbDEMaxProfile, $profileString, "<No Profiles>")
	GUICtrlSetData($cmbDEMinProfile, $profileString, "<No Profiles>")
	GUICtrlSetData($cmbTrophyMaxProfile, $profileString, "<No Profiles>")
	GUICtrlSetData($cmbTrophyMinProfile, $profileString, "<No Profiles>")
EndFunc   ;==>setupProfileComboBox

Func deleteProfile()
	Local $deletePath = $sProfilePath & "\" & GUICtrlRead($cmbProfile)
	If FileExists($deletePath) Then
		; Close the logs to ensure all files can be deleted.
		FileClose($hLogFileHandle)
		FileClose($hAttackLogFileHandle)

		; Remove the directory and all files and sub folders.
		DirRemove($deletePath, $DIR_REMOVE)
	EndIf
EndFunc   ;==>deleteProfile

Func createProfile()
	; create the profile directory if it doesn't already exist.
	DirCreate($sProfilePath & "\" & $sCurrProfile)

	; If the Profiles file does not exist create it.
	If Not FileExists($sProfilePath & "\profile.ini") Then
		Local $hFile = FileOpen($sProfilePath & "\profile.ini", BitOR($FO_APPEND, $FO_CREATEPATH))
		FileWriteLine($hFile, "[general]")
		FileClose($hFile)
	EndIf

	; Set the current profile as the default profile.
	IniWrite($sProfilePath & "\profile.ini", "general", "defaultprofile", $sCurrProfile)
	; Store the location of the profile's config.ini file
	$config = $sProfilePath & "\" & $sCurrProfile & "\config.ini"
	; Store the other profile files
	$building = $sProfilePath & "\" & $sCurrProfile & "\building.ini"
	$dirLogs = $sProfilePath & "\" & $sCurrProfile & "\Logs\"
	$dirLoots = $sProfilePath & "\" & $sCurrProfile & "\Loots\"
	$dirStats = $sProfilePath & "\" & $sCurrProfile & "\Stats\"
	$dirTemp = $sProfilePath & "\" & $sCurrProfile & "\Temp\"
	$dirTempDebug = $sProfilePath & "\" & $sCurrProfile & "\Temp\Debug\"
	; Create the profiles sub-folders
	DirCreate($dirLogs)
	DirCreate($dirLoots)
	DirCreate($dirStats)
	DirCreate($dirTemp)
	DirCreate($dirTempDebug)
EndFunc   ;==>createProfile

Func setupProfile()
	If GUICtrlRead($cmbProfile) = "<No Profiles>" Then
		; Set profile name to the text box value if no profiles are found.
		$sCurrProfile = StringRegExpReplace(GUICtrlRead($txtVillageName), '[/:*?"<>|]', '_')
	Else
		$sCurrProfile = GUICtrlRead($cmbProfile)
	EndIf

	; Create the profile if needed
	createProfile()
	; Set the profile name on the village info group.
	GUICtrlSetData($grpVillage, GetTranslated(13, 21, "Village") & ": " & $sCurrProfile)
	GUICtrlSetData($OrigPushB, $sCurrProfile)
EndFunc   ;==>setupProfile

Func selectProfile()
	If _GUICtrlComboBox_FindStringExact($cmbProfile, String($sCurrProfile)) <> -1 Then
		_GUICtrlComboBox_SelectString($cmbProfile, String($sCurrProfile))
		_GUICtrlComboBox_SelectString($cmbGoldMaxProfile, String($icmbGoldMaxProfile))
		_GUICtrlComboBox_SelectString($cmbGoldMinProfile, String($icmbGoldMinProfile))
		_GUICtrlComboBox_SelectString($cmbElixirMaxProfile, String($icmbElixirMaxProfile))
		_GUICtrlComboBox_SelectString($cmbElixirMinProfile, String($icmbElixirMinProfile))
		_GUICtrlComboBox_SelectString($cmbDEMaxProfile, String($icmbDEMaxProfile))
		_GUICtrlComboBox_SelectString($cmbDEMinProfile, String($icmbDEMinProfile))
		_GUICtrlComboBox_SelectString($cmbTrophyMaxProfile, String($icmbTrophyMaxProfile))
		_GUICtrlComboBox_SelectString($cmbTrophyMinProfile, String($icmbTrophyMinProfile))
	Else
		Local $comboBoxArray = _GUICtrlComboBox_GetListArray($cmbProfile)
		$sCurrProfile = $comboBoxArray[1]

		; Create the profile if needed, this also sets the variables if the profile exists.
		createProfile()
		readConfig()
		applyConfig()
		_GUICtrlComboBox_SetCurSel($cmbProfile, 0)
		_GUICtrlComboBox_SetCurSel($cmbGoldMaxProfile, 0)
		_GUICtrlComboBox_SetCurSel($cmbGoldMinProfile, 0)
		_GUICtrlComboBox_SetCurSel($cmbElixirMaxProfile, 0)
		_GUICtrlComboBox_SetCurSel($cmbElixirMinProfile, 0)
		_GUICtrlComboBox_SetCurSel($cmbDEMaxProfile, 0)
		_GUICtrlComboBox_SetCurSel($cmbDEMinProfile, 0)
		_GUICtrlComboBox_SetCurSel($cmbTrophyMaxProfile, 0)
		_GUICtrlComboBox_SetCurSel($cmbTrophyMinProfile, 0)
	EndIf

	; Set the profile name on the village info group.
	GUICtrlSetData($grpVillage, GetTranslated(13, 21, "Village") & ": " & $sCurrProfile)
	GUICtrlSetData($OrigPushB, $sCurrProfile)
EndFunc   ;==>selectProfile
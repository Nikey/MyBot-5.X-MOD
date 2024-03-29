Global $cmbMilkLvl4,$cmbMilkLvl5,$cmbMilkLvl6,$cmbMilkLvl7,$cmbMilkLvl8,$cmbMilkLvl9,$cmbMilkLvl10,$cmbMilkLvl11,$cmbMilkLvl12
Global $chkAtkElixirExtractors, $chkAtkGoldMines, $chkAtkDarkDrills
Global $cmbAtkGoldMinesLevel, $cmbAtkDarkDrillsLevel
Global $cmbRedlineResDistance
Global $chkAttackMinesifGold,$chkAttackMinesifElixir, $chkAttackMinesifDarkElixir
Global $txtAttackMinesifGold,$txtAttackMinesifElixir, $txtAttackMinesifDarkElixir
Global $txtLowerXWave, $txtUpperXWave, $txtLowerDelayWaves, $txtUpperDelayWaves, $txtMaxWaves
Global $grpMilkingDebug ,$chkMilkingDebugIMG, $chkMilkingDebugFullSearch

Func GUIMilk()
	$hMilkGUI = GUICreate(GetTranslated(16,1, "Milking Options"), 380, 536, 85, 60, -1, $WS_EX_MDICHILD, $frmbot)
	GUISetOnEvent($GUI_EVENT_CLOSE, 'CloseGUIMilk2') ; Run this function when the secondary GUI [X] is clicked
	GUISetIcon($pIconLib, $eIcnGUI)
	$gui3open = 1
	Local $x = 9
	Local $y = 13
	$grpExtractorOptions = GUICtrlCreateGroup(GetTranslated(16,2, "1. Elixir Collectors Minimum Level"), $x, $y, 367, 111)
	$y += 20
	$x += 20
	$lblLvl4 = GUICtrlCreateLabel(GetTranslated(16,3, "Levels 1-4"), $x, $y)
	$cmbMilkLvl4 = GUICtrlCreateCombo("", $x - 6, $y + 16, 68, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "DISABLE|0-4%|5-19%|20-74%|75-89%|90-100%")
	$x += 70
	$lblLvl5 = GUICtrlCreateLabel(GetTranslated(16,4, "Level 5"), $x, $y)
	$cmbMilkLvl5 = GUICtrlCreateCombo("", $x - 6, $y + 16, 68, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "DISABLE|0-4%|5-19%|20-74%|75-89%|90-100%")
	$x += 70
	$lblLvl6 = GUICtrlCreateLabel(GetTranslated(16,5, "Level 6"), $x, $y)
	$cmbMilkLvl6 = GUICtrlCreateCombo("", $x - 6, $y + 16, 68, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "DISABLE|0-4%|5-19%|20-74%|75-89%|90-100%")
	$x += 70
	$lblLvl7 = GUICtrlCreateLabel(GetTranslated(16,6, "Level 7"), $x, $y)
	$cmbMilkLvl7 = GUICtrlCreateCombo("", $x - 6, $y + 16, 68, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "DISABLE|0-4%|5-19%|20-74%|75-89%|90-100%")
	$x += 70
	$lblLvl8 = GUICtrlCreateLabel(GetTranslated(16,7, "Level 8"), $x, $y)
	$cmbMilkLvl8 = GUICtrlCreateCombo("", $x - 6, $y + 16, 68, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "DISABLE|0-4%|5-19%|20-74%|75-89%|90-100%")

	$x = 29
	$y = 78
	$lblLvl9 = GUICtrlCreateLabel(GetTranslated(16,8, "Level 9"), $x, $y)
	$cmbMilkLvl9 = GUICtrlCreateCombo("", $x - 6, $y + 16, 68, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "DISABLE|0-4%|5-19%|20-74%|75-89%|90-100%")
	$x += 70
	$lblLvl10 = GUICtrlCreateLabel(GetTranslated(16,9, "Level 10"), $x, $y)
	$cmbMilkLvl10 = GUICtrlCreateCombo("", $x - 6, $y + 16, 68, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "DISABLE|0-4%|5-19%|20-74%|75-89%|90-100%")
	$x += 70
	$lblLvl11 = GUICtrlCreateLabel(GetTranslated(16,10, "Level 11"), $x, $y)
	$cmbMilkLvl11 = GUICtrlCreateCombo("", $x - 6, $y + 16, 68, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "DISABLE|0-4%|5-19%|20-74%|75-89%|90-100%")
	$x += 70
	$lblLvl12 = GUICtrlCreateLabel(GetTranslated(16,11, "Level 12"), $x, $y)
	$cmbMilkLvl12 = GUICtrlCreateCombo("", $x - 6, $y + 16, 68, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "DISABLE|0-4%|5-19%|20-74%|75-89%|90-100%")

	$grpIfFoundElixir = GUICtrlCreateGroup(GetTranslated(16,12, "2. If Elixir Collectors Found, Then"), 9, 127, 280, 83)

	$x = 26
	$y = 147
	$chkAtkElixirExtractors = GUICtrlCreateCheckbox(GetTranslated(16,13, "Attack Elixir Collectors"), $x, $y)
	$y += 20
	$chkAtkGoldMines = GUICtrlCreateCheckbox(GetTranslated(16,14, "Attack Gold Mines With Level >"), $x, $y)
		GUICtrlSetOnEvent(-1, "chkAtkGoldMines")
	$cmbAtkGoldMinesLevel = GUICtrlCreateCombo("", 235, $y, 47, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1,"1-4|5|6|7|8|9|10|11")
	$y += 20
	$chkAtkDarkDrills = GUICtrlCreateCheckbox(GetTranslated(16,15, "Attack Dark Elixir Drills With Level >"), $x, $y)
	GUICtrlSetOnEvent(-1, "chkAtkDarkDrills")
	$cmbAtkDarkDrillsLevel = GUICtrlCreateCombo("", 235, $y, 47, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1,"1|2|3|4|5|6")

	$grpAttackResourcesIf = GUICtrlCreateGroup(GetTranslated(16,16, "3. Only Attack If"), 9, 225, 280, 110)
	$y = 245
	$x = 25
	$lblRedlineResDistance = GUICtrlCreateLabel(GetTranslated(16,17, "Distance between red line and collectors <"), $x, $y)
 	$cmbRedlineResDistance = GUICtrlCreateCombo("", 235, $y - 4 , 51, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "0 tile|1 tile|2 tiles|3 tiles","1")
	$x += 20
	$y += 20
	$chkAttackMinesifGold = GUICtrlCreateCheckbox(GetTranslated(16,18, "Attack Gold Mines If Gold Over"), $x, $y)
		GUICtrlSetOnEvent(-1, "chkAttackMinesifGold")
		GUICtrlSetTip(-1, "This filter is not used by the bot yet")
	$txtAttackMinesIfGold = GUICtrlCreateInput("100000", 235, $y, 52, 21)
		GUICtrlSetState(-1,$GUI_DISABLE)
		GUICtrlSetTip(-1, "This filter is not used by the bot yet")
	$y += 20
	$chkAttackMinesifElixir = GUICtrlCreateCheckbox(GetTranslated(16,19, "Attack Elixir Collectors If Elixir Over"), $x, $y)
		GUICtrlSetOnEvent(-1, "chkAttackMinesifElixir")
		GUICtrlSetTip(-1, "This filter is not used by the bot yet")
	$txtAttackMinesIfElixir = GUICtrlCreateInput("100000", 235, $y, 52, 21)
		GUICtrlSetState(-1,$GUI_DISABLE)
		GUICtrlSetTip(-1, "This filter is not used by the bot yet")
	$y += 20
	$chkAttackMinesifDarkElixir = GUICtrlCreateCheckbox(GetTranslated(16,20, "Attack Dark Elixir Drills If Dark Over"), $x, $y)
		GUICtrlSetOnEvent(-1, "chkAttackMinesifDarkElixir")
		GUICtrlSetTip(-1, "This filter is not used by the bot yet")
	$txtAttackMinesIfDarkElixir = GUICtrlCreateInput("500", 235, $y, 52, 21)
		GUICtrlSetState(-1,$GUI_DISABLE)
		GUICtrlSetTip(-1, "This filter is not used by the bot yet")

	$grpTroopsToUse = GUICtrlCreateGroup(GetTranslated(16,21, "4. Troops To Use For Each Resource"), 9, 343,280,96)
	$x = 42
	$y = 367
	$lblTroopXWave = GUICtrlCreateLabel(GetTranslated(16,22, "- Troop X Wave:"), $x, $y)
		GUICtrlSetTip(-1, "Number of troops per wave")
	$txtLowerXWave = GUICtrlCreateInput("", 180, $y - 5, 37, 21)
		GUICtrlSetTip(-1, "Number of min troops per wave")
	GUICtrlCreateLabel("-", 228, $y)
	$txtUpperXWave = GUICtrlCreateInput("", 245, $y - 5, 37, 21)
		GUICtrlSetTip(-1, "Number of max troops per wave")
	$y += 20
	$lblMaxWave = GUICtrlCreateLabel(GetTranslated(16,23, "- Max Waves:"), $x, $y)
		GUICtrlSetTip(-1, "Max number of troop waves")
	$txtMaxWaves = GUICtrlCreateInput(3, 180, $y - 5, 37, 21)
		GUICtrlSetTip(-1, "Max number of troop waves")
	$y += 20
	$lblDelayBtwnWaves = GUICtrlCreateLabel(GetTranslated(16,24, "- Delay Between Waves:"), $x, $y)
	$txtLowerDelayWaves = GUICtrlCreateInput("", 180, $y - 5, 37, 21)
	GUICtrlCreateLabel("-", 228, $y)
	$txtUpperDelayWaves = GUICtrlCreateInput("", 245, $y - 5, 37, 21)

	$x = 300
	$y = 127
	$grpMilkingLegend = GUICtrlCreateGroup(GetTranslated(16,31, "Legend"), $x, $y, 77,312)
	$x += 20
	$y += 20
	$lblLegend0 = GUICtrlCreateLabel(GetTranslated(16,32, "0-4%"), $x, $y)
	$y += 20
    $picLegend0 = GUICtrlCreatePic(@ScriptDir & "\Images\CapacityStructure\elixir_8_0_70_A.bmp", $x , $y, 25, 25 )
	$y += 35
	$lblLegend1 = GUICtrlCreateLabel(GetTranslated(16,33, "5-19%"), $x, $y)
	$y += 20
    $picLegend1 = GUICtrlCreatePic(@ScriptDir & "\Images\CapacityStructure\elixir_8_1_70_A.bmp", $x , $y, 25, 25 )
	$y += 35
	$lblLegend2 = GUICtrlCreateLabel(GetTranslated(16,34, "20-74%"), $x, $y)
	$y += 20
    $picLegend2 = GUICtrlCreatePic(@ScriptDir & "\Images\CapacityStructure\elixir_8_2_70_A.bmp", $x , $y, 25, 25 )
	$y += 35
	$lblLegend3 = GUICtrlCreateLabel(GetTranslated(16,35, "75-89%"), $x, $y)
	$y += 20
    $picLegend3 = GUICtrlCreatePic(@ScriptDir & "\Images\CapacityStructure\elixir_8_3_70_A.bmp", $x , $y, 25, 25 )
	$y += 35
	$lblLegend0 = GUICtrlCreateLabel(GetTranslated(16,36, "90-100%"), $x, $y)
	$y += 20
    $picLegend4 = GUICtrlCreatePic(@ScriptDir & "\Images\CapacityStructure\elixir_8_4_70_A.bmp", $x , $y, 25, 25 )
	$y += 35

	$x = 300
	$y= 452
	
	$grpMilkingDebug = GUICtrlCreateGroup(GetTranslated(16,37, "Debug"), $x, $y, 77,70)
	GUICtrlSetState(-1, $GUI_HIDE)
	$y += 20
	$x += 5
	$chkMilkingDebugIMG = GUICtrlCreateCheckbox(GetTranslated(16,38, "offset IMG"), $x, $y)
	GUICtrlSetState(-1, $GUI_HIDE)
	$y += 20
	$chkMilkingDebugFullSearch = GUICtrlCreateCheckbox(GetTranslated(16,39, "fullsearch"), $x, $y)
	GUICtrlSetState(-1, $GUI_HIDE)	
	
	$y-=20
	$btnMilkSaveExit = GUICtrlCreateButton(GetTranslated(16,40, "Save And Close"), 20, $y, 250, 20)
	GUICtrlSetOnEvent(-1, "CloseGUIMilk2")
EndFunc
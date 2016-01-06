; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), Promac (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;~ -------------------------------------------------------------
;~ Attack Advanced Tab
;~ -------------------------------------------------------------
 $tabAttackAdv = GUICtrlCreateTabItem(GetTranslated(4,1, "Attack Adv."))
	Local $x = 30, $y = 150
	$grpAtkOptions = GUICtrlCreateGroup(GetTranslated(4,2, "Attack Options"), $x - 20, $y - 20, 220, 85)
		$y -=5
		$chkAttackNow = GUICtrlCreateCheckbox(GetTranslated(4,3, "Attack Now! option."), $x-10, $y, -1, -1)
			$txtTip = GetTranslated(4,4, "Check this if you want the option to have an 'Attack Now!' button next to") & @CRLF & GetTranslated(4,5, "the Start and Pause buttons to bypass the dead base or all base search values.") & @CRLF & GetTranslated(4,6, "The Attack Now! button will only appear when searching for villages to Attack.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkAttackNow")
		$y +=22
		$lblAttackNow = GUICtrlCreateLabel(GetTranslated(4,7, "Add") & ":", $x - 10, $y + 4, 27, -1, $SS_RIGHT)
			$txtTip = GetTranslated(4,8, "Add this amount of reaction time to slow down the search.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$cmbAttackNowDelay = GUICtrlCreateCombo("", $x + 20, $y + 1, 35, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "5|4|3|2|1","3") ; default value 3
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblAttackNowSec = GUICtrlCreateLabel(GetTranslated(4,9, "sec. delay"), $x + 57, $y + 4, -1, -1)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y +=22
		$chkAttackTH = GUICtrlCreateCheckbox(GetTranslated(4,10, "Attack Townhall Outside"), $x-10, $y, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(4,11, "Check this to Attack an exposed Townhall first. (Townhall outside of Walls)") & @CRLF & GetTranslated(4,12, "TIP: Also tick 'Meet Townhall Outside' on the Search tab if you only want to search for bases with exposed Townhalls."))

	GUICtrlCreateGroup("", -99, -99, 1, 1)


	Local $x = 255, $y = 150
	$grpTHSnipeWhileTrainOptions = GUICtrlCreateGroup(GetTranslated(4,13, "TH Snipe"), $x - 20, $y - 20, 225, 375)

		$y -=5
		$ChkSnipeWhileTrain = GUICtrlCreateCheckbox(GetTranslated(4,14, "Snipe While Train"), $x-10, $y, -1, -1)
			$txtTip = GetTranslated(4,15, "Check this if you want the bot search TH outsite while train troops.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSnipeWhileTrain")
		$lblSWTTiles = GUICtrlCreateLabel(GetTranslated(4,16, "Add Tiles") & ":", $x + 67, $y + 4, 100, -1, $SS_RIGHT)
			$txtTip = GetTranslated(4,17, "Add number of tiles from Base Edges")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtSWTTiles = GUICtrlCreateInput("1", $x + 170, $y, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
			
		$y +=22
		$lblSearchlimit = GUICtrlCreateLabel(GetTranslated(4,18, "Search limit") & ":", $x + 95, $y + 4, 72, -1, $SS_RIGHT)
			$txtTip = GetTranslated(4,19, "Maximum searches first to return to home.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtSearchlimit = GUICtrlCreateInput("15", $x + 170, $y, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetState(-1, $GUI_DISABLE)
			
		$y +=22
		$lblminArmyCapacityTHSnipe = GUICtrlCreateLabel(GetTranslated(4,20, "Min Army Capacity % to start Snipe") & ":", $x - 10, $y + 4, 177, -1, $SS_RIGHT)
			$txtTip = GetTranslated(4,21, "Minimum Army Capacity to start Snipe.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$txtminArmyCapacityTHSnipe = GUICtrlCreateInput("35", $x + 170, $y, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
			
		$y +=22
		$chkTrophyMode = GUICtrlCreateCheckbox(GetTranslated(4,23, "Snipe Combo"), $x-10, $y, -1, -1)
			$txtTip = GetTranslated(4,24, "Adds the TH Snipe combination to the current search settings. (Example: Deadbase OR TH Snipe)")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSnipeMode")
			
		$y+= 25
		$lblTHadd = GUICtrlCreateLabel(GetTranslated(4,25, "Add") & ":", $x -10, $y+5, -1, 17, $SS_RIGHT)
		    $txtTip = GetTranslated(4,26, "Enter how many 'Grass' 1x1 tiles the TH may be from the Base edges to be seen as a TH Outside.") & @CRLF & GetTranslated(4,27, "Ex: (0) tiles; TH must be exactly at the edge. (4) tiles: TH may be 4 tiles farther from edges and closer to the center of the village.") & @CRLF & GetTranslated(4,28, "If the TH is farther away then the No. of tiles set, the base will be skipped.")
			GUICtrlSetTip(-1, $txtTip)
		$lblTHaddtiles = GUICtrlCreateLabel(GetTranslated(4,29, "tile(s) from Base Edges"), $x + 57, $y+5, -1, 17)
		    GUICtrlSetTip(-1, $txtTip)
		$txtTHaddtiles = GUICtrlCreateInput("2", $x + 26, $y + 1, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		
		$y += 30		
		$chkTSMeetGold = GUICtrlCreateCheckbox(GetTranslated(4,30, "Min Gold"), $x , $y, -1, -1)
			$txtTip = GetTranslated(4,31, "Search for a base that meets the value set for Min. Gold.")
			GUICtrlSetOnEvent(-1, "chkTSMeetGold")
			GUICtrlSetTip(-1, $txtTip)
		$txtTSMinGold = GUICtrlCreateInput("100000", $x + 80, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(4,31, "Set the Min. amount of Gold to search for on a village to attack.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picTSMinGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 131, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
			
		$y += 21
		$chkTSMeetElixir= GUICtrlCreateCheckbox(GetTranslated(4,32, "Min Elixir"), $x , $y, -1, -1)
			$txtTip = GetTranslated(4,33, "Search for a base that meets the value set for Min. Elixir.")
			GUICtrlSetOnEvent(-1, "chkTSMeetElixir")
			GUICtrlSetTip(-1, $txtTip)
		$txtTSMinElixir = GUICtrlCreateInput("100000", $x + 80, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(4,34, "Set the Min. amount of Elixir to search for on a village to attack.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picTSMinElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 131, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
			
		$y += 21		
		$chkTSMeetDE = GUICtrlCreateCheckbox(GetTranslated(4,35, "Min Dark"), $x , $y, -1, -1)
			$txtTip = GetTranslated(4,36, "Search for a base that meets the value set for Min. Dark Elixir.")
			GUICtrlSetOnEvent(-1, "chkTSMeetDE")
			GUICtrlSetTip(-1, $txtTip)
		$txtTSMinDarkElixir = GUICtrlCreateInput("1000", $x + 80, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(4,37, "Set the Min. amount of Dark Elixir to search for on a village to attack.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
		$picTSMinDarkElixir = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 131, $y, 16, 16)
			GUICtrlSetTip(-1, $txtTip)
			
		$y += 30
		$chkTSAttackDB = GUICtrlCreateCheckbox(GetTranslated(4,40, "Attack DB"), $x , $y, -1, -1)
			$txtTip = GetTranslated(4,41, "Check loot gained by TH snipe and attack normally if it was a dead base")
			GUICtrlSetOnEvent(-1, "chkTSAttackDB")
			GUICtrlSetTip(-1, $txtTip)
        
		$y += 30
		$lblAttackTHType = GUICtrlCreateLabel(GetTranslated(4,38, "Attack TH Type") & ":", $x - 15 , $y + 5 , 90, -1, $SS_RIGHT)
		$cmbAttackTHType = GUICtrlCreateCombo("",  $x + 80, $y, 120, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "")
            $txtTip = GetTranslated(4,39, "You can add/edit attack editing csv settings files in THSnipe folder")

			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "cmbAttackTHType")
			LoadThSnipeAttacks()
			
		$y += 30
		GUICtrlCreateIcon($pIconLib, $eIcnKing, $x - 16 , $y, 24, 24)
		$chkUseKingTH = GUICtrlCreateCheckbox(GetTranslated(4,47, "Use King"), $x + 12 , $y+1, -1, -1)
			$txtTip = GetTranslated(4,48, "Use King when Attacking TH Snipe") & @CRLF & GetTranslated(4,49, "Will be deployed in First wave")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x + 102 , $y, 24, 24)
		$chkUseLSpellsTH = GUICtrlCreateCheckbox(GetTranslated(4,50, "Use LSpell"), $x + 130 , $y+1, -1, -1)
			$txtTip = GetTranslated(4,51, "Use Lighting spells when Attacking TH Snipe") & @CRLF & GetTranslated(4,52, "Will be deployed in Third wave")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 27
		GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x - 16 , $y, 24, 24)
		$chkUseQueenTH = GUICtrlCreateCheckbox(GetTranslated(4,53, "Use Queen"), $x + 12 , $y+1, -1, -1)
			$txtTip = GetTranslated(4,54, "Use Queen when Attacking TH Snipe") & @CRLF & GetTranslated(4,55, "Will be deployed in First wave")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnRageSpell, $x + 102 , $y, 24, 24)
		$chkUseRSpellsTH = GUICtrlCreateCheckbox(GetTranslated(4,56, "Use RSpell"), $x + 130 , $y+1, -1, -1)
			$txtTip = GetTranslated(4,57, "Use Heal spells when Attacking TH Snipe") & @CRLF &  GetTranslated(4,58, "Will be deployed in Third wave")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$y += 27
		GUICtrlCreateIcon($pIconLib, $eIcnCC, $x - 16, $y, 24, 24)
		$chkUseClastleTH = GUICtrlCreateCheckbox(GetTranslated(4,59, "Drop in Battle"), $x + 12 , $y+1, -1, -1)
			$txtTip = GetTranslated(4,60, "Use Clan Castle when Attacking TH Snipe") & @CRLF & GetTranslated(4,61, "Will be deployed in Second wave")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnHealSpell, $x + 102 , $y, 24, 24)
		$chkUseHSpellsTH = GUICtrlCreateCheckbox(GetTranslated(4,62, "Use HSpell"), $x + 130 , $y+1, -1, -1)
			$txtTip = GetTranslated(4,63, "Use Heal spells when Attacking TH Snipe") & @CRLF & GetTranslated(4,64, "Will be deployed in Second wave")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$y+= 30

    GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 240
	$grpBullyAtkCombo = GUICtrlCreateGroup(GetTranslated(4,65, "Bully Attack Combo"), $x - 20, $y - 20, 220, 110)
	    $y -= 5
		$x -= 10
		$chkBullyMode = GUICtrlCreateCheckbox(GetTranslated(4,66, "TH Bully.  After") & ":", $x, $y, -1, -1)
			$txtTip = GetTranslated(4,67, "Adds the TH Bully combo to the current search settings. (Example: Deadbase OR TH Bully)") & @CRLF & GetTranslated(4,68, "TH Bully: Attacks a lower townhall level after the specified No. of searches.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkBullyMode")
		$txtATBullyMode = GUICtrlCreateInput("150", $x + 95, $y, 35, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(4,69, "TH Bully: No. of searches to wait before activating.")
			GUICtrlSetLimit(-1, 3)
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblATBullyMode = GUICtrlCreateLabel(GetTranslated(4,70, "search(es)."), $x + 135, $y + 5, -1, -1)
		$y +=25
		$lblATBullyMode = GUICtrlCreateLabel(GetTranslated(4,71, "Max TH level") & ":", $x - 10, $y + 3, 90, -1, $SS_RIGHT)
		$cmbYourTH = GUICtrlCreateCombo("", $x + 95, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(4,72, "TH Bully: Max. Townhall level to bully.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "4-6|7|8|9|10|11", "4-6")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$y += 24
		GUICtrlCreateLabel(GetTranslated(4,73, "When found, Attack with settings from")&":", $x + 10, $y, -1, -1, $SS_RIGHT)
		$y += 14
		$radUseDBAttack = GUICtrlCreateRadio(GetTranslated(4,74, "DeadBase Atk."), $x + 20, $y, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(4,75, "Use Dead Base attack settings when attacking a TH Bully match."))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$radUseLBAttack = GUICtrlCreateRadio(GetTranslated(4,76, "LiveBase Atk."), $x + 115, $y, -1, -1)
			GUICtrlSetTip(-1, GetTranslated(4,77, "Use Live Base attack settings when attacking a TH Bully match."))
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 30, $y = 355
	$grpDefenseFarming = GUICtrlCreateGroup(GetTranslated(4,78, "Defense Farming"), $x - 20, $y - 20, 220, 170)
		$chkUnbreakable = GUICtrlCreateCheckbox(GetTranslated(4,79, "Enable Unbreakable Mode"), $x, $y, -1, -1)
			$TxtTip = GetTranslated(4,80, "Enable farming Defense Wins for Unbreakable achievement.") ;& @CRLF & "TIP: Set your trophy range on the Misc Tab to '600 - 800' for best results. WARNING: Doing so will DROP you Trophies!"
			GUICtrlSetTip(-1, $TxtTip)
			GUICtrlSetOnEvent(-1, "chkUnbreakable")
		$y += 23
		$lblUnbreakable1 = GUICtrlCreateLabel(GetTranslated(4,81, "Wait Time") & ":", $x - 10, $y + 3, 86, -1, $SS_RIGHT)
		$txtUnbreakable = GUICtrlCreateInput("5", $x + 80, $y, 30, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$TxtTip = GetTranslated(4,82, "Set the amount of time to stop CoC and wait for enemy attacks to gain defense wins. (1-99 minutes)")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$lblUnbreakable2 = GUICtrlCreateLabel(GetTranslated(4,83, "Minutes"), $x + 113, $y+3, -1, -1)
		$y += 28
		$lblUnBreakableFarm = GUICtrlCreateLabel(GetTranslated(4,84, "Farm Min."), $x + 25 , $y, -1, -1)
		$lblUnBreakableSave = GUICtrlCreateLabel(GetTranslated(4,85, "Save Min."), $x + 115 , $y, -1, -1)
		$y += 16
		$txtUnBrkMinGold = GUICtrlCreateInput("50000", $x + 20, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(4,86, "Amount of Gold that stops Defense farming, switches to normal farming if below.") & @CRLF & GetTranslated(4,87, "Set this value to amount of Gold you need for searching or upgrades."))
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 80, $y + 2, 16, 16)
		$txtUnBrkMaxGold = GUICtrlCreateInput("600000", $x + 110, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(4,88, "Amount of Gold in Storage Required to Enable Defense Farming.") & @CRLF & GetTranslated(4,89, "Input amount of Gold you need to attract enemy or for upgrades."))
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 170, $y + 2, 16, 16)
		$y += 26
		$txtUnBrkMinElixir = GUICtrlCreateInput("50000", $x + 20, $y, 58, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(4,90, "Amount of Elixir that stops Defense farming, switches to normal farming if below.") & @CRLF & GetTranslated(4,91, "Set this value to amount of Elixir you need for making troops or upgrades."))
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 80, $y, 16, 16)
		$txtUnBrkMaxElixir = GUICtrlCreateInput("600000", $x + 110, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(4,92, "Amount of Elixir in Storage Required to Enable Defense Farming.") & @CRLF & GetTranslated(4,93, "Input amount of Elixir you need to attract enemy or for upgrades."))
			GUICtrlSetLimit(-1, 7)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 170, $y, 16, 16)
		$y += 24
		$txtUnBrkMinDark = GUICtrlCreateInput("5000", $x + 20, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(4,94, "Amount of Dark Elixir that stops Defense farming, switches to normal farming if below.") & @CRLF & GetTranslated(4,95, "Set this value to amount of Dark Elixir you need for making troops or upgrades."))
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 80, $y, 16, 16)
		$txtUnBrkMaxDark = GUICtrlCreateInput("6000", $x + 110, $y, 58, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, GetTranslated(4,96, "Amount of Dark Elixir in Storage Required to Enable Defense Farming.") & @CRLF & GetTranslated(4,97, "Input amount of Dark Elixir you need to attract enemy or for upgrades."))
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 170, $y, 16, 16)
    GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateTabItem("")

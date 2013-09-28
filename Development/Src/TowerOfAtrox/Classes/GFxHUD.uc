class GFxHUD extends GFxMoviePlayer;

var ATROXHUD aHud;
var PlayerController PlayerOwner;

var GFxObject RootMC, CursorMC, HeroHealthMC, EnemyHealthMC, xpBar, inventoryContainer, energyBar;
var GFxObject strengthValue, healthValue, defenceValue, characterSheet, smashedValue, secretValue, deathValue, levelValue, killedValue;
var GFxClikWidget actionButton1, actionButton2, unknownBtn1, unknownBtn2, targetBtn, chargeBtn, disabledChargeBtn, disabledAttackBtn, potionBtn, levelBtn, toggleInventoryOpenBtn, toggleInventoryCloseBtn, swordBtn, torchBtn, shieldBtn, energyBtn, keyBtn;
var GFxClikWidget popupOkBtn;
var GFxObject popupDisplay;
var GFxObject combatLog;
var Array<GFxObject> combatLogEntries;

var int heroDisplayedHealth, enemyDisplayedHealth, heroDisplayedXP, heroLevel, numPotions, numEnergyPotions, heroDisplayedEnergy;
var int displayedStrength, displayedHealth, displayedDefence, displayedSmashed, displayedSecret, displayedDeath, displayedKilled;

var bool bHeroClickingOnItem, bInventoryOpen, bTorchAquired, bInteractionPossible,bCharSheetShowing, bLearnedCharge, bEnemyTargeted, bRollOver;//Er musa over en button?
var string focusedButton; //Navnet på knappen som musa er over

function Init(optional LocalPlayer LocalPlayer)
{
	super.Init(LocalPlayer);
	//Starter SWF Movie
	Start();
	//Advance(0.f) loader alle objektene i swf-en på første frame uten å spille av videre
	Advance(0);
	
	heroDisplayedHealth = 10; //Setter et tall så det blir oppdatert ved første tick
	enemyDisplayedHealth = 5;
	heroDisplayedXP = 5;
	heroDisplayedEnergy = 4;
	displayedStrength = 1;
	displayedHealth = 1;
	displayedDefence = 1;
	displayedSecret = 1;
	displayedDeath = 3;
	displayedKilled = 2;
	displayedSmashed = 3;
	
	RootMC = GetVariableObject("root");
	HeroHealthMC = RootMC.GetObject("Hero_HealthContainer");
	EnemyHealthMC = RootMC.GetObject("Enemy_HealthContainer");
	xpBar = RootMC.GetObject("xpBar");
	energyBar = RootMC.GetObject("energyBar");
	characterSheet = RootMC.GetObject("charSheet");
	strengthValue = characterSheet.GetObject("strengthValue");
	healthValue = characterSheet.GetObject("healthValue");
	defenceValue = characterSheet.GetObject("defenceValue");
	smashedValue = characterSheet.GetObject("smashedValue");
	secretValue = characterSheet.GetObject("secretValue");
	deathValue = characterSheet.GetObject("deathValue");
	levelValue = characterSheet.GetObject("levelValue");
	killedValue = characterSheet.GetObject("killedValue");
	combatLog = RootMC.GetObject("combatLog");
	combatLogEntries[0] = combatLog.GetObject("entry1");
	combatLogEntries[1] = combatLog.GetObject("entry2");
	combatLogEntries[2] = combatLog.GetObject("entry3");
	combatLogEntries[3] = combatLog.GetObject("entry4");
	combatLogEntries[4] = combatLog.GetObject("entry5");
	combatLogEntries[5] = combatLog.GetObject("entry6");
	combatLogEntries[6] = combatLog.GetObject("entry7");
	combatLogEntries[7] = combatLog.GetObject("entry8");
	//RootMC.GotoAndStop("2");
	inventoryContainer = RootMC.GetObject("inventoryContainer");
	popupDisplay = RootMC.GetObject("popup");
	//inventoryContainer.GotoAndStop("2");

	CloseInventory();

	heroLevel = 1;
	numPotions = 0;
	numEnergyPotions = 0;

	bHeroClickingOnItem = false;

}

function UpdateCombatLog(ToA_CombatLog log)
{
	local int i;

	for(i = 0; i < log.combatLog.Length; i ++)
	{
		combatLogEntries[i].SetText(log.combatLog[i]);
	}
}

function EnableButton(GFxClikWidget button, bool b)
{
	button.SetBool("enabled", b);
}

function ShowButton(GFxClikWidget button, bool b)
{
	button.SetVisible(b);
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local bool bWasHandled;
	bWasHandled = false;

	switch(WidgetName)
	{
	case('actionButton1')://attack
		actionButton1 = GFxClikWidget(Widget);
		actionButton1.AddEventListener('CLIK_rollOver', OnRollOver);
		actionButton1.AddEventListener('CLIK_rollOut', OnRollOut);
		bWasHandled = true;
		break;
	case('disabledAttackBtn')://attack disabled
		disabledAttackBtn = GFxClikWidget(Widget);
		disabledAttackBtn.SetVisible(false);
		disabledAttackBtn.AddEventListener('CLIK_rollOver', OnRollOver);
		disabledAttackBtn.AddEventListener('CLIK_rollOut', OnRollOut);
		bWasHandled = true;
		break;
	case('actionButton2'): //block
		actionButton2 = GFxClikWidget(Widget);
		actionButton2.AddEventListener('CLIK_rollOver', OnRollOver);
		actionButton2.AddEventListener('CLIK_rollOut', OnRollOut);
		bWasHandled = true;
		actionButton2.SetVisible(false);
		break;
	case('targetBtn'):
		targetBtn = GFxClikWidget(Widget);
		targetBtn.AddEventListener('CLIK_rollOver', OnRollOver);
		targetBtn.AddEventListener('CLIK_rollOut', OnRollOut);
		bWasHandled = true;
		break;
	case('chargeBtn'):
		chargeBtn = GFxClikWidget(Widget);
		chargeBtn.AddEventListener('CLIK_rollOver', OnRollOver);
		chargeBtn.AddEventListener('CLIK_rollOut', OnRollOut);
		bWasHandled = true;
		chargeBtn.SetVisible(false);
		break;
	case('unknownBtn1'):
		unknownBtn1 = GFxClikWidget(Widget);
		unknownBtn1.AddEventListener('CLIK_rollOver', OnRollOver);
		unknownBtn1.AddEventListener('CLIK_rollOut', OnRollOut);
		bWasHandled = true;
		break;
	case('unknownBtn2'):
		unknownBtn2 = GFxClikWidget(Widget);
		unknownBtn2.AddEventListener('CLIK_rollOver', OnRollOver);
		unknownBtn2.AddEventListener('CLIK_rollOut', OnRollOut);
		bWasHandled = true;
		break;
	case('disabledChargeBtn'):
		disabledChargeBtn = GFxClikWidget(Widget);
		disabledChargeBtn.AddEventListener('CLIK_rollOver', OnRollOver);
		disabledChargeBtn.AddEventListener('CLIK_rollOut', OnRollOut);
		bWasHandled = true;
		break;
	case('toggleInventoryOpenBtn'):
		toggleInventoryOpenBtn = GFxClikWidget(Widget);
		toggleInventoryOpenBtn.AddEventListener('CLIK_rollOver', OnRollOver);
		toggleInventoryOpenBtn.AddEventListener('CLIK_rollOut', OnRollOut);
		bWasHandled = true;
		break;
	case('toggleInventoryCloseBtn'):
		toggleInventoryCloseBtn = GFxClikWidget(Widget);
		toggleInventoryCloseBtn.AddEventListener('CLIK_rollOver', OnRollOver);
		toggleInventoryCloseBtn.AddEventListener('CLIK_rollOut', OnRollOut);
		bWasHandled = true;
		break;
	case('levelBtn'):
		levelBtn = GFxClikWidget(Widget);
		bWasHandled = true;
		break;
	case('potionBtn'):
		potionBtn = GFxClikWidget(Widget);
		potionBtn.AddEventListener('CLIK_rollOver', OnRollOver);
		potionBtn.AddEventListener('CLIK_rollOut', OnRollOut);
		bWasHandled = true;
		break;
	case('swordBtn'):
		swordBtn = GFxClikWidget(Widget);
		swordBtn.AddEventListener('CLIK_rollOver', OnRollOver);
		swordBtn.AddEventListener('CLIK_rollOut', OnRollOut);
		swordBtn.SetVisible(false);
		bWasHandled = true;
		break;
	case('torchBtn'):
		torchBtn = GFxClikWidget(Widget);
		torchBtn.AddEventListener('CLIK_rollOver', OnRollOver);
		torchBtn.AddEventListener('CLIK_rollOut', OnRollOut);
		torchBtn.SetVisible(false);
		bWasHandled = true;
		break;
	case('okBtn'):
		popupOkBtn = GFxClikWidget(Widget);
		popupOkBtn.AddEventListener('CLIK_rollOver', OnRollOver);
		popupOkBtn.AddEventListener('CLIK_rollOut', OnRollOut);
		bWasHandled = true;
		break;
	case('keyBtn'):
		keyBtn = GFxClikWidget(Widget);
		keyBtn.AddEventListener('CLIK_rollOver', OnRollOver);
		keyBtn.AddEventListener('CLIK_rollOut', OnRollOut);
		keyBtn.SetVisible(false);
		bWasHandled = true;
		break;
	case('shieldBtn'):
		shieldBtn = GFxClikWidget(Widget);
		shieldBtn.AddEventListener('CLIK_rollOver', OnRollOver);
		shieldBtn.AddEventListener('CLIK_rollOut', OnRollOut);
		shieldBtn.SetVisible(false);
		bWasHandled = true;
		break;
	case('energyBtn'):
		energyBtn = GFxClikWidget(Widget);
		energyBtn.AddEventListener('CLIK_rollOver', OnRollOver);
		energyBtn.AddEventListener('CLIK_rollOut', OnRollOut);
		bWasHandled = true;
		break;
	default:
		break;
	}

	return bWasHandled;
}

//String label korresponderer med label navna på timelinen i swf-fila. "Torch", "Sword", "Shield", "SpecialAttack", "Charge", "HP", og "Strength".
function ShowPopupDisplay(string label)
{
	popupDisplay.GotoAndStop(label);
	popupDisplay.SetVisible(true);
}
function HidePopupDisplay()
{
	popupDisplay.SetVisible(false);
}

function ToggleCharSheet()
{
	if(bCharSheetShowing)
	{
		characterSheet.GotoAndPlayI(1);
		bCharSheetShowing = false;
	}
	else
	{
		characterSheet.GotoAndPlayI(16);
		bCharSheetShowing = true;
	}
}

function ToggleInventory()
{
	if(!bInventoryOpen)
	{
		OpenInventory();
	}
	else
	{
		CloseInventory();
	}
}

function CloseInventory()
{
	toggleInventoryCloseBtn.SetVisible(false);
	toggleInventoryOpenBtn.SetVisible(true);
	inventoryContainer.SetVisible(false);
	bInventoryOpen = false;
}

function OpenInventory()
{
	toggleInventoryOpenBtn.SetVisible(false);
	toggleInventoryCloseBtn.SetVisible(true);
	inventoryContainer.SetVisible(true);
	bInventoryOpen = true;
}

function InventoryOpenButtonPressed()
{
	if(!bInventoryOpen)
	{
		OpenInventory();
	}
}
function InventoryCloseButtonPressed()
{
	if(bInventoryOpen)
	{
		CloseInventory();
	}
}

function OnRollOver(GFxClikWidget.EventData ev)
{
	bRollOver = true;
	focusedButton = ev._this.GetObject("target").GetString("name");
}

function OnRollOut(GFxClikWidget.EventData ev)
{
	bRollOver = false;
	focusedButton = "";
}

event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if(bRollOver == true && ButtonName == 'LeftMouseButton')
	{
		if(InputEvent == IE_Pressed)
		{
			switch(focusedButton)
			{
				case("actionButton1"):
					actionButton1.GotoAndPlay("down");
					AttackButtonPressed();
					break;
				case("actionButton2"):
					actionButton2.GotoAndPlay("down");
					BlockButtonPressed();
					break;
				case("targetBtn"):
					targetBtn.GotoAndPlay("down");
					TargetButtonPressed();
					break;
				case("chargeBtn"):
					chargeBtn.GotoAndPlay("down");
					ChargeButtonPressed();
					break;
				case("disabledChargeBtn"):
					break;
				case("toggleInventoryOpenBtn"):
					toggleInventoryOpenBtn.GotoAndPlay("down");
					InventoryOpenButtonPressed();
					break;
				case("toggleInventoryCloseBtn"):
					toggleInventoryCloseBtn.GotoAndPlay("down");
					InventoryCloseButtonPressed();
					break;
				case("potionBtn"):
					potionBtn.GotoAndPlay("down");
					UsePotion();
					break;
				case("swordBtn"):
					swordBtn.GotoAndPlay("down");
					EquipSword();
					break;
				case("torchBtn"):
					torchBtn.GotoAndPlay("down");
					EquipTorch();
					break;
				case("okBtn"):
					popupOkBtn.GotoAndPlay("down");
					popupDisplay.SetVisible(false);
					break;
				case("keyBtn"):
					popupOkBtn.GotoAndPlay("down");
					break;
				case("shieldBtn"):
					popupOkBtn.GotoAndPlay("down");
					EquipShield();
					break;
				case("energyBtn"):
					popupOkBtn.GotoAndPlay("down");
					UseEnergyPotion();
					break;
				default:
					break;
			}
		}
		else if(InputEvent == IE_Released)
		{
			switch(focusedButton)
			{
				case("actionButton1"):
					actionButton1.GotoAndPlay("over");
					break;
				case("actionButton2"):
					actionButton2.GotoAndPlay("over");
					BlockButtonReleased();
					break;
				case("targetBtn"):
					targetBtn.GotoAndPlay("over");
					break;
				case("disabledChargeBtn"):
					break;
				case("toggleInventoryCloseBtn"):
					toggleInventoryCloseBtn.GotoAndPlay("over");
					break;
				case("toggleInventoryOpenBtn"):
					toggleInventoryOpenBtn.GotoAndPlay("over");
					break;
				case("potionBtn"):
					potionBtn.GotoAndPlay("over");
					break;
				case("swordBtn"):
					swordBtn.GotoAndPlay("over");
					break;
				case("torchBtn"):
					torchBtn.GotoAndPlay("over");
					break;
				case("okBtn"):
					popupOkBtn.GotoAndPlay("over");
					break;
				case("keyBtn"):
					popupOkBtn.GotoAndPlay("over");
					break;
				case("shieldBtn"):
					popupOkBtn.GotoAndPlay("over");
					break;
				case("energyBtn"):
					popupOkBtn.GotoAndPlay("over");
					break;
				case("chargeBtn"):
					chargeBtn.GotoAndPlay("over");
					ChargeButtonReleased();
					break;
				default:
					break;
			}
		}
		return true;
	}
	return false;
}

function EquipShield()
{
	if(ToA_GamePlayerController(PlayerOwner).EquipShieldOffHand())
	{
		EnableBlockButton();
		HideInventoryItem('Shield');
	}
}

function DisableAttackButton()
{
	actionButton1.SetVisible(false);
	disabledAttackBtn.SetVisible(true);
}

function EnableAttackButton()
{
	actionButton1.SetVisible(true);
	disabledAttackBtn.SetVisible(false);
}

function EnableBlockButton()
{
	actionButton2.SetVisible(true);
	unknownBtn2.SetVisible(false);
}

function ShowChargeButton()
{
	bLearnedCharge = true;
	disabledChargeBtn.SetVisible(true);
	unknownBtn1.SetVisible(false);
}
function EnableChargeButton()
{
	if(bLearnedCharge)
	{
		disabledChargeBtn.SetVisible(false);
		chargeBtn.SetVisible(true);
	}
}

function DisableChargeButton()
{
	disabledChargeBtn.SetVisible(true);
	chargeBtn.SetVisible(false);
}

function EquipTorch()
{
	ToA_GamePlayerController(PlayerOwner).EquipTorchMainHand();
	HideInventoryItem('Torch');
}

function EquipSword()
{
	ToA_GamePlayerController(PlayerOwner).EquipSwordMainHand();
	HideInventoryItem('Sword');
}

function AttackButtonPressed()
{
	ToA_GamePlayerController(PlayerOwner).AttackWithSword();
}

function BlockButtonPressed()
{
	ToA_GamePlayerController(PlayerOwner).StartShieldBlock();
}
function BlockButtonReleased()
{
	ToA_GamePlayerController(PlayerOwner).StopShieldBlock();
}

function TargetButtonPressed()
{
	ToA_GamePlayerController(PlayerOwner).CycleThroughEnemies();
}

function ChargeButtonPressed()
{
	ToA_GamePlayerController(PlayerOwner).StartCharge();
}

function ChargeButtonReleased()
{
	ToA_GamePlayerController(PlayerOwner).StopCharge();
}

function UsePotion()
{
	ToA_GamePlayerController(PlayerOwner).UsePotion();
}

function UseEnergyPotion()
{
	ToA_GamePlayerController(PlayerOwner).UseEnergyPotion();
}

function DisplayInventoryItem(Name type)
{
	switch(type)
	{
		case 'Sword': 
			ShowButton(swordBtn, true);
			break;
		case 'Shield':
			ShowButton(shieldBtn, true);
			break;
		case 'Torch':
			ShowButton(torchBtn, true);
			break;
		case 'Key':
			ShowButton(keyBtn, true);
			break;
		default:
			break;
	}
	
}

function HideInventoryItem(Name type)
{
	switch(type)
	{
		case 'Sword': 
			ShowButton(swordBtn, false);
			break;
		case 'Shield':
			ShowButton(shieldBtn, false);
			break;
		case 'Torch':
			ShowButton(torchBtn, false);
			break;
		case 'Key':
			ShowButton(keyBtn, false);
			break;
		default:
			break;
	}
}

event UpdateMousePosition(float x, float y)
{
	local MouseInterfacePlayerInput MIPI;

	if(aHud != none &&  aHud.PlayerOwner != none)
	{
		MIPI = MouseInterfacePlayerInput(aHud.PlayerOwner.PlayerInput);

		if(MIPI != none)
		{
			MIPI.SetMousePosition(x, y);
		}
	}
}

function TickHUD()
{
	local ToA_Pawn hero;
	local ToA_BaseEnemy enemy;

	hero = ToA_Pawn(ToA_GamePlayerController(PlayerOwner).Pawn);
	if(hero == none)
		return;

	if(displayedHealth != hero.heroMaxHealth)
	{
		displayedHealth = hero.heroMaxHealth;
		healthValue.SetText(string(displayedHealth));
	}
	if(displayedStrength != hero.heroStrength)
	{
		displayedStrength = hero.heroStrength;
		strengthValue.SetText(string(displayedStrength));
	}
	if(displayedDefence != hero.heroDefence)
	{
		displayedDefence = hero.heroDefence;
		defenceValue.SetText(string(displayedDefence));
	}

	if(displayedSecret != aHud.GetSecretRoomsFound())
	{
		displayedSecret = aHud.GetSecretRoomsFound();
		secretValue.SetText(string(displayedSecret));
	}

	if(displayedSmashed != aHud.GetNumSmashedObjs())
	{
		displayedSmashed = aHud.GetNumSmashedObjs();
		smashedValue.SetText(string(displayedSmashed));
	}

	if(displayedKilled != aHud.GetNumKilledEnemies())
	{
		displayedKilled = aHud.GetNumKilledEnemies();
		killedValue.SetText(string(displayedKilled));

	}

	if(displayedDeath != aHud.GetTimesDied())
	{
		displayedDeath = aHud.GetTimesDied();
		deathValue.SetText(string(displayedDeath));
	}

	if(heroDisplayedEnergy != hero.heroEnergy.GetPercentOfEnergyLeft())
	{
		heroDisplayedEnergy = hero.heroEnergy.GetPercentOfEnergyLeft();
		energyBar.GotoAndStop(string(heroDisplayedEnergy));
	}

	if(heroLevel != hero.heroCurrentLevel)
	{
		heroLevel = hero.heroCurrentLevel;
		levelValue.SetText(string(heroLevel));
		levelBtn.SetString("label", string(heroLevel));
	}

	if(numPotions != hero.pawnInventory.GetNumPotions())
	{
		numPotions = hero.pawnInventory.GetNumPotions();
		potionBtn.SetString("label", string(numPotions));
	}

	if(numEnergyPotions != hero.pawnInventory.GetNumEnergyPotions())
	{
		numEnergyPotions = hero.pawnInventory.GetNumEnergyPotions();
		energyBtn.SetString("label", string(numEnergyPotions));
	}

	enemy = ToA_BaseEnemy(ToA_GamePlayerController(PlayerOwner).currentClickTarget);
	if(enemy == none)
	{
		EnemyHealthMC.SetVisible(false);
		if(bEnemyTargeted)
		{
			DisableChargeButton();
			bEnemyTargeted = false;
		}
		
	}
	if(enemy != none)
	{
		if(!bEnemyTargeted)
		{
			bEnemyTargeted = true;
			EnableChargeButton();
		}
		EnemyHealthMC.SetVisible(true);
		if(enemyDisplayedHealth != GetPercent(enemy.enemyHealth, enemy.enemyMaxHealth))
		{
			enemyDisplayedHealth = GetPercent(enemy.enemyHealth, enemy.enemyMaxHealth);
			EnemyHealthMC.GotoAndStop(string(enemyDisplayedHealth));
		}
	}
	
	if(heroDisplayedHealth != GetPercent(hero.heroHealth, hero.heroMaxHealth))
	{
		heroDisplayedHealth = GetPercent(hero.heroHealth, hero.heroMaxHealth);
		HeroHealthMC.GotoAndStop(string(heroDisplayedHealth));
		//HealthBarMC.SetPosition(20.0f, 50.0f);
		//HealthBarMC.SetFloat("width", (displayedHealth > 100) ? 100 : displayedHealth);
		//HealthText.SetString("text", displayedHealth$"%");
	}

	if(heroDisplayedXP != GetPercent(hero.heroCurrentXp, hero.xpToNextLevel))
	{
		heroDisplayedXP = GetPercent(hero.heroCurrentXp, hero.xpToNextLevel);
		xpBar.GotoAndStop(string(heroDisplayedXP));
	}
}

function int GetPercent(int val, int max)
{
	return int((float(val)/float(max) * 100.0f));
}

DefaultProperties
{
	//Dette er HUD-en. Hvis hud-en er av, så burde denne være av
	bDisplayWithHudOff=false
	//Path til SWF asset
	MovieInfo=SwfMovie'ScaleformMenuGFx.SFMFrontEnd.ATROXHUD'

	//Noe jeg ikke er helt sikker på hva er men som bør være der
	bEnableGammaCorrection=false

	WidgetBindings.Add((WidgetName="actionButton1",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="disabledAttackBtn",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="actionButton2",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="targetBtn",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="chargeBtn",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="disabledChargeBtn",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="toggleInventoryCloseBtn",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="toggleInventoryOpenBtn",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="potionBtn",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="levelBtn",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="torchBtn",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="swordBtn",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="okBtn",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="keyBtn",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="shieldBtn",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="energyBtn",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="unknownBtn1",WidgetClass=class'GFxClikWidget'))
	WidgetBindings.Add((WidgetName="unknownBtn2",WidgetClass=class'GFxClikWidget'))

	bIgnoreMouseInput=false
	bCaptureInput=false
	bPauseGameWhileActive=false

	



}

class ToA_GameInfo extends GameInfo dependsOn(ToA_Pawn);

struct GameInfo_SaveData
{
	var int secretRooms, timesDead, smashedObjs, killedEnemies;
	var bool bTorchLit;
};

var GameInfo_SaveData data;

var SaveEngine saveEngineOBJ;
var LoadEngine loadEngineOBJ;

var ToA_GamePlayerController controllerWorld;
var ATROXHUD hudWorld;

var ToA_InvisibleDoorOpener doorOpener;
var ToA_Level1_Door1Opener door1Opener;
var ToA_Tutorial_DoorOpener tutorialDoorOpener;
var ToA_Level1_ThirdRoom_MagicBlockingCube magicBlockingCube;
var ToA_BossSpawner bossSpawner;
var ToA_Level1_ThirdRoom_KeyDoor door3;

var int numSecretRoomsFound;
var int numTimesDied;
var int numSmashedObjs;
var int numKilledEnemies;

var bool bTorchIsLit;

var string filename;

var Array<ToA_BaseEnemy> levelEnemiesArray;
var Array<ToA_Destructible> levelDestructiblesArray;
var Array<ToA_BaseItem> levelBaseItemsArray;
var ToA_Pawn levelObjHero;
var ToA_InventoryManager levelInventory;

var() const ToA_Pawn PawnArchetype;

var ToA_MainMenu mainMenu;
var ToA_StoryMovie storyMovie;
var int iShouldLoadMenu; //0 = false, 1 = true
var int iShouldLoadGameSave;
var int iShouldAllowSave;
var int iDeathNums;
var int iDisplayStory;

var string currentLevel; //Is this the tutorial stage or the main level?
var string mainLevelString;
var string tutorialLevelString;

event InitGame(string Options, out string ErrorMessage)
{
    local string inOpt;
	local string inOpt2;
	local string inOpt3;
	local string inOpt4;
	local string inOpt5;
    super.InitGame(Options, ErrorMessage);

    InOpt = ParseOption(Options, "ShouldLoadGameSave");
	inOpt2 = ParseOption(Options, "ShouldLoadMenu");
	inOpt3 = ParseOption(Options, "ShouldAllowSave"); //For at du ikke skal save på tutorial level
	inOpt4 = ParseOption(Options, "TimesDied");
	inOpt5 = ParseOption(Options, "ShouldDisplayStory"); //For å loade story swf-en
    if(InOpt != "")
        iShouldLoadGameSave = int(inOpt);
	if(inOpt2 != "")
		 iShouldLoadMenu = int(inOpt2);
	if(inOpt3 != "")
		iShouldAllowSave = int(inOpt3);
	if(inOpt4 != "")
		AddTimesDied();
	if(inOpt5 != "")
		iDisplayStory = int(inOpt5);

}


simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if(iShouldLoadMenu == 1)
	{
		ShowMainMenu();
		//For at filmen skal havne over hud-en...
		SetTimer(0.1f, false, 'ShowMainMenu');
	}
	if(iDisplayStory == 1)
	{
		ShowStory();
		SetTimer(0.1f, false, 'ShowStory');
	}
	if(iShouldAllowSave == 0)
		currentLevel = tutorialLevelString;
	else if(iShouldAllowSave == 1)
		currentLevel = mainLevelString;
	
	loadEngineOBJ = new class'LoadEngine';
	saveEngineOBJ = new class'SaveEngine';
	saveEngineOBJ.gameRef = self;
	loadEngineOBJ.gameRef = self;


	FindEnemies();
	FindDestructibles();
	FindBaseItems();

	if(iShouldLoadGameSave == 1)
	{
		SetTimer(0.1f, false, 'LoadGame');
	}

}

function ShowStory()
{
	if(storyMovie != none)
		storyMovie.Close();
	storyMovie = new class'ToA_StoryMovie'; 
	storyMovie.MovieInfo = SwfMovie'ScaleformMenuGFx.SFMFrontEnd.Atrox_Story'; 
	storyMovie.Start();
}


function LoadGame()
{
	Load(filename);
	hudWorld.combatLog.AddEntriesToLog("Game loaded.");

}

function ShowMainMenu()
{
	mainMenu = new class'ToA_MainMenu'; 
	mainMenu.gameRef = self;
	mainMenu.MovieInfo = SwfMovie'ScaleformMenuGFx.SFMFrontEnd.Atrox_MainMenu'; 
	mainMenu.Start();
}

function FindBaseItems()
{
	local ToA_BaseItem item;
	foreach AllActors(class'ToA_BaseItem', item)
	{
		levelBaseItemsArray[levelBaseItemsArray.Length] = item;
	}
	`Log("Length of baseItemArray in GameInfo:"@levelBaseItemsArray.Length);
}
function FindDestructibles()
{
	local ToA_Destructible des;
	foreach AllActors(class'ToA_Destructible', des)
	{
		levelDestructiblesArray[levelDestructiblesArray.Length] = des;
	}
	`Log("Length of destructiblesArray in GameInfo:"@levelDestructiblesArray.Length);
}

function FindEnemies()
{
	local ToA_BaseEnemy nmy;

	foreach AllActors(class'ToA_BaseEnemy', nmy)
	{
		levelEnemiesArray[levelEnemiesArray.Length] = nmy;
	}
	`Log("Length of enemiesArray in GameInfo:"@levelEnemiesArray.Length);
}

function UpdateStruct()
{
	data.killedEnemies = numKilledEnemies;
	data.secretRooms = numSecretRoomsFound;
	data.smashedObjs = numSmashedObjs;
	data.timesDead = numTimesDied;
	data.bTorchLit = bTorchIsLit;
}

function SetTorchBoolTrue()
{
	bTorchIsLit = true;
}

function CreateGameInfoFromStruct(GameInfo_SaveData loadedData)
{
	numKilledEnemies = loadedData.killedEnemies;
	numSecretRoomsFound = loadedData.secretRooms;
	numTimesDied = loadedData.timesDead;
	numSmashedObjs = loadedData.smashedObjs;
	bTorchIsLit = loadedData.bTorchLit;

	data = loadedData;
}

function CreateInventoryFromStruct(Inventory_SaveData loadedData)
{
	local int i;
	local ToA_InventoryTorch torch;

	if(levelInventory != none)
	{
		if(loadedData.bHasShield)
			levelInventory.SpawnStartingInventory('ToA_InventoryShield');
		if(loadedData.bHasTorch)
		{
			torch = ToA_InventoryTorch(levelInventory.SpawnStartingInventory('ToA_InventoryTorch'));
			if(bTorchIsLit)
				torch.bIsLit = true;
		}
		if(loadedData.bHasKey)
		{
			levelInventory.SpawnStartingInventory('ToA_InventoryKey');
		}
		if(loadedData.numPotions > 0)
		{
			for(i = 0; i < loadedData.numPotions; i++)
			{
				levelInventory.SpawnStartingInventory('ToA_InventoryPotion');
			}
		}
		if(loadedData.numEnergyPotions > 0)
		{
			for(i = 0; i < loadedData.numEnergyPotions; i++)
			{
				levelInventory.SpawnStartingInventory('ToA_InventoryEnergyPotion');
			}
		}
		
	}

	levelInventory.data = loadedData;
}

function CreateEnemiesFromStruct(Enemy_SaveData loadedData, int it)
{
	if(levelEnemiesArray[it] != none)
	{
		if(loadedData.bDead)
		{
			levelEnemiesArray[it].Destroy();
			return;
		}
		levelEnemiesArray[it].SetLocation(loadedData.location);
		levelEnemiesArray[it].SetRotation(loadedData.rotation);
		levelEnemiesArray[it].data = loadedData;
	}
}

function CreateDestructiblesFromStruct(Destructible_SaveData loadedData, int it)
{
	if(levelDestructiblesArray[it] != none)
	{
		if(loadedData.bDestroyed)
		{
			levelDestructiblesArray[it].Destroy();
			return;
		}
		levelDestructiblesArray[it].data = loadedData;
	}
}

function CreateBaseItemsFromStruct(BaseItem_SaveData loadedData, int it)
{
	if(levelBaseItemsArray[it] != none)
	{
		if(loadedData.bUsed)
		{
			if(ToA_InteractableItem(levelBaseItemsArray[it]) != none)
			{
				if(ToA_InteractableItem(levelBaseItemsArray[it]).animNodeCrossfader != none)
					ToA_InteractableItem(levelBaseItemsArray[it]).animNodeCrossfader.PlayOneShotAnim('animation', ,,true,100.0f); //Kjører animasjonen kjempefort så man ikke ser den, for den skal jo være ferdigavspilt... hehe, hack løsning.
				levelBaseItemsArray[it].SetBoolDestroyed();
			}
			else if(ToA_WallTorch(levelBaseItemsArray[it]) != none)
			{
				ToA_WallTorch(levelBaseItemsArray[it]).LightTorch();
				levelBaseItemsArray[it].SetBoolDestroyed();
			}
			else
				levelBaseItemsArray[it].Destroy();
			return;
		}
		levelBaseItemsArray[it].data = loadedData;
	}
}

function CreatePawnFromStruct(ToA_Pawn_SaveData loadedData)
{
	ToA_Pawn(controllerWorld.Pawn).SetRotation(loadedData.rotation);
	ToA_Pawn(controllerWorld.Pawn).SetLocation(loadedData.location);
	ToA_Pawn(controllerWorld.Pawn).heroHealth = loadedData.HP;
	ToA_Pawn(controllerWorld.Pawn).heroCurrentXp = loadedData.currentXP;
	ToA_Pawn(controllerWorld.Pawn).heroMaxHealth = loadedData.maxHP;
	ToA_Pawn(controllerWorld.Pawn).heroDefence = loadedData.defence;
	ToA_Pawn(controllerWorld.Pawn).heroStrength = loadedData.strength;
	ToA_Pawn(controllerWorld.Pawn).heroCurrentLevel = loadedData.level;
	ToA_Pawn(controllerWorld.Pawn).heroDmgMax = loadedData.maxDMG;
	ToA_Pawn(controllerWorld.Pawn).heroDmgMin = loadedData.minDMG;
	if(loadedData.shieldEquipped)
		hudWorld.HudMovie.EquipShield();
	if(loadedData.torchEquipped)
	{
		hudWorld.HudMovie.EquipTorch();
	}
	else if(loadedData.swordEquipped)
	{
		hudWorld.HudMovie.EquipSword();
	}
		

	if(loadedData.level >= 2)
		hudWorld.HudMovie.ShowChargeButton();

	ToA_Pawn(controllerWorld.Pawn).data = loadedData;

}

function Load(string s)
{
	loadEngineOBJ.init(s);
	loadEngineOBJ.LoadObjHero();
	loadEngineOBJ.LoadGameInfo();
	loadEngineOBJ.LoadEnemies();
	loadEngineOBJ.LoadDestructibles();
	loadEngineOBJ.LoadBaseItems();
	loadEngineOBJ.LoadInventory();
}

function Save(string s)
{
	saveEngineOBJ.init();
	saveEngineOBJ.SaveObjHero();
	saveEngineOBJ.SaveGameInfo();
	saveEngineOBJ.SaveEnemies();
	saveEngineOBJ.SaveDestructibles();
	saveEngineOBJ.SaveBaseItems();
	saveEngineOBJ.SaveInventory();

	//Remember this line
	//Should always come last
	saveEngineOBJ.FinalSave(s);
}

function DisplayChapterNameOnHud()
{
	hudWorld.HudMovie.ShowPopupDisplay("Chapter1");
}

function HideChapterNameOnHud()
{
	hudWorld.HudMovie.HidePopupDisplay();
}

function DisplayHudPopup(string label)
{
	hudWorld.HudMovie.ShowPopupDisplay(label);
}
function HideHudPopup()
{
	hudWorld.HudMovie.HidePopupDisplay();
}

function AddKilledEnemy()
{
	numKilledEnemies += 1;
}

function int GetNumKilledEnemies()
{
	return numKilledEnemies;
}

function AddSmashedObj()
{
	numSmashedObjs += 1;
}

function int GetNumSmashedObjs()
{
	return numSmashedObjs;
}

function AddTimesDied()
{
	numTimesDied += 1;
}

function int GetTimesDied()
{
	return numTimesDied;
}

function AddSecretRoomFound()
{
	if(numSecretRoomsFound < 3)
		numSecretRoomsFound += 1;
}

function int GetSecretRoomsFound()
{
	return numSecretRoomsFound;
}

function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
	local Pawn SpawnedPawn;

	if(NewPlayer == none || StartSpot == none)
	{
		return none;
	}

	SpawnedPawn = Spawn(PawnArchetype.Class,,,StartSpot.Location,,PawnArchetype);

	levelObjHero = ToA_Pawn(SpawnedPawn);

	return SpawnedPawn;
}


//Siden dette er et singelplayer spill er det ingen andre
//controllere in game, og det her er en lett måte
//å koble sammen game info-klassen med player controller klassen
/*function RegisterController(ToA_GamePlayerController PC)
{
	controller = PC;
}*/

//Dette er for cooking
static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return class'ToA_GameInfo';
}

event PostLogin(PlayerController NewPlayer)
{
	super.PostLogin(NewPlayer);
	`Log("GameInfo class is working!");
}

DefaultProperties
{
	bDelayedStart=false
	//bRestartLevel=false
	//Name="Default__ToA_GameInfo"
	PlayerControllerClass=class'ToA_GamePlayerController'
	PawnArchetype=ToA_Pawn'ToA_Hero.Archetypes.ToA_Pawn_Archetype'
	//HUDType=class'ToA_HUD'
	HUDType=class'ATROXHUD'

	numSecretRoomsFound=0
	numTimesDied=0

	filename="ToA_GameState.bin"

	iShouldLoadMenu=1 //0 = false, 1 = true
	iShouldLoadGameSave=0
	iShouldAllowSave=0
	iDeathNums=0
	iDisplayStory=0

	mainLevelString="TowerOfAtrox_IntroLevel"
	tutorialLevelString="TowerOfAtrox_TutorialStage"


}

class LoadEngine extends Object;

var X_SaveFile loadFileObj;
var ToA_GameInfo gameRef;

function Init(string filename)
{
	loadFileObj = new class'X_SaveFile';
	if(!class'Engine'.static.BasicLoadObject(loadFileObj, filename, true, 1))
	{
		`Log("LoadEngine:>> Invalid Filename");
	}
}

function LoadObjHero()
{
	gameRef.CreatePawnFromStruct(loadFileObj.heroSaveObj);
}

function LoadGameInfo()
{
	gameRef.CreateGameInfoFromStruct(loadFileObj.gameInfoSaveObj);
}

function LoadInventory()
{
	gameRef.CreateInventoryFromStruct(loadFileObj.inventoryObj);
}

function LoadEnemies()
{
	local int i;
	for(i=0; i<loadFileObj.numEnemiesSaved; i++)
	{
		gameRef.CreateEnemiesFromStruct(loadFileObj.enemiesSaveObjs[i], i);
	}
	
}
function LoadDestructibles()
{
	local int i;
	for(i=0; i<loadFileObj.numDestructiblesSaved; i++)
	{
		gameRef.CreateDestructiblesFromStruct(loadFileObj.destructibles[i], i);
	}
}

function LoadBaseItems()
{
	local int i;
	for(i=0; i<loadFileObj.numBaseItemsSaved; i++)
	{
		gameRef.CreateBaseItemsFromStruct(loadFileObj.baseItemObjs[i], i);
	}
}

DefaultProperties
{
}

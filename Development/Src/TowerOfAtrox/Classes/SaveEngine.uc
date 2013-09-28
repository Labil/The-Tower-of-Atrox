class SaveEngine extends Object;

var X_SaveFile saveFileObj;
var ToA_GameInfo gameRef;

function init()
{
	saveFileObj = new class'X_SaveFile';
}

function SaveObjHero()
{
	gameRef.levelObjHero.UpdateStruct();
	saveFileObj.heroSaveObj = gameRef.levelObjHero.data;

}

function SaveGameInfo()
{
	gameRef.UpdateStruct();
	saveFileObj.gameInfoSaveObj = gameRef.data;
}

function SaveInventory()
{
	gameRef.levelInventory.UpdateStruct();
	saveFileObj.inventoryObj = gameRef.levelInventory.data;

}

function SaveEnemies()
{
	local int i;
	saveFileObj.numEnemiesSaved = gameRef.levelEnemiesArray.Length;

	for(i=0; i<saveFileObj.numEnemiesSaved; i++)
	{
		if(gameRef.levelEnemiesArray[i] == none)
		{
			saveFileObj.enemiesSaveObjs[i].bDead = true;
			continue;
		}
		gameRef.levelEnemiesArray[i].UpdateStruct();
		saveFileObj.enemiesSaveObjs[i] = gameRef.levelEnemiesArray[i].data;
	}
}

function SaveDestructibles()
{
	local int i;
	saveFileObj.numDestructiblesSaved = gameRef.levelDestructiblesArray.Length;

	for(i=0; i < saveFileObj.numDestructiblesSaved; i++)
	{
		if(gameRef.levelDestructiblesArray[i] == none)
		{
			saveFileObj.destructibles[i].bDestroyed = true;
			continue;
		}
		gameRef.levelDestructiblesArray[i].UpdateStruct();
		saveFileObj.destructibles[i] = gameRef.levelDestructiblesArray[i].data;
	}
}

function SaveBaseItems()
{
	local int i;
	saveFileObj.numBaseItemsSaved = gameRef.levelBaseItemsArray.Length;

	for(i=0; i < saveFileObj.numBaseItemsSaved; i++)
	{
		if(gameRef.levelBaseItemsArray[i] == none)
		{
			saveFileObj.baseItemObjs[i].bUsed = true;
			continue;
		}
		gameRef.levelBaseItemsArray[i].UpdateStruct();
		saveFileObj.baseItemObjs[i] = gameRef.levelBaseItemsArray[i].data;
	}
}


function FinalSave(string filename)
{
	//Saves file at very end of all loops
	//Just before finishing

	class'Engine'.static.BasicSaveObject(saveFileObj, filename, true, 1);
}

DefaultProperties
{
}

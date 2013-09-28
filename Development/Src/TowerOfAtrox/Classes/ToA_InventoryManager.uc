class ToA_InventoryManager extends ToA_ActorBase;

struct Inventory_SaveData
{
	var int numPotions;
	var int numEnergyPotions;
	var bool bHasSword, bHasShield, bHasTorch, bHasKey;
};

var Inventory_SaveData data;

var int numPotionsMax;
var int numEnergyPotionsMax;

var array<ToA_InventoryPotion> potions;
var array<ToA_InventoryEnergyPotion> energyPotions;
var array<ToA_InventoryItem> allInventory;

var ToA_Pawn hero;
//var array<ToA_BaseItem> allInventory;

function UpdateStruct()
{
	data.bHasKey = CheckInventoryFor('ToA_InventoryKey') != none;
	data.bHasShield = CheckInventoryFor('ToA_InventoryShield') != none;
	data.bHasTorch = CheckInventoryFor('ToA_InventoryTorch') != none;
	data.bHasSword = CheckInventoryFor('ToA_InventorySword') != none;

	data.numEnergyPotions = GetNumEnergyPotions();
	data.numPotions = GetNumPotions();
}

simulated function PostBeginPlay()
{
	
	super.PostBeginPlay();

	ToA_GameInfo(WorldInfo.Game).levelInventory = self;

	hero = ToA_Pawn(Owner);
	if(hero == none)
		`Log("INVENTORY HAS NO OWNER");
	
	//SpawnStartingInventory();
	
}

event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	Move(Owner.Location - self.Location);
}

function ToA_BaseItem SpawnStartingInventory(Name classname)
{
	local ToA_BaseItem startingItem;

	//`Log("Spawned inventory classname is:"@classname);

	switch(classname)
	{
		case 'ToA_InventorySword':
			startingItem = Spawn(class'ToA_InventorySword', self);
			break;
		case 'ToA_InventoryShield':
			startingItem = Spawn(class'ToA_InventoryShield', self);
			break;
		case 'ToA_InventoryTorch':
			startingItem = Spawn(class'ToA_InventoryTorch', self);
			break;
		case 'ToA_InventoryPotion':
			startingItem = Spawn(class'ToA_InventoryPotion', self);
			break;
		case 'ToA_InventoryEnergyPotion':
			startingItem = Spawn(class'ToA_InventoryEnergyPotion', self);
			break;
		default:
			break;
	}

	if(startingItem != none)
	{
		//`Log("Picking up the spawned inventory"@classname);
		PickUpInventory(startingItem);
		//hero.AttachInventory('ToA_InventorySword');
	}
	return startingItem;
}

function bool PickUpInventory(ToA_BaseItem item)
{
	if(SortInventory(item))
	{
		//`Log("Item"@item@ "was sucessfully added to your inventory");
		return true;
	}
	`Log("Could not add item"@item@"to inventory");
	return false;
}

function bool SortInventory(ToA_BaseItem item)
{
	if(ToA_InventoryPotion(item) != none)
	{
		if(potions.Length < numPotionsMax)
		{
			potions[potions.Length] = ToA_InventoryPotion(item);
			return true;
		}
	}
	else if(ToA_InventoryEnergyPotion(item) != none)
	{
		if(energyPotions.Length < numEnergyPotionsMax)
		{
			energyPotions[energyPotions.Length] = ToA_InventoryEnergyPotion(item);
			return true;
		}
	}
	else if(ToA_InventoryItem(item) != none)
	{
		allInventory[allInventory.Length] = ToA_InventoryItem(item);
		ToA_GameInfo(WorldInfo.Game).hudWorld.HudMovie.DisplayInventoryItem(ToA_InventoryItem(item).HudDisplayName);
		item.SetOwner(self);
		//`Log("Inventory item is"@item);
		return true;
	}
	return false;
}

function ToA_InventoryItem CheckInventoryFor(name className)
{
	local int i;
	for(i=0; i<allInventory.Length; i++)
	{
		if(allInventory[i].IsA(className))
		{
			//`Log("Found the item you were looking for!");
			return allInventory[i];
		}
	}
	return none;
}

function DeleteInventory(ToA_InventoryItem item)
{
	
}

function SpendPotion()
{
	if(GetNumPotions() > 0)
	{
		potions[potions.Length-1].UsePotion();
		//potions.Remove(potions.Length-1, 1);
		potions.RemoveItem(potions[potions.Length-1]);
		`Log("Used a potion in inventory!");
		`Log("Number of potions in inventory:"@potions.Length);
	}
	else
	{
		`Log("Out of health potions!");
	}
}

function SpendEnergyPotion()
{
	if(GetNumEnergyPotions() > 0)
	{
		energyPotions[energyPotions.Length-1].UsePotion();
		energyPotions.RemoveItem(energyPotions[energyPotions.Length-1]);
		`Log("Used an energy potion in inventory!");
		`Log("Number of energy potions in inventory:"@energyPotions.Length);
	}
	else
	{
		`Log("Out of energy potions!");
	}
}

function int GetNumPotions()
{
	return potions.Length;
}
function int GetNumEnergyPotions()
{
	return energyPotions.Length;
}

DefaultProperties
{
	numPotionsMax=3
	numEnergyPotionsMax=3
}
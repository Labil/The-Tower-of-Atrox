class ToA_InventoryEnergyPotion extends ToA_BaseItem;

var int Energy;
var ToA_Pawn hero;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	//Setter en liten delay i tilfelle Pawn-klassen ikke er satt opp innen denne funksjonene kjører
	SetTimer(0.5f, false, 'FindPawn');
	
}

function FindPawn()
{
	if(ToA_GameInfo(WorldInfo.Game).controllerWorld != none)
		hero = ToA_Pawn(ToA_GameInfo(WorldInfo.Game).controllerWorld.Pawn);
	else
		`Log("FAILED TO FIND PAWN in INVENTORYPOTION class!");
}

function UsePotion()
{
	`Log("USING ENERGY POT");
	if(hero.heroEnergy.currentEnergyAmount + Energy < hero.heroEnergy.totalEnergyAmount)
		hero.heroEnergy.currentEnergyAmount += Energy; 
	else
		hero.heroEnergy.currentEnergyAmount = hero.heroEnergy.totalEnergyAmount;

	self.Destroy();
}

DefaultProperties
{
	Energy=30
}

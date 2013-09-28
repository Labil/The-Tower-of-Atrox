class ToA_InventoryPotion extends ToA_BaseItem;

var int HP;
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
	`Log("USING POT");
	if(hero.heroHealth + HP < hero.heroMaxHealth)
		hero.heroHealth += HP; 
	else
		hero.heroHealth = hero.heroMaxHealth;

	self.Destroy();
}

DefaultProperties
{
	HP=10
}
